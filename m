Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8783845AC;
	Thu, 17 Sep 2026 15:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659888; cv=none; b=q9/+MeXxZJ7GObWJlqrA4p+h7nBX66K3fSQXBkJFrbolmgH9leySQarvIxmkHJ3RRwOgieH2kGtKinH6VRfcEQaTo4S3FXs4rOexxYGZMKnv8/ILGVvGSlMSGkDaVOnFQGMeUcLwy3vNNzeBwoXhgpxN2dlcalNaoXxw7f6C0K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659888; c=relaxed/simple;
	bh=4phtMhjpCbwBPI9Nn/sd4fM07vy72TxVyJSfkLcpEWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTGW+iUi9ssbrds5UnKXs9LnGnE2DZr5tQnwOpdfesdjHhFDO4taxvxfRCm0igRQJBT1wxrvvtDWPhc3J/ttDsmUpuR3I4kD2BCUM4EAs1/YKoOUSdJYMwOSvN+f+7ndqlAuT5+m596q8q/GYZQHYpj5siK2zO+vs9IW+Dvr3dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZMiwc7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZMiwc7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5967F1F00898;
	Thu, 17 Sep 2026 15:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659881;
	bh=jASxq5pZm7ZjIU33ofkpIh/nu5bJSHHkDsjk6Ytntbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HZMiwc7K8I/K2QXmDJfPHEN6ORhXIwJbdtNW/85YyuHt3J2Xoh+bqqcH6ESd8Oozm
	 TvO0BL9Wa6q7eKE5oZTu3uUeviOq1ev+PWoYW8fw0EMZPqXB7hQgmFFAxJ6L8SRsZq
	 A6AamZFBMs0JX1k9+DuR4VaFTyXVBBLGi+j/W4zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 404/733] octeontx2-pf: reset HTB scheduler topology before freeing queues
Date: Thu, 17 Sep 2026 16:11:52 +0100
Message-ID: <20260917151401.815113991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit ef39fca8508597fa565cf2be72a884a712fb98af ]

HTB offload programs NIX_AF_TLxX_TOPOLOGY on QoS-allocated scheduler
queues via otx2_qos_txschq_set_parent_topology(), but teardown freed
those queues without clearing TOPOLOGY.  The AF only restores PARENT and
SCHEDULE on free, so PRIO_ANCHOR/RR_PRIO settings can survive in the
shared scheduler pool and affect later allocations.

Add otx2_qos_reset_schq_topology() and otx2_qos_free_hw_schq() to zero
TL4 through TL2 TOPOLOGY before each schq is returned to the AF during
hierarchy teardown and cfg rollback.  Skip the aggregation level (TL1):
it is a per-tx-link queue shared by the PF, default Tx hierarchy and VFs,
and is not freed back to the AF by nix_txschq_free_one().

Fixes: 5e6808b4c68d ("octeontx2-pf: Add support for HTB offload")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260903020533.3068041-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/qos.c  | 60 +++++++++++++++++--
 1 file changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
index 69c0911e28e91..f160b1618efa2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
@@ -235,13 +235,63 @@ static int otx2_qos_txschq_set_parent_topology(struct otx2_nic *pfvf,
 	return rc;
 }
 
+static int otx2_qos_reset_schq_topology(struct otx2_nic *pfvf, u16 lvl,
+					u16 schq)
+{
+	struct mbox *mbox = &pfvf->mbox;
+	struct nix_txschq_config *cfg;
+	int rc;
+
+	if (lvl < NIX_TXSCH_LVL_TL4 || lvl >= NIX_TXSCH_LVL_TL1)
+		return 0;
+
+	mutex_lock(&mbox->lock);
+
+	cfg = otx2_mbox_alloc_msg_nix_txschq_cfg(mbox);
+	if (!cfg) {
+		mutex_unlock(&mbox->lock);
+		return -ENOMEM;
+	}
+
+	cfg->lvl = lvl;
+	cfg->num_regs = 1;
+
+	if (lvl == NIX_TXSCH_LVL_TL4)
+		cfg->reg[0] = NIX_AF_TL4X_TOPOLOGY(schq);
+	else if (lvl == NIX_TXSCH_LVL_TL3)
+		cfg->reg[0] = NIX_AF_TL3X_TOPOLOGY(schq);
+	else if (lvl == NIX_TXSCH_LVL_TL2)
+		cfg->reg[0] = NIX_AF_TL2X_TOPOLOGY(schq);
+
+	cfg->regval[0] = 0;
+
+	rc = otx2_sync_mbox_msg(mbox);
+
+	mutex_unlock(&mbox->lock);
+
+	return rc;
+}
+
+static void otx2_qos_free_hw_schq(struct otx2_nic *pfvf, u16 lvl, u16 schq)
+{
+	int err;
+
+	err = otx2_qos_reset_schq_topology(pfvf, lvl, schq);
+	if (err)
+		netdev_warn(pfvf->netdev,
+			    "QoS: failed to reset topology for schq %u at level %u: %d\n",
+			    schq, lvl, err);
+
+	otx2_txschq_free_one(pfvf, lvl, schq);
+}
+
 static void otx2_qos_free_hw_node_schq(struct otx2_nic *pfvf,
 				       struct otx2_qos_node *parent)
 {
 	struct otx2_qos_node *node;
 
 	list_for_each_entry_reverse(node, &parent->child_schq_list, list)
-		otx2_txschq_free_one(pfvf, node->level, node->schq);
+		otx2_qos_free_hw_schq(pfvf, node->level, node->schq);
 }
 
 static void otx2_qos_free_hw_node(struct otx2_nic *pfvf,
@@ -252,7 +302,7 @@ static void otx2_qos_free_hw_node(struct otx2_nic *pfvf,
 	list_for_each_entry_safe(node, tmp, &parent->child_list, list) {
 		otx2_qos_free_hw_node(pfvf, node);
 		otx2_qos_free_hw_node_schq(pfvf, node);
-		otx2_txschq_free_one(pfvf, node->level, node->schq);
+		otx2_qos_free_hw_schq(pfvf, node->level, node->schq);
 	}
 }
 
@@ -266,7 +316,7 @@ static void otx2_qos_free_hw_cfg(struct otx2_nic *pfvf,
 	otx2_qos_free_hw_node_schq(pfvf, node);
 
 	/* free node hw mappings */
-	otx2_txschq_free_one(pfvf, node->level, node->schq);
+	otx2_qos_free_hw_schq(pfvf, node->level, node->schq);
 
 	mutex_unlock(&pfvf->qos.qos_lock);
 }
@@ -913,7 +963,7 @@ static void otx2_qos_free_cfg(struct otx2_nic *pfvf, struct otx2_qos_cfg *cfg)
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
 		for (idx = 0; idx < cfg->schq[lvl]; idx++) {
 			schq = cfg->schq_list[lvl][idx];
-			otx2_txschq_free_one(pfvf, lvl, schq);
+			otx2_qos_free_hw_schq(pfvf, lvl, schq);
 		}
 	}
 
@@ -921,7 +971,7 @@ static void otx2_qos_free_cfg(struct otx2_nic *pfvf, struct otx2_qos_cfg *cfg)
 		for (idx = 0; idx < cfg->schq_contig[lvl]; idx++) {
 			if (cfg->schq_index_used[lvl][idx]) {
 				schq = cfg->schq_contig_list[lvl][idx];
-				otx2_txschq_free_one(pfvf, lvl, schq);
+				otx2_qos_free_hw_schq(pfvf, lvl, schq);
 			}
 		}
 	}
-- 
2.53.0



