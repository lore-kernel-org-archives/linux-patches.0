Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55944E5352;
	Fri,  9 Oct 2026 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556116; cv=none; b=t1R3DgW/9GdbPo4/+/n7jK9+Cg+UFVlY72/CZ6Mp3r1IuyeqPNvd5QMHl/S16z6Bpr6aZ74kUIK6ODZkIyLpZHJ048yqAlq0M68XLvg6wF94cCwtqREyIIxit67pPNLo61x9916zzzNl0p3Cjucf0+FWzQzHgTKohyVHcBjPD3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556116; c=relaxed/simple;
	bh=liF4B63hy1WpvkmboKnXmtMY9x6480AaWaHpqsFCjdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqM6reH2x8I8wBcQvJ6rVhJohlSPkHOjmmhKJF6bUkRhmDO0JMNxL/TXaQ9lez2xjLCw7elkenydTe2a5tQ/OyBQCqljUC7AW/trBn6Y2VHVaQfCrddw+DkCDhKLVF4gl+5DZ67EYmrQXHijRlCUVIrkMFBDjObxIN76hmD3SYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3CLGcYf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3CLGcYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040E51F000FF;
	Fri,  9 Oct 2026 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556115;
	bh=uzJAFNorCht+W7yXmFp7YiM5pisPEtHt19wbyfFynok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3CLGcYfbBTuhmsSBRWnJ8JTC7OytNv7Sn1gg6/b4CtuveKIur63m1eaTmbrU9+Gt
	 LTmZqLTvu6KRvYWBrpme2wF+fXsZp9JU+FOu2uzcS061BPUVS+6yxssBVM5uqxg2s/
	 Ym6xIWu5XlZxAetC0m8d24aVbhUNVx/wA5pFfhvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subrat Pandey <subratp@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 123/428] octeontx2-pf: Fix aura BPID assignment when CONFIG_DCB is enabled
Date: Fri,  9 Oct 2026 16:07:40 +0200
Message-ID: <20261009140948.892680971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 056994563935e049093f100efaad7e63ad113814 ]

Previously, BPID assignment under CONFIG_DCB assumed
`queue_to_pfc_map` was always initialized. For SDP VFs this leads to
invalid memory access as it was not initialized.

This patch adds a NULL check for `queue_to_pfc_map` before
dereferencing it. Also, simplifies the logic by always assigning a
default BPID first, then conditionally overriding it if CONFIG_DCB is
enabled and the map exists.

Fixes: 184fb40f731b ("octeontx2-pf: Avoid adding dcbnl_ops for LBK and SDP vf")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subrat Pandey <subratp@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260922102149.2078168-2-subratp@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/cn20k.c   | 11 +----------
 .../ethernet/marvell/octeontx2/nic/otx2_common.c | 16 ++++++----------
 .../ethernet/marvell/octeontx2/nic/otx2_common.h |  9 +++++++++
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn20k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn20k.c
index dbf1731966082..65248bb0b61de 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn20k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn20k.c
@@ -242,15 +242,6 @@ int cn20k_register_pfvf_mbox_intr(struct otx2_nic *pf, int numvfs)
 
 #define RQ_BP_LVL_AURA   (255 - ((85 * 256) / 100)) /* BP when 85% is full */
 
-static u8 cn20k_aura_bpid_idx(struct otx2_nic *pfvf, int aura_id)
-{
-#ifdef CONFIG_DCB
-	return pfvf->queue_to_pfc_map[aura_id];
-#else
-	return 0;
-#endif
-}
-
 static int cn20k_tc_get_entry_index(struct otx2_flow_config *flow_cfg,
 				    struct otx2_tc_flow *node)
 {
@@ -580,7 +571,7 @@ static int cn20k_aura_aq_init(struct otx2_nic *pfvf, int aura_id,
 		if (pfvf->nix_blkaddr == BLKADDR_NIX1)
 			aq->aura.bp_ena = 1;
 
-		bpid_idx = cn20k_aura_bpid_idx(pfvf, aura_id);
+		bpid_idx = otx2_get_bpid_idx(pfvf, aura_id);
 		aq->aura.bpid = pfvf->bpid[bpid_idx];
 
 		/* Set backpressure level for RQ's Aura */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 8f6a5c6cb9b09..7e7727880625a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1056,6 +1056,7 @@ int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	struct nix_aq_enq_req *aq;
 	struct otx2_cq_queue *cq;
 	struct otx2_pool *pool;
+	u8 bpid_idx;
 
 	cq = &qset->cq[qidx];
 	cq->cq_idx = qidx;
@@ -1133,11 +1134,8 @@ int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 		if (!is_otx2_lbkvf(pfvf->pdev)) {
 			/* Enable receive CQ backpressure */
 			aq->cq.bp_ena = 1;
-#ifdef CONFIG_DCB
-			aq->cq.bpid = pfvf->bpid[pfvf->queue_to_pfc_map[qidx]];
-#else
-			aq->cq.bpid = pfvf->bpid[0];
-#endif
+			bpid_idx = otx2_get_bpid_idx(pfvf, qidx);
+			aq->cq.bpid = pfvf->bpid[bpid_idx];
 
 			/* Set backpressure level is same as cq pass level */
 			aq->cq.bp = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
@@ -1379,6 +1377,7 @@ int otx2_aura_aq_init(struct otx2_nic *pfvf, int aura_id,
 {
 	struct npa_aq_enq_req *aq;
 	struct otx2_pool *pool;
+	u8 bpid_idx;
 	int err;
 
 	pool = &pfvf->qset.pool[pool_id];
@@ -1434,11 +1433,8 @@ int otx2_aura_aq_init(struct otx2_nic *pfvf, int aura_id,
 		 */
 		if (pfvf->nix_blkaddr == BLKADDR_NIX1)
 			aq->aura.bp_ena = 1;
-#ifdef CONFIG_DCB
-		aq->aura.nix0_bpid = pfvf->bpid[pfvf->queue_to_pfc_map[aura_id]];
-#else
-		aq->aura.nix0_bpid = pfvf->bpid[0];
-#endif
+		bpid_idx = otx2_get_bpid_idx(pfvf, aura_id);
+		aq->aura.nix0_bpid = pfvf->bpid[bpid_idx];
 
 		/* Set backpressure level for RQ's Aura */
 		aq->aura.bp = RQ_BP_LVL_AURA;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index eecee612b7b2c..44cd56a0c2c4c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -1029,6 +1029,15 @@ static inline int otx2_tc_flower_rule_cnt(struct otx2_nic *pfvf)
 	return pfvf->flow_cfg->nr_flows;
 }
 
+static inline u8 otx2_get_bpid_idx(struct otx2_nic *pfvf, int qidx)
+{
+#ifdef CONFIG_DCB
+	if (pfvf->queue_to_pfc_map)
+		return pfvf->queue_to_pfc_map[qidx];
+#endif
+	return 0;
+}
+
 /* MSI-X APIs */
 void otx2_free_cints(struct otx2_nic *pfvf, int n);
 void otx2_set_cints_affinity(struct otx2_nic *pfvf);
-- 
2.53.0



