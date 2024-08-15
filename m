Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C701AC8BB;
	Thu, 15 Aug 2024 14:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731916; cv=none; b=K2gH7Lo1A9EXGZrelVBXxcfVlerEoNBqnMyctGcXTR0//SNegjV81yto2SH243L4gc2y/QCWTJWf9kp12wc2N4PboOVhBb8OC7tkk8qKL/62Z8+J/p6X+KArwAieLrCAnyr1WR2H9PkKugPrIrGfO5u0GgWbaDuakcNEE+P+yw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731916; c=relaxed/simple;
	bh=War0Nr4M3e+pzv7l8K6ZSKUB+cAnrO1eYABXnkw3pfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rp7h/m9+NuP0VyE1NbBE6URsNTfFOb/Qcfoh/RjngFt9DRwB89NLKfm6pNiVCTE2msP2/3hMzcyjE3E4CIQ9dwd6/P2kD2mnDWjC40dGQL8tgEK44XsPg98XjB4l99ryx7DWbZdUK4i5omMO6UI+hp23rpu4G74R2AiSF9uYvZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=js3knlwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="js3knlwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB910C4AF0A;
	Thu, 15 Aug 2024 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731916;
	bh=War0Nr4M3e+pzv7l8K6ZSKUB+cAnrO1eYABXnkw3pfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=js3knlwkqQ070DQkX3TRX7e576s8uDhfQRHwQHXFEbCzY6Ku4lclsgCfx1YokfJJb
	 hFMw27xfh17g/gReXVPVGNLKyExG9ee/ERX9Hw7bGSAgOxDO6elBbUE9YshEl9YlQ4
	 BAY7yZ/aUQG2aLw2yepjrgMfz69fgPv57Z7qFmG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Tung <chineweff@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/352] hwmon: (adt7475) Fix default duty on fan is disabled
Date: Thu, 15 Aug 2024 15:21:15 +0200
Message-ID: <20240815131919.570147002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Tung <chineweff@gmail.com>

[ Upstream commit 39b24cced70fdc336dbc0070f8b3bde61d8513a8 ]

According to the comments on fan is disabled, we change to manual mode
and set the duty cycle to 0.
For setting the duty cycle part, the register is wrong. Fix it.

Fixes: 1c301fc5394f ("hwmon: Add a driver for the ADT7475 hardware monitoring chip")
Signed-off-by: Wayne Tung <chineweff@gmail.com>
Link: https://lore.kernel.org/r/20240701073252.317397-1-chineweff@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7475.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 22e314725def0..b4c0f01f52c4f 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1770,7 +1770,7 @@ static void adt7475_read_pwm(struct i2c_client *client, int index)
 		data->pwm[CONTROL][index] &= ~0xE0;
 		data->pwm[CONTROL][index] |= (7 << 5);
 
-		i2c_smbus_write_byte_data(client, PWM_CONFIG_REG(index),
+		i2c_smbus_write_byte_data(client, PWM_REG(index),
 					  data->pwm[INPUT][index]);
 
 		i2c_smbus_write_byte_data(client, PWM_CONFIG_REG(index),
-- 
2.43.0



