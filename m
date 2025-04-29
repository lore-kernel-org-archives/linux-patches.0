Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F67250C0C;
	Tue, 29 Apr 2025 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949082; cv=none; b=dwOmaApUuoSCCM4g1eILjf59LhYiMMI3NEg1ralk357jsQwffT/kvrQC8cKmiJIllnazWR26bm/luvX9ZfjmqGG+UqJqc9Nw7hbJi8+facDQ7yum05WsTD4f2rzjyaVKCZwDQEKSEFKSSosjSjw9DBE2IeIOO4ETBFgkuVBmCrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949082; c=relaxed/simple;
	bh=BRtTpcMxtj5yQqDpShx4Ivizs46iQsDY956vh2BoQeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKk5sNCuIxpUiEtFhQIOcVcdRcYOYDNmii+ge0WMj+/OZaUNfLdtIHDFMH8NtswxcS1Ze7/vDjwBjrn5cqw+2+KY0ivzdZsTREzoki8RZy/4x0Wq7/urZNgPeNxAvty03G81FW4yRw+IVuIMlppP0d8DWI0YmCZmFR5uQ9yxAlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPfLbih3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPfLbih3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF747C4CEE3;
	Tue, 29 Apr 2025 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949082;
	bh=BRtTpcMxtj5yQqDpShx4Ivizs46iQsDY956vh2BoQeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPfLbih3Q8bmyd14J1spktxMT3lQwPeXbgVvS/bYraUPjLmyjq44L9XOuqqB9utsQ
	 2+Izh4gAXhw9B4iTNL0lxz1Buv0TxYkIC5O/oAglk2ncJMzND5SWSqDJCJ/4r/Mn46
	 MT3yVFIl2ONbc+6XETu3DVLw36cD+py3jvEy/13Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 208/373] net: mana: Fix error handling in mana_create_txq/rxqs NAPI cleanup
Date: Tue, 29 Apr 2025 18:41:25 +0200
Message-ID: <20250429161131.719160747@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>

[ Upstream commit b6ecc662037694488bfff7c9fd21c405df8411f2 ]

Currently napi_disable() gets called during rxq and txq cleanup,
even before napi is enabled and hrtimer is initialized. It causes
kernel panic.

? page_fault_oops+0x136/0x2b0
  ? page_counter_cancel+0x2e/0x80
  ? do_user_addr_fault+0x2f2/0x640
  ? refill_obj_stock+0xc4/0x110
  ? exc_page_fault+0x71/0x160
  ? asm_exc_page_fault+0x27/0x30
  ? __mmdrop+0x10/0x180
  ? __mmdrop+0xec/0x180
  ? hrtimer_active+0xd/0x50
  hrtimer_try_to_cancel+0x2c/0xf0
  hrtimer_cancel+0x15/0x30
  napi_disable+0x65/0x90
  mana_destroy_rxq+0x4c/0x2f0
  mana_create_rxq.isra.0+0x56c/0x6d0
  ? mana_uncfg_vport+0x50/0x50
  mana_alloc_queues+0x21b/0x320
  ? skb_dequeue+0x5f/0x80

Cc: stable@vger.kernel.org
Fixes: e1b5683ff62e ("net: mana: Move NAPI from EQ to CQ")
Signed-off-by: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit b6ecc662037694488bfff7c9fd21c405df8411f2)
[Harshit: conflicts resolved due to missing commit: ed5356b53f07 ("net:
mana: Add XDP support") and commit: d356abb95b98 ("net: mana: Add
counter for XDP_TX") in 5.15.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana.h    |    2 ++
 drivers/net/ethernet/microsoft/mana/mana_en.c |   21 +++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -76,6 +76,8 @@ struct mana_txq {
 
 	atomic_t pending_sends;
 
+	bool napi_initialized;
+
 	struct mana_stats stats;
 };
 
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1154,10 +1154,12 @@ static void mana_destroy_txq(struct mana
 
 	for (i = 0; i < apc->num_queues; i++) {
 		napi = &apc->tx_qp[i].tx_cq.napi;
-		napi_synchronize(napi);
-		napi_disable(napi);
-		netif_napi_del(napi);
-
+		if (apc->tx_qp[i].txq.napi_initialized) {
+			napi_synchronize(napi);
+			napi_disable(napi);
+			netif_napi_del(napi);
+			apc->tx_qp[i].txq.napi_initialized = false;
+		}
 		mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
 
 		mana_deinit_cq(apc, &apc->tx_qp[i].tx_cq);
@@ -1213,6 +1215,7 @@ static int mana_create_txq(struct mana_p
 		txq->ndev = net;
 		txq->net_txq = netdev_get_tx_queue(net, i);
 		txq->vp_offset = apc->tx_vp_offset;
+		txq->napi_initialized = false;
 		skb_queue_head_init(&txq->pending_skbs);
 
 		memset(&spec, 0, sizeof(spec));
@@ -1277,6 +1280,7 @@ static int mana_create_txq(struct mana_p
 
 		netif_tx_napi_add(net, &cq->napi, mana_poll, NAPI_POLL_WEIGHT);
 		napi_enable(&cq->napi);
+		txq->napi_initialized = true;
 
 		mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
 	}
@@ -1288,7 +1292,7 @@ out:
 }
 
 static void mana_destroy_rxq(struct mana_port_context *apc,
-			     struct mana_rxq *rxq, bool validate_state)
+			     struct mana_rxq *rxq, bool napi_initialized)
 
 {
 	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
@@ -1302,12 +1306,13 @@ static void mana_destroy_rxq(struct mana
 
 	napi = &rxq->rx_cq.napi;
 
-	if (validate_state)
+	if (napi_initialized) {
 		napi_synchronize(napi);
 
-	napi_disable(napi);
-	netif_napi_del(napi);
+		napi_disable(napi);
 
+		netif_napi_del(napi);
+	}
 	mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
 	mana_deinit_cq(apc, &rxq->rx_cq);


