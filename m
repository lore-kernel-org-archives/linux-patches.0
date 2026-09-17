Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF84A3A4523;
	Thu, 17 Sep 2026 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663841; cv=none; b=b/gzJScrbs5ULGCQBCJ4zslk/Y/kvMjyLlJM2ABCFxUf2qU7fLl06MEcIjIbL5T1HATZOl+TxJ0q6cNUM6KK6BOgrdNI3RkQdhGBvWhERChC2lwThOXeEi/mhxOC+XaDYt8UgzQSiBpXzG6tAHMpMGnePc3ZBcnKlbw1mK+4Vpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663841; c=relaxed/simple;
	bh=wR9PnfyD8TuYPr28i4wy51+brcYL+BXooNPgK7mbBEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHfi91Mwj4Ytxa6zTBcWdgTgSYxxXPw66VCAB4JDiaJwfGRLRXJqyqWPshOE+MDmU8sWkzKLc7UxEqyOqvzYLebarGQeqI4rHxH9UXyyJGXt+d8m4TvaW7robjJsc4GIx4I0RwZREKpJLzfmSiB3FJeYx7pmlV4JlLUsfN0S5l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmFHWcnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmFHWcnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8D01F000FF;
	Thu, 17 Sep 2026 16:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663839;
	bh=zHUKjoFW2qSS8Lhhsq7DDuYHlwnwH7Qki6RKIu1jQsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zmFHWcnKI0MDLZSJs0mUS14Xs/il0fDUPnYwxnq9/v+EzqU9VoeX+4fvjOas/R4SD
	 i/FuHzRFFt8gaxzPhpdKOm/GOQ5owQz2vc260ntYNiw7b8Kol+ltMPchhgS6zKlevR
	 9RTQAyK5pgh734oSs06P167NJqe/2yd9lM5wc8vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuegang Lu <xuegang.lu@airoha.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0123/1250] net: airoha: Reserve RX headroom to avoid skb reallocation
Date: Thu, 17 Sep 2026 15:58:38 +0100
Message-ID: <20260917151555.359288627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit bbfb1983944f2eaa8ee192e0f7b59ecc0fda9981 ]

Reserve NET_SKB_PAD + NET_IP_ALIGN bytes of headroom for received packets
to avoid skb head reallocation when pushing protocol headers into the skb.

Tested-by: Xuegang Lu <xuegang.lu@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260513-airoha-rx-headroom-v1-1-bd87798e422d@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 14 ++++++++------
 drivers/net/ethernet/airoha/airoha_eth.h |  2 ++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 64ab34e37c36f..e016f7521af59 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -568,9 +568,10 @@ static int airoha_qdma_fill_rx_queue(struct airoha_queue *q)
 		q->queued++;
 		nframes++;
 
+		offset += AIROHA_RX_HEADROOM;
 		e->buf = page_address(page) + offset;
 		e->dma_addr = page_pool_get_dma_addr(page) + offset;
-		e->dma_len = SKB_WITH_OVERHEAD(q->buf_size);
+		e->dma_len = SKB_WITH_OVERHEAD(AIROHA_RX_LEN(q->buf_size));
 
 		val = FIELD_PREP(QDMA_DESC_LEN_MASK, e->dma_len);
 		WRITE_ONCE(desc->ctrl, cpu_to_le32(val));
@@ -635,13 +636,12 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
 		q->tail = (q->tail + 1) % q->ndesc;
 		q->queued--;
 
-		dma_sync_single_for_cpu(eth->dev, e->dma_addr,
-					SKB_WITH_OVERHEAD(q->buf_size), dir);
+		dma_sync_single_for_cpu(eth->dev, e->dma_addr, e->dma_len,
+					dir);
 
 		page = virt_to_head_page(e->buf);
 		len = FIELD_GET(QDMA_DESC_LEN_MASK, desc_ctrl);
-		data_len = q->skb ? q->buf_size
-				  : SKB_WITH_OVERHEAD(q->buf_size);
+		data_len = q->skb ? AIROHA_RX_LEN(q->buf_size) : e->dma_len;
 		if (!len || data_len < len)
 			goto free_frag;
 
@@ -651,10 +651,12 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
 
 		port = eth->ports[p];
 		if (!q->skb) { /* first buffer */
-			q->skb = napi_build_skb(e->buf, q->buf_size);
+			q->skb = napi_build_skb(e->buf - AIROHA_RX_HEADROOM,
+						q->buf_size);
 			if (!q->skb)
 				goto free_frag;
 
+			skb_reserve(q->skb, AIROHA_RX_HEADROOM);
 			__skb_put(q->skb, len);
 			skb_mark_for_recycle(q->skb);
 			q->skb->dev = port->dev;
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 57e8ddb30a9c5..216273595115d 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -32,6 +32,8 @@
 #define AIROHA_FE_MC_MAX_VLAN_TABLE	64
 #define AIROHA_FE_MC_MAX_VLAN_PORT	16
 #define AIROHA_NUM_TX_IRQ		2
+#define AIROHA_RX_HEADROOM		(NET_SKB_PAD + NET_IP_ALIGN)
+#define AIROHA_RX_LEN(_n)		((_n) - AIROHA_RX_HEADROOM)
 #define HW_DSCP_NUM			2048
 #define IRQ_QUEUE_LEN(_n)		((_n) ? 1024 : 2048)
 #define TX_DSCP_NUM			1024
-- 
2.53.0



