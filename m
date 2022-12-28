Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BF223AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B3BC433EF;
	Wed, 28 Dec 2022 16:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246674;
	bh=hikALMhCr119baUZq1pQ/utGrr8+EJvZn7py4V8ykH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydcYMkbozeFc8p17ZXra88R/5rXbfacal75iRYJaeJzIE9DhWlsafRMxfj1X3Jbwn
	 7JZFHUuEzOD0eEEQ7P/PBAhyO2MRp/LTN+2y8A3C6sUtN81ttGAyMe4Wlan2Ujktxm
	 1auQ9VrfQjkFCNRIQvRfwhSax9robVAb3Ev4ilMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Mattijs Korpershoek <mkorpershoek@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1094/1146] Input: iqs7222 - add support for IQS7222A v1.13+
Date: Wed, 28 Dec 2022 15:43:53 +0100
Message-Id: <20221228144359.889486622@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 8d4c313c03f104c69e25ab03058d8955be9dc387 ]

IQS7222A revisions 1.13 and later widen the gesture multiplier from
x4 ms to x16 ms. Add a means to scale the gesture timings specified
in the device tree based on the revision of the device.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/Y1SRdbK1Dp2q7O8o@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs7222.c | 111 +++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index 6af25dfd1d2a..e47ab6c1177f 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -86,7 +86,9 @@ enum iqs7222_reg_key_id {
 	IQS7222_REG_KEY_TOUCH,
 	IQS7222_REG_KEY_DEBOUNCE,
 	IQS7222_REG_KEY_TAP,
+	IQS7222_REG_KEY_TAP_LEGACY,
 	IQS7222_REG_KEY_AXIAL,
+	IQS7222_REG_KEY_AXIAL_LEGACY,
 	IQS7222_REG_KEY_WHEEL,
 	IQS7222_REG_KEY_NO_WHEEL,
 	IQS7222_REG_KEY_RESERVED
@@ -202,10 +204,68 @@ struct iqs7222_dev_desc {
 	int allow_offset;
 	int event_offset;
 	int comms_offset;
+	bool legacy_gesture;
 	struct iqs7222_reg_grp_desc reg_grps[IQS7222_NUM_REG_GRPS];
 };
 
 static const struct iqs7222_dev_desc iqs7222_devs[] = {
+	{
+		.prod_num = IQS7222_PROD_NUM_A,
+		.fw_major = 1,
+		.fw_minor = 13,
+		.sldr_res = U8_MAX * 16,
+		.touch_link = 1768,
+		.allow_offset = 9,
+		.event_offset = 10,
+		.comms_offset = 12,
+		.reg_grps = {
+			[IQS7222_REG_GRP_STAT] = {
+				.base = IQS7222_SYS_STATUS,
+				.num_row = 1,
+				.num_col = 8,
+			},
+			[IQS7222_REG_GRP_CYCLE] = {
+				.base = 0x8000,
+				.num_row = 7,
+				.num_col = 3,
+			},
+			[IQS7222_REG_GRP_GLBL] = {
+				.base = 0x8700,
+				.num_row = 1,
+				.num_col = 3,
+			},
+			[IQS7222_REG_GRP_BTN] = {
+				.base = 0x9000,
+				.num_row = 12,
+				.num_col = 3,
+			},
+			[IQS7222_REG_GRP_CHAN] = {
+				.base = 0xA000,
+				.num_row = 12,
+				.num_col = 6,
+			},
+			[IQS7222_REG_GRP_FILT] = {
+				.base = 0xAC00,
+				.num_row = 1,
+				.num_col = 2,
+			},
+			[IQS7222_REG_GRP_SLDR] = {
+				.base = 0xB000,
+				.num_row = 2,
+				.num_col = 11,
+			},
+			[IQS7222_REG_GRP_GPIO] = {
+				.base = 0xC000,
+				.num_row = 1,
+				.num_col = 3,
+			},
+			[IQS7222_REG_GRP_SYS] = {
+				.base = IQS7222_SYS_SETUP,
+				.num_row = 1,
+				.num_col = 13,
+			},
+		},
+	},
 	{
 		.prod_num = IQS7222_PROD_NUM_A,
 		.fw_major = 1,
@@ -215,6 +275,7 @@ static const struct iqs7222_dev_desc iqs7222_devs[] = {
 		.allow_offset = 9,
 		.event_offset = 10,
 		.comms_offset = 12,
+		.legacy_gesture = true,
 		.reg_grps = {
 			[IQS7222_REG_GRP_STAT] = {
 				.base = IQS7222_SYS_STATUS,
@@ -874,6 +935,16 @@ static const struct iqs7222_prop_desc iqs7222_props[] = {
 		.reg_offset = 9,
 		.reg_shift = 8,
 		.reg_width = 8,
+		.val_pitch = 16,
+		.label = "maximum gesture time",
+	},
+	{
+		.name = "azoteq,gesture-max-ms",
+		.reg_grp = IQS7222_REG_GRP_SLDR,
+		.reg_key = IQS7222_REG_KEY_TAP_LEGACY,
+		.reg_offset = 9,
+		.reg_shift = 8,
+		.reg_width = 8,
 		.val_pitch = 4,
 		.label = "maximum gesture time",
 	},
@@ -884,6 +955,16 @@ static const struct iqs7222_prop_desc iqs7222_props[] = {
 		.reg_offset = 9,
 		.reg_shift = 3,
 		.reg_width = 5,
+		.val_pitch = 16,
+		.label = "minimum gesture time",
+	},
+	{
+		.name = "azoteq,gesture-min-ms",
+		.reg_grp = IQS7222_REG_GRP_SLDR,
+		.reg_key = IQS7222_REG_KEY_TAP_LEGACY,
+		.reg_offset = 9,
+		.reg_shift = 3,
+		.reg_width = 5,
 		.val_pitch = 4,
 		.label = "minimum gesture time",
 	},
@@ -897,6 +978,16 @@ static const struct iqs7222_prop_desc iqs7222_props[] = {
 		.val_pitch = 16,
 		.label = "gesture distance",
 	},
+	{
+		.name = "azoteq,gesture-dist",
+		.reg_grp = IQS7222_REG_GRP_SLDR,
+		.reg_key = IQS7222_REG_KEY_AXIAL_LEGACY,
+		.reg_offset = 10,
+		.reg_shift = 8,
+		.reg_width = 8,
+		.val_pitch = 16,
+		.label = "gesture distance",
+	},
 	{
 		.name = "azoteq,gesture-max-ms",
 		.reg_grp = IQS7222_REG_GRP_SLDR,
@@ -904,6 +995,16 @@ static const struct iqs7222_prop_desc iqs7222_props[] = {
 		.reg_offset = 10,
 		.reg_shift = 0,
 		.reg_width = 8,
+		.val_pitch = 16,
+		.label = "maximum gesture time",
+	},
+	{
+		.name = "azoteq,gesture-max-ms",
+		.reg_grp = IQS7222_REG_GRP_SLDR,
+		.reg_key = IQS7222_REG_KEY_AXIAL_LEGACY,
+		.reg_offset = 10,
+		.reg_shift = 0,
+		.reg_width = 8,
 		.val_pitch = 4,
 		.label = "maximum gesture time",
 	},
@@ -2115,8 +2216,18 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222,
 		if (!event_node)
 			continue;
 
+		/*
+		 * Depending on the device, gestures are either offered using
+		 * one of two timing resolutions, or are not supported at all.
+		 */
 		if (reg_offset)
 			reg_key = IQS7222_REG_KEY_RESERVED;
+		else if (dev_desc->legacy_gesture &&
+			 iqs7222_sl_events[i].reg_key == IQS7222_REG_KEY_TAP)
+			reg_key = IQS7222_REG_KEY_TAP_LEGACY;
+		else if (dev_desc->legacy_gesture &&
+			 iqs7222_sl_events[i].reg_key == IQS7222_REG_KEY_AXIAL)
+			reg_key = IQS7222_REG_KEY_AXIAL_LEGACY;
 		else
 			reg_key = iqs7222_sl_events[i].reg_key;
 
-- 
2.35.1



