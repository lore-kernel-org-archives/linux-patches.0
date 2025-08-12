Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188112ECE93;
	Tue, 12 Aug 2025 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023690; cv=none; b=J6zbwv7JCghjEzaw0cZM1HvM461GTTCEUcHmTWOQ3sKyyIF22FQvvYrCqHz9E6xbUZrS89okoFkYFUaDLAIYj2L0ziFS+drvtlCFqNtJ/2s5wG0AMv+TvaI24IDRYGYQklI6Ppv7LcU63CWirNWhz3yzyXOpouhj76kIb/TpeBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023690; c=relaxed/simple;
	bh=jv3K/BEWRvknlh4NMraPFo/bl6dpMioHb71ZKPD6YxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGSqv4psZYyWUYa/Etz4cEChFCKmpe3Bq2LIhmh/TCquVyP+WIn2qLvcilMsqMpJnZWrGm6CaOF7PN+tHcC/k/+2v415SfkfJUjRPJOJnPgxWGFk1qwNDejuIGiMHMtaJjKr7jMQEboRWv6OyDsf25V4mqAMaWu0Ho/6KqV3D/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQ3WmbJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQ3WmbJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A06BC4CEF0;
	Tue, 12 Aug 2025 18:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023690;
	bh=jv3K/BEWRvknlh4NMraPFo/bl6dpMioHb71ZKPD6YxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQ3WmbJBWu+jQaztEwcDQzzPo3g/G+PS3dmRuGQFAoPc6IpusSeKlO1dbMOSFsb2m
	 cHPQFcxH/1ptZu1PpWVvhIt96EdITVizpNFlYs1pT/HcVYcFP4z/uJlmcDhdDQ6Eev
	 BtG9Ck1StluyVRcYnvIchEO1qV+CUtLGgydvtmYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Saurabh Singh Sengar <ssengar@linux.microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 153/627] net: mana: Fix potential deadlocks in mana napi ops
Date: Tue, 12 Aug 2025 19:27:28 +0200
Message-ID: <20250812173425.109807187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit d5c8f0e4e0cb0ac2a4a4e015f2f5b1ba39e5e583 ]

When net_shaper_ops are enabled for MANA, netdev_ops_lock
becomes active.

MANA VF setup/teardown by netvsc follows this call chain:

netvsc_vf_setup()
        dev_change_flags()
		...
         __dev_open() OR __dev_close()

dev_change_flags() holds the netdev mutex via netdev_lock_ops.

Meanwhile, mana_create_txq() and mana_create_rxq() in mana_open()
path call NAPI APIs (netif_napi_add_tx(), netif_napi_add_weight(),
napi_enable()), which also try to acquire the same lock, risking
deadlock.

Similarly in the teardown path (mana_close()), netif_napi_disable()
and netif_napi_del(), contend for the same lock.

Switch to the _locked variants of these APIs to avoid deadlocks
when the netdev_ops_lock is held.

Fixes: d4c22ec680c8 ("net: hold netdev instance lock during ndo_open/ndo_stop")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Reviewed-by: Saurabh Singh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/1750144656-2021-2-git-send-email-ernis@linux.microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index faad1cb880f8..2dd14d97cc98 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1912,8 +1912,10 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 		napi = &apc->tx_qp[i].tx_cq.napi;
 		if (apc->tx_qp[i].txq.napi_initialized) {
 			napi_synchronize(napi);
-			napi_disable(napi);
-			netif_napi_del(napi);
+			netdev_lock_ops_to_full(napi->dev);
+			napi_disable_locked(napi);
+			netif_napi_del_locked(napi);
+			netdev_unlock_full_to_ops(napi->dev);
 			apc->tx_qp[i].txq.napi_initialized = false;
 		}
 		mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
@@ -2065,8 +2067,11 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		mana_create_txq_debugfs(apc, i);
 
-		netif_napi_add_tx(net, &cq->napi, mana_poll);
-		napi_enable(&cq->napi);
+		set_bit(NAPI_STATE_NO_BUSY_POLL, &cq->napi.state);
+		netdev_lock_ops_to_full(net);
+		netif_napi_add_locked(net, &cq->napi, mana_poll);
+		napi_enable_locked(&cq->napi);
+		netdev_unlock_full_to_ops(net);
 		txq->napi_initialized = true;
 
 		mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
@@ -2102,9 +2107,10 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	if (napi_initialized) {
 		napi_synchronize(napi);
 
-		napi_disable(napi);
-
-		netif_napi_del(napi);
+		netdev_lock_ops_to_full(napi->dev);
+		napi_disable_locked(napi);
+		netif_napi_del_locked(napi);
+		netdev_unlock_full_to_ops(napi->dev);
 	}
 	xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
@@ -2355,14 +2361,18 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-	netif_napi_add_weight(ndev, &cq->napi, mana_poll, 1);
+	netdev_lock_ops_to_full(ndev);
+	netif_napi_add_weight_locked(ndev, &cq->napi, mana_poll, 1);
+	netdev_unlock_full_to_ops(ndev);
 
 	WARN_ON(xdp_rxq_info_reg(&rxq->xdp_rxq, ndev, rxq_idx,
 				 cq->napi.napi_id));
 	WARN_ON(xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
 					   rxq->page_pool));
 
-	napi_enable(&cq->napi);
+	netdev_lock_ops_to_full(ndev);
+	napi_enable_locked(&cq->napi);
+	netdev_unlock_full_to_ops(ndev);
 
 	mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
 out:
-- 
2.39.5



