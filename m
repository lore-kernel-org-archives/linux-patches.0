Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D5D345EB5;
	Sat, 12 Sep 2026 19:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242741; cv=none; b=ZVQkH4XfqrGC/9poffOUfYLg4VcClZ4IrO91OoGgQSPGCWUYUsAO98BjABrVblPjCVnu4cgly76x+fbrFOTSpKwEM2aZa5yrbCesW3p2Yq8X3SlJcLjwCi0J89ZrtMg9k98JxPfviHL5vcP6wOs8OMpE93taMirztCMW1NtIRZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242741; c=relaxed/simple;
	bh=PSDgcFRR2QEiYDdSuhRdZg3MD6qx5l+eiiEyEtK9ZBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+rorJgXdzVWvaNjL1DvM7zShMBMfPm4x8HwUHUfpnmK5TZ0n7J0jJxGTYYb2diWnuiTMYPbseFhclz3UQbDWDgzzb8ucV4V2MWnJBY/UmUcNKWuOsI+ohz8Wv89wAjwCoINGHj8oya0CUVjEezcGuiI9ya0dc8iuLzRUXo3x2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pQBZWKW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pQBZWKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623401F000FF;
	Sat, 12 Sep 2026 19:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242739;
	bh=02j34+5obb8o0qh4g+f9TU9mPSGSYn8oJ6viCgxPg14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pQBZWKWFz2ja1T8LfLHhLrp4sDpmR6KAcrdFrQyKpdvBhq3xKO6GP8RAknp59Jv1
	 vpiiIifzJgrCD8XM1e6dCvWhAy3cK1pN8Id2Q+XC3YIqGHpb4GZ6PLMFpZyMXwYJ31
	 Y29RLBQLz7xJGH6eNWFhW0s2efWwCfuTFISkeoG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 508/798] leds: pca9532: Fix phantom device registration on missing hardware
Date: Sat, 12 Sep 2026 09:02:16 +0200
Message-ID: <20260912065528.777487634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmo Chou <chou.cosmo@gmail.com>

[ Upstream commit 8d6b6c05b8e33d11e3fb3203309385e1a9cceecd ]

The initial PWM and PSC register writes in pca9532_configure() do not
check the return values of i2c_smbus_write_byte_data(). If the I2C
device is physically absent from the bus, the write fails with -ENXIO.
However, the driver ignores this error and allows probe() to complete
successfully.

This results in the registration of phantom LED class devices and
gpiochips backed by non-existent hardware. Subsequent GPIO reads from
these phantom chips return bogus values (due to -ENXIO being truncated
to an unsigned char in pca9532_gpio_get_value()), silently corrupting
hardware state tracking in userspace.

Propagate the I2C write failures back to probe() so the driver core
can gracefully abort binding and release devres-managed resources.

Fixes: e14fa82439d3 ("leds: Add pca9532 led driver")
Signed-off-by: Cosmo Chou <chou.cosmo@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260715080747.1638097-1-chou.cosmo@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca9532.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index ae5e5dfaab3cd..e350d5a588d6c 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -360,10 +360,14 @@ static int pca9532_configure(struct i2c_client *client,
 	for (i = 0; i < 2; i++)	{
 		data->pwm[i] = pdata->pwm[i];
 		data->psc[i] = pdata->psc[i];
-		i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(maxleds, i),
-			data->pwm[i]);
-		i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(maxleds, i),
-			data->psc[i]);
+		err = i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(maxleds, i),
+						data->pwm[i]);
+		if (err < 0)
+			return err;
+		err = i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(maxleds, i),
+						data->psc[i]);
+		if (err < 0)
+			return err;
 	}
 
 	for (i = 0; i < data->chip_info->num_leds; i++) {
-- 
2.53.0



