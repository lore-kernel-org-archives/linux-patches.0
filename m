Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717DB1A619B;
	Tue, 30 Jul 2024 16:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357515; cv=none; b=oqE+32hpRcWcDMW2zQ73/Eg367AeFd/FpapgJh/YU1E0UUW7/pjdNG8b7iDkpzuo4sJcvHyGwRbQ0ieZpfAnPsDS962L+7JKoIn6wcM1iE5bIrzDKd/0hPM+JFQpY3ELCc2sD6K5PMpTLXQKJlI9r4ZTL1lQ78zOPbtldQjIhbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357515; c=relaxed/simple;
	bh=0qL9rCfRUcS1PUDIvM1dOWGtMg4ZP1ny/denGQaR9dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qg39QaZDlXzXw1idYj1q2ObLhF67eNLq2gu4Qamh6ypEpaXsLAhAS6gawugLyeB5Ef3SZl6IYKPa4K3dofczDEuyL2iIE0WWwzwAi1ijAuLX0Wk3AMck5+PSPoHjk8FaBB2I0r2FqN9SRUBzmkuzZSYEgWZzYorF1fnjumXAK4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnSOzODC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnSOzODC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59A6C32782;
	Tue, 30 Jul 2024 16:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357515;
	bh=0qL9rCfRUcS1PUDIvM1dOWGtMg4ZP1ny/denGQaR9dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnSOzODCE+IXFvp2Iab3G4gXp/QEvOi6vWDh2bNhsGO1Gxs1LgEOayPawLMpXLXEC
	 0ZzhAW64GSryyVgQI6V4vV6zLBSerfrjf2gR0nI+QXvKq89L45CkIEa9kCYwUNwx/m
	 EQUAaPU2vsnVJK6Zeb9HAESHqNFy/ILmvMEl/qCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/568] leds: flash: leds-qcom-flash: Test the correct variable in init
Date: Tue, 30 Jul 2024 17:45:51 +0200
Message-ID: <20240730151649.417546614@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 87e552ad654554be73e62dd43c923bcee215287d ]

This code was passing the incorrect pointer to PTR_ERR_OR_ZERO() so it
always returned success.  It should have been checking the array element
instead of the array itself.

Fixes: 96a2e242a5dc ("leds: flash: Add driver to support flash LED module in QCOM PMICs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/ZoWJS_epjIMCYITg@stanley.mountain
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-qcom-flash.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/flash/leds-qcom-flash.c b/drivers/leds/flash/leds-qcom-flash.c
index a73d3ea5c97a3..17391aefeb941 100644
--- a/drivers/leds/flash/leds-qcom-flash.c
+++ b/drivers/leds/flash/leds-qcom-flash.c
@@ -505,6 +505,7 @@ qcom_flash_v4l2_init(struct device *dev, struct qcom_flash_led *led, struct fwno
 	struct qcom_flash_data *flash_data = led->flash_data;
 	struct v4l2_flash_config v4l2_cfg = { 0 };
 	struct led_flash_setting *intensity = &v4l2_cfg.intensity;
+	struct v4l2_flash *v4l2_flash;
 
 	if (!(led->flash.led_cdev.flags & LED_DEV_CAP_FLASH))
 		return 0;
@@ -523,9 +524,12 @@ qcom_flash_v4l2_init(struct device *dev, struct qcom_flash_led *led, struct fwno
 				LED_FAULT_OVER_TEMPERATURE |
 				LED_FAULT_TIMEOUT;
 
-	flash_data->v4l2_flash[flash_data->leds_count] =
-		v4l2_flash_init(dev, fwnode, &led->flash, &qcom_v4l2_flash_ops, &v4l2_cfg);
-	return PTR_ERR_OR_ZERO(flash_data->v4l2_flash);
+	v4l2_flash = v4l2_flash_init(dev, fwnode, &led->flash, &qcom_v4l2_flash_ops, &v4l2_cfg);
+	if (IS_ERR(v4l2_flash))
+		return PTR_ERR(v4l2_flash);
+
+	flash_data->v4l2_flash[flash_data->leds_count] = v4l2_flash;
+	return 0;
 }
 # else
 static int
-- 
2.43.0



