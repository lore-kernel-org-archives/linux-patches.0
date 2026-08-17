Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D568439F9B;
	Mon, 17 Aug 2026 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974816; cv=none; b=WjsHoMYZ6M1Njhjin1WcCRIkDNOfceMwZ30k8Aln2GluVUINu1nB1JRCAlwDfmEEINRFQ+NHHTKxp52lzLQgmXO76pG5iDPp5WzsQglviK4yDOFJZ5DVjTUKWpOIobd33asUmbPAmYiz6muglKPXiSTwB0mC2rvXKs7NReZRWcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974816; c=relaxed/simple;
	bh=n8l877AoZnw2Tyfj3thqG1EXRNTDX/vo/zPqLb+lFHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJTQ+uvM55mJs+NmkCOFGxPyC4aR+8r72MV/i0j/ETWfgOb0lOaOqfQjmtOQ9g1EXAEJGS02b3kgBhglDw41QypaUK+B4h7XiXKxqJvotv9pAi1MPbFqXdtWSQAydkq6cdh2goo4zF04Rq8wfzBYXu7lGonCN4pVslWA6J5yh+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxAKjUKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxAKjUKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4281F00A3A;
	Mon, 17 Aug 2026 13:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974810;
	bh=vOtficGmTu4/J/8UjWUl2SGwuso9FgwaZlGx1/ga2MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxAKjUKx2MuQEPzLPuKkfVnJ/B54Cv94Qc1h2LXEPPRBTe/qdyq/dlpLmxCNLsqhM
	 nmY8hZ7vf2UmsDA1H6hPyMs6p9UBofQddX/na6DEdcBt6rZtNFoufyDLE1nPXGP1bF
	 jAXr2jhZYncGiCVveoDb13yFkGcuBUSTWT6JWf7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/250] net: pass queue rx page size from memory provider
Date: Mon, 17 Aug 2026 15:30:22 +0200
Message-ID: <20260817132538.941969987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit c0b709bf438ba9d197d369f55e4a97603fd4a705 ]

Allow memory providers to configure rx queues with a custom receive
page size. It's passed in struct pp_memory_provider_params, which is
copied into the queue, so it's preserved across queue restarts. Then,
it's propagated to the driver in a new queue config parameter.

Drivers should explicitly opt into using it by setting
QCFG_RX_PAGE_SIZE, in which case they should implement ndo_default_qcfg,
validate the size on queue restart and honour the current config in case
of a reset.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Stable-dep-of: d1000fd7995e ("bnxt: fix memory leak in bnxt_queue_mem_alloc error cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netdev_queues.h   | 10 ++++++++++
 include/net/page_pool/types.h |  1 +
 net/core/netdev_rx_queue.c    |  9 +++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index f6f1f71a24e15..feca25131930b 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -15,6 +15,7 @@ struct netdev_config {
 };
 
 struct netdev_queue_config {
+	u32	rx_page_size;
 };
 
 /* See the netdev.yaml spec for definition of each statistic */
@@ -114,6 +115,11 @@ void netdev_stat_queue_sum(struct net_device *netdev,
 			   int tx_start, int tx_end,
 			   struct netdev_queue_stats_tx *tx_sum);
 
+enum {
+	/* The queue checks and honours the page size qcfg parameter */
+	QCFG_RX_PAGE_SIZE	= 0x1,
+};
+
 /**
  * struct netdev_queue_mgmt_ops - netdev ops for queue management
  *
@@ -135,6 +141,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  *
  * @ndo_default_qcfg:	Populate queue config struct with defaults. Optional.
  *
+ * @supported_params:	Bitmask of supported parameters, see QCFG_*.
+ *
  * Note that @ndo_queue_mem_alloc and @ndo_queue_mem_free may be called while
  * the interface is closed. @ndo_queue_start and @ndo_queue_stop will only
  * be called for an interface which is open.
@@ -158,6 +166,8 @@ struct netdev_queue_mgmt_ops {
 				    struct netdev_queue_config *qcfg);
 	struct device *	(*ndo_queue_get_dma_dev)(struct net_device *dev,
 						 int idx);
+
+	unsigned int supported_params;
 };
 
 bool netif_rxq_has_unreadable_mp(struct net_device *dev, int idx);
diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index fb4f03ccd6156..cdd95477af7a2 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -161,6 +161,7 @@ struct memory_provider_ops;
 struct pp_memory_provider_params {
 	void *mp_priv;
 	const struct memory_provider_ops *mp_ops;
+	u32 rx_page_size;
 };
 
 struct page_pool {
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index f18147b478688..485bdb7447b99 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -30,12 +30,21 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 	    !qops->ndo_queue_mem_alloc || !qops->ndo_queue_start)
 		return -EOPNOTSUPP;
 
+	if (WARN_ON_ONCE(qops->supported_params && !qops->ndo_default_qcfg))
+		return -EINVAL;
+
 	netdev_assert_locked(dev);
 
 	memset(&qcfg, 0, sizeof(qcfg));
 	if (qops->ndo_default_qcfg)
 		qops->ndo_default_qcfg(dev, &qcfg);
 
+	if (rxq->mp_params.rx_page_size) {
+		if (!(qops->supported_params & QCFG_RX_PAGE_SIZE))
+			return -EOPNOTSUPP;
+		qcfg.rx_page_size = rxq->mp_params.rx_page_size;
+	}
+
 	new_mem = kvzalloc(qops->ndo_queue_mem_size, GFP_KERNEL);
 	if (!new_mem)
 		return -ENOMEM;
-- 
2.53.0



