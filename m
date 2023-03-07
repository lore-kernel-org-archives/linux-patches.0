Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F322DBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06058C433EF;
	Tue,  7 Mar 2023 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209530;
	bh=cqvK8r4nU32/v9srYS0ItdLsFwB3cVfIeR/BUI/1wKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tq2COvohdbWIeBZYAStDac7/VUjaKNdjhAB0F4qQX8jaEEFjMQG90G/soEfhgkJqX
	 nNMHhNz62ASLriMylko2+L1lTjKOIF5CZCk6lk8NDR5hGMd1IWh72c7cm6h0RD0UeJ
	 Lewujtl2Q7yS5VKH7iSzqLrXg4ZbX7S2qc9W+zD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0248/1001] wifi: mt76: dma: fix memory leak running mt76_dma_tx_cleanup
Date: Tue,  7 Mar 2023 17:50:20 +0100
Message-Id: <20230307170032.558832804@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 3f7dda36e0b6dfa2cd26191f754ba061ab8191f2 ]

Fix device unregister memory leak and alway cleanup all configured
rx queues in mt76_dma_tx_cleanup routine.

Fixes: 52546e27787e ("wifi: mt76: add WED RX support to dma queue alloc")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 06161815c180e..dee4449de9082 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -975,8 +975,7 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
 		struct mt76_queue *q = &dev->q_rx[i];
 
 		netif_napi_del(&dev->napi[i]);
-		if (FIELD_GET(MT_QFLAG_WED_TYPE, q->flags))
-			mt76_dma_rx_cleanup(dev, q);
+		mt76_dma_rx_cleanup(dev, q);
 	}
 
 	mt76_free_pending_txwi(dev);
-- 
2.39.2



