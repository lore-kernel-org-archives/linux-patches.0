Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FAA1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2E8C433C8;
	Tue, 25 Jul 2023 11:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285443;
	bh=p5QsjKC+cpuRZIC25h8xVJBXEs+Dpw6qX/zwwWM42yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZ+BOVHImDMBXGwGWiZyPbHjbzZfLhg3YWvLhGZ/rQfEihK8oD+AdK7LPiocynjeY
	 ueRbKbkhfejW5dA+3kiNn7k0Az0FgKSdS0hGvxLunvSbqePiuOntoqC/4zJZhcCI6K
	 YwKeZYelYmYUuoM5On3iVSwkLiZTNY4LdHfzAOHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <snelson@pensando.io>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/313] ionic: ionic_intr_free parameter change
Date: Tue, 25 Jul 2023 12:45:59 +0200
Message-ID: <20230725104529.920849403@linuxfoundation.org>
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

[ Upstream commit 36ac2c50924892a28e17ff463e354fec7650ee19 ]

Change the ionic_intr_free parameter from struct ionic_lif to
struct ionic since that's what it actually cares about.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: abfb2a58a537 ("ionic: remove WARN_ON to prevent panic_on_warn")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 3fc9ac1e8b7b7..52d291383c233 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -167,10 +167,10 @@ static int ionic_intr_alloc(struct ionic_lif *lif, struct ionic_intr_info *intr)
 	return 0;
 }
 
-static void ionic_intr_free(struct ionic_lif *lif, int index)
+static void ionic_intr_free(struct ionic *ionic, int index)
 {
-	if (index != INTR_INDEX_NOT_ASSIGNED && index < lif->ionic->nintrs)
-		clear_bit(index, lif->ionic->intrs);
+	if (index != INTR_INDEX_NOT_ASSIGNED && index < ionic->nintrs)
+		clear_bit(index, ionic->intrs);
 }
 
 static int ionic_qcq_enable(struct ionic_qcq *qcq)
@@ -289,7 +289,7 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		irq_set_affinity_hint(qcq->intr.vector, NULL);
 		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
 		qcq->intr.vector = 0;
-		ionic_intr_free(lif, qcq->intr.index);
+		ionic_intr_free(lif->ionic, qcq->intr.index);
 	}
 
 	devm_kfree(dev, qcq->cq.info);
@@ -333,7 +333,7 @@ static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
 				      struct ionic_qcq *n_qcq)
 {
 	if (WARN_ON(n_qcq->flags & IONIC_QCQ_F_INTR)) {
-		ionic_intr_free(n_qcq->cq.lif, n_qcq->intr.index);
+		ionic_intr_free(n_qcq->cq.lif->ionic, n_qcq->intr.index);
 		n_qcq->flags &= ~IONIC_QCQ_F_INTR;
 	}
 
@@ -485,7 +485,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		devm_free_irq(dev, new->intr.vector, &new->napi);
 err_out_free_intr:
 	if (flags & IONIC_QCQ_F_INTR)
-		ionic_intr_free(lif, new->intr.index);
+		ionic_intr_free(lif->ionic, new->intr.index);
 err_out:
 	dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
 	return err;
-- 
2.39.2



