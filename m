Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E48C3B38A9;
	Mon, 17 Aug 2026 14:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977378; cv=none; b=jYNXGPX0j4YNge2MqOybUwrrt5twV+KIqnToP26UfRJ1Tk7Kzy5KTCclIUqZ4uhvcqrXdimKD69lf9QSWi9GSAPp5Davzs8XiGKWi8mIhblHSKFUFZ9fK9ezIBD9kLMtqNLNcbOc11szRX5embTmUmgVV/1LHZyS1UhqhzuBwl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977378; c=relaxed/simple;
	bh=Hpm0oufxJ5JKKDzK7GzQtKUKkyRI0JXuVpgQLirwS/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izchKJlQcXJMvZ16Vc9hoR0fMCA3h+fj4jCUTMhaZ35YXbg3qa0VTtce9r76CuSReOP6Tuqu7nwAmVcOiwMNGsaRPDdumU/0AFze2Jl25QQcEI+4w8kZ8LAMVukqMY+TB/Hc70Vlwd0L5sqrbF29ANN8pGf5ZOPY2nFs7+DyDzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkUPPav6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkUPPav6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71731F000E9;
	Mon, 17 Aug 2026 14:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977377;
	bh=d5IoEsAVXCgBgfZd3SUnrBik0SsgfRlwjJu18b+E4TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkUPPav6r9SE4hUD+FllNydo3I6cUHdZ59W4s7RS5y61pa0+tF57eoZR6maeUY9i+
	 RrcjsVMS1zZqXAa9hgAHyFLssGBtPX9NftXzbdMXNYjh4idmrzEs5V8J0lcmijgvLk
	 fpZCODCXPPV3fmqRyjFWb3Sky88Oa6qH+okCLwlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/456] hwmon: (adt7470) Fix temperature alarm logic in hwmon_temp_read()
Date: Mon, 17 Aug 2026 15:31:01 +0200
Message-ID: <20260817132550.580451922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit 1a18c79c4bc44cc5349c60e16b0b744dc6ec5f77 ]

During the conversion the alarm callback started interpreting the
channel index as an alarm bitmask, resulting in incorrect alarm
reporting. Compute the proper alarm bit instead.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/r/20260717211224.B9E291F000E9@smtp.kernel.org
Fixes: fc958a61ff6d ("hwmon: (adt7470) Convert to devm_hwmon_device_register_with_info API")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20260727-adt7470_fixes-v2-5-598e38a46ba6@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 0874d3684fbce..68658cb566a1a 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -110,6 +110,21 @@ static const unsigned short normal_i2c[] = { 0x2C, 0x2E, 0x2F, I2C_CLIENT_END };
 
 #define ALARM2(x)		((x) << 8)
 
+/* TEMP1..TEMP7 (ch 0..6) are, respectively BIT(0)..BIT(6) of reg 0x41 and
+ * 0x72, or BIT(0)..BIT(6) of data->alarm.
+ * TEMP8..TEMP9 (ch 7..9) are, respectively BIT(0)..BIT(2) of reg 0x42 and
+ * 0x73, or BIT(8)..BIT(10) of data->alarm.
+ */
+#define TEMP_ALARM_BIT(ch)	({		\
+	typeof(ch) _ch = (ch);			\
+	(1 << (_ch < 7 ? _ch : _ch + 1));	\
+})
+
+/* FAN1..FAN4 (ch 0..3) are respectively BIT(4)..BIT(7) in
+ * reg 0x42 and 0x73 or BIT(12)..BIT(15) in data->alarm.
+ */
+#define FAN_ALARM_BIT(ch)	(1 << (12 + (ch)))
+
 #define ADT7470_VENDOR		0x41
 #define ADT7470_DEVICE		0x70
 /* datasheet only mentions a revision 2 */
@@ -569,7 +584,7 @@ static int adt7470_temp_read(struct device *dev, u32 attr, int channel, long *va
 		*val = 1000 * data->temp_max[channel];
 		break;
 	case hwmon_temp_alarm:
-		*val = !!(data->alarm & channel);
+		*val = !!(data->alarm & TEMP_ALARM_BIT(channel));
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -668,7 +683,7 @@ static int adt7470_fan_read(struct device *dev, u32 attr, int channel, long *val
 			*val = 0;
 		break;
 	case hwmon_fan_alarm:
-		*val = !!(data->alarm & (1 << (12 + channel)));
+		*val = !!(data->alarm & FAN_ALARM_BIT(channel));
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.53.0



