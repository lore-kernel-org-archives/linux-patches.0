Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4C92E7185;
	Tue, 17 Jun 2025 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178819; cv=none; b=SeQeZyjixM8NhF7Sn7xK7JJEJhRdfzOVJzGkdVcCq9+MVCo0ewy5Qi9U9LsWfRdrLsLFU3mLeFFGYCTMA8eLpiJylDIdecFw4A3TYsepaU86Tq5Y/Z2pyQ0c9AgWNXaa9zuZR2Lz7bPZDAhnVA6XMoHiDM5OYn3PimQ835oeEB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178819; c=relaxed/simple;
	bh=H8r7PbIGzIZofUy7tDxeeHB2eJH3QTvmlc+3Jpm3zzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4VEAU2sMBPGLGcpMOlFEj/vcCEv9cCTkHhvdjo+8DMm/elB6bKy+8ltL9RgETjJQFkqxTqQhSJe020j0bR8BVe90duWIBmU7f4GJ0clDonxMijOJNJnsG5yavYNYPRqBqEu1SAg9YptShhxvqajDHilc1fDuRUQ8IEBgRA0Gyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sz9Yefq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sz9Yefq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5B1C4CEE3;
	Tue, 17 Jun 2025 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178819;
	bh=H8r7PbIGzIZofUy7tDxeeHB2eJH3QTvmlc+3Jpm3zzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sz9Yefq6RCWoCyQQNrtWFOyS0DWHuG7WQ+nAHlX/zst6RLrnaDv/JZoHrBxDJYQ3C
	 ucbCy5UXFim4Xrju9JEcxusLfT0pLArp1V+oRBxwIstRruCQzizOqTzjlWhu5VwNnM
	 tZamk1+lFZFYjndBPFimWcMvu0FFL8aWH4ePnNsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanqing Wang <ot_yanqing.wang@mediatek.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Biao Huang <biao.huang@mediatek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 563/780] driver: net: ethernet: mtk_star_emac: fix suspend/resume issue
Date: Tue, 17 Jun 2025 17:24:31 +0200
Message-ID: <20250617152514.415947540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b175119a6a7da..b83886a411210 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1463,6 +1463,8 @@ static __maybe_unused int mtk_star_suspend(struct device *dev)
 	if (netif_running(ndev))
 		mtk_star_disable(ndev);
 
+	netif_device_detach(ndev);
+
 	clk_bulk_disable_unprepare(MTK_STAR_NCLKS, priv->clks);
 
 	return 0;
@@ -1487,6 +1489,8 @@ static __maybe_unused int mtk_star_resume(struct device *dev)
 			clk_bulk_disable_unprepare(MTK_STAR_NCLKS, priv->clks);
 	}
 
+	netif_device_attach(ndev);
+
 	return ret;
 }
 
-- 
2.39.5



