Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA30D1E8320;
	Tue, 16 Jun 2026 15:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623217; cv=none; b=oExlLQ/aYpoDQyEyUgCNcGQqqSz2m6CRf966ecJB0C49UNtzrJ2HIykCnQF1Z0S9xsqt1emCCAs/4onBRnngwgy++GrZJmjVrryCMCRkmldzob4wwCgbh5bW6q9l7Vm4aecS0AioLMUlZu23cT9Wsiw4CqbF0bEIG1ogxi7CohQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623217; c=relaxed/simple;
	bh=WSUc4Yz0pynm+BG7c+SAD1dz3aYI6yb83qdYeapine0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9XiMjSWbW2rQcLNx41IDBt8WabD/aNO/FctrceNXDJoJEAA59CE8PlFVa2GF2kO4Owb47i2q1g08K+xR83HaRE8dVgwBqXtpp3/UoP9mS6e1qd0jdShUjuLcUEz1SD/WSgjR6V7z2IRuBvch8acmlTFQ6AEud01Xhcgl3fqCaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mB9Es6iq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mB9Es6iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB9A1F000E9;
	Tue, 16 Jun 2026 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623215;
	bh=SZSR9BVpKlGLwsEoIgc25VgZRTuN0CzUknt6+196BqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mB9Es6iqKJgT/g37KUaPpN1CAbrd9DDCVbEQj8JvnA4YAH3EUH3NEsKHDD/aJSVlM
	 g1Drjf83mA9ysX0AVucjCeClbSYl2vuXn1OF9VlIo0X/wTIzRAeZIIYl8dTKSrvluQ
	 wwipaqO4DNZWE6vlqgLOZGkKjdqQVm1Cr4Clap8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 074/378] Reapply "bnxt_en: bring back rtnl_lock() in the bnxt_open() path"
Date: Tue, 16 Jun 2026 20:25:05 +0530
Message-ID: <20260616145114.048575922@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b6197b386677ae5268d4702e23849d9ad53051ad ]

This reverts commit 850d9248d2eac662f869c766a598c877690c74e5.
This reapplies commit 325eb217e41f ("bnxt_en: bring back rtnl_lock()
in the bnxt_open() path").

Breno reports a lockdep warning in bnxt. During FW reset the driver
may end up calling netif_set_real_num_tx_queues() (if queue count
changes), so calls to bnxt_open() still require rtnl_lock.

  net/sched/sch_generic.c:1416 suspicious rcu_dereference_protected() usage!

   dev_qdisc_change_real_num_tx+0x54/0xe0
   netif_set_real_num_tx_queues+0x4ed/0xa80
   __bnxt_open_nic+0x9cb/0x3490
   bnxt_open+0x1cb/0x370
   bnxt_fw_reset_task+0x80d/0x1e80
   process_scheduled_works+0x9c1/0x13b0

The reverted commit was just an optimization / experiment
so let's go back to taking the lock.

Reported-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/ah726OtFX-Qw3U-R@gmail.com
Fixes: 850d9248d2ea ("Revert "bnxt_en: bring back rtnl_lock() in the bnxt_open() path"")
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260603195845.2574426-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 36 ++++++++++++++++++-----
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 86e45352cec105..ff5501999b4df1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -14290,13 +14290,28 @@ static void bnxt_unlock_sp(struct bnxt *bp)
 	netdev_unlock(bp->dev);
 }
 
+/* Same as bnxt_lock_sp() with additional rtnl_lock */
+static void bnxt_rtnl_lock_sp(struct bnxt *bp)
+{
+	clear_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
+	rtnl_lock();
+	netdev_lock(bp->dev);
+}
+
+static void bnxt_rtnl_unlock_sp(struct bnxt *bp)
+{
+	set_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
+	netdev_unlock(bp->dev);
+	rtnl_unlock();
+}
+
 /* Only called from bnxt_sp_task() */
 static void bnxt_reset(struct bnxt *bp, bool silent)
 {
-	bnxt_lock_sp(bp);
+	bnxt_rtnl_lock_sp(bp);
 	if (test_bit(BNXT_STATE_OPEN, &bp->state))
 		bnxt_reset_task(bp, silent);
-	bnxt_unlock_sp(bp);
+	bnxt_rtnl_unlock_sp(bp);
 }
 
 /* Only called from bnxt_sp_task() */
@@ -14304,9 +14319,9 @@ static void bnxt_rx_ring_reset(struct bnxt *bp)
 {
 	int i;
 
-	bnxt_lock_sp(bp);
+	bnxt_rtnl_lock_sp(bp);
 	if (!test_bit(BNXT_STATE_OPEN, &bp->state)) {
-		bnxt_unlock_sp(bp);
+		bnxt_rtnl_unlock_sp(bp);
 		return;
 	}
 	/* Disable and flush TPA before resetting the RX ring */
@@ -14345,7 +14360,7 @@ static void bnxt_rx_ring_reset(struct bnxt *bp)
 	}
 	if (bp->flags & BNXT_FLAG_TPA)
 		bnxt_set_tpa(bp, true);
-	bnxt_unlock_sp(bp);
+	bnxt_rtnl_unlock_sp(bp);
 }
 
 static void bnxt_fw_fatal_close(struct bnxt *bp)
@@ -15255,15 +15270,17 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_OPENING;
 		fallthrough;
 	case BNXT_FW_RESET_STATE_OPENING:
-		while (!netdev_trylock(bp->dev)) {
+		while (!rtnl_trylock()) {
 			bnxt_queue_fw_reset_work(bp, HZ / 10);
 			return;
 		}
+		netdev_lock(bp->dev);
 		rc = bnxt_open(bp->dev);
 		if (rc) {
 			netdev_err(bp->dev, "bnxt_open() failed during FW reset\n");
 			bnxt_fw_reset_abort(bp, rc);
 			netdev_unlock(bp->dev);
+			rtnl_unlock();
 			goto ulp_start;
 		}
 
@@ -15283,6 +15300,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 			bnxt_dl_health_fw_status_update(bp, true);
 		}
 		netdev_unlock(bp->dev);
+		rtnl_unlock();
 		bnxt_ulp_start(bp);
 		bnxt_reenable_sriov(bp);
 		netdev_lock(bp->dev);
@@ -16272,7 +16290,7 @@ static int bnxt_queue_start(struct net_device *dev,
 		   rc);
 	napi_enable_locked(&bnapi->napi);
 	bnxt_db_nq_arm(bp, &cpr->cp_db, cpr->cp_raw_cons);
-	bnxt_reset_task(bp, true);
+	netif_close(dev);
 	return rc;
 }
 
@@ -17116,6 +17134,7 @@ static int bnxt_resume(struct device *device)
 	struct bnxt *bp = netdev_priv(dev);
 	int rc = 0;
 
+	rtnl_lock();
 	netdev_lock(dev);
 	rc = pci_enable_device(bp->pdev);
 	if (rc) {
@@ -17160,6 +17179,7 @@ static int bnxt_resume(struct device *device)
 
 resume_exit:
 	netdev_unlock(bp->dev);
+	rtnl_unlock();
 	if (!rc) {
 		bnxt_ulp_start(bp);
 		bnxt_reenable_sriov(bp);
@@ -17326,6 +17346,7 @@ static void bnxt_io_resume(struct pci_dev *pdev)
 	int err;
 
 	netdev_info(bp->dev, "PCI Slot Resume\n");
+	rtnl_lock();
 	netdev_lock(netdev);
 
 	err = bnxt_hwrm_func_qcaps(bp);
@@ -17343,6 +17364,7 @@ static void bnxt_io_resume(struct pci_dev *pdev)
 		netif_device_attach(netdev);
 
 	netdev_unlock(netdev);
+	rtnl_unlock();
 	if (!err) {
 		bnxt_ulp_start(bp);
 		bnxt_reenable_sriov(bp);
-- 
2.53.0



