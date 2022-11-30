Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7F46FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE25C433C1;
	Wed, 30 Nov 2022 18:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832830;
	bh=bo47dcqfnvY8c+vhOvHvDfgNZrE5+EvDdyJ1RrYo9Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kc0zJQ3+OSifk259UuZ2otur0HDkGv8vRtP7BfWf+EhB+AMYLgnk0AEIE/2+X3mNI
	 7oUyF+GvynpfUWSU+ui+6NI65OL1WwTgVO2/MFQQxJLbv52A7QrTXz4ylSo7OPTG23
	 BhXQUhiSOc4pmVtwGAuTEIoRB3Q4jQuPyL6zbKRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/162] net: ethernet: mtk_eth_soc: fix error handling in mtk_open()
Date: Wed, 30 Nov 2022 19:22:17 +0100
Message-Id: <20221130180530.027288958@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c7aff89141e1..217dc67c48fa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2299,7 +2299,10 @@ static int mtk_open(struct net_device *dev)
 		int err = mtk_start_dma(eth);
 
 		if (err)
+		if (err) {
+			phylink_disconnect_phy(mac->phylink);
 			return err;
+		}
 
 		mtk_gdm_config(eth, MTK_GDMA_TO_PDMA);
 
-- 
2.35.1



