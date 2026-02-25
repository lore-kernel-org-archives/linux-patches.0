Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49B74C81;
	Wed, 25 Feb 2026 06:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002721; cv=none; b=urhf6EaWLfgWFSX4ri2qnNdZdOjb21a4FBZ0eHdDHJjyzka7l2T8/9NnUJnu3oNjKGDv6DiaJ5FTXtlHBJVSg+otzpNeEwtRJGpFiY3+zTearmie4/eQ5Y3Qrl2fsP9wYv2ggCEIoexwxT767ELtbp1ibPllwX6eQb4VxiAXF7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002721; c=relaxed/simple;
	bh=HNIafgQvO+44TNYTjz0LWHH9vmV4cJ/PEw6K2u2h++I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+QoFPdE+SEi3C03GJB+UqH8spXna26CjRrYSKUFGwxqQVphStFym9GoV2WMoEm/ndl2vHbS5zALJe7tEIZ5LMmXUmTrFZUAQ8Ih/GsnS85f+r/iKwqbXKK6rg4jFYxDc1ijWGw7rAx5HrEBdbgbK+AB2HdIpNxaU4bW86mInQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6SpslPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6SpslPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883D9C116D0;
	Wed, 25 Feb 2026 06:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002721;
	bh=HNIafgQvO+44TNYTjz0LWHH9vmV4cJ/PEw6K2u2h++I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6SpslPfYM82mIfk5u1D94dOeQF8OeEQK5TPxOLyVX5NCZe9bzHp8udrNUvEjlHfr
	 ItCG1bZLm6rUCOWI2v1jm0lPjm1XLRSc0opYs8Wi3PbCEIf0mBEssTSgOtDeXC+A2K
	 H72llksD9KayEEXDAk2//J9SFGCKw6e8Z0eR2RFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 531/641] eth: fbnic: set FBNIC_QUEUE_RDE_CTL0_EN_HDR_SPLIT on RDE_CTL0
Date: Tue, 24 Feb 2026 17:24:17 -0800
Message-ID: <20260225012401.394874033@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bobby Eshleman <bobbyeshleman@meta.com>

[ Upstream commit bbeb3bfbffe0279fa47c041658b037fb38a93965 ]

Fix EN_HDR_SPLIT configuration by writing the field to RDE_CTL0 instead
of RDE_CTL1.

Because drop mode configuration and header splitting enablement both use
RDE_CTL0, we consolidate these configurations into the single function
fbnic_config_drop_mode.

Fixes: 2b30fc01a6c7 ("eth: fbnic: Add support for HDS configuration")
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
Acked-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Link: https://patch.msgid.link/20260211-fbnic-tcp-hds-fixes-v1-1-55d050e6f606@meta.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 25 +++++++++++---------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index e99d17660230c..fbdf79b6ad2de 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -2573,7 +2573,8 @@ static void fbnic_enable_bdq(struct fbnic_ring *hpq, struct fbnic_ring *ppq)
 }
 
 static void fbnic_config_drop_mode_rcq(struct fbnic_napi_vector *nv,
-				       struct fbnic_ring *rcq, bool tx_pause)
+				       struct fbnic_ring *rcq, bool tx_pause,
+				       bool hdr_split)
 {
 	struct fbnic_net *fbn = netdev_priv(nv->napi.dev);
 	u32 drop_mode, rcq_ctl;
@@ -2586,22 +2587,26 @@ static void fbnic_config_drop_mode_rcq(struct fbnic_napi_vector *nv,
 	/* Specify packet layout */
 	rcq_ctl = FIELD_PREP(FBNIC_QUEUE_RDE_CTL0_DROP_MODE_MASK, drop_mode) |
 	    FIELD_PREP(FBNIC_QUEUE_RDE_CTL0_MIN_HROOM_MASK, FBNIC_RX_HROOM) |
-	    FIELD_PREP(FBNIC_QUEUE_RDE_CTL0_MIN_TROOM_MASK, FBNIC_RX_TROOM);
+	    FIELD_PREP(FBNIC_QUEUE_RDE_CTL0_MIN_TROOM_MASK, FBNIC_RX_TROOM) |
+	    FIELD_PREP(FBNIC_QUEUE_RDE_CTL0_EN_HDR_SPLIT, hdr_split);
 
 	fbnic_ring_wr32(rcq, FBNIC_QUEUE_RDE_CTL0, rcq_ctl);
 }
 
-void fbnic_config_drop_mode(struct fbnic_net *fbn, bool tx_pause)
+void fbnic_config_drop_mode(struct fbnic_net *fbn, bool txp)
 {
+	bool hds;
 	int i, t;
 
+	hds = fbn->hds_thresh < FBNIC_HDR_BYTES_MIN;
+
 	for (i = 0; i < fbn->num_napi; i++) {
 		struct fbnic_napi_vector *nv = fbn->napi[i];
 
 		for (t = 0; t < nv->rxt_count; t++) {
 			struct fbnic_q_triad *qt = &nv->qt[nv->txt_count + t];
 
-			fbnic_config_drop_mode_rcq(nv, &qt->cmpl, tx_pause);
+			fbnic_config_drop_mode_rcq(nv, &qt->cmpl, txp, hds);
 		}
 	}
 }
@@ -2652,20 +2657,18 @@ static void fbnic_enable_rcq(struct fbnic_napi_vector *nv,
 {
 	struct fbnic_net *fbn = netdev_priv(nv->napi.dev);
 	u32 log_size = fls(rcq->size_mask);
-	u32 hds_thresh = fbn->hds_thresh;
 	u32 rcq_ctl = 0;
-
-	fbnic_config_drop_mode_rcq(nv, rcq, fbn->tx_pause);
+	bool hdr_split;
+	u32 hds_thresh;
 
 	/* Force lower bound on MAX_HEADER_BYTES. Below this, all frames should
 	 * be split at L4. It would also result in the frames being split at
 	 * L2/L3 depending on the frame size.
 	 */
-	if (fbn->hds_thresh < FBNIC_HDR_BYTES_MIN) {
-		rcq_ctl = FBNIC_QUEUE_RDE_CTL0_EN_HDR_SPLIT;
-		hds_thresh = FBNIC_HDR_BYTES_MIN;
-	}
+	hdr_split = fbn->hds_thresh < FBNIC_HDR_BYTES_MIN;
+	fbnic_config_drop_mode_rcq(nv, rcq, fbn->tx_pause, hdr_split);
 
+	hds_thresh = max(fbn->hds_thresh, FBNIC_HDR_BYTES_MIN);
 	rcq_ctl |= FIELD_PREP(FBNIC_QUEUE_RDE_CTL1_PADLEN_MASK, FBNIC_RX_PAD) |
 		   FIELD_PREP(FBNIC_QUEUE_RDE_CTL1_MAX_HDR_MASK, hds_thresh) |
 		   FIELD_PREP(FBNIC_QUEUE_RDE_CTL1_PAYLD_OFF_MASK,
-- 
2.51.0



