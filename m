Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE116369999;
	Wed, 20 May 2026 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297721; cv=none; b=ERNNheF91jXrK/8gePqrT11yPIjYVbWHcRoJGnxxs0AY3HJT51tKJdirfzKLtG0gIukLqNd3c4Irivc1WF23MNllqrhTSD77dgVhQ69YUZVUf2Q72ca0Ly2LSOjCpzMDj78KAqRwsExc/Tu71XpnKKlAf50CL4KZ0Uf0sv8mNww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297721; c=relaxed/simple;
	bh=vAkYgmeCrTrG4ojg/GPR6/s2pD5cwUfmsNf2MIohQD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpBXY+4lhmrLwyKlyFCyQBdxNdRkIfxbUAeQCcE4wzDx6LOyuz3qUjf8mF2jEL7x1k8nM0p1IxI1CTfKdiDgRh11z08obw/v5D51dRZlPachlEl4XeXA2eXmcCZ6RjkfJI9wnXcIW6CjP0eyeuPncU9S7ygqfVF3rrNaRqthReo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwug0tRd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwug0tRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329421F000E9;
	Wed, 20 May 2026 17:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297719;
	bh=E87gjGX8stJfjgXkM5ubPOdl04MNw+r+wXXxMghdfS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwug0tRdtV7LmZeXorJAs10NjFep0eCConntbCE9kOa7E6qZa8omKj7g+8DDe1M1s
	 6n+ZpReFtouPrWiYW6O7EHPYDl3KVI6RvwQeUWw7gbifyjxor8GXJkceCvED6EhJaI
	 RiW9pnemlpUbx9beTb/0rCTXxyL4VYSUTaV4/1eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/957] net: airoha: Add dma_rmb() and READ_ONCE() in airoha_qdma_rx_process()
Date: Wed, 20 May 2026 18:10:22 +0200
Message-ID: <20260520162137.569810805@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

[ Upstream commit 4ae0604a0673e11e2075b178387151fcad5111b5 ]

Add missing dma_rmb() in airoha_qdma_rx_process routine to make sure the
DMA read operations are completed when the NIC reports the processing on
the current descriptor is done. Moreover, add missing READ_ONCE() in
airoha_qdma_rx_process() for DMA descriptor control fields in order to
avoid any compiler reordering.

Fixes: 23020f0493270 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260407-airoha_qdma_rx_process-fix-reordering-v3-1-91c36e9da31f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index bdf600fea9508..060865b98880e 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -596,7 +596,7 @@ static int airoha_qdma_fill_rx_queue(struct airoha_queue *q)
 static int airoha_qdma_get_gdm_port(struct airoha_eth *eth,
 				    struct airoha_qdma_desc *desc)
 {
-	u32 port, sport, msg1 = le32_to_cpu(desc->msg1);
+	u32 port, sport, msg1 = le32_to_cpu(READ_ONCE(desc->msg1));
 
 	sport = FIELD_GET(QDMA_ETH_RXMSG_SPORT_MASK, msg1);
 	switch (sport) {
@@ -624,21 +624,24 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
 	while (done < budget) {
 		struct airoha_queue_entry *e = &q->entry[q->tail];
 		struct airoha_qdma_desc *desc = &q->desc[q->tail];
-		u32 hash, reason, msg1 = le32_to_cpu(desc->msg1);
-		struct page *page = virt_to_head_page(e->buf);
-		u32 desc_ctrl = le32_to_cpu(desc->ctrl);
+		u32 hash, reason, msg1, desc_ctrl;
 		struct airoha_gdm_port *port;
 		int data_len, len, p;
+		struct page *page;
 
+		desc_ctrl = le32_to_cpu(READ_ONCE(desc->ctrl));
 		if (!(desc_ctrl & QDMA_DESC_DONE_MASK))
 			break;
 
+		dma_rmb();
+
 		q->tail = (q->tail + 1) % q->ndesc;
 		q->queued--;
 
 		dma_sync_single_for_cpu(eth->dev, e->dma_addr,
 					SKB_WITH_OVERHEAD(q->buf_size), dir);
 
+		page = virt_to_head_page(e->buf);
 		len = FIELD_GET(QDMA_DESC_LEN_MASK, desc_ctrl);
 		data_len = q->skb ? q->buf_size
 				  : SKB_WITH_OVERHEAD(q->buf_size);
@@ -682,8 +685,8 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
 			 * DMA descriptor. Report DSA tag to the DSA stack
 			 * via skb dst info.
 			 */
-			u32 sptag = FIELD_GET(QDMA_ETH_RXMSG_SPTAG,
-					      le32_to_cpu(desc->msg0));
+			u32 msg0 = le32_to_cpu(READ_ONCE(desc->msg0));
+			u32 sptag = FIELD_GET(QDMA_ETH_RXMSG_SPTAG, msg0);
 
 			if (sptag < ARRAY_SIZE(port->dsa_meta) &&
 			    port->dsa_meta[sptag])
@@ -691,6 +694,7 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
 						  &port->dsa_meta[sptag]->dst);
 		}
 
+		msg1 = le32_to_cpu(READ_ONCE(desc->msg1));
 		hash = FIELD_GET(AIROHA_RXD4_FOE_ENTRY, msg1);
 		if (hash != AIROHA_RXD4_FOE_ENTRY)
 			skb_set_hash(q->skb, jhash_1word(hash, 0),
-- 
2.53.0



