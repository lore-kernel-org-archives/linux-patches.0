Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9144847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE2DC4339B;
	Fri, 10 Mar 2023 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456513;
	bh=SNaxmAtCEeHxlIWT61VctlLC/rGOYT4cC5lF7HzXyqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAqhV2+3G2m6Vfppv9Pt8oAO3cHwIU/zLVfiK/MjIoZavjsM6HLSNjZdIdxxqQ94f
	 8UC+9DCa/E25kxQQT59tRFLRNAOWjMNhASlX2WZ199JUadZA90vNH4ZzBtIflSgFk7
	 m0xlz6xdI5qtRcWvPDvXoahNBEcufaZfKul7s9tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 011/211] memory: renesas-rpc-if: Move resource acquisition to .probe()
Date: Fri, 10 Mar 2023 14:36:31 +0100
Message-Id: <20230310133719.069811299@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 8b3580df15f53045fda3ffae53f74575c96aa77e ]

While the acquired resources are tied to the lifetime of the RPC-IF core
device (through the use of managed resource functions), the actual
resource acquisition is triggered from the HyperBus and SPI child
drivers.  Due to this mismatch, unbinding and rebinding the child
drivers manually fails with -EBUSY:

    # echo rpc-if-hyperflash > /sys/bus/platform/drivers/rpc-if-hyperflash/unbind
    # echo rpc-if-hyperflash > /sys/bus/platform/drivers/rpc-if-hyperflash/bind
    rpc-if ee200000.spi: can't request region for resource [mem 0xee200000-0xee2001ff]
    rpc-if-hyperflash: probe of rpc-if-hyperflash failed with error -16

The same is true for rpc-if-spi.

Fix this by moving all resource acquisition to the core driver's probe
routine.

Fixes: ca7d8b980b67 ("memory: add Renesas RPC-IF driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/c1012ef1de799e08a70817ab7313794e2d8d7bfb.1669213027.git.geert+renesas@glider.be
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 49 ++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index ded80caec1678..5be3b46cd55f1 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -277,32 +277,7 @@ static const struct regmap_config rpcif_regmap_config = {
 
 int rpcif_sw_init(struct rpcif *rpcif, struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
 	struct rpcif_priv *rpc = dev_get_drvdata(dev);
-	struct resource *res;
-
-	rpc->base = devm_platform_ioremap_resource_byname(pdev, "regs");
-	if (IS_ERR(rpc->base))
-		return PTR_ERR(rpc->base);
-
-	rpc->regmap = devm_regmap_init(&pdev->dev, NULL, rpc, &rpcif_regmap_config);
-	if (IS_ERR(rpc->regmap)) {
-		dev_err(&pdev->dev,
-			"failed to init regmap for rpcif, error %ld\n",
-			PTR_ERR(rpc->regmap));
-		return	PTR_ERR(rpc->regmap);
-	}
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirmap");
-	rpc->dirmap = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(rpc->dirmap))
-		return PTR_ERR(rpc->dirmap);
-	rpc->size = resource_size(res);
-
-	rpc->type = (uintptr_t)of_device_get_match_data(dev);
-	rpc->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
-	if (IS_ERR(rpc->rstc))
-		return PTR_ERR(rpc->rstc);
 
 	rpcif->dev = dev;
 	rpcif->dirmap = rpc->dirmap;
@@ -705,9 +680,11 @@ EXPORT_SYMBOL(rpcif_dirmap_read);
 
 static int rpcif_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct platform_device *vdev;
 	struct device_node *flash;
 	struct rpcif_priv *rpc;
+	struct resource *res;
 	const char *name;
 	int ret;
 
@@ -732,6 +709,28 @@ static int rpcif_probe(struct platform_device *pdev)
 	if (!rpc)
 		return -ENOMEM;
 
+	rpc->base = devm_platform_ioremap_resource_byname(pdev, "regs");
+	if (IS_ERR(rpc->base))
+		return PTR_ERR(rpc->base);
+
+	rpc->regmap = devm_regmap_init(dev, NULL, rpc, &rpcif_regmap_config);
+	if (IS_ERR(rpc->regmap)) {
+		dev_err(dev, "failed to init regmap for rpcif, error %ld\n",
+			PTR_ERR(rpc->regmap));
+		return	PTR_ERR(rpc->regmap);
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirmap");
+	rpc->dirmap = devm_ioremap_resource(dev, res);
+	if (IS_ERR(rpc->dirmap))
+		return PTR_ERR(rpc->dirmap);
+	rpc->size = resource_size(res);
+
+	rpc->type = (uintptr_t)of_device_get_match_data(dev);
+	rpc->rstc = devm_reset_control_get_exclusive(dev, NULL);
+	if (IS_ERR(rpc->rstc))
+		return PTR_ERR(rpc->rstc);
+
 	vdev = platform_device_alloc(name, pdev->id);
 	if (!vdev)
 		return -ENOMEM;
-- 
2.39.2



