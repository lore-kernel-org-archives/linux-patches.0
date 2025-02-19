Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255F51E7C10;
	Wed, 19 Feb 2025 08:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954266; cv=none; b=Ho+JbgDxzzwptN7SL2SuPK36+WLYzCia02DyMPeyWDXMzh2oUyhD+92EobyluUH1FgSyC/A2EGzBZKrXyLFgXGMOM5rMnRxEEYyj3/xZajcWsymo/d1Vf3QVnqHWw5/WrfVqTrGDZVnDgMDbH0xZmnOzGj0Z902ZkaGz4iiIPJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954266; c=relaxed/simple;
	bh=8o+VaSnswham1BZBqBO3wiUN7DitlW1UohmX9j5gMoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsmcAYnZ1rEmVdlVR5T43w0jPvOuRCTJU98H5d8gF25FArCsiO1Qp+mV1ryLCTRkH9X/oS5Y/TrFQ8mJucymOIxvj3YNWlTfTIgagXn7tn4YHp0bLtMeCgbhfC3E+5PluIwDCgEb7h+tx8aJhInxjpaqgUhi4rsZjqr7EeEXKSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fC2S0xB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fC2S0xB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD97C4CEE6;
	Wed, 19 Feb 2025 08:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954266;
	bh=8o+VaSnswham1BZBqBO3wiUN7DitlW1UohmX9j5gMoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fC2S0xB3wvc48HS8Vlz94JBzPkY6WMdxvr/08/lYSmdL1XX3Z1rMQq3yhZml2C7Tm
	 kkisJM61NSozMBa91hT6uoAFqdZOl1nL1ULmpwUvzNy1CfBsLLpP+2+B6jSJxSi2Pi
	 AtxpUoHdRf4ZffcMHMZ7DHZp3b8lm7fNj+MRcoaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.13 150/274] can: c_can: fix unbalanced runtime PM disable in error path
Date: Wed, 19 Feb 2025 09:26:44 +0100
Message-ID: <20250219082615.469744888@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 257a2cd3eb578ee63d6bf90475dc4f4b16984139 upstream.

Runtime PM is enabled as one of the last steps of probe(), so all
earlier gotos to "exit_free_device" label were not correct and were
leading to unbalanced runtime PM disable depth.

Fixes: 6e2fe01dd6f9 ("can: c_can: move runtime PM enable/disable to c_can_platform")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250112-syscon-phandle-args-can-v1-1-314d9549906f@linaro.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/c_can/c_can_platform.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -385,15 +385,16 @@ static int c_can_plat_probe(struct platf
 	if (ret) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
 			KBUILD_MODNAME, ret);
-		goto exit_free_device;
+		goto exit_pm_runtime;
 	}
 
 	dev_info(&pdev->dev, "%s device registered (regs=%p, irq=%d)\n",
 		 KBUILD_MODNAME, priv->base, dev->irq);
 	return 0;
 
-exit_free_device:
+exit_pm_runtime:
 	pm_runtime_disable(priv->device);
+exit_free_device:
 	free_c_can_dev(dev);
 exit:
 	dev_err(&pdev->dev, "probe failed\n");


