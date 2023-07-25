Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097DE1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D387C433C9;
	Tue, 25 Jul 2023 11:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285434;
	bh=gSW7OcilM+v6Ypb8LNFxr2RtsmttypM4X4gCz9zb8oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QNFp9R9yxuvUuyhsp9fME/upiahFIofZkQBIyyx61Lf+8XKXFFTS8TccPaJCxDpz
	 emAbmFGNQ5GuqahBFpEEyZYfZyZGTKAX1yUafmNW2IbHUCXOzOaETq08Krc6Kzr9UM
	 TvC7aTgWT0Ewk97OtOjIBcNyPEYeQrhi8O/+3vCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <snelson@pensando.io>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 204/313] ionic: clean irq affinity on queue deinit
Date: Tue, 25 Jul 2023 12:45:57 +0200
Message-ID: <20230725104529.844800588@linuxfoundation.org>
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

[ Upstream commit b9c17d39d5d19b321414a1737c754a819878424a ]

Add a little more cleanup when tearing down the queues.

Fixes: 1d062b7b6f64 ("ionic: Add basic adminq support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: abfb2a58a537 ("ionic: remove WARN_ON to prevent panic_on_warn")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 975cda9377ec4..fa57a526b60f6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -269,8 +269,10 @@ static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
+		irq_set_affinity_hint(qcq->intr.vector, NULL);
 		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
 		netif_napi_del(&qcq->napi);
+		qcq->intr.vector = 0;
 	}
 
 	qcq->flags &= ~IONIC_QCQ_F_INITED;
-- 
2.39.2



