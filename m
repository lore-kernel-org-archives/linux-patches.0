Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4013015DBBA;
	Mon, 14 Oct 2024 14:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917610; cv=none; b=e6Dnnwb/hRgp54YfBrQPtajdD+EgCYaTLCt/HcrcH7J91201bkfcYvdJ0sQGI2Hmmjeg+j89UqEWEJB5SMFZCaK4ZzCuZtPq4ngBtEZBdSJQN3Qa8mFWLzdhTN6ZSkPkAK55x3cbVoR2+TPReNwLQCm5c04rdH/eMcblvdJUCqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917610; c=relaxed/simple;
	bh=U9oEutQFzoigNlMnReCZrqxsTxNV3hB/GCkl0aGuhe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sbx6ETjy6/pQVzD9h9om6zlMd/ULXBLLHy9PNOEHoit1n/sPHCQeUXk0ZuUmjXF4T6rnZyQqmtCsWXzBYahi2aQs2Fc/5co/TtPfSSpEBFjAh66KEx14wgdLn4O2llmBtv6W/hLkiK3y+7rkgAtQ2nAH1qAnU+e2LB56nH+9ipg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoGPEzff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoGPEzff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53A8C4CEC3;
	Mon, 14 Oct 2024 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917610;
	bh=U9oEutQFzoigNlMnReCZrqxsTxNV3hB/GCkl0aGuhe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoGPEzffZ07dAgbuo1/uIZ2joLWQbtJVRZneVHp65VLFkhH85MXwmSXkvKq3YKict
	 EEPmbXIbAzjfaztZoUlqZwq0eDMH6rsNHA/XyNbiT6eCNHdpwZB5HpSrbdYMbkgT4B
	 ymWmugL7uGFjcNEvojtX1WpkzKBMXicaJmnByP+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/798] reset: berlin: fix OF node leak in probe() error path
Date: Mon, 14 Oct 2024 16:10:35 +0200
Message-ID: <20241014141221.116104522@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



