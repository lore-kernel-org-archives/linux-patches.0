Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB37D3AC2B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72734C433C7;
	Wed, 20 Sep 2023 12:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213102;
	bh=G641JYNYRh/p5YrXbzFB4K+Yv/tTlvGLzwSIlFPGCRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmrDGenEP3KHgnuhedVyMKz0T0EwVK1YpRLnzwEOhpp+5aINRvV35zKJA9SWygAxB
	 1LaulFATmBHIl7bGIuV2LNd3zB++O3MNwkB7zHYRlZc6jLD4ynk7tl39sj6qccAz+7
	 WXLx3CuBlZfgnJ5xOpYHm0HSKNnMt4APrJ8S5EiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang7@gmail.com>,
	Chunyan Zhang <chunyan.zhang@unisoc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/367] serial: sprd: getting port index via serial aliases only
Date: Wed, 20 Sep 2023 13:28:59 +0200
Message-ID: <20230920112902.842181970@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 4b7349cb4e26e79429ecd619eb588bf384f69fdb ]

This patch simplifies the process of getting serial port number, with
this patch, serial devices must have aliases configured in devicetree.

The serial port searched out via sprd_port array maybe wrong if we don't
have serial alias defined in devicetree, and specify console with command
line, we would get the wrong port number if other serial ports probe
failed before console's. So using aliases is mandatory.

Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lore.kernel.org/r/20200318105049.19623-2-zhang.lyra@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f9608f188756 ("serial: sprd: Assign sprd_port after initialized to avoid wrong access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sprd_serial.c | 36 +++++---------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 07573de70445c..e6acf2c848f39 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1073,29 +1073,6 @@ static struct uart_driver sprd_uart_driver = {
 	.cons = SPRD_CONSOLE,
 };
 
-static int sprd_probe_dt_alias(int index, struct device *dev)
-{
-	struct device_node *np;
-	int ret = index;
-
-	if (!IS_ENABLED(CONFIG_OF))
-		return ret;
-
-	np = dev->of_node;
-	if (!np)
-		return ret;
-
-	ret = of_alias_get_id(np, "serial");
-	if (ret < 0)
-		ret = index;
-	else if (ret >= ARRAY_SIZE(sprd_port) || sprd_port[ret] != NULL) {
-		dev_warn(dev, "requested serial port %d not available.\n", ret);
-		ret = index;
-	}
-
-	return ret;
-}
-
 static int sprd_remove(struct platform_device *dev)
 {
 	struct sprd_uart_port *sup = platform_get_drvdata(dev);
@@ -1173,14 +1150,11 @@ static int sprd_probe(struct platform_device *pdev)
 	int index;
 	int ret;
 
-	for (index = 0; index < ARRAY_SIZE(sprd_port); index++)
-		if (sprd_port[index] == NULL)
-			break;
-
-	if (index == ARRAY_SIZE(sprd_port))
-		return -EBUSY;
-
-	index = sprd_probe_dt_alias(index, &pdev->dev);
+	index = of_alias_get_id(pdev->dev.of_node, "serial");
+	if (index < 0 || index >= ARRAY_SIZE(sprd_port)) {
+		dev_err(&pdev->dev, "got a wrong serial alias id %d\n", index);
+		return -EINVAL;
+	}
 
 	sprd_port[index] = devm_kzalloc(&pdev->dev, sizeof(*sprd_port[index]),
 					GFP_KERNEL);
-- 
2.40.1



