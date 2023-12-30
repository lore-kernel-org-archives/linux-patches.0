Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA92E8F4F;
	Sat, 30 Dec 2023 12:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpQH4dGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7335DC433C7;
	Sat, 30 Dec 2023 12:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938110;
	bh=0BchEaUgmn+Luyi9fHxyl7b/7qToO+D2yrUyRu0L5O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpQH4dGySNWbHiO0u7E0n+waJX9c4P8zcjIeODwqYneJ3LraiWIoqiEdncoMXifMx
	 aNQa9QwKcbdJWCeNTa1AUA75nM+6+CDiEqPaIk2GYGdubfOH7AYkeQx8X1ryyB0Hed
	 IdaESCXSClKzCdsU1q+AMv8CGiQO2Fm9xO+FMwCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Hsu <yinghsu@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/112] Bluetooth: Fix deadlock in vhci_send_frame
Date: Sat, 30 Dec 2023 11:59:04 +0000
Message-ID: <20231230115807.749489379@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Hsu <yinghsu@chromium.org>

[ Upstream commit 769bf60e17ee1a56a81e7c031192c3928312c52e ]

syzbot found a potential circular dependency leading to a deadlock:
    -> #3 (&hdev->req_lock){+.+.}-{3:3}:
    __mutex_lock_common+0x1b6/0x1bc2 kernel/locking/mutex.c:599
    __mutex_lock kernel/locking/mutex.c:732 [inline]
    mutex_lock_nested+0x17/0x1c kernel/locking/mutex.c:784
    hci_dev_do_close+0x3f/0x9f net/bluetooth/hci_core.c:551
    hci_rfkill_set_block+0x130/0x1ac net/bluetooth/hci_core.c:935
    rfkill_set_block+0x1e6/0x3b8 net/rfkill/core.c:345
    rfkill_fop_write+0x2d8/0x672 net/rfkill/core.c:1274
    vfs_write+0x277/0xcf5 fs/read_write.c:594
    ksys_write+0x19b/0x2bd fs/read_write.c:650
    do_syscall_x64 arch/x86/entry/common.c:55 [inline]
    do_syscall_64+0x51/0xba arch/x86/entry/common.c:93
    entry_SYSCALL_64_after_hwframe+0x61/0xcb

    -> #2 (rfkill_global_mutex){+.+.}-{3:3}:
    __mutex_lock_common+0x1b6/0x1bc2 kernel/locking/mutex.c:599
    __mutex_lock kernel/locking/mutex.c:732 [inline]
    mutex_lock_nested+0x17/0x1c kernel/locking/mutex.c:784
    rfkill_register+0x30/0x7e3 net/rfkill/core.c:1045
    hci_register_dev+0x48f/0x96d net/bluetooth/hci_core.c:2622
    __vhci_create_device drivers/bluetooth/hci_vhci.c:341 [inline]
    vhci_create_device+0x3ad/0x68f drivers/bluetooth/hci_vhci.c:374
    vhci_get_user drivers/bluetooth/hci_vhci.c:431 [inline]
    vhci_write+0x37b/0x429 drivers/bluetooth/hci_vhci.c:511
    call_write_iter include/linux/fs.h:2109 [inline]
    new_sync_write fs/read_write.c:509 [inline]
    vfs_write+0xaa8/0xcf5 fs/read_write.c:596
    ksys_write+0x19b/0x2bd fs/read_write.c:650
    do_syscall_x64 arch/x86/entry/common.c:55 [inline]
    do_syscall_64+0x51/0xba arch/x86/entry/common.c:93
    entry_SYSCALL_64_after_hwframe+0x61/0xcb

    -> #1 (&data->open_mutex){+.+.}-{3:3}:
    __mutex_lock_common+0x1b6/0x1bc2 kernel/locking/mutex.c:599
    __mutex_lock kernel/locking/mutex.c:732 [inline]
    mutex_lock_nested+0x17/0x1c kernel/locking/mutex.c:784
    vhci_send_frame+0x68/0x9c drivers/bluetooth/hci_vhci.c:75
    hci_send_frame+0x1cc/0x2ff net/bluetooth/hci_core.c:2989
    hci_sched_acl_pkt net/bluetooth/hci_core.c:3498 [inline]
    hci_sched_acl net/bluetooth/hci_core.c:3583 [inline]
    hci_tx_work+0xb94/0x1a60 net/bluetooth/hci_core.c:3654
    process_one_work+0x901/0xfb8 kernel/workqueue.c:2310
    worker_thread+0xa67/0x1003 kernel/workqueue.c:2457
    kthread+0x36a/0x430 kernel/kthread.c:319
    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

    -> #0 ((work_completion)(&hdev->tx_work)){+.+.}-{0:0}:
    check_prev_add kernel/locking/lockdep.c:3053 [inline]
    check_prevs_add kernel/locking/lockdep.c:3172 [inline]
    validate_chain kernel/locking/lockdep.c:3787 [inline]
    __lock_acquire+0x2d32/0x77fa kernel/locking/lockdep.c:5011
    lock_acquire+0x273/0x4d5 kernel/locking/lockdep.c:5622
    __flush_work+0xee/0x19f kernel/workqueue.c:3090
    hci_dev_close_sync+0x32f/0x1113 net/bluetooth/hci_sync.c:4352
    hci_dev_do_close+0x47/0x9f net/bluetooth/hci_core.c:553
    hci_rfkill_set_block+0x130/0x1ac net/bluetooth/hci_core.c:935
    rfkill_set_block+0x1e6/0x3b8 net/rfkill/core.c:345
    rfkill_fop_write+0x2d8/0x672 net/rfkill/core.c:1274
    vfs_write+0x277/0xcf5 fs/read_write.c:594
    ksys_write+0x19b/0x2bd fs/read_write.c:650
    do_syscall_x64 arch/x86/entry/common.c:55 [inline]
    do_syscall_64+0x51/0xba arch/x86/entry/common.c:93
    entry_SYSCALL_64_after_hwframe+0x61/0xcb

This change removes the need for acquiring the open_mutex in
vhci_send_frame, thus eliminating the potential deadlock while
maintaining the required packet ordering.

Fixes: 92d4abd66f70 ("Bluetooth: vhci: Fix race when opening vhci device")
Signed-off-by: Ying Hsu <yinghsu@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_vhci.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 4415d850d698b..44dc91555aa00 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <asm/unaligned.h>
 
+#include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -44,6 +45,7 @@ struct vhci_data {
 	bool wakeup;
 	__u16 msft_opcode;
 	bool aosp_capable;
+	atomic_t initialized;
 };
 
 static int vhci_open_dev(struct hci_dev *hdev)
@@ -75,11 +77,10 @@ static int vhci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 
 	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
 
-	mutex_lock(&data->open_mutex);
 	skb_queue_tail(&data->readq, skb);
-	mutex_unlock(&data->open_mutex);
 
-	wake_up_interruptible(&data->read_wait);
+	if (atomic_read(&data->initialized))
+		wake_up_interruptible(&data->read_wait);
 	return 0;
 }
 
@@ -363,7 +364,8 @@ static int __vhci_create_device(struct vhci_data *data, __u8 opcode)
 	skb_put_u8(skb, 0xff);
 	skb_put_u8(skb, opcode);
 	put_unaligned_le16(hdev->id, skb_put(skb, 2));
-	skb_queue_tail(&data->readq, skb);
+	skb_queue_head(&data->readq, skb);
+	atomic_inc(&data->initialized);
 
 	wake_up_interruptible(&data->read_wait);
 	return 0;
-- 
2.43.0



