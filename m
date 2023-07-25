Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7517E1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E356AC433C7;
	Tue, 25 Jul 2023 11:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285440;
	bh=oAMV6m1uEsuT35Eo+OgXvHVxa16lyUqbkzqOS85W42k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlhMShCepbaQTR94E8lwKm87sof23iOa6L5A1MglxOiDXTIIdnkkxDoANJ7fsbjSN
	 a+FR7z0qw/MNskIlNN8YckSym4QLX3aDOFy+R/DpSxj3e0t2JRI05FgksFRMBm3Zfm
	 eDOD+VJTZJI7Cgjmh2OOtV49ZRVZPYWUJ3Wv3Vmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <snelson@pensando.io>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/313] ionic: move irq request to qcq alloc
Date: Tue, 25 Jul 2023 12:45:58 +0200
Message-ID: <20230725104529.885726207@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 0b0641009b8918c8d5f6e7ed300d569c9d811de5 ]

Move the irq request and free out of the qcq_init and deinit
and into the alloc and free routines where they belong for
better resource management.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: abfb2a58a537 ("ionic: remove WARN_ON to prevent panic_on_warn")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 41 +++++++++----------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index fa57a526b60f6..3fc9ac1e8b7b7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -256,7 +256,6 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
 static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
-	struct device *dev = lif->ionic->dev;
 
 	if (!qcq)
 		return;
@@ -269,10 +268,7 @@ static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
-		irq_set_affinity_hint(qcq->intr.vector, NULL);
-		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
 		netif_napi_del(&qcq->napi);
-		qcq->intr.vector = 0;
 	}
 
 	qcq->flags &= ~IONIC_QCQ_F_INITED;
@@ -289,8 +285,12 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	qcq->base = NULL;
 	qcq->base_pa = 0;
 
-	if (qcq->flags & IONIC_QCQ_F_INTR)
+	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		irq_set_affinity_hint(qcq->intr.vector, NULL);
+		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
+		qcq->intr.vector = 0;
 		ionic_intr_free(lif, qcq->intr.index);
+	}
 
 	devm_kfree(dev, qcq->cq.info);
 	qcq->cq.info = NULL;
@@ -420,6 +420,12 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		ionic_intr_mask_assert(idev->intr_ctrl, new->intr.index,
 				       IONIC_INTR_MASK_SET);
 
+		err = ionic_request_irq(lif, new);
+		if (err) {
+			netdev_warn(lif->netdev, "irq request failed %d\n", err);
+			goto err_out_free_intr;
+		}
+
 		new->intr.cpu = cpumask_local_spread(new->intr.index,
 						     dev_to_node(dev));
 		if (new->intr.cpu != -1)
@@ -434,13 +440,13 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	if (!new->cq.info) {
 		netdev_err(lif->netdev, "Cannot allocate completion queue info\n");
 		err = -ENOMEM;
-		goto err_out_free_intr;
+		goto err_out_free_irq;
 	}
 
 	err = ionic_cq_init(lif, &new->cq, &new->intr, num_descs, cq_desc_size);
 	if (err) {
 		netdev_err(lif->netdev, "Cannot initialize completion queue\n");
-		goto err_out_free_intr;
+		goto err_out_free_irq;
 	}
 
 	new->base = dma_alloc_coherent(dev, total_size, &new->base_pa,
@@ -448,7 +454,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	if (!new->base) {
 		netdev_err(lif->netdev, "Cannot allocate queue DMA memory\n");
 		err = -ENOMEM;
-		goto err_out_free_intr;
+		goto err_out_free_irq;
 	}
 
 	new->total_size = total_size;
@@ -474,8 +480,12 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 
 	return 0;
 
+err_out_free_irq:
+	if (flags & IONIC_QCQ_F_INTR)
+		devm_free_irq(dev, new->intr.vector, &new->napi);
 err_out_free_intr:
-	ionic_intr_free(lif, new->intr.index);
+	if (flags & IONIC_QCQ_F_INTR)
+		ionic_intr_free(lif, new->intr.index);
 err_out:
 	dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
 	return err;
@@ -650,12 +660,6 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi,
 		       NAPI_POLL_WEIGHT);
 
-	err = ionic_request_irq(lif, qcq);
-	if (err) {
-		netif_napi_del(&qcq->napi);
-		return err;
-	}
-
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
 	ionic_debugfs_add_qcq(lif, qcq);
@@ -1873,13 +1877,6 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi,
 		       NAPI_POLL_WEIGHT);
 
-	err = ionic_request_irq(lif, qcq);
-	if (err) {
-		netdev_warn(lif->netdev, "adminq irq request failed %d\n", err);
-		netif_napi_del(&qcq->napi);
-		return err;
-	}
-
 	napi_enable(&qcq->napi);
 
 	if (qcq->flags & IONIC_QCQ_F_INTR)
-- 
2.39.2



