Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655682DE715;
	Tue,  6 Jan 2026 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720811; cv=none; b=s1JDtic8xXl9tgxNkKhmTRZBHaOjW/okckcnVo64iBd2mDPyqifkvAAZKZxW0Xi8tAyhfQOW5ACWTq3E2s+bQ2v99k5ihjdNb4BHWVJAcXAcUh6HHO6eId1GrbNkJDN2fzJBvUF/7NWhrmBaOyz0pY4BBOyf3QT62N9vT9E7On0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720811; c=relaxed/simple;
	bh=eKXm1FAw+4gAgZoXmPAW+yH5HxRQw709yZaCOsfkGPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EetSePSw4WsaNjsVgJ3VyYlzGcLrr3r/L33InE8J77kR/RnfSc6BkrbeHRU7qX+ATu0IyksBVTCtFIr93GoGDuOSMIJDPZiakRvSw+EPw94E2I00PJ/EyffUQQutMCkqKBelpwdlW2JH9HAkjvLEXZZJLtxAFYowhlctNzW3niU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wB/3eBUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wB/3eBUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE8BC116C6;
	Tue,  6 Jan 2026 17:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720811;
	bh=eKXm1FAw+4gAgZoXmPAW+yH5HxRQw709yZaCOsfkGPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wB/3eBUlv6aT4vov2XWfEQVRfoVSLT4USx62SMlMe3TUpvJsikV7Uf1Fo7qgR4Fhs
	 A2W0y6KJFnLbOfnCpmnKIb0c8YOTWyn5AYp16PjoDZqDLhhbniY5435SJiGXdKnz9u
	 w/9jX82zJtff1W8cT4LeQGHcNC6VbpcSucxWUNvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@st.com>,
	Johan Hovold <johan@kernel.org>,
	olivier moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 347/567] ASoC: stm32: sai: fix clk prepare imbalance on probe failure
Date: Tue,  6 Jan 2026 18:02:09 +0100
Message-ID: <20260106170504.164723908@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1501,14 +1501,21 @@ static int stm32_sai_sub_parse_of(struct
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
@@ -1548,26 +1555,33 @@ static int stm32_sai_sub_probe(struct pl
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


