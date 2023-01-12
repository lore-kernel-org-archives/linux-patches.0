Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58FE749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137AAC433D2;
	Thu, 12 Jan 2023 14:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532598;
	bh=6s1DubVKumRT8kawU7Q+an1rKQYEAy268tWyp3jY/7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWsxfZ5J9KkIYaPyMHNvHrT9rnzSqo6tXgNHIXwO5pOX4MPZrDWJ+VO3ARmsirlnM
	 2cviKpVQ5O2yVY2jXwBnWl3g0W++hTXwl+sqq6NLTQ4pakNibIt0/Cruzy0bfYs1Pu
	 EU3fjlw3fVhQ18s4nA5vFnZqfl+y8IkiKGjbON7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/783] hwmon: (jc42) Restore the min/max/critical temperatures on resume
Date: Thu, 12 Jan 2023 14:48:51 +0100
Message-Id: <20230112135534.318598012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 084ed144c448fd5bc8ed5a58247153fbbfd115c3 ]

The JC42 compatible thermal sensor on Kingston KSM32ES8/16ME DIMMs
(using Micron E-Die) is an ST Microelectronics STTS2004 (manufacturer
0x104a, device 0x2201). It does not keep the previously programmed
minimum, maximum and critical temperatures after system suspend and
resume (which is a shutdown / startup cycle for the JC42 temperature
sensor). This results in an alarm on system resume because the hardware
default for these values is 0°C (so any environment temperature greater
than 0°C will trigger the alarm).

Example before system suspend:
  jc42-i2c-0-1a
  Adapter: SMBus PIIX4 adapter port 0 at 0b00
  temp1:        +34.8°C  (low  =  +0.0°C)
                         (high = +85.0°C, hyst = +85.0°C)
                         (crit = +95.0°C, hyst = +95.0°C)

Example after system resume (without this change):
  jc42-i2c-0-1a
  Adapter: SMBus PIIX4 adapter port 0 at 0b00
  temp1:        +34.8°C  (low  =  +0.0°C)             ALARM (HIGH, CRIT)
                         (high =  +0.0°C, hyst =  +0.0°C)
                         (crit =  +0.0°C, hyst =  +0.0°C)

Apply the cached values from the JC42_REG_TEMP_UPPER,
JC42_REG_TEMP_LOWER, JC42_REG_TEMP_CRITICAL and JC42_REG_SMBUS (where
the SMBUS register is not related to this issue but a side-effect of
using regcache_sync() during system resume with the previously
cached/programmed values. This fixes the alarm due to the hardware
defaults of 0°C because the previously applied limits (set by userspace)
are re-applied on system resume.

Fixes: 175c490c9e7f ("hwmon: (jc42) Add support for STTS2004 and AT30TSE004")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20221023213157.11078-3-martin.blumenstingl@googlemail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/jc42.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 9a2a062eb7b8..5240bfdfcf2e 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -567,6 +567,10 @@ static int jc42_suspend(struct device *dev)
 
 	data->config |= JC42_CFG_SHUTDOWN;
 	regmap_write(data->regmap, JC42_REG_CONFIG, data->config);
+
+	regcache_cache_only(data->regmap, true);
+	regcache_mark_dirty(data->regmap);
+
 	return 0;
 }
 
@@ -574,9 +578,13 @@ static int jc42_resume(struct device *dev)
 {
 	struct jc42_data *data = dev_get_drvdata(dev);
 
+	regcache_cache_only(data->regmap, false);
+
 	data->config &= ~JC42_CFG_SHUTDOWN;
 	regmap_write(data->regmap, JC42_REG_CONFIG, data->config);
-	return 0;
+
+	/* Restore cached register values to hardware */
+	return regcache_sync(data->regmap);
 }
 
 static const struct dev_pm_ops jc42_dev_pm_ops = {
-- 
2.35.1



