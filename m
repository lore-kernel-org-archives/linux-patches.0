Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B3D33A010;
	Tue,  6 Jan 2026 17:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721968; cv=none; b=KHYT+wMZODqFNH6hC/xo6jHBQCOvD2pFq2hrNYJa5C2xYyu9ecYe0AbvZqrqIoenKIBfDsasLK1aBVjWe+10YCXCMKDe/HZG6s9qlRG/CKUrj7XR/q287o0AtOgYzNqM1/RRP+3vufTiNPqeglouDy3OecGuV6ZPWVHg6SzlCbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721968; c=relaxed/simple;
	bh=ALBhjqwqDlqDTvQUlK1iOs5oWIbKaNQD/epe4TNzeio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChnsXH3B/w35z+AyYhgdJi3Wf+BbcronwIO/LzQf5xISYRhKCiAMLO6K5WUXXylU0+/2ho3bsA7Kc/he+wYVnCJ2k85fW92uPhbKWs7m3aO2H0VGQnkhwS3W12qMQwFZf/qFEH+JXGVK3lwE5IMzr8CUFHJglxBH3cCpJxRL350=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q8LZ084; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q8LZ084"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE224C116C6;
	Tue,  6 Jan 2026 17:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721968;
	bh=ALBhjqwqDlqDTvQUlK1iOs5oWIbKaNQD/epe4TNzeio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q8LZ084x5a9hqUCtRQE0c0B7YYBUy9TIAzeT8wtTaFWq+6ld62+GONXTYHo63mbs
	 AW1oSIWF5/Nkl292OlNFJ51Zr6Z0LDWwfzBjJkoUh1nJ2stT1E1K2Uh2ZYggk1KuiJ
	 1FuBXyf6fQ66tcy+I29ds+QaVOW7fwVvn4vPxEyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@st.com>,
	Johan Hovold <johan@kernel.org>,
	olivier moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 093/312] ASoC: stm32: sai: fix clk prepare imbalance on probe failure
Date: Tue,  6 Jan 2026 18:02:47 +0100
Message-ID: <20260106170551.198912464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 312ec2f0d9d1a5656f76d770bbf1d967e9289aa7 upstream.

Make sure to unprepare the parent clock also on probe failures (e.g.
probe deferral).

Fixes: a14bf98c045b ("ASoC: stm32: sai: fix possible circular locking")
Cc: stable@vger.kernel.org	# 5.5
Cc: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: olivier moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20251124104908.15754-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/stm/stm32_sai_sub.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -1634,14 +1634,21 @@ static int stm32_sai_sub_parse_of(struct
 	if (of_property_present(np, "#clock-cells")) {
 		ret = stm32_sai_add_mclk_provider(sai);
 		if (ret < 0)
-			return ret;
+			goto err_unprepare_pclk;
 	} else {
 		sai->sai_mclk = devm_clk_get_optional(&pdev->dev, "MCLK");
-		if (IS_ERR(sai->sai_mclk))
-			return PTR_ERR(sai->sai_mclk);
+		if (IS_ERR(sai->sai_mclk)) {
+			ret = PTR_ERR(sai->sai_mclk);
+			goto err_unprepare_pclk;
+		}
 	}
 
 	return 0;
+
+err_unprepare_pclk:
+	clk_unprepare(sai->pdata->pclk);
+
+	return ret;
 }
 
 static int stm32_sai_sub_probe(struct platform_device *pdev)
@@ -1688,26 +1695,33 @@ static int stm32_sai_sub_probe(struct pl
 			       IRQF_SHARED, dev_name(&pdev->dev), sai);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ request returned %d\n", ret);
-		return ret;
+		goto err_unprepare_pclk;
 	}
 
 	if (STM_SAI_PROTOCOL_IS_SPDIF(sai))
 		conf = &stm32_sai_pcm_config_spdif;
 
 	ret = snd_dmaengine_pcm_register(&pdev->dev, conf, 0);
-	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "Could not register pcm dma\n");
+	if (ret) {
+		ret = dev_err_probe(&pdev->dev, ret, "Could not register pcm dma\n");
+		goto err_unprepare_pclk;
+	}
 
 	ret = snd_soc_register_component(&pdev->dev, &stm32_component,
 					 &sai->cpu_dai_drv, 1);
 	if (ret) {
 		snd_dmaengine_pcm_unregister(&pdev->dev);
-		return ret;
+		goto err_unprepare_pclk;
 	}
 
 	pm_runtime_enable(&pdev->dev);
 
 	return 0;
+
+err_unprepare_pclk:
+	clk_unprepare(sai->pdata->pclk);
+
+	return ret;
 }
 
 static void stm32_sai_sub_remove(struct platform_device *pdev)


