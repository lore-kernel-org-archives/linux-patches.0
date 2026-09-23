Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4893A6EF1;
	Wed, 23 Sep 2026 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173348; cv=none; b=tik7qnv4ilnRgjq5cBM3DpVWqWoLPWlxsetewCurVg4PiNxP4/QIl1Ll7dabG5RVbjW9YcHMir9XrVzHiaSo0I87QrG4UH3hLkp+U/T3MxdTqtGRE2pkXkbTnvkm3csX85EiurtVq1K0ENfWHJoAxHLCqH/HFjoRqz1y05HuGQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173348; c=relaxed/simple;
	bh=Pi6OZXrq0qZwZQNQ9Suj5X8wqlQ/njKW1zarAlIgFtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qniJL8VIigUu0y2Mjm4W5idDQtYPA7YR4OiOdDFJkoEXTGK4tLtPY1M7+Y6mbUjKYSI/yplnYgUCQJgON2lMrx7bSgEkBGa4dxep2Yh/B3qLyzN/JEHUtLKlCujyVvHVMJJoYqsE09uCuzrBtFmRWKU+NELyw0zZt2bxWu7IAmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jl+3q/Hf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jl+3q/Hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC70C1F000FF;
	Wed, 23 Sep 2026 14:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173346;
	bh=qe5bKhOtKJMmjpeJDD4aAkjU3GgILNYgcG9W+RL+d44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jl+3q/HfITsQYrUWGBBDg9ArsXth338YUvoChQadZyFMIOS6JyZGsH7eecPWTUoTh
	 U3mLqd3Fya6bApX09xc/65nQ+3DKaPLhm57afAwBK2xY40EC6FiHZrFSFFofaCQnPm
	 oklLftLWdSvjF29qjj46HNSXzHibkUJYaxgTtMuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 216/438] net: stmmac: preserve real_num_tx_queues on mqprio setup failure
Date: Wed, 23 Sep 2026 16:03:57 +0200
Message-ID: <20260923140650.361715219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 02fffd1939f6b45892f61822459953ce95e42948 ]

With the FPE preemption-class mapping error now propagated from
stmmac_fpe_map_preemption_class(), tc_setup_dwmac510_mqprio() can fail
on the mapping step. The error path used to call stmmac_reset_tc_mqprio(),
which resets the number of real TX queues to priv->plat->tx_queues_to_use
(the platform maximum), overwriting the value that was active before the
offload was attempted (for example a lower count left over from a previous
mqprio configuration).

The issue can be triggered using the following configuration:

  # First mqprio config lowers the hw queue count below the platform
  # default (e.g. 8 TX queues).
  $tc qdisc add dev eth0 root handle 1: mqprio queues 2@0 2@2

  # Replace mqprio configuration with a second one that fails FPE
  # preemption-class mapping. stmmac driver resets the real_num_tx_queues
  # to the platform maximum, losing the previous configuration.
  $tc qdisc replace dev eth0 root handle 2: mqprio queues 2@0 2@2 fp E P

Save ndev->real_num_tx_queues before lowering it and restore it,
together with the TC-to-queue and priority-to-TC mappings, when the FPE
preemption-class mapping fails, instead of resetting the queue count to
the platform maximum.

Note that a failed setup makes the qdisc layer run mqprio_destroy() on
the new qdisc. Because priv->hw_offload is only assigned after
ndo_setup_tc() succeeds, mqprio_destroy() calls netdev_set_num_tc(dev, 0),
so dev->num_tc ends up 0 regardless of the driver-side restore and the
previous qdisc is not reactivated. The restore is still needed to keep
real_num_tx_queues and to avoid leaving the failed configuration's
TC-to-queue and priority-to-TC mappings in place.

Fixes: 195e4f409a40 ("net: stmmac: support fp parameter of tc-mqprio")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260911-stmmac-tc_setup_dwmac510_mqprio-error-path-v3-2-a76b1e2547c1@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 82 ++++++++++++++-----
 1 file changed, 62 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 5398616fcdfea..42a00446e9b41 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1237,6 +1237,30 @@ static int tc_query_caps(struct stmmac_priv *priv,
 	}
 }
 
+static int stmmac_set_ndev_tcs(struct net_device *ndev, u8 ntc,
+			       struct netdev_tc_txq *tc_to_txq)
+{
+	int i, err;
+
+	netdev_reset_tc(ndev);
+	if (!ntc)
+		return 0;
+
+	err = netdev_set_num_tc(ndev, ntc);
+	if (err)
+		return err;
+
+	for (i = 0; i < ntc; i++) {
+		u16 count, offset;
+
+		count = tc_to_txq[i].count;
+		offset = tc_to_txq[i].offset;
+		netdev_set_tc_queue(ndev, i, count, offset);
+	}
+
+	return 0;
+}
+
 static int stmmac_reset_tc_mqprio(struct net_device *ndev,
 				  struct netlink_ext_ack *extack)
 {
@@ -1251,43 +1275,61 @@ static int stmmac_reset_tc_mqprio(struct net_device *ndev,
 static int tc_setup_dwmac510_mqprio(struct stmmac_priv *priv,
 				    struct tc_mqprio_qopt_offload *mqprio)
 {
+	unsigned int ndev_num_tx_queues, num_tx_queues = 0;
+	struct netdev_tc_txq ndev_tc_to_txq[TC_MAX_QUEUE];
+	struct netdev_tc_txq tc_to_txq[TC_MAX_QUEUE] = {};
 	struct netlink_ext_ack *extack = mqprio->extack;
 	struct tc_mqprio_qopt *qopt = &mqprio->qopt;
-	u32 offset, count, num_stack_tx_queues = 0;
 	struct net_device *ndev = priv->dev;
-	u32 num_tc = qopt->num_tc;
-	int err;
+	u8 ndev_prio_tc_map[TC_BITMASK + 1];
+	int i, err, ndev_ntc;
 
-	if (!num_tc)
+	if (!qopt->num_tc)
 		return stmmac_reset_tc_mqprio(ndev, extack);
 
-	err = netdev_set_num_tc(ndev, num_tc);
-	if (err)
-		return err;
-
-	for (u32 tc = 0; tc < num_tc; tc++) {
-		offset = qopt->offset[tc];
-		count = qopt->count[tc];
-		num_stack_tx_queues += count;
+	if (qopt->num_tc > ARRAY_SIZE(tc_to_txq))
+		return -EINVAL;
 
-		err = netdev_set_tc_queue(ndev, tc, count, offset);
-		if (err)
-			goto err_reset_tc;
+	/* save current tc values for reset */
+	ndev_ntc = netdev_get_num_tc(ndev);
+	for (i = 0; i < ARRAY_SIZE(ndev->tc_to_txq); i++)
+		ndev_tc_to_txq[i].combined =
+			READ_ONCE(ndev->tc_to_txq[i].combined);
+	for (i = 0; i < ARRAY_SIZE(ndev_prio_tc_map); i++)
+		ndev_prio_tc_map[i] = READ_ONCE(ndev->prio_tc_map[i]);
+
+	for (i = 0; i < qopt->num_tc; i++) {
+		tc_to_txq[i] = (struct netdev_tc_txq) {
+			.count = qopt->count[i],
+			.offset = qopt->offset[i],
+		};
+		num_tx_queues += qopt->count[i];
 	}
 
-	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+	err = stmmac_set_ndev_tcs(ndev, qopt->num_tc, tc_to_txq);
+	if (err)
+		goto error_reset_tc;
+
+	ndev_num_tx_queues = ndev->real_num_tx_queues;
+	err = netif_set_real_num_tx_queues(ndev, num_tx_queues);
 	if (err)
-		goto err_reset_tc;
+		goto error_reset_tc;
 
 	err = stmmac_fpe_map_preemption_class(priv, ndev, extack,
 					      mqprio->preemptible_tcs);
 	if (err)
-		goto err_reset_tc;
+		goto error_reset_num_tx_queues;
 
 	return 0;
 
-err_reset_tc:
-	stmmac_reset_tc_mqprio(ndev, extack);
+error_reset_num_tx_queues:
+	if (netif_set_real_num_tx_queues(ndev, ndev_num_tx_queues))
+		netdev_warn(ndev, "Failed to restore %u TX queues\n",
+			    ndev_num_tx_queues);
+error_reset_tc:
+	stmmac_set_ndev_tcs(ndev, ndev_ntc, ndev_tc_to_txq);
+	for (i = 0; i < ARRAY_SIZE(ndev_prio_tc_map); i++)
+		netdev_set_prio_tc_map(ndev, i, ndev_prio_tc_map[i]);
 
 	return err;
 }
-- 
2.53.0



