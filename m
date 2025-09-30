Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A206173;
	Tue, 30 Sep 2025 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244581; cv=none; b=M2TQ62N7KsUOzhfXqn4ZO2abvNqG4rXjOnLpm+r9LwwuI6ltEdYHgEFqQhLSA17JpUPX0ac971/uM2GqPzbmvmsDASjtNHn6AC/QHLVULZ+FgajbYo2WaasODvBgwPo7YCeZOUSAsBG8R33c24IXLuGeGGZrlGyQhq0tiutNjpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244581; c=relaxed/simple;
	bh=eqhsu5UTIWgWhKw7gw9+4eJH0uk/vnvEKnjnHbrQq6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkeyYxmMg0wgPS7y/EBhdHKb3z3A6/zO9AlA2DY0xXHLsWDJBUbFtb2xfPRsrvR5jdOsPPmAbebIRl6jjEVF1fHTyxaQeYcoDMFrzpVRiADdrT4qZydXq7XjaVNiuqmFxqQyLOGYFsheDxMDGcsNTpE5YT8NNnpkaCk2MTctAt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7JadRc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7JadRc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C74CC116B1;
	Tue, 30 Sep 2025 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244580;
	bh=eqhsu5UTIWgWhKw7gw9+4eJH0uk/vnvEKnjnHbrQq6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7JadRc32GjymYDvzsm7hai/e568t3tArgt7KH9D9d5ogq0xAWvgLTjwDTGzMrOFG
	 PfEsQC1RBuwQg33uKwir+W2onrNUpji22jN0WGL9LDaxucOLMJ6xVX4X2fzyDRkS7g
	 lTOydWyl/2WACyMkgwujriyuNQ4BIYd7S7gSA2+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 049/143] btrfs: dont allow adding block device of less than 1 MB
Date: Tue, 30 Sep 2025 16:46:13 +0200
Message-ID: <20250930143833.187330982@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f475b4b7c4578..817d3ef501ec4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2714,6 +2714,11 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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



