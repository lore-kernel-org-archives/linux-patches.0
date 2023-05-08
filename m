Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C4B171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03BCC433EF;
	Mon,  8 May 2023 11:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546121;
	bh=jXVTlRAo5QAICqR3+s5jU5mN3lolD1B2OqvVMKqujVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7Ya+O68koYFchmGKVATD7vWiHg6U7W+YeDFZgyjNUeK6p+jWWk0J4cP0btlKubRL
	 hz7vN8bXosS/t9hHroyvt4KNArbPdECsCKOwLC8P6gPlCe53YQCONleD8KYw3sFeuc
	 Cyxd1a6Y5Jmeay7OZoZSVAzan7l+a8TAPprD2IQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liliang Ye <yll@hust.edu.cn>,
	Dan Carpenter <error27@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/371] ASoC: fsl_mqs: move of_node_put() to the correct location
Date: Mon,  8 May 2023 11:47:45 +0200
Message-Id: <20230508094822.535416841@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liliang Ye <yll@hust.edu.cn>

[ Upstream commit 1c34890273a020d61d6127ade3f68ed1cb21c16a ]

of_node_put() should have been done directly after
mqs_priv->regmap = syscon_node_to_regmap(gpr_np);
otherwise it creates a reference leak on the success path.

To fix this, of_node_put() is moved to the correct location, and change
all the gotos to direct returns.

Fixes: a9d273671440 ("ASoC: fsl_mqs: Fix error handling in probe")
Signed-off-by: Liliang Ye <yll@hust.edu.cn>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/20230403152647.17638-1-yll@hust.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_mqs.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/sound/soc/fsl/fsl_mqs.c b/sound/soc/fsl/fsl_mqs.c
index 0d4efbed41dab..c33439650823b 100644
--- a/sound/soc/fsl/fsl_mqs.c
+++ b/sound/soc/fsl/fsl_mqs.c
@@ -204,10 +204,10 @@ static int fsl_mqs_probe(struct platform_device *pdev)
 		}
 
 		mqs_priv->regmap = syscon_node_to_regmap(gpr_np);
+		of_node_put(gpr_np);
 		if (IS_ERR(mqs_priv->regmap)) {
 			dev_err(&pdev->dev, "failed to get gpr regmap\n");
-			ret = PTR_ERR(mqs_priv->regmap);
-			goto err_free_gpr_np;
+			return PTR_ERR(mqs_priv->regmap);
 		}
 	} else {
 		regs = devm_platform_ioremap_resource(pdev, 0);
@@ -236,8 +236,7 @@ static int fsl_mqs_probe(struct platform_device *pdev)
 	if (IS_ERR(mqs_priv->mclk)) {
 		dev_err(&pdev->dev, "failed to get the clock: %ld\n",
 			PTR_ERR(mqs_priv->mclk));
-		ret = PTR_ERR(mqs_priv->mclk);
-		goto err_free_gpr_np;
+		return PTR_ERR(mqs_priv->mclk);
 	}
 
 	dev_set_drvdata(&pdev->dev, mqs_priv);
@@ -246,13 +245,9 @@ static int fsl_mqs_probe(struct platform_device *pdev)
 	ret = devm_snd_soc_register_component(&pdev->dev, &soc_codec_fsl_mqs,
 			&fsl_mqs_dai, 1);
 	if (ret)
-		goto err_free_gpr_np;
-	return 0;
-
-err_free_gpr_np:
-	of_node_put(gpr_np);
+		return ret;
 
-	return ret;
+	return 0;
 }
 
 static int fsl_mqs_remove(struct platform_device *pdev)
-- 
2.39.2



