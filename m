Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53CC314D11;
	Mon, 13 Oct 2025 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367254; cv=none; b=V4BhV4DIc7FY3mCUgn83AI3xKcHLOxwVnVLAIr9mujuCkytrXe4T/RwoQmgtHX3QTjTvDGSSoR0Z8HflxcDpt/Omf+fI+TP842rniTQYeydbDfyAHfw84OydR1eSD4R2N+n4hix0cHJK94uHENH54IEsTUhA4/BzKX41Y0vXfMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367254; c=relaxed/simple;
	bh=mmHbqoN7rHPvbpal5WqRsNZ0OMT142yLSjcfx1K6QlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvWTtDtukroJkSvB7UxsSqS1sixUQ4u/NKkf8ki1PWfaRrikp0pSyal4KD58AdYqQya1hWSjIjgkTZgZx9dNprvnBI0KHBi9sTcHmCQ7baMB90OiQfkUZqTyk0MZ+CMx3EuFlDFx1AcdFbSdhKOHgBjXOl8lzF7hL86VWhUoYok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkLFV93Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkLFV93Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E67C4CEE7;
	Mon, 13 Oct 2025 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367254;
	bh=mmHbqoN7rHPvbpal5WqRsNZ0OMT142yLSjcfx1K6QlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkLFV93QYZ1SYxfu+M29QD+Nfj593VKbeuJ4l0tNavxPFW89Iad60fi8l9j2ELRkv
	 CSN+nfoREn/YW3854CN6T5ZR36hMGpfdhVOTMWbGXvDcig8oF7d1UPgs1sfjFej3sM
	 I1tkLXci5PE9kLAy9bEhcxe7GLppTheTLann1GrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/196] wifi: rtw89: avoid circular locking dependency in ser_state_run()
Date: Mon, 13 Oct 2025 16:45:18 +0200
Message-ID: <20251013144319.944387799@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index f5dacdc4d11ab..24a9025e5bea8 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -204,7 +204,6 @@ static void rtw89_ser_hdl_work(struct work_struct *work)
 
 static int ser_send_msg(struct rtw89_ser *ser, u8 event)
 {
-	struct rtw89_dev *rtwdev = container_of(ser, struct rtw89_dev, ser);
 	struct ser_msg *msg = NULL;
 
 	if (test_bit(RTW89_SER_DRV_STOP_RUN, ser->flags))
@@ -220,7 +219,7 @@ static int ser_send_msg(struct rtw89_ser *ser, u8 event)
 	list_add(&msg->list, &ser->msg_q);
 	spin_unlock_irq(&ser->msg_q_lock);
 
-	ieee80211_queue_work(rtwdev->hw, &ser->ser_hdl_work);
+	schedule_work(&ser->ser_hdl_work);
 	return 0;
 }
 
-- 
2.51.0



