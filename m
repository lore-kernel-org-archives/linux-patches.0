Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420D1A6192;
	Tue, 30 Jul 2024 17:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359175; cv=none; b=Myp3/2x+jbivA2TkaMcgqfY1TA93nF6dtxIxbSWFZNEoYhAqxH77NIRH5jB6HXNBapJUkJEPEHI1nifE4Cs6WUKb/bElqx7VxsmQfTBiHFRchvCT4/wkM8I6IZ62blviN8xR5eWSZzNjs3mY/M3Kr2ORFRG3DQ7bnAdr1+guuaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359175; c=relaxed/simple;
	bh=A3VWFM1YvKJsy4FFzjErVQV8e4bF8C/FnryABbcTk6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3qQ1JRJknLqaVkMTyIdhew1cEhANhcOsq+dg94iV3+5XtOT3MK6QO+FWiM+8WPNIZNldKADL43EH66I8ns2ekFSkoqMNZmgNIKQCKgsxLq0Lc6GgHwjLfa9PDe8pIm7jv5jStMVcSi55Xf8xpfe7Fs9PkcxT8tnsnqudp4uBj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDfP+Q9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDfP+Q9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A775C4AF10;
	Tue, 30 Jul 2024 17:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359175;
	bh=A3VWFM1YvKJsy4FFzjErVQV8e4bF8C/FnryABbcTk6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDfP+Q9wvCzzqSWnaJ+V+BFUqy/ATjIn1qIrcHdKNAjY2oXIscecuZiCzHzGc9rn/
	 GYMzd0r3CcngZp3sbgq6ltCAG750PxSaXTjNS0X+l/2nSLNMnM8DY++aM16wUE7qo5
	 UidiqVfg/hzErEv+YcSHftBZphAk8m3ldNP8jS5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yang <yang.yang@vivo.com>,
	Ming Lei <ming.lei@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 443/568] block: fix deadlock between sd_remove & sd_release
Date: Tue, 30 Jul 2024 17:49:10 +0200
Message-ID: <20240730151657.187200677@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yang <yang.yang@vivo.com>

commit 7e04da2dc7013af50ed3a2beb698d5168d1e594b upstream.

Our test report the following hung task:

[ 2538.459400] INFO: task "kworker/0:0":7 blocked for more than 188 seconds.
[ 2538.459427] Call trace:
[ 2538.459430]  __switch_to+0x174/0x338
[ 2538.459436]  __schedule+0x628/0x9c4
[ 2538.459442]  schedule+0x7c/0xe8
[ 2538.459447]  schedule_preempt_disabled+0x24/0x40
[ 2538.459453]  __mutex_lock+0x3ec/0xf04
[ 2538.459456]  __mutex_lock_slowpath+0x14/0x24
[ 2538.459459]  mutex_lock+0x30/0xd8
[ 2538.459462]  del_gendisk+0xdc/0x350
[ 2538.459466]  sd_remove+0x30/0x60
[ 2538.459470]  device_release_driver_internal+0x1c4/0x2c4
[ 2538.459474]  device_release_driver+0x18/0x28
[ 2538.459478]  bus_remove_device+0x15c/0x174
[ 2538.459483]  device_del+0x1d0/0x358
[ 2538.459488]  __scsi_remove_device+0xa8/0x198
[ 2538.459493]  scsi_forget_host+0x50/0x70
[ 2538.459497]  scsi_remove_host+0x80/0x180
[ 2538.459502]  usb_stor_disconnect+0x68/0xf4
[ 2538.459506]  usb_unbind_interface+0xd4/0x280
[ 2538.459510]  device_release_driver_internal+0x1c4/0x2c4
[ 2538.459514]  device_release_driver+0x18/0x28
[ 2538.459518]  bus_remove_device+0x15c/0x174
[ 2538.459523]  device_del+0x1d0/0x358
[ 2538.459528]  usb_disable_device+0x84/0x194
[ 2538.459532]  usb_disconnect+0xec/0x300
[ 2538.459537]  hub_event+0xb80/0x1870
[ 2538.459541]  process_scheduled_works+0x248/0x4dc
[ 2538.459545]  worker_thread+0x244/0x334
[ 2538.459549]  kthread+0x114/0x1bc

[ 2538.461001] INFO: task "fsck.":15415 blocked for more than 188 seconds.
[ 2538.461014] Call trace:
[ 2538.461016]  __switch_to+0x174/0x338
[ 2538.461021]  __schedule+0x628/0x9c4
[ 2538.461025]  schedule+0x7c/0xe8
[ 2538.461030]  blk_queue_enter+0xc4/0x160
[ 2538.461034]  blk_mq_alloc_request+0x120/0x1d4
[ 2538.461037]  scsi_execute_cmd+0x7c/0x23c
[ 2538.461040]  ioctl_internal_command+0x5c/0x164
[ 2538.461046]  scsi_set_medium_removal+0x5c/0xb0
[ 2538.461051]  sd_release+0x50/0x94
[ 2538.461054]  blkdev_put+0x190/0x28c
[ 2538.461058]  blkdev_release+0x28/0x40
[ 2538.461063]  __fput+0xf8/0x2a8
[ 2538.461066]  __fput_sync+0x28/0x5c
[ 2538.461070]  __arm64_sys_close+0x84/0xe8
[ 2538.461073]  invoke_syscall+0x58/0x114
[ 2538.461078]  el0_svc_common+0xac/0xe0
[ 2538.461082]  do_el0_svc+0x1c/0x28
[ 2538.461087]  el0_svc+0x38/0x68
[ 2538.461090]  el0t_64_sync_handler+0x68/0xbc
[ 2538.461093]  el0t_64_sync+0x1a8/0x1ac

  T1:				T2:
  sd_remove
  del_gendisk
  __blk_mark_disk_dead
  blk_freeze_queue_start
  ++q->mq_freeze_depth
  				bdev_release
 				mutex_lock(&disk->open_mutex)
  				sd_release
 				scsi_execute_cmd
 				blk_queue_enter
 				wait_event(!q->mq_freeze_depth)
  mutex_lock(&disk->open_mutex)

SCSI does not set GD_OWNS_QUEUE, so QUEUE_FLAG_DYING is not set in
this scenario. This is a classic ABBA deadlock. To fix the deadlock,
make sure we don't try to acquire disk->open_mutex after freezing
the queue.

Cc: stable@vger.kernel.org
Fixes: eec1be4c30df ("block: delete partitions later in del_gendisk")
Signed-off-by: Yang Yang <yang.yang@vivo.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: and Cc: stable tags are missing. Otherwise this patch looks fine
Link: https://lore.kernel.org/r/20240724070412.22521-1-yang.yang@vivo.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -655,12 +655,12 @@ void del_gendisk(struct gendisk *disk)
 	 */
 	if (!test_bit(GD_DEAD, &disk->state))
 		blk_report_disk_dead(disk, false);
-	__blk_mark_disk_dead(disk);
 
 	/*
 	 * Drop all partitions now that the disk is marked dead.
 	 */
 	mutex_lock(&disk->open_mutex);
+	__blk_mark_disk_dead(disk);
 	xa_for_each_start(&disk->part_tbl, idx, part, 1)
 		drop_partition(part);
 	mutex_unlock(&disk->open_mutex);


