Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7260C154B4
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7216C433C7;
	Wed,  9 Aug 2023 10:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577847;
	bh=kMJWxdHBwpyw+US6+myc/dzgv1dHdORVS5tybQFM+z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JidJgcbakwlppwA5at5QPhoEoebM3+9WorAQGTxKM82fenyVLWzc32hRQJSYGEi5e
	 eQAXYyuJKuOoC/ID+NsQKkz8dfCRQPD7Hvqu5x5a4gF6QZsghFCBGGiSJoQKVSnoNl
	 DtOWqQtL7G2gBG14d7hoW5HnqrckrCobG4kNlVWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yannic Moog <Y.Moog@phytec.de>,
	Lucas Stach <l.stach@pengutronix.de>,
	Yannic Moog <y.moog@phytec.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 016/165] soc: imx: imx8mp-blk-ctrl: register HSIO PLL clock as bus_power_dev child
Date: Wed,  9 Aug 2023 12:39:07 +0200
Message-ID: <20230809103643.310945129@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 53cab4d871690c49fac87c657cbf459e39c5b93b ]

The blk-ctrl device is deliberately placed outside of the GPC power
domain as it needs to control the power sequencing of the blk-ctrl
domains together with the GPC domains.

Clock runtime PM works by operating on the clock parent device, which
doesn't translate into the neccessary GPC power domain action if the
clk parent is not part of the GPC power domain. Use the bus_power_device
as the parent for the clock to trigger the proper GPC domain actions on
clock runtime power management.

Fixes: 2cbee26e5d59 ("soc: imx: imx8mp-blk-ctrl: expose high performance PLL clock")
Reported-by: Yannic Moog <Y.Moog@phytec.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Yannic Moog <y.moog@phytec.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8mp-blk-ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/imx/imx8mp-blk-ctrl.c b/drivers/soc/imx/imx8mp-blk-ctrl.c
index 870aecc0202ae..1c1fcab4979a4 100644
--- a/drivers/soc/imx/imx8mp-blk-ctrl.c
+++ b/drivers/soc/imx/imx8mp-blk-ctrl.c
@@ -164,7 +164,7 @@ static int imx8mp_hsio_blk_ctrl_probe(struct imx8mp_blk_ctrl *bc)
 	clk_hsio_pll->hw.init = &init;
 
 	hw = &clk_hsio_pll->hw;
-	ret = devm_clk_hw_register(bc->dev, hw);
+	ret = devm_clk_hw_register(bc->bus_power_dev, hw);
 	if (ret)
 		return ret;
 
-- 
2.40.1



