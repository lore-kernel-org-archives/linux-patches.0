Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37E94FECCF;
	Wed, 30 Sep 2026 16:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787068; cv=none; b=jxwy21OSNJraMGrbqKFR+5/RlERDjneL9Pesw024GJHpukYdiPq3Y7YQv4j+o7ZFCj/OpMQZcpdC3UEZHHWsaeZcmV7r+6sQQM7afRxrb3YPzK3tqVwtXOeb1IyljsK+GOEbZyLN+jLarB+/fX/L8OAIXID/jqlJBxg/lYEI5sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787068; c=relaxed/simple;
	bh=OzIKRJO14/nM+I+UlSO1sdNJAOOt1hqmDsojG4mnHjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0W63kDoetwnaKq0oYEkG8NOwfRsG0HdvqYjIJeH9Rit+HVuVo9eA18QMIs65Wgx0bsdTTDQsqYQvybdxJvJ1OkYAEKerI4vPg+V2ZdNYzdp6UmxWr8sI2jvtbDIRMWb/ZgkPigpPak1ta2aKpRH83HRbZcXZNJ2ehQNwdVqshE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXonkE0H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXonkE0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2009C1F000FF;
	Wed, 30 Sep 2026 16:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787066;
	bh=OqOzjvaUCmtF6z9SWguHyHG5YhRudleGBD1CfxXPJIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXonkE0HPBodECriR1qOT76/vD3jt38e/gYNR2b/xflxjV1glJ7I5Er+6W4QGuWey
	 qfqRIAKkR4CiXdzqMFIPl9XLBr7EcZ79JrnqpqtsSx0CM3rFrHNGYvFMSVLwnd0rLE
	 A0JPmVXAHY+4V+9cAzOgiiaf+WeRonEa0LcpqgjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 098/457] eth: fbnic: use the Rx queue napi pointer to find the napi vector
Date: Wed, 30 Sep 2026 17:23:23 +0200
Message-ID: <20260930152348.166357848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit b5d9e9d4d0c13bc8b60d8d97e7a07fb25fea639e ]

The queue management ndos pick the napi vector for an Rx queue with:
	nv = fbn->napi[idx % fbn->num_napi];

The issue is this is only correct in the cases where there are no
standalone Tx vectors. In those cases we were allocating the Tx vectors
first and then the Rx so the queues would be pointing to Tx NAPI vectors
instead of the Rx ones.

The mapping the ndos want is already recorded.  fbnic_set_netif_napi()
publishes it with netif_queue_set_napi(), which stores the napi pointer
in netdev_rx_queue.napi, and fbnic_reset_netif_napi() clears it again.
Both run under the netdev instance lock that the queue management ndos
also hold, so the pointer can be read directly.

Use it and drop the divide.  The pointer is NULL exactly while the
datapath is down, so fbnic_queue_mem_alloc() can reject that case rather
than reaching into freed state: netdev_rx_queue_restart() calls it
before it tests netif_running(), and fbnic_pm_suspend() leaves
netif_running() true across a PCIe recovery that never completes, so a
queue restart can arrive after fbnic_stop() has freed the rings and the
vectors.  fbnic_stop() clears the association in
fbnic_reset_netif_queues() before fbnic_free_napi_vectors(), so the
NULL is always published first.  fbnic_queue_start() and
fbnic_queue_stop() need no check of their own, as
netdev_rx_queue_reconfig() only reaches them once fbnic_queue_mem_alloc()
has succeeded under the same instance lock.

Fixes: da43127a8edc ("eth: fbnic: support queue ops / zero-copy Rx")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/178942021136.7700.4391219358260544104.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 26 +++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index a30aa44508487..10caacffee0f0 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -7,6 +7,7 @@
 #include <linux/iopoll.h>
 #include <linux/pci.h>
 #include <net/netdev_queues.h>
+#include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
 #include <net/tcp.h>
 #include <net/xdp.h>
@@ -2853,6 +2854,17 @@ void fbnic_napi_depletion_check(struct net_device *netdev)
 	fbnic_wrfl(fbd);
 }
 
+/* Returns the napi vector servicing an Rx queue, or NULL if the datapath
+ * is torn down.  The association is published by fbnic_set_netif_napi()
+ * and cleared by fbnic_reset_netif_napi(), both under the instance lock.
+ */
+static struct fbnic_napi_vector *fbnic_rxq_nv(struct net_device *dev, int idx)
+{
+	struct napi_struct *napi = __netif_get_rx_queue(dev, idx)->napi;
+
+	return napi ? container_of(napi, struct fbnic_napi_vector, napi) : NULL;
+}
+
 static int fbnic_queue_mem_alloc(struct net_device *dev,
 				 struct netdev_queue_config *qcfg,
 				 void *qmem, int idx)
@@ -2865,8 +2877,16 @@ static int fbnic_queue_mem_alloc(struct net_device *dev,
 	if (!netif_running(dev))
 		return fbnic_alloc_qt_page_pools(fbn, qt, idx);
 
+	/* A failed PCIe recovery or resume can leave the datapath torn down
+	 * while netif_running() is still true.  This ndo runs before
+	 * netdev_rx_queue_restart() checks netif_running(), so bail out
+	 * rather than touching rings and vectors that are already freed.
+	 */
+	nv = fbnic_rxq_nv(dev, idx);
+	if (!nv)
+		return -ENETDOWN;
+
 	real = container_of(fbn->rx[idx], struct fbnic_q_triad, cmpl);
-	nv = fbn->napi[idx % fbn->num_napi];
 
 	fbnic_ring_init(&qt->sub0, real->sub0.doorbell, real->sub0.q_idx,
 			real->sub0.flags);
@@ -2917,7 +2937,7 @@ static int fbnic_queue_start(struct net_device *dev,
 	struct fbnic_q_triad *real;
 
 	real = container_of(fbn->rx[idx], struct fbnic_q_triad, cmpl);
-	nv = fbn->napi[idx % fbn->num_napi];
+	nv = fbnic_rxq_nv(dev, idx);
 
 	fbnic_aggregate_ring_bdq_counters(fbn, &real->sub0);
 	fbnic_aggregate_ring_bdq_counters(fbn, &real->sub1);
@@ -2939,7 +2959,7 @@ static int fbnic_queue_stop(struct net_device *dev, void *qmem, int idx)
 	int err;
 
 	real = container_of(fbn->rx[idx], struct fbnic_q_triad, cmpl);
-	nv = fbn->napi[idx % fbn->num_napi];
+	nv = fbnic_rxq_nv(dev, idx);
 	fbnic_dbg_nv_exit(nv);
 
 	napi_disable_locked(&nv->napi);
-- 
2.53.0



