Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9013D3334;
	Mon,  4 May 2026 14:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903304; cv=none; b=qjDNrfAM+lLLJ59hf7sZ+Q+ENjV4llwl5Vy2Cp2Y13PIyvSVZu1rym+4lYA+QwNHajx/hnt34gib3YDb5i2z0gYt1wkFttj+LTx0BBbjILEBlVWyTCaPrDZF9iGBI+E0g46UT8G9VCwVxWnuBCR0tjoYNsS1GIJk6vXl04FZg6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903304; c=relaxed/simple;
	bh=HguybM0XmGUQ2g4F5Wf0MLPfw387OJPOAdFepbU3/y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZ5YrZ4vCozSWbSiY1Mn4GtoFKGHF4A1EnPSv6A7gptNxaX5Tyw9AcmwYVbmqL6Hs+iUNGvD1BtezRPL8isaqskGInqGRJXxY2F98MZ2p2QhNZrWBah28Bztn0ZMAXCSTJ5Ojyaij0/iwrPiUu4o/0dTEu0ndyjgQomo31GPris=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdYqx9JP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdYqx9JP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70CBC2BCF4;
	Mon,  4 May 2026 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903304;
	bh=HguybM0XmGUQ2g4F5Wf0MLPfw387OJPOAdFepbU3/y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdYqx9JP+9MWIs/Ub07LOQYy77XzddiQN4JMEjTeLOdrf57Y8+3TlPf5VynLgbst3
	 /iihaiSREtDjC45VQVCAq1LDOAYfZDo2PM/9QaY72ZhtkWnq8EaR3p287A5ILS58Qt
	 nqr5jznob7AZpvuPEp01GzFr0PA+jaG+5SWS+LFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Viorel Suman (OSS)" <viorel.suman@oss.nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 7.0 183/307] pwm: imx-tpm: Count the number of enabled channels in probe
Date: Mon,  4 May 2026 15:51:08 +0200
Message-ID: <20260504135149.758649318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-imx-tpm.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/pwm/pwm-imx-tpm.c
+++ b/drivers/pwm/pwm-imx-tpm.c
@@ -352,7 +352,7 @@ static int pwm_imx_tpm_probe(struct plat
 	struct clk *clk;
 	void __iomem *base;
 	int ret;
-	unsigned int npwm;
+	unsigned int i, npwm;
 	u32 val;
 
 	base = devm_platform_ioremap_resource(pdev, 0);
@@ -382,6 +382,13 @@ static int pwm_imx_tpm_probe(struct plat
 
 	mutex_init(&tpm->lock);
 
+	/* count the enabled channels */
+	for (i = 0; i < npwm; ++i) {
+		val = readl(base + PWM_IMX_TPM_CnSC(i));
+		if (FIELD_GET(PWM_IMX_TPM_CnSC_ELS, val))
+			++tpm->enable_count;
+	}
+
 	ret = devm_pwmchip_add(&pdev->dev, chip);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "failed to add PWM chip\n");


