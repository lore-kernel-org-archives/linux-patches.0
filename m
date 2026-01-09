Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BD72EAD10;
	Fri,  9 Jan 2026 12:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960839; cv=none; b=SA8g3EYEGDneUptkyl7ilFqdrGd0znVwhJA2fdEcZKm5dnuQ/5YvyX4YQ6k+6GS7ZOLY46WBnN1u/i160O/LoAu43IfecWM+VFEWPPAyZ7mqG432IuBXKDeKuxyKr3tKpO91QrmgG/2150pUjc+nxBKPJ2xzYCMXKB+6+42Na84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960839; c=relaxed/simple;
	bh=dyY8vaxmKc0NC5vVCucTc58QwsHkY5Wl0+a0BwTNYI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzWRUss3Iq2Ekc2Ll3p2m6936OrHL7Xf25NDb4uMBvG/BJiLd5NFaSNaurH4dyjMs9pCvXkQIZj1TGPXaTWpFiSCjIVdBcRhHOIS85Cy4jcGKYKf6XaFmrwhFY0UjcIfclEtM6DjTmkCv84JG/+MOR1eMp5SIkZBiAFqP524/cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oi6tdP0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi6tdP0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8EFC4CEF1;
	Fri,  9 Jan 2026 12:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960839;
	bh=dyY8vaxmKc0NC5vVCucTc58QwsHkY5Wl0+a0BwTNYI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oi6tdP0OXwlVOwHxNqmx7KejchRvnPaIeCwE5Qe7UvOcmYBo7nfqtDWpwO93kGk4B
	 yiYOZTmivJFq6uoREcStAE1zHEWWOVqtBOmfvRXXyqYH/cq69+HQ0mASTDnZkZKi9f
	 iMYzVif7iVoM/E4vQTpoJgcFrBLwwyfnV029SdRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@st.com>,
	Johan Hovold <johan@kernel.org>,
	olivier moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 544/737] ASoC: stm32: sai: fix OF node leak on probe
Date: Fri,  9 Jan 2026 12:41:23 +0100
Message-ID: <20260109112154.459086658@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 23261f0de09427367e99f39f588e31e2856a690e upstream.

The reference taken to the sync provider OF node when probing the
platform device is currently only dropped if the set_sync() callback
fails during DAI probe.

Make sure to drop the reference on platform probe failures (e.g. probe
deferral) and on driver unbind.

This also avoids a potential use-after-free in case the DAI is ever
reprobed without first rebinding the platform driver.

Fixes: 5914d285f6b7 ("ASoC: stm32: sai: Add synchronization support")
Fixes: d4180b4c02e7 ("ASoC: stm32: sai: fix set_sync service")
Cc: Olivier Moysan <olivier.moysan@st.com>
Cc: stable@vger.kernel.org      # 4.16: d4180b4c02e7
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: olivier moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20251124104908.15754-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/stm/stm32_sai.c     |   12 +++---------
 sound/soc/stm/stm32_sai_sub.c |   23 ++++++++++++++++-------
 2 files changed, 19 insertions(+), 16 deletions(-)

--- a/sound/soc/stm/stm32_sai.c
+++ b/sound/soc/stm/stm32_sai.c
@@ -122,7 +122,6 @@ static int stm32_sai_set_sync(struct stm
 	if (!pdev) {
 		dev_err(&sai_client->pdev->dev,
 			"Device not found for node %pOFn\n", np_provider);
-		of_node_put(np_provider);
 		return -ENODEV;
 	}
 
@@ -131,21 +130,16 @@ static int stm32_sai_set_sync(struct stm
 	if (!sai_provider) {
 		dev_err(&sai_client->pdev->dev,
 			"SAI sync provider data not found\n");
-		ret = -EINVAL;
-		goto error;
+		return -EINVAL;
 	}
 
 	/* Configure sync client */
 	ret = stm32_sai_sync_conf_client(sai_client, synci);
 	if (ret < 0)
-		goto error;
+		return ret;
 
 	/* Configure sync provider */
-	ret = stm32_sai_sync_conf_provider(sai_provider, synco);
-
-error:
-	of_node_put(np_provider);
-	return ret;
+	return stm32_sai_sync_conf_provider(sai_provider, synco);
 }
 
 static int stm32_sai_probe(struct platform_device *pdev)
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -1453,7 +1453,8 @@ static int stm32_sai_sub_parse_of(struct
 				dev_err(&pdev->dev,
 					"External synchro not supported\n");
 				of_node_put(args.np);
-				return -EINVAL;
+				ret = -EINVAL;
+				goto err_put_sync_provider;
 			}
 			sai->sync = SAI_SYNC_EXTERNAL;
 
@@ -1462,7 +1463,8 @@ static int stm32_sai_sub_parse_of(struct
 			    (sai->synci > (SAI_GCR_SYNCIN_MAX + 1))) {
 				dev_err(&pdev->dev, "Wrong SAI index\n");
 				of_node_put(args.np);
-				return -EINVAL;
+				ret = -EINVAL;
+				goto err_put_sync_provider;
 			}
 
 			if (of_property_match_string(args.np, "compatible",
@@ -1476,7 +1478,8 @@ static int stm32_sai_sub_parse_of(struct
 			if (!sai->synco) {
 				dev_err(&pdev->dev, "Unknown SAI sub-block\n");
 				of_node_put(args.np);
-				return -EINVAL;
+				ret = -EINVAL;
+				goto err_put_sync_provider;
 			}
 		}
 
@@ -1486,13 +1489,15 @@ static int stm32_sai_sub_parse_of(struct
 
 	of_node_put(args.np);
 	sai->sai_ck = devm_clk_get(&pdev->dev, "sai_ck");
-	if (IS_ERR(sai->sai_ck))
-		return dev_err_probe(&pdev->dev, PTR_ERR(sai->sai_ck),
-				     "Missing kernel clock sai_ck\n");
+	if (IS_ERR(sai->sai_ck)) {
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(sai->sai_ck),
+				    "Missing kernel clock sai_ck\n");
+		goto err_put_sync_provider;
+	}
 
 	ret = clk_prepare(sai->pdata->pclk);
 	if (ret < 0)
-		return ret;
+		goto err_put_sync_provider;
 
 	if (STM_SAI_IS_F4(sai->pdata))
 		return 0;
@@ -1514,6 +1519,8 @@ static int stm32_sai_sub_parse_of(struct
 
 err_unprepare_pclk:
 	clk_unprepare(sai->pdata->pclk);
+err_put_sync_provider:
+	of_node_put(sai->np_sync_provider);
 
 	return ret;
 }
@@ -1584,6 +1591,7 @@ static int stm32_sai_sub_probe(struct pl
 
 err_unprepare_pclk:
 	clk_unprepare(sai->pdata->pclk);
+	of_node_put(sai->np_sync_provider);
 
 	return ret;
 }
@@ -1596,6 +1604,7 @@ static void stm32_sai_sub_remove(struct
 	snd_dmaengine_pcm_unregister(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	of_node_put(sai->np_sync_provider);
 }
 
 #ifdef CONFIG_PM_SLEEP


