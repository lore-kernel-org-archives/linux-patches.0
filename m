Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E79442124;
	Mon, 17 Aug 2026 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979772; cv=none; b=kauqdkd4loeeOxQpnhM2FXetVEO5ky4OZWurql2mpx3V3TbDhSZ6SZBr4FQx1Q9ySSyj139pwqoGZbtJenEJ4TrxpFVHXnSwFE5IrcLS5ih141i8Gt3cpgUKyggu/1ByVzauf7fBf0ofjaNiwSUAZ96knLGN6cY4r9/uovf533g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979772; c=relaxed/simple;
	bh=rbx1JIfHLB1HaIlX9iTNq5SDkGJE6KS5ssqj/ZL8HgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYaOSzuWLn1p0SRLz2UCTwA5afRV9qIgaUBgoFVI42xUc6a00wlFxIAIFOD+g3XUFBoou1O0JDYH23I78zqPCJlbJQtqHmdAhpT6hsltKqV2IFLrDpB4lw54MAqMWmHaRv2aGTiG0HhkMyn4yMiyy1S8FbKVZEoTTXVBa8o6pOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08IGmfhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08IGmfhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9D71F00A3A;
	Mon, 17 Aug 2026 15:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979771;
	bh=2JM4vY/Xh1JX3dFssVbo3VYRXEOLvybOXQ3vQZboIuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08IGmfhcvn0iBfUuOOhcYoVrI34BTI9WZr4D9qA2tP9fRQ0tWqRsLL9ujDja2GGGK
	 EH8/97BpqxDY5oufo23l40pc/EmvdHFJWdCZRnHT4jspxeUxpoF5jL/Zy6oLCvtLbH
	 DeGMRnxtbPm2fwP/QhfV8oIUDdbSVXPyIwnXl0QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Khalifa <ahmad@khalifa.ws>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/609] hwmon: (nct6775) Fix IN scaling factors for 6798/6799
Date: Mon, 17 Aug 2026 15:30:38 +0200
Message-ID: <20260817132555.699707905@linuxfoundation.org>
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

From: Ahmad Khalifa <ahmad@khalifa.ws>

[ Upstream commit 13558a2e6341d1ba6dff9f8e2febf97877067885 ]

Scaling for VTT/VIN5/VIN6 registers were based on prior chips
* Split scaling factors for 6798/6799 and assign at probe()
* Pass them through driver data to sysfs functions

Tested on nct6799 with old/new input/min/max

Fixes: 0599682b826f ("hwmon: (nct6775) Add support for NCT6798D")
Signed-off-by: Ahmad Khalifa <ahmad@khalifa.ws>
Link: https://lore.kernel.org/r/20230719192848.337508-1-ahmad@khalifa.ws
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: b0e8adb2ccb4 ("hwmon: (nct6775-core) Fix number of temperature registers for NCT6116")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 28 ++++++++++++++++++++++------
 drivers/hwmon/nct6775.h      |  1 +
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index 3a61acec7a345..a7e5faf8d0278 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -955,14 +955,25 @@ static const u16 scale_in[15] = {
 	800, 800
 };
 
-static inline long in_from_reg(u8 reg, u8 nr)
+/*
+ * NCT6798 scaling:
+ *    CPUVC, IN1, AVSB, 3VCC, IN0, IN8, IN4, 3VSB, VBAT,  VTT,  IN5,  IN6, IN2,
+ *      IN3, IN7
+ * Additional scales to be added later: IN9 (800), VHIF (1600)
+ */
+static const u16 scale_in_6798[15] = {
+	800, 800, 1600, 1600, 800, 800, 800, 1600, 1600, 1600, 1600, 1600, 800,
+	800, 800
+};
+
+static inline long in_from_reg(u8 reg, u8 nr, const u16 *scales)
 {
-	return DIV_ROUND_CLOSEST(reg * scale_in[nr], 100);
+	return DIV_ROUND_CLOSEST(reg * scales[nr], 100);
 }
 
-static inline u8 in_to_reg(u32 val, u8 nr)
+static inline u8 in_to_reg(u32 val, u8 nr, const u16 *scales)
 {
-	return clamp_val(DIV_ROUND_CLOSEST(val * 100, scale_in[nr]), 0, 255);
+	return clamp_val(DIV_ROUND_CLOSEST(val * 100, scales[nr]), 0, 255);
 }
 
 /* TSI temperatures are in 8.3 format */
@@ -1677,7 +1688,8 @@ show_in_reg(struct device *dev, struct device_attribute *attr, char *buf)
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	return sprintf(buf, "%ld\n", in_from_reg(data->in[nr][index], nr));
+	return sprintf(buf, "%ld\n",
+		       in_from_reg(data->in[nr][index], nr, data->scale_in));
 }
 
 static ssize_t
@@ -1695,7 +1707,7 @@ store_in_reg(struct device *dev, struct device_attribute *attr, const char *buf,
 	if (err < 0)
 		return err;
 	mutex_lock(&data->update_lock);
-	data->in[nr][index] = in_to_reg(val, nr);
+	data->in[nr][index] = in_to_reg(val, nr, data->scale_in);
 	err = nct6775_write_value(data, data->REG_IN_MINMAX[index - 1][nr], data->in[nr][index]);
 	mutex_unlock(&data->update_lock);
 	return err ? : count;
@@ -3472,6 +3484,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 	mutex_init(&data->update_lock);
 	data->name = nct6775_device_names[data->kind];
 	data->bank = 0xff;		/* Force initial bank selection */
+	data->scale_in = scale_in;
 
 	switch (data->kind) {
 	case nct6106:
@@ -3987,6 +4000,9 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 			break;
 		}
 
+		if (data->kind == nct6798 || data->kind == nct6799)
+			data->scale_in = scale_in_6798;
+
 		reg_temp = NCT6779_REG_TEMP;
 		num_reg_temp = ARRAY_SIZE(NCT6779_REG_TEMP);
 		if (data->kind == nct6791) {
diff --git a/drivers/hwmon/nct6775.h b/drivers/hwmon/nct6775.h
index 44f79c5726a9c..a84c6ce7275de 100644
--- a/drivers/hwmon/nct6775.h
+++ b/drivers/hwmon/nct6775.h
@@ -98,6 +98,7 @@ struct nct6775_data {
 	u8 bank;		/* current register bank */
 	u8 in_num;		/* number of in inputs we have */
 	u8 in[15][3];		/* [0]=in, [1]=in_max, [2]=in_min */
+	const u16 *scale_in;	/* internal scaling factors */
 	unsigned int rpm[NUM_FAN];
 	u16 fan_min[NUM_FAN];
 	u8 fan_pulses[NUM_FAN];
-- 
2.53.0



