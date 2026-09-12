Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD5E37FF46;
	Sat, 12 Sep 2026 09:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204194; cv=none; b=kLq51vbbB49QtD/Vr4Xbcw/zuxeX/54oHjTI5iHvoYmiOUDmzun+LVg/OEM2MweCcLBe2L/Zda61hWGMFNrH17onwyiopUM1ee/Ajc3A2mj/C1rhayS+qMpfhcenayltYmiwOnWLOS4zsiLtAwl1S06kX73Q/jg53k00/spvRxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204194; c=relaxed/simple;
	bh=wV+OIosVPezhnZs4SMqaIq7YPoL1B0uGukHFyQlR8Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKzPUMRlcRAnn+PjtcVC4V8NeafZBC/xZST6H/+VIp1tGJw3lAizjDi9+xD+1O5Az1kJYAV5xmxGJ27izhJnBwDQWErCMgdLZBstGSAaRE0mM5WDWz45gfpdG2+laFKd2izoi7a7g5STK/8cnetTBKJ3Wp8VXtsG+Y66h4j4rcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBmwblzN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBmwblzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAE31F000FF;
	Sat, 12 Sep 2026 09:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204192;
	bh=u5HfijQqVUC9SjHSFmVtdp9jUZ7Gvp47ib9YCyCcQmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBmwblzNxqaVrvWNwOtkVgsAuvk8eMibKOyG1Wo84IZ/4tQrEPbjRLXSq7muHksor
	 n9jDfuFYeq+wJVuvy/9n0NT4i4twUtshV7cNlZHEmrFrJEd/8KUgmzGtVE/B7eahUS
	 CVIbe04sQnm/8bPvPJN5/+J1WD/1qwxWuBLKievU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Joyner <eric.joyner@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1563/1815] ionic: add missing dma_rmb() after the completion publish check
Date: Sat, 12 Sep 2026 08:55:13 +0200
Message-ID: <20260912065725.686397000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Joyner <eric.joyner@amd.com>

[ Upstream commit 621f44af8c5b373de2b2e19a4a8db9e45c3c659a ]

Each completion service routine tests a device-written publish flag and
then reads the rest of the descriptor with nothing ordering those loads.
A control dependency does not order loads, so a weakly ordered CPU may
satisfy the payload reads from a cache line state observed before the
flag became valid. Add the barrier to all four completion paths.

Fixes: 1d062b7b6f64 ("ionic: Add basic adminq support")
Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Fixes: 77ceb68e29cc ("ionic: Add notifyq support")
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260811195039.1315045-2-eric.joyner@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 4 ++++
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 6e6f3ed07271b..10501be9ef956 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -269,6 +269,8 @@ bool ionic_notifyq_service(struct ionic_cq *cq)
 	if ((s64)(eid - lif->last_eid) <= 0)
 		return false;
 
+	dma_rmb();
+
 	lif->last_eid = eid;
 
 	dev_dbg(lif->ionic->dev, "notifyq event:\n");
@@ -314,6 +316,8 @@ bool ionic_adminq_service(struct ionic_cq *cq)
 	if (!color_match(comp->color, cq->done_color))
 		return false;
 
+	dma_rmb();
+
 	/* check for empty queue */
 	if (q->tail_idx == q->head_idx)
 		return false;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 73998d61593a9..c3bcfdd1a1405 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -739,6 +739,8 @@ static bool __ionic_rx_service(struct ionic_cq *cq, struct bpf_prog *xdp_prog)
 	if (!color_match(comp->pkt_type_color, cq->done_color))
 		return false;
 
+	dma_rmb();
+
 	/* check for empty queue */
 	if (q->tail_idx == q->head_idx)
 		return false;
@@ -1254,6 +1256,8 @@ static bool ionic_tx_service(struct ionic_cq *cq,
 	if (!color_match(comp->color, cq->done_color))
 		return false;
 
+	dma_rmb();
+
 	/* clean the related q entries, there could be
 	 * several q entries completed for each cq completion
 	 */
-- 
2.53.0



