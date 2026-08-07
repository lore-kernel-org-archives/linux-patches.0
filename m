Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4AC420478;
	Fri,  7 Aug 2026 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114047; cv=none; b=XRTvkUQN44fajwGGkeKxcYU5Wbi6t5VDp3zddKfKhIHxsZpsIuIoiYwP6QBpuLI0nM9Cpv2w6bqLrUpqaZp1YRX6LXwpDdP2VuLGNlzLKL+V/jDP5vwcoxsVuejPAOt9ymKlkpsx6qNlbNU7/nAz+fEo2dAIRL6LV1+oKzQD4is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114047; c=relaxed/simple;
	bh=h13ZCWcfZnmzTbCflPA6q7jwH4s0dNxZWFv4lG2lfPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TioC+jGs8pSrn3JiOMjIaRK923NOw58FhM7FKnxzcfPezkR9gNCMXo+1eQjyJzJjJeB4NHzCwYD4hubucMWnHORHIgHufISjV4svwGiIMmiq557bURBGZN10T3etFRQL/RmlFdZa821h7QyBoFGoZk/9Km0AGEky1D2WRyKvyRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMGoPuqm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMGoPuqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5273A1F00A3A;
	Fri,  7 Aug 2026 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114042;
	bh=oXqQ7LAWnd5njCnyjr74lY9QUq9PyXRSeMfvJuyvozc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMGoPuqmzWUx4je/bjVgQcDZPIoQqmlZrcsmcyA1n+7V/LGT2qXWl8EsiyvixGGAx
	 ChitoFwRmIK1gg+Bcg8Qk2aVFy5FQu7XJZT4rFAdyaT2Xdkdfd3BhJ7L7PGq2KUu2n
	 o7qvv8dDeEJyRk8a6jwRxrlnYFTAQm6ZBau6USv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/337] hwmon: (adt7470) Fix temperature alarm logic in hwmon_temp_read()
Date: Fri,  7 Aug 2026 16:34:42 +0200
Message-ID: <20260807143420.228735374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a927e0b6d3319..41fa6a0e8b937 100644
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



