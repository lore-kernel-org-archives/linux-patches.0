Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB6732B11D;
	Sat, 30 May 2026 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160756; cv=none; b=MuYdH9z11v1VcgsKonXAJhGRtr1l7QHelBV4jqycO4ZZcH4JU2O5zF4qmFO32YkTUi+49b6rX0cFyoM/OHMOS1iaNTIppwAeyw6s7ujY52NfQ7nXjpd2bkCc3e7uaWyD9WAzqW9UsrizV2B4cHE47k08tX24zjBgxAaS1gEPzhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160756; c=relaxed/simple;
	bh=MKu8wNJ7XXXO71BIh2gOquhXTqL43VCtOOeqJFwlw8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2AKwNCEdbRcIKfGQJjP7OmTCYLBS63wJVCJwMOaYtpk4g23CmkKRKIUj8CBs8o3RdT+Ex30CRgoOCJyrSB2MiMl/2+ykCw4wSGHFvhP04dXM8brbPWaVpAloQ7FzjtH/3sdNL4f0+soEvluNgAaQgaBXHog82MJolAtfGVLY2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKl6Gc12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKl6Gc12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F16A1F00893;
	Sat, 30 May 2026 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160755;
	bh=0cmKcLadMDOg1Lc619/OuywPUERyIkjD+heqf/yKR3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKl6Gc12EWJJ/8IkPM6hpZsgB23OfAvNvxoSvVXv4LXWHH1f2JaKDXb1fZpbPpU/z
	 B1NHvRdU8U3xNww+OVGJesEYhQPdmaD/8fuJJxJyLAhAY9++FJLpSpTOU2TVHP2+7i
	 cz4hOaBF9jplpVrZk9DPGrA8PuFE7uyVuCj5s/Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Viorel Suman (OSS)" <viorel.suman@oss.nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.1 425/969] pwm: imx-tpm: Count the number of enabled channels in probe
Date: Sat, 30 May 2026 17:59:09 +0200
Message-ID: <20260530160311.999147869@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viorel Suman (OSS) <viorel.suman@oss.nxp.com>

commit 3962c24f2d14e8a7f8a23f56b7ce320523947342 upstream.

On a soft reset TPM PWM IP may preserve its internal state from previous
runtime, therefore on a subsequent OS boot and driver probe
"enable_count" value and TPM PWM IP internal channels "enabled" states
may get unaligned. In consequence on a suspend/resume cycle the call "if
(--tpm->enable_count == 0)" may lead to "enable_count" overflow the
system being blocked from entering suspend due to:

   if (tpm->enable_count > 0)
       return -EBUSY;

Fix the problem by counting the enabled channels in probe function.

Signed-off-by: Viorel Suman (OSS) <viorel.suman@oss.nxp.com>
Fixes: 738a1cfec2ed ("pwm: Add i.MX TPM PWM driver support")
Link: https://patch.msgid.link/20260311123309.348904-1-viorel.suman@oss.nxp.com
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
[ukleinek: backport to linux-6.6.y]
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-imx-tpm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/pwm/pwm-imx-tpm.c
+++ b/drivers/pwm/pwm-imx-tpm.c
@@ -350,6 +350,7 @@ static int pwm_imx_tpm_probe(struct plat
 {
 	struct imx_tpm_pwm_chip *tpm;
 	int ret;
+	unsigned int i;
 	u32 val;
 
 	tpm = devm_kzalloc(&pdev->dev, sizeof(*tpm), GFP_KERNEL);
@@ -383,6 +384,13 @@ static int pwm_imx_tpm_probe(struct plat
 
 	mutex_init(&tpm->lock);
 
+	/* count the enabled channels */
+	for (i = 0; i < tpm->chip.npwm; ++i) {
+		val = readl(tpm->base + PWM_IMX_TPM_CnSC(i));
+		if (FIELD_GET(PWM_IMX_TPM_CnSC_ELS, val))
+			++tpm->enable_count;
+	}
+
 	ret = pwmchip_add(&tpm->chip);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add PWM chip: %d\n", ret);


