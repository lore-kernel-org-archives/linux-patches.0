Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F0016A956;
	Tue, 30 Sep 2025 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246145; cv=none; b=r/SJYapoZfPcsPmOp2HjVW7RX+ni+QUsOYUwwUCogTxr2x/F0qYarlVIsGPUjEzewrKicjwVxTQt9pVIzMhHgPfaEVPJMGbnL20HsJr5LxckywDTNi2IDYE2PsFe+7eOuup6lG77Z+ELxoV3Q8tTYBxKP3KWeOjkdnUcD7Z9qTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246145; c=relaxed/simple;
	bh=SpqlaYcQ1sFznTFXQRF5VJNInP8n/54dHZXqqBRzo3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psNu3B11sNSDD/RbIxkC+RezZ2H2DnxHFhbyZZ90Ck94qY3b1Cycm2wHwZnB0ygBneYls8u2tb9Trkc33YRo3J1qFw+nShl/dUrnY82vAo+R3TUeUqTUjFn04XPEOByhieTDq+UqBNVGpcxUV+GGOdJ9ZQTFadP7GiKF5g2/DgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFVYeEyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFVYeEyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6BCC4CEF0;
	Tue, 30 Sep 2025 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246143;
	bh=SpqlaYcQ1sFznTFXQRF5VJNInP8n/54dHZXqqBRzo3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFVYeEyP9oGemv969aeb9b1358upu5EoGi9FGvHlNRHgp3smqNJOzF56WrTlRIL3T
	 uh9kKYtJkozRG5DNkEhufM5StjT1WfQUKZNrFZa1dzomcG4CqJ8k3/dYFnNxowug8L
	 cEkqfVNJAGZXajJPRwFp+Yopq0jzRrGST0F24ids=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 35/89] btrfs: dont allow adding block device of less than 1 MB
Date: Tue, 30 Sep 2025 16:47:49 +0200
Message-ID: <20250930143823.374860018@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 3d1267475b94b3df7a61e4ea6788c7c5d9e473c4 ]

Commit 15ae0410c37a79 ("btrfs-progs: add error handling for
device_get_partition_size_fd_stat()") in btrfs-progs inadvertently
changed it so that if the BLKGETSIZE64 ioctl on a block device returned
a size of 0, this was no longer seen as an error condition.

Unfortunately this is how disconnected NBD devices behave, meaning that
with btrfs-progs 6.16 it's now possible to add a device you can't
remove:

  # btrfs device add /dev/nbd0 /root/temp
  # btrfs device remove /dev/nbd0 /root/temp
  ERROR: error removing device '/dev/nbd0': Invalid argument

This check should always have been done kernel-side anyway, so add a
check in btrfs_init_new_device() that the new device doesn't have a size
less than BTRFS_DEVICE_RANGE_RESERVED (i.e. 1 MB).

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 58e0cac5779dd..ce991a8390466 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2699,6 +2699,11 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		goto error;
 	}
 
+	if (bdev_nr_bytes(file_bdev(bdev_file)) <= BTRFS_DEVICE_RANGE_RESERVED) {
+		ret = -EINVAL;
+		goto error;
+	}
+
 	if (fs_devices->seeding) {
 		seeding_dev = true;
 		down_write(&sb->s_umount);
-- 
2.51.0



