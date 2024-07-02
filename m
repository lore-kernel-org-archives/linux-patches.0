Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F1D63D;
	Tue,  2 Jul 2024 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941617; cv=none; b=TWw36fZo8y3JXUPMLyEMGBMWfCqs4xd1IhjjcsfPiO0lRbVcXJRfPQRpCWMTLEqSyhJOKWxrNFGTwRNSi7a0PSo6cRCrfiPiVUrugudKJzWCr7gee9X4dz9wqAF0OEDUErq0x3dPITOAwClyoxJaP9FeZ+dHELCIAzSJ2bFc+58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941617; c=relaxed/simple;
	bh=6hPLp9rVOwxCDVvuG+cm1VmI7Zvicj02oGv8eXlF3Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CxdwzFEuHAmYgwMi2lt8fhpG78Mukccuik+IRRb6fZ+MymFp7YjcVWTZF9IgsssILkn1ofjTTUc1+lFszU4kzeyKU0dn655iSMOr2Q+mqditn+lnEKZRPZL2XYB5dqSEQKz7ZCDqwokBeLWGwG4PpIg3dvgmQ5+OHS/IpVq7nL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHtLow7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHtLow7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7FEC4AF0D;
	Tue,  2 Jul 2024 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941617;
	bh=6hPLp9rVOwxCDVvuG+cm1VmI7Zvicj02oGv8eXlF3Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHtLow7XDzNpgQB0fHfi9WEHAR0lcAIerCULttLTnRk2DY1kndxng5rmzdULw6Dl8
	 RmSuvf2DoiGwRTGV16FlK3Q872VKCwawgb6EriOZ4hCFIjMkqqJCCLWyY/R6Bzcylb
	 KsfQiEmAkcx/JYrDnA+fogTHRvUHXe3q1Z4SBqDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.1 117/128] pwm: stm32: Refuse too small period requests
Date: Tue,  2 Jul 2024 19:05:18 +0200
Message-ID: <20240702170230.646438781@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit c45fcf46ca2368dafe7e5c513a711a6f0f974308 upstream.

If period_ns is small, prd might well become 0. Catch that case because
otherwise with

	regmap_write(priv->regmap, TIM_ARR, prd - 1);

a few lines down quite a big period is configured.

Fixes: 7edf7369205b ("pwm: Add driver for STM32 plaftorm")
Cc: stable@vger.kernel.org
Reviewed-by: Trevor Gamblin <tgamblin@baylibre.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/b86f62f099983646f97eeb6bfc0117bb2d0c340d.1718979150.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-stm32.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -340,6 +340,9 @@ static int stm32_pwm_config(struct stm32
 
 	prd = div;
 
+	if (!prd)
+		return -EINVAL;
+
 	if (prescaler > MAX_TIM_PSC)
 		return -EINVAL;
 


