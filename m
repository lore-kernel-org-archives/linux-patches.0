Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFA6225A38;
	Mon, 13 Apr 2026 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097857; cv=none; b=NqAw95yBwROJkR7McEMHU+ivwqYIZb1SOY/KsYPJ23700OFZL3+wGDUOsdKgsinOe05pmymrPlS8kTwNHDBblhZVZ9HfLp3IOt7H91lO8iM1xTC1hC3c0t7gQZ2eRpGS3rutPTh3zeD7yLvvx/6y84ZXmzGHfLO4eQ/QL10A1uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097857; c=relaxed/simple;
	bh=a1A02WCIHiTkmB0/ycz6iMjHa02iuYyNsOWzPrG1ofc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWSAjKOfuZqhxofK7SMkoYKqEDQe3SMlBcf76jVOj1wo+TkP2Ct19lE9TBHrMuhqq05L9OX5yli5L+YKYowbk7yR4GjvUehojBcsRl7lVHqkivL0mvI3vjhGuYbAk94K6iJh+84z1lDKcUWeYGaMSe4RdDvT+bhohcZIUgwAq18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2brHmUHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2brHmUHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47301C2BCAF;
	Mon, 13 Apr 2026 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097857;
	bh=a1A02WCIHiTkmB0/ycz6iMjHa02iuYyNsOWzPrG1ofc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2brHmUHSmuKKDqMtL6cqDj2LtLbgOHi5Fvfwc5XOLiPZ53+7v4/sbiiDS7MgsXM7+
	 JOlF5RB7mEcC+VgmWCRYjilsZs8msPl12FDM3kifn4600Zzjg8EfKxPCEQaBK5QShI
	 Codb6o1k1xSfWSNsAPPfxTBcBbEE8Hc7HWzyGzE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	syzbot+6c905ab800f20cf4086c@syzkaller.appspotmail.com,
	Bart Van Assche <bvanassche@acm.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/570] PM: runtime: Fix a race condition related to device removal
Date: Mon, 13 Apr 2026 17:56:38 +0200
Message-ID: <20260413155840.483725809@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 29ab768277617452d88c0607c9299cdc63b6e9ff ]

The following code in pm_runtime_work() may dereference the dev->parent
pointer after the parent device has been freed:

	/* Maybe the parent is now able to suspend. */
	if (parent && !parent->power.ignore_children) {
		spin_unlock(&dev->power.lock);

		spin_lock(&parent->power.lock);
		rpm_idle(parent, RPM_ASYNC);
		spin_unlock(&parent->power.lock);

		spin_lock(&dev->power.lock);
	}

Fix this by inserting a flush_work() call in pm_runtime_remove().

Without this patch blktest block/001 triggers the following complaint
sporadically:

BUG: KASAN: slab-use-after-free in lock_acquire+0x70/0x160
Read of size 1 at addr ffff88812bef7198 by task kworker/u553:1/3081
Workqueue: pm pm_runtime_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x61/0x80
 print_address_description.constprop.0+0x8b/0x310
 print_report+0xfd/0x1d7
 kasan_report+0xd8/0x1d0
 __kasan_check_byte+0x42/0x60
 lock_acquire.part.0+0x38/0x230
 lock_acquire+0x70/0x160
 _raw_spin_lock+0x36/0x50
 rpm_suspend+0xc6a/0xfe0
 rpm_idle+0x578/0x770
 pm_runtime_work+0xee/0x120
 process_one_work+0xde3/0x1410
 worker_thread+0x5eb/0xfe0
 kthread+0x37b/0x480
 ret_from_fork+0x6cb/0x920
 ret_from_fork_asm+0x11/0x20
 </TASK>

Allocated by task 4314:
 kasan_save_stack+0x2a/0x50
 kasan_save_track+0x18/0x40
 kasan_save_alloc_info+0x3d/0x50
 __kasan_kmalloc+0xa0/0xb0
 __kmalloc_noprof+0x311/0x990
 scsi_alloc_target+0x122/0xb60 [scsi_mod]
 __scsi_scan_target+0x101/0x460 [scsi_mod]
 scsi_scan_channel+0x179/0x1c0 [scsi_mod]
 scsi_scan_host_selected+0x259/0x2d0 [scsi_mod]
 store_scan+0x2d2/0x390 [scsi_mod]
 dev_attr_store+0x43/0x80
 sysfs_kf_write+0xde/0x140
 kernfs_fop_write_iter+0x3ef/0x670
 vfs_write+0x506/0x1470
 ksys_write+0xfd/0x230
 __x64_sys_write+0x76/0xc0
 x64_sys_call+0x213/0x1810
 do_syscall_64+0xee/0xfc0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

Freed by task 4314:
 kasan_save_stack+0x2a/0x50
 kasan_save_track+0x18/0x40
 kasan_save_free_info+0x3f/0x50
 __kasan_slab_free+0x67/0x80
 kfree+0x225/0x6c0
 scsi_target_dev_release+0x3d/0x60 [scsi_mod]
 device_release+0xa3/0x220
 kobject_cleanup+0x105/0x3a0
 kobject_put+0x72/0xd0
 put_device+0x17/0x20
 scsi_device_dev_release+0xacf/0x12c0 [scsi_mod]
 device_release+0xa3/0x220
 kobject_cleanup+0x105/0x3a0
 kobject_put+0x72/0xd0
 put_device+0x17/0x20
 scsi_device_put+0x7f/0xc0 [scsi_mod]
 sdev_store_delete+0xa5/0x120 [scsi_mod]
 dev_attr_store+0x43/0x80
 sysfs_kf_write+0xde/0x140
 kernfs_fop_write_iter+0x3ef/0x670
 vfs_write+0x506/0x1470
 ksys_write+0xfd/0x230
 __x64_sys_write+0x76/0xc0
 x64_sys_call+0x213/0x1810

Reported-by: Ming Lei <ming.lei@redhat.com>
Closes: https://lore.kernel.org/all/ZxdNvLNI8QaOfD2d@fedora/
Reported-by: syzbot+6c905ab800f20cf4086c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68c13942.050a0220.2ff435.000b.GAE@google.com/
Fixes: 5e928f77a09a ("PM: Introduce core framework for run-time PM of I/O devices (rev. 17)")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260312182720.2776083-1-bvanassche@acm.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 7dcf2498965a3..f94d9223ab151 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1774,6 +1774,7 @@ void pm_runtime_reinit(struct device *dev)
 void pm_runtime_remove(struct device *dev)
 {
 	__pm_runtime_disable(dev, false);
+	flush_work(&dev->power.work);
 	pm_runtime_reinit(dev);
 }
 
-- 
2.51.0



