Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D7724DFE8;
	Thu,  3 Apr 2025 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693902; cv=none; b=HM+XSwwv+Cg9M0oZq8s6KzsvbGuHpvrYth05yx6aDayNnlw99GxLqoPPv++iyIOHGFOJU2tGFqASPiYuYE8TcrDpQr1InezqMsKzTtR3NzqrqT6oiCp/G/AiUaO6G3nvNa+HvylircB8H0I/IAhzQ7u80TkEhQdYkjQX9YfXzIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693902; c=relaxed/simple;
	bh=aC3jH8O9ioR+mBAggWGaR3qLmtUWTQDsqjAELIihUlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qCyEDweEPTMf4cybyA4ZPWspUInKD3ByOFMmSud0WXSBXrBT1Ua24rvye40z2qRF5Gn9/L9JBxayRdtLakR/aZrIYFJ/W0yTVJoNcAooda/IaoOAJwaa5zpE8xMBsk7I5Kz9tHR3b8gsegb8U1HSLKa05M2SB4RMT7e7ca2UFyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBqV+9FV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBqV+9FV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4489C4CEE3;
	Thu,  3 Apr 2025 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693902;
	bh=aC3jH8O9ioR+mBAggWGaR3qLmtUWTQDsqjAELIihUlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBqV+9FVdBqT+kSJLsPqo1uldCgYUZ4tNKoN7Veg1tc9F661dT2HBBh0ZEfN6efaf
	 kiNvUkSq0rA4g8NfVvxo0pOElheIh1cLJWMSbY4uiGcTYxRDbLx+BQQlGe6g1sirrm
	 IbOCQpj75bDxOxBsKcwoeT44oXlEAbSgDmg8jAD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.12 09/22] counter: microchip-tcb-capture: Fix undefined counter channel state on probe
Date: Thu,  3 Apr 2025 16:20:19 +0100
Message-ID: <20250403151622.308559947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Breathitt Gray <wbg@kernel.org>

commit c0c9c73434666dc99ee156b25e7e722150bee001 upstream.

Hardware initialize of the timer counter channel does not occur on probe
thus leaving the Count in an undefined state until the first
function_write() callback is executed. Fix this by performing the proper
hardware initialization during probe.

Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
Reported-by: Csókás Bence <csokas.bence@prolan.hu>
Closes: https://lore.kernel.org/all/bfa70e78-3cc3-4295-820b-3925c26135cb@prolan.hu/
Link: https://lore.kernel.org/r/20250305-preset-capture-mode-microchip-tcb-capture-v1-1-632c95c6421e@kernel.org
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/microchip-tcb-capture.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -368,6 +368,25 @@ static int mchp_tc_probe(struct platform
 			channel);
 	}
 
+	/* Disable Quadrature Decoder and position measure */
+	ret = regmap_update_bits(regmap, ATMEL_TC_BMR, ATMEL_TC_QDEN | ATMEL_TC_POSEN, 0);
+	if (ret)
+		return ret;
+
+	/* Setup the period capture mode */
+	ret = regmap_update_bits(regmap, ATMEL_TC_REG(priv->channel[0], CMR),
+				 ATMEL_TC_WAVE | ATMEL_TC_ABETRG | ATMEL_TC_CMR_MASK |
+				 ATMEL_TC_TCCLKS,
+				 ATMEL_TC_CMR_MASK);
+	if (ret)
+		return ret;
+
+	/* Enable clock and trigger counter */
+	ret = regmap_write(regmap, ATMEL_TC_REG(priv->channel[0], CCR),
+			   ATMEL_TC_CLKEN | ATMEL_TC_SWTRG);
+	if (ret)
+		return ret;
+
 	priv->tc_cfg = tcb_config;
 	priv->regmap = regmap;
 	counter->name = dev_name(&pdev->dev);


