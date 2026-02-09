Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E5137997A;
	Mon,  9 Feb 2026 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648653; cv=none; b=rzjQOddLds8V1LWXXAW1EYWdqJ8apaMNwFol/SaibkDHESffIrGareJRW31ffG7Vt3hfzgBSolZ94Jl9FUMmj9WY2Tzp/J9E9S+tGzmeXgny3j7x+3Lagi/JSmea7l2zXwLEYfbCVQzpBQNmRtTuPEip3Wp2pB+cRsv2UvR5vI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648653; c=relaxed/simple;
	bh=D2sm5IgZz1urJF4QCNjrzruT1/Ip1snjrFU7q3Qy4JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL33NNKBqX5+O4B7nITJ9D8hRnZzfGoy033k/GZz+pwNhY9Z98flT5NXJ2OQu9UC00o6YApyoQTTVfwm5cTZSm8YdNLMr7DmDQE2lE+OptKmcettFvo+Dw2I4Jx3NXyrHf3JkLcmOPp6lygO2TMUfN++wyOQL+8u/Ak6mwJ0CqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcAcmopV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcAcmopV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4DFC116C6;
	Mon,  9 Feb 2026 14:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648653;
	bh=D2sm5IgZz1urJF4QCNjrzruT1/Ip1snjrFU7q3Qy4JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcAcmopVwhvcglf1LXqSMkc4A1JAFw1hidn1MJVtTAqUKhWjHz6/4AH/k9w8+GSlM
	 V3HJ5bQBP9pIx8yQ/EZcm7bVQjPw/exariCXCK2fxPWQEyKyRH75GtniUxch2Fpczt
	 PAHFX9yLHVBTSv7tg11RFJkm70zrPAVl2BWRJ9H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/41] ASoC: davinci-evm: Fix reference leak in davinci_evm_probe
Date: Mon,  9 Feb 2026 15:24:38 +0100
Message-ID: <20260209142257.430632327@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit 5b577d214fcc109707bcb77b4ae72a31cfd86798 ]

The davinci_evm_probe() function calls of_parse_phandle() to acquire
device nodes for "ti,audio-codec" and "ti,mcasp-controller". These
functions return device nodes with incremented reference counts.

However, in several error paths (e.g., when the second of_parse_phandle(),
snd_soc_of_parse_card_name(), or devm_snd_soc_register_card() fails),
the function returns directly without releasing the acquired nodes,
leading to reference leaks.

This patch adds an error handling path 'err_put' to properly release
the device nodes using of_node_put() and clean up the pointers when
an error occurs.

Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Link: https://patch.msgid.link/20260107154836.1521-2-qikeyu2017@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-evm.c | 39 ++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/sound/soc/ti/davinci-evm.c b/sound/soc/ti/davinci-evm.c
index 105e56ab9cdc2..745c79cf739df 100644
--- a/sound/soc/ti/davinci-evm.c
+++ b/sound/soc/ti/davinci-evm.c
@@ -405,27 +405,32 @@ static int davinci_evm_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	dai->cpus->of_node = of_parse_phandle(np, "ti,mcasp-controller", 0);
-	if (!dai->cpus->of_node)
-		return -EINVAL;
+	if (!dai->cpus->of_node) {
+		ret = -EINVAL;
+		goto err_put;
+	}
 
 	dai->platforms->of_node = dai->cpus->of_node;
 
 	evm_soc_card.dev = &pdev->dev;
 	ret = snd_soc_of_parse_card_name(&evm_soc_card, "ti,model");
 	if (ret)
-		return ret;
+		goto err_put;
 
 	mclk = devm_clk_get(&pdev->dev, "mclk");
 	if (PTR_ERR(mclk) == -EPROBE_DEFER) {
-		return -EPROBE_DEFER;
+		ret = -EPROBE_DEFER;
+		goto err_put;
 	} else if (IS_ERR(mclk)) {
 		dev_dbg(&pdev->dev, "mclk not found.\n");
 		mclk = NULL;
 	}
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
+	if (!drvdata) {
+		ret = -ENOMEM;
+		goto err_put;
+	}
 
 	drvdata->mclk = mclk;
 
@@ -435,7 +440,8 @@ static int davinci_evm_probe(struct platform_device *pdev)
 		if (!drvdata->mclk) {
 			dev_err(&pdev->dev,
 				"No clock or clock rate defined.\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_put;
 		}
 		drvdata->sysclk = clk_get_rate(drvdata->mclk);
 	} else if (drvdata->mclk) {
@@ -451,8 +457,25 @@ static int davinci_evm_probe(struct platform_device *pdev)
 	snd_soc_card_set_drvdata(&evm_soc_card, drvdata);
 	ret = devm_snd_soc_register_card(&pdev->dev, &evm_soc_card);
 
-	if (ret)
+	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
+		goto err_put;
+	}
+
+	return ret;
+
+err_put:
+	dai->platforms->of_node = NULL;
+
+	if (dai->cpus->of_node) {
+		of_node_put(dai->cpus->of_node);
+		dai->cpus->of_node = NULL;
+	}
+
+	if (dai->codecs->of_node) {
+		of_node_put(dai->codecs->of_node);
+		dai->codecs->of_node = NULL;
+	}
 
 	return ret;
 }
-- 
2.51.0



