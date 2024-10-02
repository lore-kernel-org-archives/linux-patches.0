Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168EA1D1728;
	Wed,  2 Oct 2024 14:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879399; cv=none; b=mvDNXqlTFiHp7t02oqujTZcLeqfilIFAN0iEQiMBV+Frsj/2Kzu8GSI09GTh0peULMbaIGUQQ4AlMHRuPwsL/ULYqhi7unBvip0KhhARqDbfZ70El+dkKbp4e/YLHBGA6cQ94wJ5qMDgy+WNbTN4euo5yYfz8ucL/HHPwCLeswU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879399; c=relaxed/simple;
	bh=22A1/eSEux1RnkD/t4lr+wZ7YqWSGy4eYfjX1gaS7xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raqAs6rN7EgvNUh20RMWMfGmJ7cR0DUFwU1G68nfGwSSWXmuKg+0Xu6yGv9wkrLfqUWQW074hvJQM/Vl8xC0sPXeVWL7V9LIsCizjbAoRUej3UxC1h9ILhs+nJ6bCDaMQ2uyOAMxTQ6txj5u85gw71TarTbjYmh0Zxq52r4GxQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK0a0+wZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK0a0+wZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944FBC4CEC2;
	Wed,  2 Oct 2024 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879399;
	bh=22A1/eSEux1RnkD/t4lr+wZ7YqWSGy4eYfjX1gaS7xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK0a0+wZ9IxsME9dEfPe5m7LpgQVFJkt0uXcSWOrHHbOgJdq4k+F0SxabuyXr3yRY
	 4OY1GVeJm1sTItyMxXprmt6G3w82MSPXR62vWPDxMZw+NCtOTIjG6zAYxl4eEEjmml
	 HFR0Y3nEGgoz7sbtSbqiUsBn6eNY3OlS+Fapkcq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/538] reset: berlin: fix OF node leak in probe() error path
Date: Wed,  2 Oct 2024 14:55:45 +0200
Message-ID: <20241002125756.416355755@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 5f58a88cc91075be38cec69b7cb70aaa4ba69e8b ]

Driver is leaking OF node reference on memory allocation failure.
Acquire the OF node reference after memory allocation to fix this and
keep it simple.

Fixes: aed6f3cadc86 ("reset: berlin: convert to a platform driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240825-reset-cleanup-scoped-v1-1-03f6d834f8c0@linaro.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-berlin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/reset-berlin.c b/drivers/reset/reset-berlin.c
index 2537ec05eceef..578fe867080ce 100644
--- a/drivers/reset/reset-berlin.c
+++ b/drivers/reset/reset-berlin.c
@@ -68,13 +68,14 @@ static int berlin_reset_xlate(struct reset_controller_dev *rcdev,
 
 static int berlin2_reset_probe(struct platform_device *pdev)
 {
-	struct device_node *parent_np = of_get_parent(pdev->dev.of_node);
+	struct device_node *parent_np;
 	struct berlin_reset_priv *priv;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	parent_np = of_get_parent(pdev->dev.of_node);
 	priv->regmap = syscon_node_to_regmap(parent_np);
 	of_node_put(parent_np);
 	if (IS_ERR(priv->regmap))
-- 
2.43.0



