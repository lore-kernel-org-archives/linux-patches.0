Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615D5221F20;
	Mon, 13 Oct 2025 15:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368567; cv=none; b=MOoChcVwFqQRFz8VHSv8xeuAYf+EgFbVOoPatS2ZTHCp3eRuHfK9apToZS/0LYxqZSQ0nbAiJx7SEahXKMCMP8XB1ngZ7i6OxW9p7Jpdb1TBg9dPb3eEl8l4BfhK2KIeKdWlr1Q3d1T1DkzMsPjf+LXuzFpsOz5QPlPSlCmsAdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368567; c=relaxed/simple;
	bh=6XdGgWrYVU0a1SqXstK9S431gMCc6RohGnqAxa+uiVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nijONgKgJaTSKFURe7Qxt+Id2/iZ+LREG1omT6IXqS3ylGyr6Qy1d9iI3TlQEMZhPLLp7f7rsj2PXKeKYKBguQFpSw/rGLxsNlPQeY53qAKexSdyG6E3JdnMXek01uxe4Q61D908Frkrp8WkSG6BaHajzpr+Et6l6LJ7ozc6x+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHt/PS2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHt/PS2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF993C4CEE7;
	Mon, 13 Oct 2025 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368567;
	bh=6XdGgWrYVU0a1SqXstK9S431gMCc6RohGnqAxa+uiVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHt/PS2OvtBH+vH2vz86+uojAL37auvFnmo7R0ovxS8YaIw7fCL8pfBxWMX+dBXI+
	 8Fv21C4YTg61XhoAmf6LUrE+NqirRCFOTy6N6mhE9C7ds5RBFiVERrZsrg4Kz4JkJ0
	 1wjGh18RXHG7pfPqZMO819uz6YwtdEcTZrEkzzBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/262] wifi: rtw89: avoid circular locking dependency in ser_state_run()
Date: Mon, 13 Oct 2025 16:45:20 +0200
Message-ID: <20251013144332.539765297@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 570f94511766f9236d3462dfb8a3c719c2b54c23 ]

Lockdep gives a splat [1] when ser_hdl_work item is executed.  It is
scheduled at mac80211 workqueue via ieee80211_queue_work() and takes a
wiphy lock inside.  However, this workqueue can be flushed when e.g.
closing the interface and wiphy lock is already taken in that case.

Choosing wiphy_work_queue() for SER is likely not suitable.  Back on to
the global workqueue.

[1]:

 WARNING: possible circular locking dependency detected
 6.17.0-rc2 #17 Not tainted
 ------------------------------------------------------
 kworker/u32:1/61 is trying to acquire lock:
 ffff88811bc00768 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: ser_state_run+0x5e/0x180 [rtw89_core]

 but task is already holding lock:
 ffffc9000048fd30 ((work_completion)(&ser->ser_hdl_work)){+.+.}-{0:0}, at: process_one_work+0x7b5/0x1450

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #2 ((work_completion)(&ser->ser_hdl_work)){+.+.}-{0:0}:
        process_one_work+0x7c6/0x1450
        worker_thread+0x49e/0xd00
        kthread+0x313/0x640
        ret_from_fork+0x221/0x300
        ret_from_fork_asm+0x1a/0x30

 -> #1 ((wq_completion)phy0){+.+.}-{0:0}:
        touch_wq_lockdep_map+0x8e/0x180
        __flush_workqueue+0x129/0x10d0
        ieee80211_stop_device+0xa8/0x110
        ieee80211_do_stop+0x14ce/0x2880
        ieee80211_stop+0x13a/0x2c0
        __dev_close_many+0x18f/0x510
        __dev_change_flags+0x25f/0x670
        netif_change_flags+0x7b/0x160
        do_setlink.isra.0+0x1640/0x35d0
        rtnl_newlink+0xd8c/0x1d30
        rtnetlink_rcv_msg+0x700/0xb80
        netlink_rcv_skb+0x11d/0x350
        netlink_unicast+0x49a/0x7a0
        netlink_sendmsg+0x759/0xc20
        ____sys_sendmsg+0x812/0xa00
        ___sys_sendmsg+0xf7/0x180
        __sys_sendmsg+0x11f/0x1b0
        do_syscall_64+0xbb/0x360
        entry_SYSCALL_64_after_hwframe+0x77/0x7f

 -> #0 (&rdev->wiphy.mtx){+.+.}-{4:4}:
        __lock_acquire+0x124c/0x1d20
        lock_acquire+0x154/0x2e0
        __mutex_lock+0x17b/0x12f0
        ser_state_run+0x5e/0x180 [rtw89_core]
        rtw89_ser_hdl_work+0x119/0x220 [rtw89_core]
        process_one_work+0x82d/0x1450
        worker_thread+0x49e/0xd00
        kthread+0x313/0x640
        ret_from_fork+0x221/0x300
        ret_from_fork_asm+0x1a/0x30

 other info that might help us debug this:

 Chain exists of:
   &rdev->wiphy.mtx --> (wq_completion)phy0 --> (work_completion)(&ser->ser_hdl_work)

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock((work_completion)(&ser->ser_hdl_work));
                                lock((wq_completion)phy0);
                                lock((work_completion)(&ser->ser_hdl_work));
   lock(&rdev->wiphy.mtx);

  *** DEADLOCK ***

 2 locks held by kworker/u32:1/61:
  #0: ffff888103835148 ((wq_completion)phy0){+.+.}-{0:0}, at: process_one_work+0xefa/0x1450
  #1: ffffc9000048fd30 ((work_completion)(&ser->ser_hdl_work)){+.+.}-{0:0}, at: process_one_work+0x7b5/0x1450

 stack backtrace:
 CPU: 0 UID: 0 PID: 61 Comm: kworker/u32:1 Not tainted 6.17.0-rc2 #17 PREEMPT(voluntary)
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS edk2-20250523-14.fc42 05/23/2025
 Workqueue: phy0 rtw89_ser_hdl_work [rtw89_core]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x5d/0x80
  print_circular_bug.cold+0x178/0x1be
  check_noncircular+0x14c/0x170
  __lock_acquire+0x124c/0x1d20
  lock_acquire+0x154/0x2e0
  __mutex_lock+0x17b/0x12f0
  ser_state_run+0x5e/0x180 [rtw89_core]
  rtw89_ser_hdl_work+0x119/0x220 [rtw89_core]
  process_one_work+0x82d/0x1450
  worker_thread+0x49e/0xd00
  kthread+0x313/0x640
  ret_from_fork+0x221/0x300
  ret_from_fork_asm+0x1a/0x30
  </TASK>

Found by Linux Verification Center (linuxtesting.org).

Fixes: ebfc9199df05 ("wifi: rtw89: add wiphy_lock() to work that isn't held wiphy_lock() yet")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250919210852.823912-5-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/ser.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index c0f0e3d71f5f5..2a303a758e276 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -207,7 +207,6 @@ static void rtw89_ser_hdl_work(struct work_struct *work)
 
 static int ser_send_msg(struct rtw89_ser *ser, u8 event)
 {
-	struct rtw89_dev *rtwdev = container_of(ser, struct rtw89_dev, ser);
 	struct ser_msg *msg = NULL;
 
 	if (test_bit(RTW89_SER_DRV_STOP_RUN, ser->flags))
@@ -223,7 +222,7 @@ static int ser_send_msg(struct rtw89_ser *ser, u8 event)
 	list_add(&msg->list, &ser->msg_q);
 	spin_unlock_irq(&ser->msg_q_lock);
 
-	ieee80211_queue_work(rtwdev->hw, &ser->ser_hdl_work);
+	schedule_work(&ser->ser_hdl_work);
 	return 0;
 }
 
-- 
2.51.0



