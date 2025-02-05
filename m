Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388F1B640;
	Wed,  5 Feb 2025 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763741; cv=none; b=CTPGaPbtydkKI7JUESnlRa/GTvxRXw4caRohyoRnLkoc9OtIDz57UFrDWRrkMHdeHudMyTEsqtQtK2c9f8yuBFo8pt7512W35fIe3SIv19PXFsekht8uYo/Bd5gJKw/PMS779w5kcbdDLH7h3B+ba3XGIrokwdged2fPUue0D3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763741; c=relaxed/simple;
	bh=gYDq5J/S/k/HMtRQM0ejszb0XN4hzMLG8UIMSWp/erg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gH2WNvsg5bzXxkGjMRxsMYzrWNK4rK87goc+8bEeNaOjvAeIxUUhBR1QxBbB5fGETTMv2/fWN88yWgF+NokQ891onNCCCHLeCWAS/VoD4PDyF+rBvZrJ1XKdPBNTHihtwtjgprgAaRMzFY4M0ONeamMvxRlanVrwKHhCT8cP2Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjTfoIZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjTfoIZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3AAC4CED1;
	Wed,  5 Feb 2025 13:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763740;
	bh=gYDq5J/S/k/HMtRQM0ejszb0XN4hzMLG8UIMSWp/erg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjTfoIZqlsRtuj0x7tiySil6ZrfYn6VEcvdaCIJFO2MQReo1aR7/CVIyp/XbrfKFu
	 r1WhjAIbnsxEt9AYM4E7sCmSqwxg01MXlM0BM4xV4dRmu3OfmvLYquARJ8gHVq6PpD
	 8E6el1V/VP02IvGiQp19eyW4tTWoAJz1CE5tJuKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/393] leds: cht-wcove: Use devm_led_classdev_register() to avoid memory leak
Date: Wed,  5 Feb 2025 14:40:20 +0100
Message-ID: <20250205134424.157395988@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 417cad5dc782096350e6a967ee5dd3417a19a24e ]

cht_wc_leds_probe() leaks memory when the second led_classdev_register()
call in the for-loop fails as it does not call the cleanup function
led_classdev_unregister() on the first device. Avoid this leak by
calling devm_led_classdev_register().

Fixes: 047da762b9a9 ("leds: Add Intel Cherry Trail Whiskey Cove PMIC LED driver")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://lore.kernel.org/r/20241220085346.533675-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-cht-wcove.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/leds/leds-cht-wcove.c b/drivers/leds/leds-cht-wcove.c
index b4998402b8c6f..711ac4bd60580 100644
--- a/drivers/leds/leds-cht-wcove.c
+++ b/drivers/leds/leds-cht-wcove.c
@@ -394,7 +394,7 @@ static int cht_wc_leds_probe(struct platform_device *pdev)
 		led->cdev.pattern_clear = cht_wc_leds_pattern_clear;
 		led->cdev.max_brightness = 255;
 
-		ret = led_classdev_register(&pdev->dev, &led->cdev);
+		ret = devm_led_classdev_register(&pdev->dev, &led->cdev);
 		if (ret < 0)
 			return ret;
 	}
@@ -406,10 +406,6 @@ static int cht_wc_leds_probe(struct platform_device *pdev)
 static void cht_wc_leds_remove(struct platform_device *pdev)
 {
 	struct cht_wc_leds *leds = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < CHT_WC_LED_COUNT; i++)
-		led_classdev_unregister(&leds->leds[i].cdev);
 
 	/* Restore LED1 regs if hw-control was active else leave LED1 off */
 	if (!(leds->led1_initial_regs.ctrl & CHT_WC_LED1_SWCTL))
-- 
2.39.5



