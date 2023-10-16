Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6721014288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLPO43h6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F30C433C8;
	Mon, 16 Oct 2023 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467768;
	bh=Wh3pWddlT0FmclkhncG3sVb1JVRQBSBeNo/i5DuVHl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLPO43h6gNFPmGy6j0qsZ0w1Pzbc8Lpys6yoU2/YOP2ln48HPS0xWrJljL97T8biD
	 dgbHrKXmsrQ8uL7/G0TWXo7qTtpflI8LbS3RJRo0W45FRdIp6iefIIca+0LYxMHP9A
	 wxgl4BTTXOQf0bjbT9PL+OZUsojraCHvcIrFkyiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 062/191] ieee802154: ca8210: Fix a potential UAF in ca8210_probe
Date: Mon, 16 Oct 2023 10:40:47 +0200
Message-ID: <20231016084016.848312790@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit f990874b1c98fe8e57ee9385669f501822979258 ]

If of_clk_add_provider() fails in ca8210_register_ext_clock(),
it calls clk_unregister() to release priv->clk and returns an
error. However, the caller ca8210_probe() then calls ca8210_remove(),
where priv->clk is freed again in ca8210_unregister_ext_clock(). In
this case, a use-after-free may happen in the second time we call
clk_unregister().

Fix this by removing the first clk_unregister(). Also, priv->clk could
be an error code on failure of clk_register_fixed_rate(). Use
IS_ERR_OR_NULL to catch this case in ca8210_unregister_ext_clock().

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Message-ID: <20231007033049.22353-1-dinghao.liu@zju.edu.cn>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index f9b10e84de067..9cb99dc65db34 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2741,7 +2741,6 @@ static int ca8210_register_ext_clock(struct spi_device *spi)
 	struct device_node *np = spi->dev.of_node;
 	struct ca8210_priv *priv = spi_get_drvdata(spi);
 	struct ca8210_platform_data *pdata = spi->dev.platform_data;
-	int ret = 0;
 
 	if (!np)
 		return -EFAULT;
@@ -2758,18 +2757,8 @@ static int ca8210_register_ext_clock(struct spi_device *spi)
 		dev_crit(&spi->dev, "Failed to register external clk\n");
 		return PTR_ERR(priv->clk);
 	}
-	ret = of_clk_add_provider(np, of_clk_src_simple_get, priv->clk);
-	if (ret) {
-		clk_unregister(priv->clk);
-		dev_crit(
-			&spi->dev,
-			"Failed to register external clock as clock provider\n"
-		);
-	} else {
-		dev_info(&spi->dev, "External clock set as clock provider\n");
-	}
 
-	return ret;
+	return of_clk_add_provider(np, of_clk_src_simple_get, priv->clk);
 }
 
 /**
@@ -2781,8 +2770,8 @@ static void ca8210_unregister_ext_clock(struct spi_device *spi)
 {
 	struct ca8210_priv *priv = spi_get_drvdata(spi);
 
-	if (!priv->clk)
-		return
+	if (IS_ERR_OR_NULL(priv->clk))
+		return;
 
 	of_clk_del_provider(spi->dev.of_node);
 	clk_unregister(priv->clk);
-- 
2.40.1



