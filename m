Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB9B1A3029;
	Tue, 21 Oct 2025 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077189; cv=none; b=Sp5Q9omC53V5X42LPxW1GPPVyJhRSEEj9A8IYf10kaFLsvjcdfxefEYN2Fr3mZob1OWR43z8+E3VSWuzOYDEQBkq+htRVWEoqzm/wLvCQQZiAegAqF1chjBFvex6L8/xCFcqKq+Jdnk3uKUQjzxGMDhZ4Fk/x3Q4VWwPzh29mBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077189; c=relaxed/simple;
	bh=rop5WgaV7bzGoY8OtPYKMzfnPuukmB+Db/3LFvvSr8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDKD4mNjvAShF6OCdxPy979tYB4xtjmMLz0ym2LkBiEZphvGJa0vCX0rYxTCgrx+SiVb7FHH98zT4LXRqzbLI/QtfAhfUAhr0YF5xyWVO5HkOs3gMt1wdtnov/VyeXHW+PtRnVguVGe3BCRrh3y2ejboEGgZrZXUcmaRmwg3N3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smHZ1qEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smHZ1qEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FA7C4CEF1;
	Tue, 21 Oct 2025 20:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077189;
	bh=rop5WgaV7bzGoY8OtPYKMzfnPuukmB+Db/3LFvvSr8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smHZ1qEaeiDfM/W3JtQkDhKwv5wGdCQdp5yNytK5X5dIPWuCuy/AxhL1Z5Ql9UOZv
	 AY+Vs4HV6p+V20dqEfi4iKRvUq/4YYK2flsE8hN7ZCG3ffxMgoK/36FA1XAdveCvB0
	 RgGWJ4KuLlAUfO+ESTquzssNNxWe18m86TycQIY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HAN Yuwei <hrx@bupt.moe>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 027/159] btrfs: only set the device specific options after devices are opened
Date: Tue, 21 Oct 2025 21:50:04 +0200
Message-ID: <20251021195043.846009495@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit b7fdfd29a136a17c5c8ad9e9bbf89c48919c3d19 upstream.

[BUG]
With v6.17-rc kernels, btrfs will always set 'ssd' mount option even if
the block device is not a rotating one:

  # cat /sys/block/sdd/queue/rotational
  1
  # cat /etc/fstab:
  LABEL=DATA2     /data2  btrfs rw,relatime,space_cache=v2,subvolid=5,subvol=/,nofail,nosuid,nodev      0 0

  # mount
  [...]
  /dev/sdd on /data2 type btrfs (rw,nosuid,nodev,relatime,ssd,space_cache=v2,subvolid=5,subvol=/)

[CAUSE]
The 'ssd' mount option is set by set_device_specific_options(), and it
expects that if there is any rotating device in the btrfs, it will set
fs_devices::rotating.

However after commit bddf57a70781 ("btrfs: delay btrfs_open_devices()
until super block is created"), the device opening is delayed until the
super block is created.

But the timing of set_device_specific_options() is still left as is,
this makes the function be called without any device opened.

Since no device is opened, thus fs_devices::rotating will never be set,
making btrfs incorrectly set 'ssd' mount option.

[FIX]
Only call set_device_specific_options() after btrfs_open_devices().

Also only call set_device_specific_options() after a new mount, if we're
mounting a mounted btrfs, there is no need to set the device specific
mount options again.

Reported-by: HAN Yuwei <hrx@bupt.moe>
Link: https://lore.kernel.org/linux-btrfs/C8FF75669DFFC3C5+5f93bf8a-80a0-48a6-81bf-4ec890abc99a@bupt.moe/
Fixes: bddf57a70781 ("btrfs: delay btrfs_open_devices() until super block is created")
CC: stable@vger.kernel.org # 6.17
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1902,8 +1902,6 @@ static int btrfs_get_tree_super(struct f
 		return PTR_ERR(sb);
 	}
 
-	set_device_specific_options(fs_info);
-
 	if (sb->s_root) {
 		/*
 		 * Not the first mount of the fs thus got an existing super block.
@@ -1948,6 +1946,7 @@ static int btrfs_get_tree_super(struct f
 			deactivate_locked_super(sb);
 			return -EACCES;
 		}
+		set_device_specific_options(fs_info);
 		bdev = fs_devices->latest_dev->bdev;
 		snprintf(sb->s_id, sizeof(sb->s_id), "%pg", bdev);
 		shrinker_debugfs_rename(sb->s_shrink, "sb-btrfs:%s", sb->s_id);


