Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2226D3C1F45;
	Sat, 17 Oct 2026 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259584; cv=none; b=P+TKodpakStzRUT1Ig2wmjFzs06HsC+9XQaHaOavNIjJAI58ii2L8tKebUHoT3Ec1VTaspHouMKU6bwGHl9i1hmDRwSoGcmRm144L2mfTzU/da7Hu/gIPYDi36enYQ9BpcgN9QSDcI5pj9AtmjypTkGkOg2cxjHGD9iwg6d3pgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259584; c=relaxed/simple;
	bh=iV4MS0YXc56du+YeCYrK0aWsaVcoxd8AwmBmjnqLlqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cg/RUrWD6fyGNssP2lFUtaMSIuz3nLf+icQ16KbwPRu2wWUJTbeBvTLU29J4l9ghy8S3n8wpzh8VIjfrgpfxtPZwtSJ1d2eLmwDYpZusqZLqQcajkeRtPDraX9GAEmNKW5nLw/OoFninBqWCm/UwCDEhpCdYLLCo/83VDMJ37p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pz6m0n5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pz6m0n5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72B61F000C4;
	Sat, 17 Oct 2026 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259583;
	bh=O1J6gGemKffL90B4HLurFWn7VGStZVUfSjnbG1ByRbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pz6m0n5Rg9IEb4kUI2+rHpaAJQqzVk0kyH5xTJGm4+jDDToSqVfSaIRY9TyWc1s4d
	 eT2ocdHsFOv2M4qdGKiJwgJHXM5KT2aCpkqheOyhyqJzJs75njjQs9ZyTXw0z4P6aD
	 Ip0fy/A2YrUG72+65s0jomXxbD+UheLlWmxB6QOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1235/1674] net: ethernet: mtk_eth_soc: pass eth to mtk_handle_irq_rx in poll_controller
Date: Sat, 17 Oct 2026 17:58:27 +0200
Message-ID: <20261017160502.838963540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9827e914df1df..379fc508549d9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3237,7 +3237,7 @@ static void mtk_poll_controller(struct net_device *dev)
 
 	mtk_tx_irq_disable(eth, MTK_TX_DONE_INT);
 	mtk_rx_irq_disable(eth, eth->soc->txrx.rx_irq_done_mask);
-	mtk_handle_irq_rx(eth->irq[2], dev);
+	mtk_handle_irq_rx(eth->irq[2], eth);
 	mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
 	mtk_rx_irq_enable(eth, eth->soc->txrx.rx_irq_done_mask);
 }
-- 
2.53.0



