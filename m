Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E29F79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC87C433D7;
	Wed, 30 Nov 2022 18:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833993;
	bh=GAMxbUYk8UprgOU1nHeR2JMofdOYLIDWAHDdqqF8g2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXafsJaGf6zEM+dAWm1oAQ6Bkc8wVz0gTT8sgFm+lKZcyAbqP6ATZjpsqMYuO66yJ
	 b8C4+3nNq+V8JrTHjG4OujGMd9TQQ0K3Jt/8A4OySTbSSPWokgisWaOYtsskN8+nEk
	 ydjfbs0R17AqwDyMUO082B13SCCAD50U5Kz96mZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 090/289] net: ethernet: mtk_eth_soc: fix error handling in mtk_open()
Date: Wed, 30 Nov 2022 19:21:15 +0100
Message-Id: <20221130180546.185676725@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit f70074140524c59a0935947b06dd6cb6e1ea642d ]

If mtk_start_dma() fails, invoke phylink_disconnect_phy() to perform
cleanup. phylink_disconnect_phy() contains the put_device action. If
phylink_disconnect_phy is not performed, the Kref of netdev will leak.

Fixes: b8fc9f30821e ("net: ethernet: mediatek: Add basic PHYLINK support")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20221117111356.161547-1-liujian56@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 84433f3a3e22..a75f5931f746 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2979,8 +2979,10 @@ static int mtk_open(struct net_device *dev)
 		u32 gdm_config = MTK_GDMA_TO_PDMA;
 
 		err = mtk_start_dma(eth);
-		if (err)
+		if (err) {
+			phylink_disconnect_phy(mac->phylink);
 			return err;
+		}
 
 		if (eth->soc->offload_version && mtk_ppe_start(eth->ppe) == 0)
 			gdm_config = MTK_GDMA_TO_PPE;
-- 
2.35.1



