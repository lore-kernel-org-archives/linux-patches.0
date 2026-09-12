Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8285F429000;
	Sat, 12 Sep 2026 11:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211581; cv=none; b=QQttuts9QTAeJZqdosDtnIgbm01xOga+juaAwFWTj2Lz38rycxYIIxKL3iD9RMFr0diR2fe6Hh6sDqML7Rh7ljnjo2KLbPcDfkibzGLwfIuL4c7O4joAO92YTncgPkj2d2DSE1khydeD8BeNfWCx8eXpyYNzmG808/ktSMf3DVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211581; c=relaxed/simple;
	bh=tva6N8ReLD4MZKEVGXi0mCZ1v61Ke6ebc+ZmqOat71c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOaQwAbGoqKsc7JORl7aTbcJ2mcYxQkRDVH149MAlLEkw1QwkteeFFmCdyFn/zAhs+9Yp/bHGFCXfb20h1qvlhX9RV+55UPznc7H8RF6DB8vXlUCNzOm6qlOfdLs7VSVAbN9aAVW/UU7X5YHYipcftURqLfoJ8cg/QOxeED94MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTYzLa4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTYzLa4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F8F1F000FF;
	Sat, 12 Sep 2026 11:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211580;
	bh=yDrj9TdfgST4GiBOGN4/gn903lV0VLsneWuaCZeKy30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTYzLa4Im7yoou15uFXeWFVATcpRaNFy7HmIqRiL7+95sOF7L2EwZZZ+NnzvEGCEg
	 ubLswQuZFDxVjD7McBwkR9okPWB+Ii5yElKOe9+oAH4XWuOIl2Xzg3C/j+FVe12a9d
	 KQG9Nl1pJqd9Lb8JtCEWXUfVSCLhKCxYV/HqBJm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prabu Thayalan <prabu.ponrajthayalan@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1260/1518] ionic: fix completion descriptor access with 2x desc size
Date: Sat, 12 Sep 2026 08:57:09 +0200
Message-ID: <20260912065652.015569359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Prabu Thayalan <prabu.ponrajthayalan@amd.com>

[ Upstream commit 5da6ec6f06f235166bd084466b3386c638e26675 ]

The old ionic_rx_service() and ionic_tx_service() used array
indexing to access completion descriptors:

    comp = &((struct ionic_rxq_comp *)cq->base)[cq->tail_idx];

This assumes the stride is sizeof(struct ionic_rxq_comp) = 16 bytes.
However, when the IONIC_Q_F_2X_CQ_DESC flag is set, the actual
completion descriptor size is 32 bytes (2 * sizeof(comp)), and the
completion itself is located at the end of that 32-byte slot. Array
indexing with a 16-byte stride would access the wrong offset.

Use pointer arithmetic that accounts for the actual descriptor size
from cq->desc_size:

    comp = cq->base +
           cq->desc_size * cq->tail_idx +
           cq->desc_size - sizeof(*comp);

This correctly calculates the completion location regardless of
descriptor size. For the common case where desc_size equals
sizeof(*comp), use array indexing in a likely() fast path to avoid
performance regression.

Fixes: 65e548f6b0ff ("ionic: remove the cq_info to save more memory")
Signed-off-by: Prabu Thayalan <prabu.ponrajthayalan@amd.com>
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260811195039.1315045-3-eric.joyner@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 27 ++++++++++---------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 73998d61593a9..61d48c172587d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -706,11 +706,7 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		__le64 *cq_desc_hwstamp;
 		u64 hwstamp;
 
-		cq_desc_hwstamp =
-			(void *)comp +
-			qcq->cq.desc_size -
-			sizeof(struct ionic_rxq_comp) -
-			IONIC_HWSTAMP_CQ_NEGOFFSET;
+		cq_desc_hwstamp = (void *)comp - IONIC_HWSTAMP_CQ_NEGOFFSET;
 
 		hwstamp = le64_to_cpu(*cq_desc_hwstamp);
 
@@ -734,7 +730,12 @@ static bool __ionic_rx_service(struct ionic_cq *cq, struct bpf_prog *xdp_prog)
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_rxq_comp *comp;
 
-	comp = &((struct ionic_rxq_comp *)cq->base)[cq->tail_idx];
+	if (likely(cq->desc_size == sizeof(*comp)))
+		comp = &((struct ionic_rxq_comp *)cq->base)[cq->tail_idx];
+	else
+		comp = cq->base +
+		       cq->desc_size * cq->tail_idx +
+		       cq->desc_size - sizeof(*comp);
 
 	if (!color_match(comp->pkt_type_color, cq->done_color))
 		return false;
@@ -1185,7 +1186,6 @@ static void ionic_tx_clean(struct ionic_queue *q,
 			   bool in_napi)
 {
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct ionic_qcq *qcq = q_to_qcq(q);
 	struct sk_buff *skb;
 
 	if (desc_info->xdpf) {
@@ -1210,11 +1210,7 @@ static void ionic_tx_clean(struct ionic_queue *q,
 			__le64 *cq_desc_hwstamp;
 			u64 hwstamp;
 
-			cq_desc_hwstamp =
-				(void *)comp +
-				qcq->cq.desc_size -
-				sizeof(struct ionic_txq_comp) -
-				IONIC_HWSTAMP_CQ_NEGOFFSET;
+			cq_desc_hwstamp = (void *)comp - IONIC_HWSTAMP_CQ_NEGOFFSET;
 
 			hwstamp = le64_to_cpu(*cq_desc_hwstamp);
 
@@ -1249,7 +1245,12 @@ static bool ionic_tx_service(struct ionic_cq *cq,
 	unsigned int pkts = 0;
 	u16 index;
 
-	comp = &((struct ionic_txq_comp *)cq->base)[cq->tail_idx];
+	if (likely(cq->desc_size == sizeof(*comp)))
+		comp = &((struct ionic_txq_comp *)cq->base)[cq->tail_idx];
+	else
+		comp = cq->base +
+		       cq->desc_size * cq->tail_idx +
+		       cq->desc_size - sizeof(*comp);
 
 	if (!color_match(comp->color, cq->done_color))
 		return false;
-- 
2.53.0



