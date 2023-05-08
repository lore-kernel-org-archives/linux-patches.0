Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284BD168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF65C433D2;
	Mon,  8 May 2023 10:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540451;
	bh=igqHcTiZOfUg3RVYlZCy4m2MC7Kwc9XxbrPsGGwirVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNNi6YpWw2irjtr74tissIk5vZI7A4MTqc73tpMAS5AZUhdIMZ208RNnhRqaDYTZJ
	 YIiWlQX66lpsJ+gGbSlnQKiwH0z8+sCF9wqtDafiaJ9Da0/5xCTE9Lh7FQ9KWe0foa
	 bMwhqtPfLqDhllJE0uN9fEam5/HKkb48UfuP7078=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Wang Zhao <wang.zhao@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 369/611] wifi: mt76: mt7921e: stop chip reset worker in unregister hook
Date: Mon,  8 May 2023 11:43:31 +0200
Message-Id: <20230508094434.360398661@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit 3d78c46423c6567ed25ca033e086865b1b4d5ae1 ]

If the chip reset worker is triggered during the remove process, the chip
DMA may not be properly pushed back to the idle state. This can lead to
corruption of the DMA flow due to the chip reset. Therefore, it is
necessary to stop the chip reset before the DMA is finalized.

To avoid resetting the chip after the reset worker is cancelled, use
__mt7921_mcu_drv_pmctrl() instead of mt7921_mcu_drv_pmctrl(). It is safe to
ignore the pm mutex because the pm worker and wake worker have already been
cancelled.

Fixes: 033ae79b3830 ("mt76: mt7921: refactor init.c to be bus independent")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Co-developed-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Co-developed-by: Wang Zhao <wang.zhao@mediatek.com>
Signed-off-by: Wang Zhao <wang.zhao@mediatek.com>
Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 24a2aafa6e2a1..c64b0b4e93583 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -111,9 +111,10 @@ static void mt7921e_unregister_device(struct mt7921_dev *dev)
 		napi_disable(&dev->mt76.napi[i]);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
+	cancel_work_sync(&dev->reset_work);
 
 	mt7921_tx_token_put(dev);
-	mt7921_mcu_drv_pmctrl(dev);
+	__mt7921_mcu_drv_pmctrl(dev);
 	mt7921_dma_cleanup(dev);
 	mt7921_wfsys_reset(dev);
 	skb_queue_purge(&dev->mt76.mcu.res_q);
-- 
2.39.2



