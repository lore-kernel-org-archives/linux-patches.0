Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF313BB48
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRSWAv+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31CDC433C7;
	Wed, 15 Nov 2023 19:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078144;
	bh=PnexyODXkku7QaizadklhtQDNMuurr8vBBVBXCeYAlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRSWAv+8Iigu4T/XJDlr579wESZbzVfcVytpFtVodDmG8WTmcn1LswOs5Mc+pt2gZ
	 2aoJaFso2nqlGbLAF2lxajYIXR0X9JaCMrkr9eYc2FyU5gXEUfALh9pmZ69VgL5jlb
	 RuPXz66wlCGH+B6GkYzAX6lnJWtlAEfW16IW51AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/379] hwmon: (sch5627) Disallow write access if virtual registers are locked
Date: Wed, 15 Nov 2023 14:23:08 -0500
Message-ID: <20231115192651.815776766@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 7da8a635436029957c5350da3acf51d78ed64071 ]

When the lock bit inside SCH5627_REG_CTRL is set, then the virtual
registers become read-only until the next power cycle.
Disallow write access to those registers in such a case.

Tested on a Fujitsu Esprimo P720.

Fixes: aa9f833dfc12 ("hwmon: (sch5627) Add pwmX_auto_channels_temp support")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230907052639.16491-3-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sch5627.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/sch5627.c b/drivers/hwmon/sch5627.c
index 87fc1fcf4ca3e..886386272b9f4 100644
--- a/drivers/hwmon/sch5627.c
+++ b/drivers/hwmon/sch5627.c
@@ -34,6 +34,7 @@
 #define SCH5627_REG_CTRL		0x40
 
 #define SCH5627_CTRL_START		BIT(0)
+#define SCH5627_CTRL_LOCK		BIT(1)
 #define SCH5627_CTRL_VBAT		BIT(4)
 
 #define SCH5627_NO_TEMPS		8
@@ -231,6 +232,14 @@ static int reg_to_rpm(u16 reg)
 static umode_t sch5627_is_visible(const void *drvdata, enum hwmon_sensor_types type, u32 attr,
 				  int channel)
 {
+	const struct sch5627_data *data = drvdata;
+
+	/* Once the lock bit is set, the virtual registers become read-only
+	 * until the next power cycle.
+	 */
+	if (data->control & SCH5627_CTRL_LOCK)
+		return 0444;
+
 	if (type == hwmon_pwm && attr == hwmon_pwm_auto_channels_temp)
 		return 0644;
 
-- 
2.42.0



