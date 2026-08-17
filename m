Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BAA442124;
	Mon, 17 Aug 2026 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979825; cv=none; b=W4Cq2l+9CKP6dL8f/x/W71rWX0ZoVCGaI4S0K/kgL+o0dWIbUNLCDMy45PB3APgsSB4WDRD++C1WraeiENbwJ+c5doeXcWvduUDzT5+Ro4MvEN3ef+/tOt6K/xPYk17tuqJFlBgHs2OepgZ16l4Z3bg30ACxF3EIPLU/DLB9hIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979825; c=relaxed/simple;
	bh=HnwCxsWHCsj0MkVYYo84/Rh8Is5EiIyNqjT323C+7Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIrNLYka6X0ajE3KWf9WJIE+tC/PVaKMRLja48a82PqtTcS6S3UccnjXMz12a9QJKD33A+jhOwwQ/e9bftAQk5tD4a5N9LTs+nunzvnXmM0B/VQAl4HdNwjlrit+z2gAHPb6RqIIVivNxHRA9bhJeefymMDjRP++4B0cbcOVElw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8MdSWb4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8MdSWb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5791F00A3A;
	Mon, 17 Aug 2026 15:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979821;
	bh=37WZZ3ruaO9ft7e3sU8rDOs28Gor8u2qC2+vi1K/7Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8MdSWb47puAgZ48PG3qJc2MxpgAIDYRLqvFaCiyaYkUaqI6MZMDeQy3FGsx2A6HS
	 Zrjo+YNY/g2yNlxCp/ZWK7Zd++bEMJO/f3hbjL3eKlIKITDUh8Xuk4xmet11bcPK+0
	 15y3vARFrmPIsgdBkJte+o4uT19SyVZVLp5J/4Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 357/609] hwmon: (adt7470) Fix temperature alarm logic in hwmon_temp_read()
Date: Mon, 17 Aug 2026 15:30:53 +0200
Message-ID: <20260817132556.231712366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9569f1faadeb4..7fae4a2b3dea0 100644
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



