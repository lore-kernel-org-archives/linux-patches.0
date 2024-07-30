Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BBA18801A;
	Tue, 30 Jul 2024 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358567; cv=none; b=p2gOQBFmq/gYUWPfUOsAph8TbK1TlwdbZgx5ziIT3MqCAb3UW3CGyNSHhSN1wRzkN+WiR8OcHsDgve85/5EmfBCiregjo9j5AD3Sadqq5ZzSrDhlC4jHMXT2noFvBe4D1oyaHpgyO/wsmcxCxuH8vWirRjbGBMKp8opNWggIQXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358567; c=relaxed/simple;
	bh=WNL24qwYSq4A0MhYoNJU0qQeLyN2SbsPSB/fE6CyY7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BI22rLAmuH9YjmToPSHdfKH8Px2am9OrdHB5J3Y7haCiAlLV80nJHUzNcCwcuH+pkOetclr8HKQAN1KCX4EhdZnKBJ17KSSqtFyLzDMsuRbM6TqGS+V5ZL+35Xd2dtzF7vdHkcdacq+O/Txi2P9bd+JYDFzB8up6uMLCBDiBGq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHCGBEBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHCGBEBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8437EC32782;
	Tue, 30 Jul 2024 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358567;
	bh=WNL24qwYSq4A0MhYoNJU0qQeLyN2SbsPSB/fE6CyY7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHCGBEBNLgpKWIgU+EN7IBXNIazvZzqy7I/wEo5SzACSXSi9RoeL9Z9V0Ctun0BU1
	 K38tSjFoVEF8TmySwozk1J+4s6wP/YexvaVc3VioFGraygZxKJ0iIex5ufdsVosf+k
	 muCrhssx/oK68lqLmnTkWdM3fUrccq0PEKJrKJMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 374/809] leds: flash: leds-qcom-flash: Test the correct variable in init
Date: Tue, 30 Jul 2024 17:44:10 +0200
Message-ID: <20240730151739.433120863@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7c99a30391716..bf70bf6fb0d59 100644
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



