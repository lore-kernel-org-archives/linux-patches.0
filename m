Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018589;
	b=Yb34zANlqFrMBprDvi7AdVH5e+VonV3yBI+KeUoFMZVa0WmQtT18XjknDRrIM09IE8yb
	 ihJWL6/pvVosywGndfCbbB+tr47d9f0CgNq2TJMdIPezszxG07gvsmH2Jqc7nP/VU6iQD
	 9gI5ZMBk7Gg+Dc0xykOFciMou6PtWjLz0IAXR6xBv009VbG6hXVCIln4mpd5Dp3gvomdo
	 PmyxU3khjcUQrfVY78419qX9uUtg6/dIeNz15ZNtYbOzi5p8AYt+dwkKAJnMcydha54Kz
	 I+el4KDMTfuRBXSHPjfbaKi9pIo5hi7lVF4eP9UrHfhA6B0Gpvd/akKgh5dtmmolcaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NgBFnGEa+3IDS1BNqcXlxTeVgZ7qbRkxo5CxuBSz1es=;
	b=VlXixx2PQ/BZma5tjnffnr7WUlEB0za3QpQzkaCqBHgA/VMPaeesw9AsYXnpEdjxqcyb
	 mrN1m9mKpLns7Na0mHvxwdLb/ijwzP0GRO9D2mSHJgxg0au2AgjuLMzDaRXyL8DdCt4Va
	 6wsOs4vvZW3oOdtmQPOMjp+DrflyxSsr8qwR/F6IVLrE4hhvrCJmufJgayDr4LONFQx2C
	 dOJ/QR60IC67Nq8WB3gznPu9XsF1Urw6pitfpxaI1o0HbZBhDk4MiRl81pUh+IJYTqmJp
	 L/zrSheLQSXMyihJx1iDy4qiTjqPCKMlDwmogtR474ooShYc3FBjKyPh+Sa2FGm1RSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gVAdcs7M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA27606A31C;
	Wed, 18 Nov 2026 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gVAdcs7M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9BB1F000C4;
	Wed, 18 Nov 2026 16:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018589;
	bh=NgBFnGEa+3IDS1BNqcXlxTeVgZ7qbRkxo5CxuBSz1es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVAdcs7MFRxeOHNTvSTMCSzuvWJ9GQ8w6gMGQm0K0vAfBe132CfknYeaW6kXArprY
	 zK4LRyRDkynTUblFr03VIsALM1+Ykqi3nkHidKld1nj72is0eUB+BMP9O1WWNcECxm
	 Rr2t0MxodZfUw9YznSDx+/49oJdzeniFp0U5TT2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1293/2651] ASoC: mt6359-accdet: manage private workqueues with devres
Date: Wed, 18 Nov 2026 15:42:13 +0100
Message-ID: <20261118150334.496161930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e1190c644021c..54ec1c6bd64b4 100644
--- a/sound/soc/codecs/mt6359-accdet.c
+++ b/sound/soc/codecs/mt6359-accdet.c
@@ -914,6 +914,14 @@ int mt6359_accdet_enable_jack_detect(struct snd_soc_component *component,
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
@@ -955,6 +963,26 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
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
@@ -1000,22 +1028,6 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
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
@@ -1034,12 +1046,6 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
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



