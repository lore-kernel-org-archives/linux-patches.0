Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84004432EB;
	Mon, 17 Aug 2026 15:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979782; cv=none; b=iz/DtrXavBpXMs97f/qQZ+6ZHPYOIgdinRX24CLOOJTOFDKQWN0bhDxPZeBcusZHXG9mrjoKRzuXagae8Lgt9nnOPOe5yCBLfk16YmfytSOu4scKXfwg8myVqYR5BgdgPrG+E5NFGIOfgPvpRBr/kpgIa/Dpwg1CWENS6Nec+tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979782; c=relaxed/simple;
	bh=csJRrgmw7/vjD3PnBqB7wsZmWFu8LfwhBnNfNSrIUtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoIwVgkbgaIfHlRSn35A6CjONCKC8UHasVxGagaKmsE0u23src7nCTuZHLH6qia0QEmYfA527HpEFkt0k5jpFbP6zB8eQvG28gWRjxGcEbuOksCYLIvLhpZF2FPgCYGMWigq+4PEMJQbiJKan6fO53KyH8svAchnCFXE6b9LP4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiwzNlwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiwzNlwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9619E1F00A3A;
	Mon, 17 Aug 2026 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979777;
	bh=EY+yF5I6BC5ZwKOrp7JaW6CKcMAOxg45HUSnvHCvTEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiwzNlwAjsgHRX5vg3ym5jEPm2MWcboxLKTbKMV1/vdD9E1qWM+gNyHYjaShK/nR+
	 REMQGh/BJef4ZaoWEePUx3VWDrfi6L8eHY3hxR4ogb8AFp64Ossafhtlq4a7X2USRO
	 IJFigST3M37xh/SC6gq8GQDcJIqHsh6U8aFWA4ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Khalifa <ahmad@khalifa.ws>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 344/609] hwmon: (nct6775) Add support for 18 IN readings for nct6799
Date: Mon, 17 Aug 2026 15:30:40 +0200
Message-ID: <20260817132555.776291112@linuxfoundation.org>
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

[ Upstream commit 4f65c15cf70eb22c074889af60b9d2bcffbb375a ]

* Add additional VIN/IN_MIN/IN_MAX register values
* Separate ALARM/BEEP bits for nct6799
* Update scaling factors for nct6799

Registers/alarms match for NCT6796D-S and NCT6799D-R
Tested on NCT6799D-R for new IN/MIN/MAX and ALARMS

Signed-off-by: Ahmad Khalifa <ahmad@khalifa.ws>
Link: https://lore.kernel.org/r/20230719224142.411237-1-ahmad@khalifa.ws
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: b0e8adb2ccb4 ("hwmon: (nct6775-core) Fix number of temperature registers for NCT6116")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 51 +++++++++++++++++++++++++++++-------
 drivers/hwmon/nct6775.h      |  5 ++--
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index 34b13194c91c5..c2deff486ef3c 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -79,14 +79,17 @@ static const char * const nct6775_device_names[] = {
 
 /* Common and NCT6775 specific data */
 
-/* Voltage min/max registers for nr=7..14 are in bank 5 */
+/*
+ * Voltage min/max registers for nr=7..14 are in bank 5
+ * min/max: 15-17 for NCT6799 only
+ */
 
 static const u16 NCT6775_REG_IN_MAX[] = {
 	0x2b, 0x2d, 0x2f, 0x31, 0x33, 0x35, 0x37, 0x554, 0x556, 0x558, 0x55a,
-	0x55c, 0x55e, 0x560, 0x562 };
+	0x55c, 0x55e, 0x560, 0x562, 0x564, 0x570, 0x572 };
 static const u16 NCT6775_REG_IN_MIN[] = {
 	0x2c, 0x2e, 0x30, 0x32, 0x34, 0x36, 0x38, 0x555, 0x557, 0x559, 0x55b,
-	0x55d, 0x55f, 0x561, 0x563 };
+	0x55d, 0x55f, 0x561, 0x563, 0x565, 0x571, 0x573 };
 static const u16 NCT6775_REG_IN[] = {
 	0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x550, 0x551, 0x552
 };
@@ -255,7 +258,8 @@ static const s8 NCT6776_ALARM_BITS[NUM_ALARM_BITS] = {
 	12,  9,						  /* intr0-intr1  */
 };
 
-static const u16 NCT6776_REG_BEEP[NUM_REG_BEEP] = { 0xb2, 0xb3, 0xb4, 0xb5 };
+/* 0xbf: nct6799 only */
+static const u16 NCT6776_REG_BEEP[NUM_REG_BEEP] = { 0xb2, 0xb3, 0xb4, 0xb5, 0xbf };
 
 static const s8 NCT6776_BEEP_BITS[NUM_BEEP_BITS] = {
 	 0,  1,  2,  3,  4,  5,  6,  7,  8, -1, -1, -1,	  /* in0-in11     */
@@ -327,9 +331,16 @@ static const u16 NCT6776_REG_TSI_TEMP[] = {
 
 /* NCT6779 specific data */
 
+/*
+ * 15-17 for NCT6799 only, register labels are:
+ *      CPUVC,  VIN1,  AVSB,  3VCC,  VIN0,  VIN8,  VIN4, 3VSB
+ *       VBAT,   VTT,  VIN5,  VIN6,  VIN2,  VIN3,  VIN7, VIN9
+ *       VHIF, VIN10
+ */
 static const u16 NCT6779_REG_IN[] = {
 	0x480, 0x481, 0x482, 0x483, 0x484, 0x485, 0x486, 0x487,
-	0x488, 0x489, 0x48a, 0x48b, 0x48c, 0x48d, 0x48e };
+	0x488, 0x489, 0x48a, 0x48b, 0x48c, 0x48d, 0x48e, 0x48f,
+	0x470, 0x471};
 
 static const u16 NCT6779_REG_ALARM[NUM_REG_ALARM] = {
 	0x459, 0x45A, 0x45B, 0x568 };
@@ -643,6 +654,22 @@ static const char *const nct6798_temp_label[] = {
 #define NCT6798_TEMP_MASK	0xbfff0ffe
 #define NCT6798_VIRT_TEMP_MASK	0x80000c00
 
+static const s8 NCT6799_ALARM_BITS[NUM_ALARM_BITS] = {
+	 0,  1,  2,  3,  8, -1, 20, 16, 17, 24, 25, 26,	  /* in0-in11     */
+	27, 28, 29, 30, 31, -1, -1, -1, -1, -1, -1, -1,	  /* in12-in23    */
+	 6,  7, 11, 10, 23, 33, -1, -1, -1, -1, -1, -1,	  /* fan1-fan12   */
+	 4,  5, 13, -1, -1, -1, -1, -1, -1, -1, -1, -1,	  /* temp1-temp12 */
+	12,  9,						  /* intr0-intr1  */
+};
+
+static const s8 NCT6799_BEEP_BITS[NUM_BEEP_BITS] = {
+	 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11,	  /* in0-in11     */
+	12, 13, 14, 15, 34, 35, -1, -1, -1, -1, -1, -1,	  /* in12-in23    */
+	25, 26, 27, 28, 29, -1, -1, -1, -1, -1, -1, -1,	  /* fan1-fan12   */
+	16, 17, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,	  /* temp1-temp12 */
+	30, 31, 24					  /* intr0-intr1, beep_en */
+};
+
 static const char *const nct6799_temp_label[] = {
 	"",
 	"SYSTIN",
@@ -937,12 +964,12 @@ static const u16 scale_in[15] = {
 /*
  * NCT6798 scaling:
  *    CPUVC, IN1, AVSB, 3VCC, IN0, IN8, IN4, 3VSB, VBAT,  VTT,  IN5,  IN6, IN2,
- *      IN3, IN7
- * Additional scales to be added later: IN9 (800), VHIF (1600)
+ *      IN3, IN7,  IN9, VHIF, IN10
+ * 15-17 for NCT6799 only
  */
-static const u16 scale_in_6798[15] = {
+static const u16 scale_in_6798[NUM_IN] = {
 	800, 800, 1600, 1600, 800, 800, 800, 1600, 1600, 1600, 1600, 1600, 800,
-	800, 800
+	800, 800,  800, 1600, 800
 };
 
 static inline long in_from_reg(u8 reg, u8 nr, const u16 *scales)
@@ -3970,7 +3997,13 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		case nct6796:
 		case nct6797:
 		case nct6798:
+			data->REG_TSI_TEMP = NCT6796_REG_TSI_TEMP;
+			num_reg_tsi_temp = ARRAY_SIZE(NCT6796_REG_TSI_TEMP);
+			break;
 		case nct6799:
+			data->in_num = 18;
+			data->ALARM_BITS = NCT6799_ALARM_BITS;
+			data->BEEP_BITS = NCT6799_BEEP_BITS;
 			data->REG_TSI_TEMP = NCT6796_REG_TSI_TEMP;
 			num_reg_tsi_temp = ARRAY_SIZE(NCT6796_REG_TSI_TEMP);
 			break;
diff --git a/drivers/hwmon/nct6775.h b/drivers/hwmon/nct6775.h
index c752bc7bbe722..edcde39c47915 100644
--- a/drivers/hwmon/nct6775.h
+++ b/drivers/hwmon/nct6775.h
@@ -16,6 +16,7 @@ enum pwm_enable { off, manual, thermal_cruise, speed_cruise, sf3, sf4 };
 #define NUM_REG_BEEP	5	/* Max number of beep registers */
 
 #define NUM_FAN		7
+#define NUM_IN		18
 
 struct nct6775_data {
 	int addr;	/* IO base of hw monitor block */
@@ -97,7 +98,7 @@ struct nct6775_data {
 	/* Register values */
 	u8 bank;		/* current register bank */
 	u8 in_num;		/* number of in inputs we have */
-	u8 in[15][3];		/* [0]=in, [1]=in_max, [2]=in_min */
+	u8 in[NUM_IN][3];	/* [0]=in, [1]=in_max, [2]=in_min */
 	const u16 *scale_in;	/* internal scaling factors */
 	unsigned int rpm[NUM_FAN];
 	u16 fan_min[NUM_FAN];
@@ -166,7 +167,7 @@ struct nct6775_data {
 	u16 have_temp;
 	u16 have_temp_fixed;
 	u16 have_tsi_temp;
-	u16 have_in;
+	u32 have_in;
 
 	/* Remember extra register values over suspend/resume */
 	u8 vbat;
-- 
2.53.0



