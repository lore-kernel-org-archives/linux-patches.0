Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D0527F163;
	Wed,  4 Feb 2026 15:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218172; cv=none; b=gByXTuHkAs5H3iMhhF4tfjaDoLp9NNgBVz3T755dB29oKnkuYr7j7ASW05HbGgFfaP6dU4cZ2ZfsrUajXG5Iw3r5pSZCeoz8UO7dhy7PnVJcIiuDwJeG/pvzNlUKHwvSv0FJzeNqVs9jvM1lAmaVO0Qx8DTV6s/oY7DM+KKsIIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218172; c=relaxed/simple;
	bh=ybMZMYCS9JAZJgYXs1AEF1sb5rVLpiGFa9pm8uNIYmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iq/EM9oB4Uffh5F0Z5Yz3qvPcsGD2uzqiIwd0mD5U6q4IaSULovPDwjjmDcUjclYHYKT+kticB+2I38+dEWAqY2tAY+glvVEHWh4ykPURN2L3cO4wKgus3AfQW/PExs749NfpZxz6hj3Osj23lo7ljMrZRViTgrNWBp+edpOTI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKLhgXE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKLhgXE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EF3C4CEF7;
	Wed,  4 Feb 2026 15:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218172;
	bh=ybMZMYCS9JAZJgYXs1AEF1sb5rVLpiGFa9pm8uNIYmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKLhgXE9BQooIb8tmjSshMMhukPh3Cl20MwdDJ5q255XgZ5JbpTG3u0u/EcQsyHpQ
	 1zB9PPJu8w8ElIkQ/fBmVKIbLGa9g+MODn16TpA9gf8yZnaqSf3yc/FPvYWylbxuzL
	 FdeleoCK3OlzINLsvh6QxouF/2Sjb35BOMvaS8iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f9c5fd1a0874f9069dce@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/280] nfc: nci: Fix race between rfkill and nci_unregister_device().
Date: Wed,  4 Feb 2026 15:39:34 +0100
Message-ID: <20260204143916.801327046@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit d2492688bb9fed6ab6e313682c387ae71a66ebae ]

syzbot reported the splat below [0] without a repro.

It indicates that struct nci_dev.cmd_wq had been destroyed before
nci_close_device() was called via rfkill.

nci_dev.cmd_wq is only destroyed in nci_unregister_device(), which
(I think) was called from virtual_ncidev_close() when syzbot close()d
an fd of virtual_ncidev.

The problem is that nci_unregister_device() destroys nci_dev.cmd_wq
first and then calls nfc_unregister_device(), which removes the
device from rfkill by rfkill_unregister().

So, the device is still visible via rfkill even after nci_dev.cmd_wq
is destroyed.

Let's unregister the device from rfkill first in nci_unregister_device().

Note that we cannot call nfc_unregister_device() before
nci_close_device() because

  1) nfc_unregister_device() calls device_del() which frees
     all memory allocated by devm_kzalloc() and linked to
     ndev->conn_info_list

  2) nci_rx_work() could try to queue nci_conn_info to
     ndev->conn_info_list which could be leaked

Thus, nfc_unregister_device() is split into two functions so we
can remove rfkill interfaces only before nci_close_device().

[0]:
DEBUG_LOCKS_WARN_ON(1)
WARNING: kernel/locking/lockdep.c:238 at hlock_class kernel/locking/lockdep.c:238 [inline], CPU#0: syz.0.8675/6349
WARNING: kernel/locking/lockdep.c:238 at check_wait_context kernel/locking/lockdep.c:4854 [inline], CPU#0: syz.0.8675/6349
WARNING: kernel/locking/lockdep.c:238 at __lock_acquire+0x39d/0x2cf0 kernel/locking/lockdep.c:5187, CPU#0: syz.0.8675/6349
Modules linked in:
CPU: 0 UID: 0 PID: 6349 Comm: syz.0.8675 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
RIP: 0010:hlock_class kernel/locking/lockdep.c:238 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4854 [inline]
RIP: 0010:__lock_acquire+0x3a4/0x2cf0 kernel/locking/lockdep.c:5187
Code: 18 00 4c 8b 74 24 08 75 27 90 e8 17 f2 fc 02 85 c0 74 1c 83 3d 50 e0 4e 0e 00 75 13 48 8d 3d 43 f7 51 0e 48 c7 c6 8b 3a de 8d <67> 48 0f b9 3a 90 31 c0 0f b6 98 c4 00 00 00 41 8b 45 20 25 ff 1f
RSP: 0018:ffffc9000c767680 EFLAGS: 00010046
RAX: 0000000000000001 RBX: 0000000000040000 RCX: 0000000000080000
RDX: ffffc90013080000 RSI: ffffffff8dde3a8b RDI: ffffffff8ff24ca0
RBP: 0000000000000003 R08: ffffffff8fef35a3 R09: 1ffffffff1fde6b4
R10: dffffc0000000000 R11: fffffbfff1fde6b5 R12: 00000000000012a2
R13: ffff888030338ba8 R14: ffff888030338000 R15: ffff888030338b30
FS:  00007fa5995f66c0(0000) GS:ffff8881256f8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7e72f842d0 CR3: 00000000485a0000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
 touch_wq_lockdep_map+0xcb/0x180 kernel/workqueue.c:3940
 __flush_workqueue+0x14b/0x14f0 kernel/workqueue.c:3982
 nci_close_device+0x302/0x630 net/nfc/nci/core.c:567
 nci_dev_down+0x3b/0x50 net/nfc/nci/core.c:639
 nfc_dev_down+0x152/0x290 net/nfc/core.c:161
 nfc_rfkill_set_block+0x2d/0x100 net/nfc/core.c:179
 rfkill_set_block+0x1d2/0x440 net/rfkill/core.c:346
 rfkill_fop_write+0x461/0x5a0 net/rfkill/core.c:1301
 vfs_write+0x29a/0xb90 fs/read_write.c:684
 ksys_write+0x150/0x270 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa59b39acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa5995f6028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fa59b615fa0 RCX: 00007fa59b39acb9
RDX: 0000000000000008 RSI: 0000200000000080 RDI: 0000000000000007
RBP: 00007fa59b408bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa59b616038 R14: 00007fa59b615fa0 R15: 00007ffc82218788
 </TASK>

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Reported-by: syzbot+f9c5fd1a0874f9069dce@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/695e7f56.050a0220.1c677c.036c.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260127040411.494931-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/nfc/nfc.h |  2 ++
 net/nfc/core.c        | 27 ++++++++++++++++++++++++---
 net/nfc/nci/core.c    |  4 +++-
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 5dee575fbe86a..b82f4f2a27fb8 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -215,6 +215,8 @@ static inline void nfc_free_device(struct nfc_dev *dev)
 
 int nfc_register_device(struct nfc_dev *dev);
 
+void nfc_unregister_rfkill(struct nfc_dev *dev);
+void nfc_remove_device(struct nfc_dev *dev);
 void nfc_unregister_device(struct nfc_dev *dev);
 
 /**
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 5352571b62148..a02ede8b067bd 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -1147,14 +1147,14 @@ int nfc_register_device(struct nfc_dev *dev)
 EXPORT_SYMBOL(nfc_register_device);
 
 /**
- * nfc_unregister_device - unregister a nfc device in the nfc subsystem
+ * nfc_unregister_rfkill - unregister a nfc device in the rfkill subsystem
  *
  * @dev: The nfc device to unregister
  */
-void nfc_unregister_device(struct nfc_dev *dev)
+void nfc_unregister_rfkill(struct nfc_dev *dev)
 {
-	int rc;
 	struct rfkill *rfk = NULL;
+	int rc;
 
 	pr_debug("dev_name=%s\n", dev_name(&dev->dev));
 
@@ -1175,7 +1175,16 @@ void nfc_unregister_device(struct nfc_dev *dev)
 		rfkill_unregister(rfk);
 		rfkill_destroy(rfk);
 	}
+}
+EXPORT_SYMBOL(nfc_unregister_rfkill);
 
+/**
+ * nfc_remove_device - remove a nfc device in the nfc subsystem
+ *
+ * @dev: The nfc device to remove
+ */
+void nfc_remove_device(struct nfc_dev *dev)
+{
 	if (dev->ops->check_presence) {
 		del_timer_sync(&dev->check_pres_timer);
 		cancel_work_sync(&dev->check_pres_work);
@@ -1188,6 +1197,18 @@ void nfc_unregister_device(struct nfc_dev *dev)
 	device_del(&dev->dev);
 	mutex_unlock(&nfc_devlist_mutex);
 }
+EXPORT_SYMBOL(nfc_remove_device);
+
+/**
+ * nfc_unregister_device - unregister a nfc device in the nfc subsystem
+ *
+ * @dev: The nfc device to unregister
+ */
+void nfc_unregister_device(struct nfc_dev *dev)
+{
+	nfc_unregister_rfkill(dev);
+	nfc_remove_device(dev);
+}
 EXPORT_SYMBOL(nfc_unregister_device);
 
 static int __init nfc_init(void)
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 6196bb512dfc1..2ffdbbf90eb70 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1291,6 +1291,8 @@ void nci_unregister_device(struct nci_dev *ndev)
 {
 	struct nci_conn_info *conn_info, *n;
 
+	nfc_unregister_rfkill(ndev->nfc_dev);
+
 	/* This set_bit is not protected with specialized barrier,
 	 * However, it is fine because the mutex_lock(&ndev->req_lock);
 	 * in nci_close_device() will help to emit one.
@@ -1308,7 +1310,7 @@ void nci_unregister_device(struct nci_dev *ndev)
 		/* conn_info is allocated with devm_kzalloc */
 	}
 
-	nfc_unregister_device(ndev->nfc_dev);
+	nfc_remove_device(ndev->nfc_dev);
 }
 EXPORT_SYMBOL(nci_unregister_device);
 
-- 
2.51.0



