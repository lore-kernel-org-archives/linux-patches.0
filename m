Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63E73033D6;
	Tue, 31 Mar 2026 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976768; cv=none; b=ALcnRDsxij3IEQa2Yqk8aTj/tF5xoVdCIVYA4AM6ZAAVe0KNlMUtv0ngUht5tOTiN02UKMhb7soqnfN0xOv0az/NioNmGR359i6KOIKPG3LQImhsM8YgTj7cMUTQWXC/AWvMAkucmYrjKxKCU68cOs8c+Np7JKW5OuP/02LrsTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976768; c=relaxed/simple;
	bh=y+B+QrWpSTDeIhyLnjrNtxlCt7TdNGzdYvvbXHoMOPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ui/s532wnHSdn9sBCCh9EDSoOl5zZBAHc8VEsvkeqfmrkNFQHY58sTsTbMX1upEG8uDIlQVnc+NzOuq2+atsvUAuBo3V0x1tqYQHvdQZMUmm19jN2/uHKzzDvLY09r+I/7ujIngtECHAFOYtSk50lIrNNhoz5mWBAV2s6a9l3kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLyCGjS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLyCGjS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D10BC19423;
	Tue, 31 Mar 2026 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976768;
	bh=y+B+QrWpSTDeIhyLnjrNtxlCt7TdNGzdYvvbXHoMOPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLyCGjS9iymRQfDkjZZhQUxmGM8bQsbmKyQG1nQ/SbjpKKZXt2D9t6l8aBhUP5sAo
	 62gxZ/N0Bf1X4gJyQffiu7LseQHFAXvpXOuoOxJ9KAKzF0QNDcHMvL3xGS98G20h4P
	 Slu03INrtsAGWtsObEnb0MIM5eoYX15ZtO0JUMZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 220/309] net: macb: Protect access to net_device::ip_ptr with RCU lock
Date: Tue, 31 Mar 2026 18:22:03 +0200
Message-ID: <20260331161801.545100106@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

commit baa35a698cea26930679a20a7550bbb4c8319725 upstream.

Access to net_device::ip_ptr and its associated members must be
protected by an RCU lock. Since we are modifying this piece of code,
let's also move it to execute only when WAKE_ARP is enabled.

To minimize the duration of the RCU lock, a local variable is used to
temporarily store the IP address. This change resolves the following
RCU check warning:
  WARNING: suspicious RCU usage
  7.0.0-rc3-next-20260310-yocto-standard+ #122 Not tainted
  -----------------------------
  drivers/net/ethernet/cadence/macb_main.c:5944 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  5 locks held by rtcwake/518:
   #0: ffff000803ab1408 (sb_writers#5){.+.+}-{0:0}, at: vfs_write+0xf8/0x368
   #1: ffff0008090bf088 (&of->mutex#2){+.+.}-{4:4}, at: kernfs_fop_write_iter+0xbc/0x1c8
   #2: ffff00080098d588 (kn->active#70){.+.+}-{0:0}, at: kernfs_fop_write_iter+0xcc/0x1c8
   #3: ffff800081c84888 (system_transition_mutex){+.+.}-{4:4}, at: pm_suspend+0x1ec/0x290
   #4: ffff0008009ba0f8 (&dev->mutex){....}-{4:4}, at: device_suspend+0x118/0x4f0

  stack backtrace:
  CPU: 3 UID: 0 PID: 518 Comm: rtcwake Not tainted 7.0.0-rc3-next-20260310-yocto-standard+ #122 PREEMPT
  Hardware name: ZynqMP ZCU102 Rev1.1 (DT)
  Call trace:
   show_stack+0x24/0x38 (C)
   __dump_stack+0x28/0x38
   dump_stack_lvl+0x64/0x88
   dump_stack+0x18/0x24
   lockdep_rcu_suspicious+0x134/0x1d8
   macb_suspend+0xd8/0x4c0
   device_suspend+0x218/0x4f0
   dpm_suspend+0x244/0x3a0
   dpm_suspend_start+0x50/0x78
   suspend_devices_and_enter+0xec/0x560
   pm_suspend+0x194/0x290
   state_store+0x110/0x158
   kobj_attr_store+0x1c/0x30
   sysfs_kf_write+0xa8/0xd0
   kernfs_fop_write_iter+0x11c/0x1c8
   vfs_write+0x248/0x368
   ksys_write+0x7c/0xf8
   __arm64_sys_write+0x28/0x40
   invoke_syscall+0x4c/0xe8
   el0_svc_common+0x98/0xf0
   do_el0_svc+0x28/0x40
   el0_svc+0x54/0x1e0
   el0t_64_sync_handler+0x84/0x130
   el0t_64_sync+0x198/0x1a0

Fixes: 0cb8de39a776 ("net: macb: Add ARP support to WOL")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://patch.msgid.link/20260318-macb-irq-v2-2-f1179768ab24@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5773,9 +5773,9 @@ static int __maybe_unused macb_suspend(s
 	struct macb_queue *queue;
 	struct in_device *idev;
 	unsigned long flags;
+	u32 tmp, ifa_local;
 	unsigned int q;
 	int err;
-	u32 tmp;
 
 	if (!device_may_wakeup(&bp->dev->dev))
 		phy_exit(bp->sgmii_phy);
@@ -5784,14 +5784,21 @@ static int __maybe_unused macb_suspend(s
 		return 0;
 
 	if (bp->wol & MACB_WOL_ENABLED) {
-		/* Check for IP address in WOL ARP mode */
-		idev = __in_dev_get_rcu(bp->dev);
-		if (idev)
-			ifa = rcu_dereference(idev->ifa_list);
-		if ((bp->wolopts & WAKE_ARP) && !ifa) {
-			netdev_err(netdev, "IP address not assigned as required by WoL walk ARP\n");
-			return -EOPNOTSUPP;
+		if (bp->wolopts & WAKE_ARP) {
+			/* Check for IP address in WOL ARP mode */
+			rcu_read_lock();
+			idev = __in_dev_get_rcu(bp->dev);
+			if (idev)
+				ifa = rcu_dereference(idev->ifa_list);
+			if (!ifa) {
+				rcu_read_unlock();
+				netdev_err(netdev, "IP address not assigned as required by WoL walk ARP\n");
+				return -EOPNOTSUPP;
+			}
+			ifa_local = be32_to_cpu(ifa->ifa_local);
+			rcu_read_unlock();
 		}
+
 		spin_lock_irqsave(&bp->lock, flags);
 
 		/* Disable Tx and Rx engines before  disabling the queues,
@@ -5830,7 +5837,7 @@ static int __maybe_unused macb_suspend(s
 		if (bp->wolopts & WAKE_ARP) {
 			tmp |= MACB_BIT(ARP);
 			/* write IP address into register */
-			tmp |= MACB_BFEXT(IP, be32_to_cpu(ifa->ifa_local));
+			tmp |= MACB_BFEXT(IP, ifa_local);
 		}
 		spin_unlock_irqrestore(&bp->lock, flags);
 


