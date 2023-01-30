Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9C428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDCFC433EF;
	Mon, 30 Jan 2023 13:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086875;
	bh=GSaVE25xUQxnhmh0Vmf3vqnnHjhzaNd0+Gja8dLro8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pciO9i2IZYxzD18aunk9W/HDNNe+xzXPs6oOexpQsDRA5Kl2jC+r3iZffwz7Ncbse
	 b38zvBA7KAOZXvLJujfnE2GY144KttgtBTuhDvqg5xIVZEcKQXvI+2HiuwT/CrBBVU
	 yOnGmnPV/fsU/XT3kL85+vMpqFVKMws0I/AD3Zi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Tang <tanghui20@huawei.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/313] reset: uniphier-glue: Fix possible null-ptr-deref
Date: Mon, 30 Jan 2023 14:47:40 +0100
Message-Id: <20230130134337.824581730@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 3a2390c6777e3f6662980c6cfc25cafe9e4fef98 ]

It will cause null-ptr-deref when resource_size(res) invoked,
if platform_get_resource() returns NULL.

Fixes: 499fef09a323 ("reset: uniphier: add USB3 core reset control")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20221114004958.258513-1-tanghui20@huawei.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-uniphier-glue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/reset/reset-uniphier-glue.c b/drivers/reset/reset-uniphier-glue.c
index 146fd5d45e99..15abac9fc72c 100644
--- a/drivers/reset/reset-uniphier-glue.c
+++ b/drivers/reset/reset-uniphier-glue.c
@@ -47,7 +47,6 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct uniphier_glue_reset_priv *priv;
 	struct resource *res;
-	resource_size_t size;
 	int i, ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -60,7 +59,6 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	size = resource_size(res);
 	priv->rdata.membase = devm_ioremap_resource(dev, res);
 	if (IS_ERR(priv->rdata.membase))
 		return PTR_ERR(priv->rdata.membase);
@@ -96,7 +94,7 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 
 	spin_lock_init(&priv->rdata.lock);
 	priv->rdata.rcdev.owner = THIS_MODULE;
-	priv->rdata.rcdev.nr_resets = size * BITS_PER_BYTE;
+	priv->rdata.rcdev.nr_resets = resource_size(res) * BITS_PER_BYTE;
 	priv->rdata.rcdev.ops = &reset_simple_ops;
 	priv->rdata.rcdev.of_node = dev->of_node;
 	priv->rdata.active_low = true;
-- 
2.39.0



