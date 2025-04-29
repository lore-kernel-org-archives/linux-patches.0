Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085C325228D;
	Tue, 29 Apr 2025 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950204; cv=none; b=h9M+98SXr81d5jUGeHoVeswonFww9/SgYYltHn0jaHKhzUjaWVcb98KRxJF9BD0lRP9lSa5WGl8sBu50GFmUmeNXWjzOLDn7gIdy+RsSUR4UKmy5/DFABymgMo1Q/dwBf0JE66s/UwooNv41mJpjYdycSpXGg9XH/4DObd3c38s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950204; c=relaxed/simple;
	bh=VO0UV7c+SRZ8HNICxN0KaF5/jjzosiQCSiyOGZD3qGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TsGAAtSLM0QcqTRk+//qGaExnmiqrCBCs/7HI+LPusP/Uucxnek2ZK4sVXlB454/T9HxhMo6Y8QVrSw+8WA3Z21t4kp8rjxIDxi9X8ITcLGqbdWRW9geLC2jXZ9tpEyctEOA9YAhH8kUYl/NMApChTBEBh2qwscl0SeCkxHRQgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9EMqlJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9EMqlJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32209C4CEE3;
	Tue, 29 Apr 2025 18:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950203;
	bh=VO0UV7c+SRZ8HNICxN0KaF5/jjzosiQCSiyOGZD3qGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9EMqlJ+r0vv2DbguTquejnrTBW3DhF1vvJtjnjmiUEhG9f3gSiKJ+7Uo2RkScOwc
	 n3jVGimvyFruZNcwT/ofKxBnwzMMano8cuBoFmqVPLFm0YicLvtOZ6S21vIgCZL7CU
	 T9ox7GsQr0nqSipO1Httt4ATj+h+9Z78T+9KRKlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/204] ASoC: qcom: lpass: Make asoc_qcom_lpass_cpu_platform_remove() return void
Date: Tue, 29 Apr 2025 18:41:48 +0200
Message-ID: <20250429161100.253501778@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit d0cc676c426d1958989fac2a0d45179fb9992f0a ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code.  However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

asoc_qcom_lpass_cpu_platform_remove() returned zero unconditionally.
Make it return void instead and convert all users to struct
platform_device::remove_new().

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231013221945.1489203-15-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a93dad6f4e6a ("ASoC: q6apm-dai: make use of q6apm_get_hw_pointer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-apq8016.c | 2 +-
 sound/soc/qcom/lpass-cpu.c     | 5 +----
 sound/soc/qcom/lpass-ipq806x.c | 2 +-
 sound/soc/qcom/lpass-sc7180.c  | 2 +-
 sound/soc/qcom/lpass-sc7280.c  | 2 +-
 sound/soc/qcom/lpass.h         | 2 +-
 6 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/sound/soc/qcom/lpass-apq8016.c b/sound/soc/qcom/lpass-apq8016.c
index f919d46e18caa..06a4faae50875 100644
--- a/sound/soc/qcom/lpass-apq8016.c
+++ b/sound/soc/qcom/lpass-apq8016.c
@@ -300,7 +300,7 @@ static struct platform_driver apq8016_lpass_cpu_platform_driver = {
 		.of_match_table	= of_match_ptr(apq8016_lpass_cpu_device_id),
 	},
 	.probe	= asoc_qcom_lpass_cpu_platform_probe,
-	.remove	= asoc_qcom_lpass_cpu_platform_remove,
+	.remove_new = asoc_qcom_lpass_cpu_platform_remove,
 };
 module_platform_driver(apq8016_lpass_cpu_platform_driver);
 
diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index e587455dc40a0..92316768011ae 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1284,15 +1284,12 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(asoc_qcom_lpass_cpu_platform_probe);
 
-int asoc_qcom_lpass_cpu_platform_remove(struct platform_device *pdev)
+void asoc_qcom_lpass_cpu_platform_remove(struct platform_device *pdev)
 {
 	struct lpass_data *drvdata = platform_get_drvdata(pdev);
 
 	if (drvdata->variant->exit)
 		drvdata->variant->exit(pdev);
-
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(asoc_qcom_lpass_cpu_platform_remove);
 
diff --git a/sound/soc/qcom/lpass-ipq806x.c b/sound/soc/qcom/lpass-ipq806x.c
index 2c97f295e3940..10f7e2639c423 100644
--- a/sound/soc/qcom/lpass-ipq806x.c
+++ b/sound/soc/qcom/lpass-ipq806x.c
@@ -172,7 +172,7 @@ static struct platform_driver ipq806x_lpass_cpu_platform_driver = {
 		.of_match_table	= of_match_ptr(ipq806x_lpass_cpu_device_id),
 	},
 	.probe	= asoc_qcom_lpass_cpu_platform_probe,
-	.remove	= asoc_qcom_lpass_cpu_platform_remove,
+	.remove_new = asoc_qcom_lpass_cpu_platform_remove,
 };
 module_platform_driver(ipq806x_lpass_cpu_platform_driver);
 
diff --git a/sound/soc/qcom/lpass-sc7180.c b/sound/soc/qcom/lpass-sc7180.c
index d16c0d83aaad9..62e49a0d27ba2 100644
--- a/sound/soc/qcom/lpass-sc7180.c
+++ b/sound/soc/qcom/lpass-sc7180.c
@@ -315,7 +315,7 @@ static struct platform_driver sc7180_lpass_cpu_platform_driver = {
 		.pm = &sc7180_lpass_pm_ops,
 	},
 	.probe = asoc_qcom_lpass_cpu_platform_probe,
-	.remove = asoc_qcom_lpass_cpu_platform_remove,
+	.remove_new = asoc_qcom_lpass_cpu_platform_remove,
 	.shutdown = asoc_qcom_lpass_cpu_platform_shutdown,
 };
 
diff --git a/sound/soc/qcom/lpass-sc7280.c b/sound/soc/qcom/lpass-sc7280.c
index 6b2eb25ed9390..97b9053ed3b02 100644
--- a/sound/soc/qcom/lpass-sc7280.c
+++ b/sound/soc/qcom/lpass-sc7280.c
@@ -445,7 +445,7 @@ static struct platform_driver sc7280_lpass_cpu_platform_driver = {
 		.pm = &sc7280_lpass_pm_ops,
 	},
 	.probe = asoc_qcom_lpass_cpu_platform_probe,
-	.remove = asoc_qcom_lpass_cpu_platform_remove,
+	.remove_new = asoc_qcom_lpass_cpu_platform_remove,
 	.shutdown = asoc_qcom_lpass_cpu_platform_shutdown,
 };
 
diff --git a/sound/soc/qcom/lpass.h b/sound/soc/qcom/lpass.h
index ea12f02eca55f..f821271a11467 100644
--- a/sound/soc/qcom/lpass.h
+++ b/sound/soc/qcom/lpass.h
@@ -400,7 +400,7 @@ struct lpass_pcm_data {
 
 /* register the platform driver from the CPU DAI driver */
 int asoc_qcom_lpass_platform_register(struct platform_device *);
-int asoc_qcom_lpass_cpu_platform_remove(struct platform_device *pdev);
+void asoc_qcom_lpass_cpu_platform_remove(struct platform_device *pdev);
 void asoc_qcom_lpass_cpu_platform_shutdown(struct platform_device *pdev);
 int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev);
 extern const struct snd_soc_dai_ops asoc_qcom_lpass_cpu_dai_ops;
-- 
2.39.5



