Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540122E7BD6;
	Thu,  3 Jul 2025 15:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555120; cv=none; b=Km1+XNschn+XLE7NHavPjzhIBNrQdGrctnGneor2XpKRpmImu0vqL/6Z6HZm7EU2CYNe2e+LTaRvWEB/jrpdgV7HjE3bjgU1tTlByCWSqN41a6anfkJlilyYiE2UMp2rSmCDOtlKDUhGWuQM5yCOJOTFvIvbOuset5sd7s61H5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555120; c=relaxed/simple;
	bh=Lm5wg43UrS6yfSVvtmlfvyEJKv3/X+iKmE+38BGwvpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKNYxSnbU+gRMEIHnpByEac6fG0OTLwVYqu2aWspWVG84ZQ6Dq24KwQwQfuuAlVknTwRULSieeEk8b8Bxn10azVfdTc2jB0MSf66qgqKtMIv07gEZX83qgmSvPT7TstpUjfxXQ63rp1GFvjCvY59u3BaHVITqfeGC7ELev5TzBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFW4e3vK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFW4e3vK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF67CC4CEED;
	Thu,  3 Jul 2025 15:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555120;
	bh=Lm5wg43UrS6yfSVvtmlfvyEJKv3/X+iKmE+38BGwvpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFW4e3vK0NfGCjkD255w/L6X/3xjdCnU7KrzXsrKSq/0RFbVOoIf2l5ZT8tO5GFRn
	 Anh0YiG07rR2iDFzSMwfp+H+3LWlst/oucHaOhu/L5AXXjoq5M/VO5NxzPVtTLkj6y
	 EN5xTdORT5iHjQyRTqVMtfZ+8yP0UBDsuQa63Lm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <maharmstone@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 181/263] btrfs: update superblocks device bytes_used when dropping chunk
Date: Thu,  3 Jul 2025 16:41:41 +0200
Message-ID: <20250703144011.601432580@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <maharmstone@fb.com>

commit ae4477f937569d097ca5dbce92a89ba384b49bc6 upstream.

Each superblock contains a copy of the device item for that device. In a
transaction which drops a chunk but doesn't create any new ones, we were
correctly updating the device item in the chunk tree but not copying
over the new bytes_used value to the superblock.

This can be seen by doing the following:

  # dd if=/dev/zero of=test bs=4096 count=2621440
  # mkfs.btrfs test
  # mount test /root/temp

  # cd /root/temp
  # for i in {00..10}; do dd if=/dev/zero of=$i bs=4096 count=32768; done
  # sync
  # rm *
  # sync
  # btrfs balance start -dusage=0 .
  # sync

  # cd
  # umount /root/temp
  # btrfs check test

For btrfs-check to detect this, you will also need my patch at
https://github.com/kdave/btrfs-progs/pull/991.

Change btrfs_remove_dev_extents() so that it adds the devices to the
fs_info->post_commit_list if they're not there already. This causes
btrfs_commit_device_sizes() to be called, which updates the bytes_used
value in the superblock.

Fixes: bbbf7243d62d ("btrfs: combine device update operations during transaction commit")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <maharmstone@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3281,6 +3281,12 @@ int btrfs_remove_chunk(struct btrfs_tran
 					device->bytes_used - dev_extent_len);
 			atomic64_add(dev_extent_len, &fs_info->free_chunk_space);
 			btrfs_clear_space_info_full(fs_info);
+
+			if (list_empty(&device->post_commit_list)) {
+				list_add_tail(&device->post_commit_list,
+					      &trans->transaction->dev_update_list);
+			}
+
 			mutex_unlock(&fs_info->chunk_mutex);
 		}
 	}


