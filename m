Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A1344C77;
	Mon, 23 Jun 2025 21:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714402; cv=none; b=pIEvap0TxFSTa1WuK+4BGZMnU5gWCCTH8QowSjvynSz8sLvB/lctmsgCZDT/0tKRcckB4RqpH/1bbH1uh07+LEZA2yh8d0z0oNVWoh50qjnOmZ2jtdAjquiGcrjQSGNv0lgbmw2jvlbkJTKk/dDA5bBKcBKxTYS78vDteJISnDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714402; c=relaxed/simple;
	bh=EiCuiFr9vfTZgy++4KU/nXJtPBMngoTpXTTkTYiBAlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Enydu5fe3ldCHRZsE0yXVCCMXBh5O1oc6Mi6QVsb6wcYpYrlCN3cKxD5qv60n1I6lqunE/UXYTiqa0RXxYBox0MZwzrH5mMbkGvUlkEkxK5vXNTwRvSxukI51QAy/IhmwJF1gmnEsbsf5dicVbpb0nAhg8lFQQZhs5ePzzS+9LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4iIt+T0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4iIt+T0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D41C4CEEA;
	Mon, 23 Jun 2025 21:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714401;
	bh=EiCuiFr9vfTZgy++4KU/nXJtPBMngoTpXTTkTYiBAlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4iIt+T0IGpMgmmXlQ69sp8DjzttElTAItRXSbuii3qCmbwxELJdKL9VCL/j6ehbo
	 4VJ+83IPuhXQFzFgK3UFrTNEgpO4d6yb0DJfU5q2CeUM4Dy57gYn9gW+IzITWX/rSB
	 oZPj83IHTqt/AKUFIf2ipQNN1+rdLeB5qqfkxwoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanqing Wang <ot_yanqing.wang@mediatek.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Biao Huang <biao.huang@mediatek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/508] driver: net: ethernet: mtk_star_emac: fix suspend/resume issue
Date: Mon, 23 Jun 2025 15:03:35 +0200
Message-ID: <20250623130649.457907574@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanqing Wang <ot_yanqing.wang@mediatek.com>

[ Upstream commit ba99c627aac85bc746fb4a6e2d79edb3ad100326 ]

Identify the cause of the suspend/resume hang: netif_carrier_off()
is called during link state changes and becomes stuck while
executing linkwatch_work().

To resolve this issue, call netif_device_detach() during the Ethernet
suspend process to temporarily detach the network device from the
kernel and prevent the suspend/resume hang.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Yanqing Wang <ot_yanqing.wang@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Link: https://patch.msgid.link/20250528075351.593068-1-macpaul.lin@mediatek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index c42e9f741f959..a631491a19da1 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1475,6 +1475,8 @@ static __maybe_unused int mtk_star_suspend(struct device *dev)
 	if (netif_running(ndev))
 		mtk_star_disable(ndev);
 
+	netif_device_detach(ndev);
+
 	clk_bulk_disable_unprepare(MTK_STAR_NCLKS, priv->clks);
 
 	return 0;
@@ -1499,6 +1501,8 @@ static __maybe_unused int mtk_star_resume(struct device *dev)
 			clk_bulk_disable_unprepare(MTK_STAR_NCLKS, priv->clks);
 	}
 
+	netif_device_attach(ndev);
+
 	return ret;
 }
 
-- 
2.39.5



