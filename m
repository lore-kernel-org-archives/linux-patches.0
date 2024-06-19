Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED78AD58;
	Wed, 19 Jun 2024 13:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802960; cv=none; b=qPZOWsuKCZ1f7xVRDKYYRBOwZ5Xnc7Cni3bq7X62DrrwXZxcosmNz4QUZyLXH09wllW6WnOPKK2RFW/eHlQCQ6L2XMWgHlKgr4Df2sywKwP5e3uQd0DrMExhMUrP27ysSz42icnv2NN52FMD3QJWcXIoA1sQk7Atme70jZraGv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802960; c=relaxed/simple;
	bh=f8VzZlOzFxm0Q1goC6l7zBNlWJIwXl/QsgJ9Q5mpOVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvCDuesB4q+RT95Mma7bRC/uS/0KVqOoEuoo9aLiVowr4iGsCVx1wuTfT3UPW/p4MQvwgGPbI+SQX80Xmt++w2kI6PrhqiAXgNOenshpfoylEEWJahuUnugAaqMSr0J9EFLu4BTMsw++LWfhl+Le0lCTKo30QSHA405XewqKAzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjqQFGIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjqQFGIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91E3C2BBFC;
	Wed, 19 Jun 2024 13:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802960;
	bh=f8VzZlOzFxm0Q1goC6l7zBNlWJIwXl/QsgJ9Q5mpOVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjqQFGIySKRFX0asqj53DKI/fs4Sy+vSlYaCmiA58qG4h4b/FYGes9u9ssVMRnUr1
	 3w6khQuFsaytwkR34wBAFyJ/dXEOCHrLA8dPjvgltLedLPzF1M/LhJ1LULo4WSeG24
	 a9yVdgwCmC2L/7S5o12XKKxSHCH6S+CjF3yLWIj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shailend Chand <shailend@google.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 104/281] gve: Clear napi->skb before dev_kfree_skb_any()
Date: Wed, 19 Jun 2024 14:54:23 +0200
Message-ID: <20240619125613.848963993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziwei Xiao <ziweixiao@google.com>

commit 6f4d93b78ade0a4c2cafd587f7b429ce95abb02e upstream.

gve_rx_free_skb incorrectly leaves napi->skb referencing an skb after it
is freed with dev_kfree_skb_any(). This can result in a subsequent call
to napi_get_frags returning a dangling pointer.

Fix this by clearing napi->skb before the skb is freed.

Fixes: 9b8dd5e5ea48 ("gve: DQO: Add RX path")
Cc: stable@vger.kernel.org
Reported-by: Shailend Chand <shailend@google.com>
Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Shailend Chand <shailend@google.com>
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Link: https://lore.kernel.org/r/20240612001654.923887-1-ziweixiao@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -581,11 +581,13 @@ static void gve_rx_skb_hash(struct sk_bu
 	skb_set_hash(skb, le32_to_cpu(compl_desc->hash), hash_type);
 }
 
-static void gve_rx_free_skb(struct gve_rx_ring *rx)
+static void gve_rx_free_skb(struct napi_struct *napi, struct gve_rx_ring *rx)
 {
 	if (!rx->ctx.skb_head)
 		return;
 
+	if (rx->ctx.skb_head == napi->skb)
+		napi->skb = NULL;
 	dev_kfree_skb_any(rx->ctx.skb_head);
 	rx->ctx.skb_head = NULL;
 	rx->ctx.skb_tail = NULL;
@@ -884,7 +886,7 @@ int gve_rx_poll_dqo(struct gve_notify_bl
 
 		err = gve_rx_dqo(napi, rx, compl_desc, complq->head, rx->q_num);
 		if (err < 0) {
-			gve_rx_free_skb(rx);
+			gve_rx_free_skb(napi, rx);
 			u64_stats_update_begin(&rx->statss);
 			if (err == -ENOMEM)
 				rx->rx_skb_alloc_fail++;
@@ -927,7 +929,7 @@ int gve_rx_poll_dqo(struct gve_notify_bl
 
 		/* gve_rx_complete_skb() will consume skb if successful */
 		if (gve_rx_complete_skb(rx, napi, compl_desc, feat) != 0) {
-			gve_rx_free_skb(rx);
+			gve_rx_free_skb(napi, rx);
 			u64_stats_update_begin(&rx->statss);
 			rx->rx_desc_err_dropped_pkt++;
 			u64_stats_update_end(&rx->statss);


