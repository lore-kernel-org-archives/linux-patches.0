Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E5F41D4E9;
	Sat, 12 Sep 2026 09:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204199; cv=none; b=CC3JAmeLPEF9UInumnTcfkfWOdH/XJO3OY5+axZH11eX0RTx0+PR8LHnyQDW6te2iohLBOJwJ1N3Uv8hT4bvlT1XUBMGGZVLuENQeCuqIZxB/Md4JnEpuGbJ7Lr2KAJ5DCvRKL9w6WwYb12O7g5ChKVcOuq4DwGm0dx4/3whCBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204199; c=relaxed/simple;
	bh=Bwvm17gThHb0I581STH7xE2t4eSp5W0IWwrV+XB97m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGaqeWa3I18Ngu+hFyOZuiJ+db6ovRCsrHLLR8qWKFeRyUqx+79S2jngRRZzjY5Qs9mD6Nm6Zr7KsdVQYdTRbNtfMFPyNQlsV7T6CmP+VzOjnHptiqYVo4tWXrvrs0uH3kJho+oReyxAP85mQ1y/2tvh/4ifWEvDZn6kOIZQ1So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPU4bzoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPU4bzoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACF71F000FF;
	Sat, 12 Sep 2026 09:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204197;
	bh=iDSwphTSftRucSSzUCBm0wrrWg1cQ5xTX14hPvoV6CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPU4bzoEfM2wKIbApAdXPjIXnSjHTfQKg9JdBJT08+sX/E5cLYTy2w2Jc/6jtCNPN
	 awRWH50FEixbGcGZ/VtXRiqT9jlp06/zq3syP0LlHkvOZi59kdOGOWAgjcQTZDXrHt
	 oT7EWb4OCq4OElgYgA5ORGZK3GGIQzFrhKViUmVQ=
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
Subject: [PATCH 7.2 1564/1815] ionic: fix completion descriptor access with 2x desc size
Date: Sat, 12 Sep 2026 08:55:14 +0200
Message-ID: <20260912065725.709990012@linuxfoundation.org>
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
index c3bcfdd1a1405..e436e3231e864 100644
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
@@ -1187,7 +1188,6 @@ static void ionic_tx_clean(struct ionic_queue *q,
 			   bool in_napi)
 {
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct ionic_qcq *qcq = q_to_qcq(q);
 	struct sk_buff *skb;
 
 	if (desc_info->xdpf) {
@@ -1212,11 +1212,7 @@ static void ionic_tx_clean(struct ionic_queue *q,
 			__le64 *cq_desc_hwstamp;
 			u64 hwstamp;
 
-			cq_desc_hwstamp =
-				(void *)comp +
-				qcq->cq.desc_size -
-				sizeof(struct ionic_txq_comp) -
-				IONIC_HWSTAMP_CQ_NEGOFFSET;
+			cq_desc_hwstamp = (void *)comp - IONIC_HWSTAMP_CQ_NEGOFFSET;
 
 			hwstamp = le64_to_cpu(*cq_desc_hwstamp);
 
@@ -1251,7 +1247,12 @@ static bool ionic_tx_service(struct ionic_cq *cq,
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



