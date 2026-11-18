Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055740;
	b=Cl5nWNySYO881jCrVt29wn0eFwC2QVAqfA6BdpFj/ByRPzvJVJNYcDMeZHDiRX6oxkmo
	 gdfjLep7rXj5SrMVJNiuYi9Xrh+IjR0hXTk2hHCWWf01zXwQGEfCq2FaeFrfSQhzAxuUE
	 zrU/vQs/z2fUfOTPcoEOWY5YcljpMpctqdnJOIc1y6d1bAIzYKEHrF9NuOAilTBv4KuUo
	 jEeveI1wFJn6IF39/8FY9k5oddXApvQknfU5H4dUSjMcvnntYOODgy9O+kfBE7LGb9aRf
	 O8XNVph+6E8sx7vaUcMbKT9xxBDL7tX6tA6KCDP9qYFurUBlCJ6YtNJgjNca3JU05cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z8kC30uc+HikOFgyf2NgHdH29vBXF0XCpxIv/Rs55sI=;
	b=qA0FQGcefKzBXv8xzzmVjUVxOcWOkTTYBQy+l5/yX1nuG12DERqMWTiPwY2xmyi9eGfP
	 36eftb0ZMRTkEX7WFlYzcyPo6XolpvkjzXD/3XC3U8ACHrxuplHieSB0emL+XHn5ig8Bj
	 SoBLyzZaZqPv5iG1hzOfob8CW7O8WuiC31wXCkHexGTeFSDfMCadv6Wbpvns8kH1svg17
	 yx2YM2FSgQl5qOL9NTSmDz1vxZX5lGnGDxy+yOznXwf0v1zeBfSZkJnaOd1sSXT66kW2O
	 wnin5e27e0bv7B/24sy7GJoHT1+BWRYe+ul33q8Agr6p2XzhHfhcaevjt2bpXi1qluA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BEepdHpU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7A7606A320;
	Thu, 19 Nov 2026 02:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BEepdHpU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7504C1F000C4;
	Thu, 19 Nov 2026 02:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055740;
	bh=Z8kC30uc+HikOFgyf2NgHdH29vBXF0XCpxIv/Rs55sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEepdHpUpAigaJRHRnxLlB+f5Zq5xf0LlBFWkaWdoiw5dap+3lyJIIcC5NZhtokDB
	 C2m9SIrlr8Xeib85QeNALgU08Lr4EDHsNeucYycflZk8ACssmtO6dwpT7iIFRK6IIy
	 YEwi/EpFxYjwYf/Y8dL73VHwwqWSgbTl3L6dWRA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1740/2214] ASoC: mt6359-accdet: manage private workqueues with devres
Date: Wed, 18 Nov 2026 15:56:56 +0100
Message-ID: <20261118150121.255691980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 9a773d9d21fa909e8babbe11e93c811cf1a6d22d ]

The threaded jack-detect interrupts queue work on two private
workqueues. Neither queue is destroyed on device removal, so queued
callbacks can retain pointers to devm-allocated state after it is
released. Probe error paths also leak the queues.

Create and initialize both workqueues before requesting interrupts, then
add a managed cleanup action. Since the managed IRQs are acquired
afterwards, devres releases and synchronizes them before draining and
destroying the workqueues on both removal and probe failure.

Fixes: eef07b9e0925 ("ASoC: mediatek: mt6359: add MT6359 accdet jack driver")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134054.312-1-getshell@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6359-accdet.c | 50 ++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/sound/soc/codecs/mt6359-accdet.c b/sound/soc/codecs/mt6359-accdet.c
index 7f624854948c7..e7dc20ac67024 100644
--- a/sound/soc/codecs/mt6359-accdet.c
+++ b/sound/soc/codecs/mt6359-accdet.c
@@ -923,6 +923,14 @@ int mt6359_accdet_enable_jack_detect(struct snd_soc_component *component,
 }
 EXPORT_SYMBOL_GPL(mt6359_accdet_enable_jack_detect);
 
+static void mt6359_accdet_destroy_workqueues(void *data)
+{
+	struct mt6359_accdet *priv = data;
+
+	destroy_workqueue(priv->jd_workqueue);
+	destroy_workqueue(priv->accdet_workqueue);
+}
+
 static int mt6359_accdet_probe(struct platform_device *pdev)
 {
 	struct mt6359_accdet *priv;
@@ -964,6 +972,26 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
 	}
 	mutex_init(&priv->res_lock);
 
+	priv->accdet_workqueue = create_singlethread_workqueue("accdet");
+	INIT_WORK(&priv->accdet_work, mt6359_accdet_work);
+	if (!priv->accdet_workqueue) {
+		dev_err(&pdev->dev, "Failed to create accdet workqueue\n");
+		return -ENOMEM;
+	}
+
+	priv->jd_workqueue = create_singlethread_workqueue("mt6359_accdet_jd");
+	INIT_WORK(&priv->jd_work, mt6359_accdet_jd_work);
+	if (!priv->jd_workqueue) {
+		dev_err(&pdev->dev, "Failed to create jack detect workqueue\n");
+		destroy_workqueue(priv->accdet_workqueue);
+		return -ENOMEM;
+	}
+
+	ret = devm_add_action_or_reset(&pdev->dev,
+				       mt6359_accdet_destroy_workqueues, priv);
+	if (ret)
+		return ret;
+
 	priv->accdet_irq = platform_get_irq(pdev, 0);
 	if (priv->accdet_irq >= 0) {
 		ret = devm_request_threaded_irq(&pdev->dev, priv->accdet_irq,
@@ -1009,22 +1037,6 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
 		}
 	}
 
-	priv->accdet_workqueue = create_singlethread_workqueue("accdet");
-	INIT_WORK(&priv->accdet_work, mt6359_accdet_work);
-	if (!priv->accdet_workqueue) {
-		dev_err(&pdev->dev, "Failed to create accdet workqueue\n");
-		ret = -1;
-		goto err_accdet_wq;
-	}
-
-	priv->jd_workqueue = create_singlethread_workqueue("mt6359_accdet_jd");
-	INIT_WORK(&priv->jd_work, mt6359_accdet_jd_work);
-	if (!priv->jd_workqueue) {
-		dev_err(&pdev->dev, "Failed to create jack detect workqueue\n");
-		ret = -1;
-		goto err_eint_wq;
-	}
-
 	platform_set_drvdata(pdev, priv);
 	ret = devm_snd_soc_register_component(&pdev->dev,
 					      &mt6359_accdet_soc_driver,
@@ -1043,12 +1055,6 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
 	mt6359_accdet_jack_report(priv);
 
 	return 0;
-
-err_eint_wq:
-	destroy_workqueue(priv->accdet_workqueue);
-err_accdet_wq:
-	dev_err(&pdev->dev, "%s error. now exit.!\n", __func__);
-	return ret;
 }
 
 static struct platform_driver mt6359_accdet_driver = {
-- 
2.53.0



