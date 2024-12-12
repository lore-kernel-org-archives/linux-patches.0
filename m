Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891CD217739;
	Thu, 12 Dec 2024 15:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016524; cv=none; b=EBDrsucS8tetJw11klS1k4ZqRadfvinwkCkd/F/Z9eO71Vq/+7G61Jr1jVy2loPyq+PkAPPUnL71AhCW/auC4wgX2UAMf5hC1bRqB8Pzj7csdwJScf4X2HtRn3Yr6FW0T+yAfv6B8v7WdrmF8wRTQTzsn6GPKslQ8BDKy0rfgao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016524; c=relaxed/simple;
	bh=ZRwUKUbAVdIuA6uUGfRAwBJDnj5WLHq1F/Fl266liNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5xtJUkyB8u78joFZVsbtlLmofUc7CD2ooZwJWIkF0LVl4DpjGX26NOc0T3HfooPmcpYHfpLY/gLgUCrCbBlpLPg0mgo6aAjmTyBBOsB/7bYBLoK6nEo8vFEYmzzAVFPSOHAVzHFREGaUppae+362MorSRqPj0daMTDBzdq0pUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXx360MC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXx360MC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F95C4CECE;
	Thu, 12 Dec 2024 15:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016524;
	bh=ZRwUKUbAVdIuA6uUGfRAwBJDnj5WLHq1F/Fl266liNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXx360MCd/6lzAxpHY77njq7lotGYgw4cLVhToZj80ehw4a/YOvx/wy50jF9N7mR8
	 1nS3NcUK7/I3Z6fngetC7MCTN09yFSZYjSJUFHsN0twMJZ3l9ICgVeYb9lTGwdjMsp
	 Whrh7zDm22jbhy3lrVhXkC0/C28YQbfzUIXwhjC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/466] btrfs: do not clear read-only when adding sprout device
Date: Thu, 12 Dec 2024 15:56:31 +0100
Message-ID: <20241212144315.553289096@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 70958a949d852cbecc3d46127bf0b24786df0130 ]

If you follow the seed/sprout wiki, it suggests the following workflow:

btrfstune -S 1 seed_dev
mount seed_dev mnt
btrfs device add sprout_dev
mount -o remount,rw mnt

The first mount mounts the FS readonly, which results in not setting
BTRFS_FS_OPEN, and setting the readonly bit on the sb. The device add
somewhat surprisingly clears the readonly bit on the sb (though the
mount is still practically readonly, from the users perspective...).
Finally, the remount checks the readonly bit on the sb against the flag
and sees no change, so it does not run the code intended to run on
ro->rw transitions, leaving BTRFS_FS_OPEN unset.

As a result, when the cleaner_kthread runs, it sees no BTRFS_FS_OPEN and
does no work. This results in leaking deleted snapshots until we run out
of space.

I propose fixing it at the first departure from what feels reasonable:
when we clear the readonly bit on the sb during device add.

A new fstest I have written reproduces the bug and confirms the fix.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5895397364aac..0c4d14c59ebec 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2842,8 +2842,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	set_blocksize(device->bdev_file, BTRFS_BDEV_BLOCKSIZE);
 
 	if (seeding_dev) {
-		btrfs_clear_sb_rdonly(sb);
-
 		/* GFP_KERNEL allocation must not be under device_list_mutex */
 		seed_devices = btrfs_init_sprout(fs_info);
 		if (IS_ERR(seed_devices)) {
@@ -2986,8 +2984,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 error_trans:
-	if (seeding_dev)
-		btrfs_set_sb_rdonly(sb);
 	if (trans)
 		btrfs_end_transaction(trans);
 error_free_zone:
-- 
2.43.0



