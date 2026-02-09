Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2934637AA8A;
	Mon,  9 Feb 2026 14:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648263; cv=none; b=VQwLwla9AYJB4onAdJMcFdD6nJnjWAkjR7j4ufh9+F7pUgdFAi+vdhAHTZTJXYQ9QSj7mmT/9CZAvkpvE91g+v0ZZFhvIIoBJM8b/361cYjIRACawSU+XvAFwT5Ji3K8lNtPHiC/1W5p9NYH4irnb3pHza9VUt29abtP11DnXbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648263; c=relaxed/simple;
	bh=IdS6IErqumVWjM+FjZSMU4fxRBQX4cfBUiUIVkrlmE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvFS5Ixk1hWMV32IdyAa8FLSEwrWmpn1j3e6ETvF/qwbI4FEwchcom+NZSMoNoWXP9jQeuR/TfE1CYwXLYpymkNISnWX30afE0PsMkDSUqH1zp6QKNXu+8bWlgsJrhXybN53Zl/VuEWyllrkzKbblJXvipqIw7N8lrj1tlFKbf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6uZAb8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6uZAb8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA2BC16AAE;
	Mon,  9 Feb 2026 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648263;
	bh=IdS6IErqumVWjM+FjZSMU4fxRBQX4cfBUiUIVkrlmE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6uZAb8d7ixDPYKidjiaxoxukl3yxO2RD2kbbGdl1WhhPkTmuEvmAHTGdJLb4z37W
	 Kpjud28qkRBe+T539bg0XxdqlANUCFAX2pPXYM09ksCAGTTxCPMkKfp73LsCbqswzF
	 WzlUZ3t+Z/MxsZPmE/h0kpb3YemVpP3trouGxO9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/69] ASoC: davinci-evm: Fix reference leak in davinci_evm_probe
Date: Mon,  9 Feb 2026 15:24:05 +0100
Message-ID: <20260209142303.259796799@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 68d69e32681ad..c5ff68ee3e128 100644
--- a/sound/soc/ti/davinci-evm.c
+++ b/sound/soc/ti/davinci-evm.c
@@ -404,27 +404,32 @@ static int davinci_evm_probe(struct platform_device *pdev)
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
 
@@ -434,7 +439,8 @@ static int davinci_evm_probe(struct platform_device *pdev)
 		if (!drvdata->mclk) {
 			dev_err(&pdev->dev,
 				"No clock or clock rate defined.\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_put;
 		}
 		drvdata->sysclk = clk_get_rate(drvdata->mclk);
 	} else if (drvdata->mclk) {
@@ -450,8 +456,25 @@ static int davinci_evm_probe(struct platform_device *pdev)
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



