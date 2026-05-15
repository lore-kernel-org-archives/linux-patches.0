Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061F9303CB0;
	Fri, 15 May 2026 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861773; cv=none; b=aackML/jov1+DVr0blGVMIrObxpI2SmSGKRlo3CfXKJBiFuoJ6Aq7pG81s51G1Hn0MRtSymf7mMlcrBmVPs7qSLJRGrHdQoxfHOgI3/W2+BpH7xW3FS7PcQ268D0ppiRp90mM1Rf383JrIY0I+z4r18mNw8dRk0iw7rbPKmT63A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861773; c=relaxed/simple;
	bh=kqohpkWxzl35Z4sksiR2Tfr2MwnZQgc2i9LtfArrxDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PxfD2yuubcPtZD3i8CyQTj9Zb52W9f3Yqfm039cGcY4YLkwA/SI+mKpdl4UDpfJEzHPQJp1hnwqSZVBOHUeIhKrLbTYQYJAdB4eqcbyYe5zc0NLPaLWUWIXchNwsCZDwAPDZLoRqz4luyBO6adAOY7rCiSy8ga+dfKr0/roXnWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpmwQW6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpmwQW6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFE0C2BCB0;
	Fri, 15 May 2026 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861772;
	bh=kqohpkWxzl35Z4sksiR2Tfr2MwnZQgc2i9LtfArrxDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpmwQW6Plm+5MGGhVVUY80qxG4j0lCSBo6WrA8Q3UTMHTnMg0lxCDXSIpjvcdPSPy
	 ckrVG+wKVLPmygEqgbdl4WExldJv+qOvNW8QTG3Dgmog3eCpLKnwfMbLEnTBu6r6vi
	 +UZgC9mK06l2rRdmbyfhSvJuLiG0xHGMgirfZc4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Viorel Suman (OSS)" <viorel.suman@oss.nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.6 456/474] pwm: imx-tpm: Count the number of enabled channels in probe
Date: Fri, 15 May 2026 17:49:25 +0200
Message-ID: <20260515154724.963690016@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


