Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61284BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BFCC4339B;
	Tue,  7 Mar 2023 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212479;
	bh=hUtFGrsj5y6R/DETVteMbuVvnY4+/QxaxD/UvEi1pvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGIv1crdh8ZxjdQEcTgmgXy64Hy1Ow4a0srwMo2EbZ7ZmPsMSL6urFr01R0Nn3ha4
	 l0Kkm0aK8ml7Sdqkm77WrSQ86L6rpxw8fDYGIyxYmLGYKw6vJmQiVIXVwwXlESbib3
	 dBj7sbAlddOU5bKZ2iTr549uavWLMlZnmUEjhHrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/885] wifi: mt76: add memory barrier to SDIO queue kick
Date: Tue,  7 Mar 2023 17:52:10 +0100
Message-Id: <20230307170010.536143614@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 5f54237ad798f41cb6a503271aa9ca47188cfb9b ]

Ensure the entry has been fully updated before SDIO bus worker access
it. This patch would fix potential memory risk in both mt7663s and
mt7921s.

Fixes: 764dee47e2c1 ("mt76: sdio: move common code in mt76_sdio module")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 0ec308f99af5a..176207f3177c4 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -562,6 +562,10 @@ mt76s_tx_queue_skb_raw(struct mt76_dev *dev, struct mt76_queue *q,
 
 	q->entry[q->head].buf_sz = len;
 	q->entry[q->head].skb = skb;
+
+	/* ensure the entry fully updated before bus access */
+	smp_wmb();
+
 	q->head = (q->head + 1) % q->ndesc;
 	q->queued++;
 
-- 
2.39.2



