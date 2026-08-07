Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475324756C9;
	Fri,  7 Aug 2026 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115074; cv=none; b=JngGEUoGd4Cbxt5MHuGsfMjBKXyonoDTGvPfsmbDJlLgTfgfu+PWaZTUd3teB+Qw7lDPfKHZPv79yVU1gd7f5/zSyBs5mwbBFy336wxhCj7IP5f2IAuw0PQtN1pdPngR/VMNhMJceos9YqlMz5rwIv3WQvb/W4oEEGW8zH2rqgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115074; c=relaxed/simple;
	bh=9nPAAHIWB+7/Gg39Z1eNeJGAEa0q6oGWzrM3It/H22Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5LYAMnDBXb1j0iIct3w2yogpm4vNJw18dULv73RsR6b0ljVDIqO5RZllcopHJv8SYePklun+PWM0DxoZm3ZnVL6nkztRBnbAzqEj69xaMjyScdnO++zwopXTmx4dpQ7GmtdbNbdmGMsLVoYP2Pdf2E1BxJNPOP6q23Riqazi8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0j51AKjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0j51AKjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1B41F00A3A;
	Fri,  7 Aug 2026 15:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115064;
	bh=RGXWZbsKAfwSPDrXbgmotfHTdv41696Ni5qa0L9wB8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0j51AKjVqNI0A8QSvixYvNnKj22NO4Ht1WK9NvyXLhEhDcnCUiearIqrXU/88LISs
	 kyLNxwpeNzDJAteInscCyV2t2w+ShKX/v6+KKFHuvj5zzLnE0zLtDTyV7RT/IiW7uG
	 3phEPoYItmY33u0seWftpGEecs9fB+9FuVWdIuN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/396] net: ethernet: mtk_eth_soc: pass eth to mtk_handle_irq_rx in poll_controller
Date: Fri,  7 Aug 2026 16:34:21 +0200
Message-ID: <20260807143426.471556797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit e095f249e2209674f6366f6db0383a2b96e19239 ]

mtk_handle_irq_rx expects a struct mtk_eth * (matching the request_irq
cookie), but mtk_poll_controller incorrectly passed the net_device *.
Calling ndo_poll_controller with CONFIG_NET_POLL_CONTROLLER enabled
would then crash.

Fixes: 8186f6e382d8 ("net-next: mediatek: fix compile error inside mtk_poll_controller()")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Link: https://patch.msgid.link/20260723055735.885112-1-chenguang.zhao@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 065f969ee44ef..98cf11a706e14 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3446,7 +3446,7 @@ static void mtk_poll_controller(struct net_device *dev)
 
 	mtk_tx_irq_disable(eth, MTK_TX_DONE_INT);
 	mtk_rx_irq_disable(eth, eth->soc->rx.irq_done_mask);
-	mtk_handle_irq_rx(eth->irq[MTK_FE_IRQ_RX], dev);
+	mtk_handle_irq_rx(eth->irq[MTK_FE_IRQ_RX], eth);
 	mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
 	mtk_rx_irq_enable(eth, eth->soc->rx.irq_done_mask);
 }
-- 
2.53.0



