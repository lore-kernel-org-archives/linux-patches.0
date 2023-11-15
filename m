Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CE9433BB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsTgKn9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F4DC433CB;
	Wed, 15 Nov 2023 19:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077067;
	bh=jFNAJLOIXIRWvFs3FK2WddW2EuyRgwFo6o2X91cM7o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsTgKn9irjIHA0eBz0FO9iS2rW1woZI+00YWu1DXgO8d9l+9dhuFks2FGp7rbKzl8
	 BdYFphtQj6lpz0wAwb2VUglHk74b5K2j5yRdC3kWoZgPu5HRKlYbMZaWfWsutX4op/
	 nsntK85X/2I87749pOTpfnQ33OcgZ5nL7AcdsD6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/603] PM / devfreq: rockchip-dfi: Make pmu regmap mandatory
Date: Wed, 15 Nov 2023 14:10:59 -0500
Message-ID: <20231115191621.123191105@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 1e0731c05c985deb68a97fa44c1adcd3305dda90 ]

As a matter of fact the regmap_pmu already is mandatory because
it is used unconditionally in the driver. Bail out gracefully in
probe() rather than crashing later.

Link: https://lore.kernel.org/lkml/20230704093242.583575-2-s.hauer@pengutronix.de/
Fixes: b9d1262bca0af ("PM / devfreq: event: support rockchip dfi controller")
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/event/rockchip-dfi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/devfreq/event/rockchip-dfi.c b/drivers/devfreq/event/rockchip-dfi.c
index 39ac069cabc75..74893c06aa087 100644
--- a/drivers/devfreq/event/rockchip-dfi.c
+++ b/drivers/devfreq/event/rockchip-dfi.c
@@ -193,14 +193,15 @@ static int rockchip_dfi_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(data->clk),
 				     "Cannot get the clk pclk_ddr_mon\n");
 
-	/* try to find the optional reference to the pmu syscon */
 	node = of_parse_phandle(np, "rockchip,pmu", 0);
-	if (node) {
-		data->regmap_pmu = syscon_node_to_regmap(node);
-		of_node_put(node);
-		if (IS_ERR(data->regmap_pmu))
-			return PTR_ERR(data->regmap_pmu);
-	}
+	if (!node)
+		return dev_err_probe(&pdev->dev, -ENODEV, "Can't find pmu_grf registers\n");
+
+	data->regmap_pmu = syscon_node_to_regmap(node);
+	of_node_put(node);
+	if (IS_ERR(data->regmap_pmu))
+		return PTR_ERR(data->regmap_pmu);
+
 	data->dev = dev;
 
 	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
-- 
2.42.0



