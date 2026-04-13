Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19AE31F9BC;
	Mon, 13 Apr 2026 16:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099475; cv=none; b=iMVv8uJQdAAxJSTAsVs/+9pM0Gj17/8hA/9ztsNuT5kECXQBMQwp8oNthd01marhx4AJYsW0lm1B1QdRdeytCpGtid0KxC+/Q6QIH99yS4fWvhDxC/hpDdoulrYGwrWKMkNeJEqa/ARgpwFw94d21RbEnSPDkghrYuRqQH9Z0os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099475; c=relaxed/simple;
	bh=JMX/YGLSFJOZ8aFfPTWwJ5HPYiuCLsp7r1+fpmQvFxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V29MxABR60pjnr15GPuG/e9JZ/0byrVPY4/SSwHMDh44Pu8c5YVXjrNwxRKmydzut88lZfDsTpevDPx4dvuMLASWYJCKOIH0SATrLOC/qEqhMaxyeYsO+9bv+n2J8Mb97tRksAwAv03bl3s4yyM/CTN915qPfyh303BCxZZ0WF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iy88SAHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iy88SAHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E0BC2BCAF;
	Mon, 13 Apr 2026 16:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099475;
	bh=JMX/YGLSFJOZ8aFfPTWwJ5HPYiuCLsp7r1+fpmQvFxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iy88SAHSCJF6cjGCOwRRS90x+cAs1zL5v5QKbfjSEX64d+aFZv2XZQGU3q1RdrWLX
	 yhrB0yORfa9kOmbY4TXvGTcviAb/o/Ly4H0oBm5efcidkNU49NIuK2h2qh3VUAbYKe
	 mHe00qr+TUpPlmQYjsRol/S8f4naZlRaF+Qq9Lz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/491] net: qrtr: Add GFP flags parameter to qrtr_alloc_ctrl_packet
Date: Mon, 13 Apr 2026 17:59:27 +0200
Message-ID: <20260413155831.098961201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit f7dec6cb914c8923808eefc034bba8227a5dfe3a ]

This will be requested for allocating control packet in atomic context.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2428083101f6 ("net: qrtr: replace qrtr_tx_flow radix_tree with xarray to fix memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 8476a229bce0a..01d8cb93ad756 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -540,18 +540,20 @@ EXPORT_SYMBOL_GPL(qrtr_endpoint_post);
 /**
  * qrtr_alloc_ctrl_packet() - allocate control packet skb
  * @pkt: reference to qrtr_ctrl_pkt pointer
+ * @flags: the type of memory to allocate
  *
  * Returns newly allocated sk_buff, or NULL on failure
  *
  * This function allocates a sk_buff large enough to carry a qrtr_ctrl_pkt and
  * on success returns a reference to the control packet in @pkt.
  */
-static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt)
+static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt,
+					      gfp_t flags)
 {
 	const int pkt_len = sizeof(struct qrtr_ctrl_pkt);
 	struct sk_buff *skb;
 
-	skb = alloc_skb(QRTR_HDR_MAX_SIZE + pkt_len, GFP_KERNEL);
+	skb = alloc_skb(QRTR_HDR_MAX_SIZE + pkt_len, flags);
 	if (!skb)
 		return NULL;
 
@@ -620,7 +622,7 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	mutex_unlock(&node->ep_lock);
 
 	/* Notify the local controller about the event */
-	skb = qrtr_alloc_ctrl_packet(&pkt);
+	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
 	if (skb) {
 		pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
 		qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
@@ -677,7 +679,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
 	to.sq_node = QRTR_NODE_BCAST;
 	to.sq_port = QRTR_PORT_CTRL;
 
-	skb = qrtr_alloc_ctrl_packet(&pkt);
+	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
 	if (skb) {
 		pkt->cmd = cpu_to_le32(QRTR_TYPE_DEL_CLIENT);
 		pkt->client.node = cpu_to_le32(ipc->us.sq_node);
@@ -992,7 +994,7 @@ static int qrtr_send_resume_tx(struct qrtr_cb *cb)
 	if (!node)
 		return -EINVAL;
 
-	skb = qrtr_alloc_ctrl_packet(&pkt);
+	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 
-- 
2.53.0



