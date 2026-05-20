Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B839E3E92B5;
	Wed, 20 May 2026 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294441; cv=none; b=Kb6MQrY3DVkVoXlI7uy6RHnkWl00bvUHrs2SnIgjpwVB6hAvxCi3j1qsUwuiVDLC6+FouqL9datfIHdO1IjWNJXw0TYA7+OkEuykmpIqpEpj+oyVX2QU2reityfy2gzCz2VsZVVVPF/CYYwiCu9qWWKRgpeQRH0AtDQGI0SW6hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294441; c=relaxed/simple;
	bh=y3GZXxv1yxW9qMLxVJFb/XbV4OLSyN2IDZNk6k1C9tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZszyxoW5bL8KYsZc/SsfGBdpmZNlcIUaQ76XWmFK+KuO4FlEBm/0VlbW1rILSEEGma2l8ztdzUtOwlGtNuCX7XFbVMulFdvp9AdkpsDTfe+SbRl5sKCDvzFwCtlA6c8gfRWNa0Usv8SGrpz67Tg4gnkhGMKSEeqPEqTBI96s1+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYdjhdnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYdjhdnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A37A1F000E9;
	Wed, 20 May 2026 16:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294439;
	bh=SbQx/KG46Inps2U1IIBP0CwII7029bnKKEmbJ67tuAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYdjhdnwGUbaw+M1xfgdhOKlvOWtbcsUERu7XQVegYn2DFJGn2Kh4sGdiO1adtqQW
	 XSxESbIpqnlRccuDMguTmipqQBgXPVveBVWbbKZETkHtC6nmvXOp4RqKHE4/3GzZPZ
	 dq5bPlU/mFF//8fMS6jVBEoBoOCtxNcjUjS/FUDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan@amutable.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0008/1146] loop: fix partition scan race between udev and loop_reread_partitions()
Date: Wed, 20 May 2026 18:04:18 +0200
Message-ID: <20260520162148.582599736@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daan De Meyer <daan.j.demeyer@gmail.com>

[ Upstream commit 267ec4d7223a783f029a980f41b93c39b17996da ]

When LOOP_CONFIGURE is called with LO_FLAGS_PARTSCAN, the following
sequence occurs:

  1. disk_force_media_change() sets GD_NEED_PART_SCAN
  2. Uevent suppression is lifted and a KOBJ_CHANGE uevent is sent
  3. loop_global_unlock() releases the lock
  4. loop_reread_partitions() calls bdev_disk_changed() to scan

There is a race between steps 2 and 4: when udev receives the uevent
and opens the device before loop_reread_partitions() runs,
blkdev_get_whole() in bdev.c sees GD_NEED_PART_SCAN set and calls
bdev_disk_changed() for a first scan. Then loop_reread_partitions()
does a second scan. The open_mutex serializes these two scans, but
does not prevent both from running.

The second scan in bdev_disk_changed() drops all partition devices
from the first scan (via blk_drop_partitions()) before re-adding
them, causing partition block devices to briefly disappear. This
breaks any systemd unit with BindsTo= on the partition device: systemd
observes the device going dead, fails the dependent units, and does
not retry them when the device reappears.

Fix this by removing the GD_NEED_PART_SCAN set from
disk_force_media_change() entirely. None of the current callers need
the lazy on-open partition scan triggered by this flag:

  - floppy: sets GENHD_FL_NO_PART, so disk_has_partscan() is always
    false and GD_NEED_PART_SCAN has no effect.
  - loop (loop_configure, loop_change_fd): when LO_FLAGS_PARTSCAN is
    set, loop_reread_partitions() performs an explicit scan. When not
    set, GD_SUPPRESS_PART_SCAN prevents the lazy scan path.
  - loop (__loop_clr_fd): calls bdev_disk_changed() explicitly if
    LO_FLAGS_PARTSCAN is set.
  - nbd (nbd_clear_sock_ioctl): capacity is set to zero immediately
    after; nbd manages GD_NEED_PART_SCAN explicitly elsewhere.

With GD_NEED_PART_SCAN no longer set by disk_force_media_change(),
udev opening the loop device after the uevent no longer triggers a
redundant scan in blkdev_get_whole(), and only the single explicit
scan from loop_reread_partitions() runs.

A regression test for this bug has been submitted to blktests:
https://github.com/linux-blktests/blktests/pull/240.

Fixes: 9f65c489b68d ("loop: raise media_change event")
Signed-off-by: Daan De Meyer <daan@amutable.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Link: https://patch.msgid.link/20260331105130.1077599-1-daan@amutable.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/disk-events.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/disk-events.c b/block/disk-events.c
index 9f9f9f8a2d6b1..074731ecc3d25 100644
--- a/block/disk-events.c
+++ b/block/disk-events.c
@@ -290,13 +290,14 @@ EXPORT_SYMBOL(disk_check_media_change);
  * Should be called when the media changes for @disk.  Generates a uevent
  * and attempts to free all dentries and inodes and invalidates all block
  * device page cache entries in that case.
+ *
+ * Callers that need a partition re-scan should arrange for one explicitly.
  */
 void disk_force_media_change(struct gendisk *disk)
 {
 	disk_event_uevent(disk, DISK_EVENT_MEDIA_CHANGE);
 	inc_diskseq(disk);
 	bdev_mark_dead(disk->part0, true);
-	set_bit(GD_NEED_PART_SCAN, &disk->state);
 }
 EXPORT_SYMBOL_GPL(disk_force_media_change);
 
-- 
2.53.0



