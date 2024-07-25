Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31BD199E9F;
	Thu, 25 Jul 2024 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918539; cv=none; b=ORTjq3PEP6DPObk92yIJI5yRhZ1kg7/xoRwHr54rmNzhUZaQLF4BCYWcaIf80XnQoyRVsmwZ2Ye6GGIUe6Suc3zQRK1PaEsf97o/ci08KbMG6JRkRpeSupoUEMVWZOnOyE5X7R/IaCSap9hKBJcBpN3Vxgw3lPplZR6gpFpZaoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918539; c=relaxed/simple;
	bh=6hKUm/45m+I1/lB3c0+YNth86MlUfBdQ4ruIOygwXfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ax6w+xBP4gq6jvgzmnSZGMm6DpQK77VvA5CwzYQ5VXR70PIS1UEOAmk864RP24aTu7/NTsMhVASqOd2q2zsnJWXGGtk8R9+isE20XdsKLZoDmR/eOo/55tO0W4Fqgiv0jO46k78zxIOvuxBR8kQco3wueDTphQk4tBtYN6owgBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQCGQKTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQCGQKTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3837FC116B1;
	Thu, 25 Jul 2024 14:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918539;
	bh=6hKUm/45m+I1/lB3c0+YNth86MlUfBdQ4ruIOygwXfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQCGQKTRRU0uSNimV5C7Pl8We9aAebVNzwwytpiY5/x7BTC5Es8+R+snrMhOVnOLq
	 RKrV/3H2k77eI+oOsdbWs3JORk2E3CoQxZiFWyhUrHNA7tPKwiYc+Cxxj+DkBhU/3V
	 aLtAd1EdewrRwkzGHx7uWoEGbDoopnJ7l4lF1sI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/43] Input: silead - Always support 10 fingers
Date: Thu, 25 Jul 2024 16:36:31 +0200
Message-ID: <20240725142730.789346612@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 38a38f5a36da9820680d413972cb733349400532 ]

When support for Silead touchscreens was orginal added some touchscreens
with older firmware versions only supported 5 fingers and this was made
the default requiring the setting of a "silead,max-fingers=10" uint32
device-property for all touchscreen models which do support 10 fingers.

There are very few models with the old 5 finger fw, so in practice the
setting of the "silead,max-fingers=10" is boilerplate which needs to
be copy and pasted to every touchscreen config.

Reporting that 10 fingers are supported on devices which only support
5 fingers doesn't cause any problems for userspace in practice, since
at max 4 finger gestures are supported anyways. Drop the max_fingers
configuration and simply always assume 10 fingers.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/20240525193854.39130-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/silead.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/input/touchscreen/silead.c b/drivers/input/touchscreen/silead.c
index c8776146f1d1b..467feacdbd7a2 100644
--- a/drivers/input/touchscreen/silead.c
+++ b/drivers/input/touchscreen/silead.c
@@ -70,7 +70,6 @@ struct silead_ts_data {
 	struct regulator_bulk_data regulators[2];
 	char fw_name[64];
 	struct touchscreen_properties prop;
-	u32 max_fingers;
 	u32 chip_id;
 	struct input_mt_pos pos[SILEAD_MAX_FINGERS];
 	int slots[SILEAD_MAX_FINGERS];
@@ -98,7 +97,7 @@ static int silead_ts_request_input_dev(struct silead_ts_data *data)
 	input_set_abs_params(data->input, ABS_MT_POSITION_Y, 0, 4095, 0, 0);
 	touchscreen_parse_properties(data->input, true, &data->prop);
 
-	input_mt_init_slots(data->input, data->max_fingers,
+	input_mt_init_slots(data->input, SILEAD_MAX_FINGERS,
 			    INPUT_MT_DIRECT | INPUT_MT_DROP_UNUSED |
 			    INPUT_MT_TRACK);
 
@@ -145,10 +144,10 @@ static void silead_ts_read_data(struct i2c_client *client)
 		return;
 	}
 
-	if (buf[0] > data->max_fingers) {
+	if (buf[0] > SILEAD_MAX_FINGERS) {
 		dev_warn(dev, "More touches reported then supported %d > %d\n",
-			 buf[0], data->max_fingers);
-		buf[0] = data->max_fingers;
+			 buf[0], SILEAD_MAX_FINGERS);
+		buf[0] = SILEAD_MAX_FINGERS;
 	}
 
 	touch_nr = 0;
@@ -200,7 +199,6 @@ static void silead_ts_read_data(struct i2c_client *client)
 
 static int silead_ts_init(struct i2c_client *client)
 {
-	struct silead_ts_data *data = i2c_get_clientdata(client);
 	int error;
 
 	error = i2c_smbus_write_byte_data(client, SILEAD_REG_RESET,
@@ -210,7 +208,7 @@ static int silead_ts_init(struct i2c_client *client)
 	usleep_range(SILEAD_CMD_SLEEP_MIN, SILEAD_CMD_SLEEP_MAX);
 
 	error = i2c_smbus_write_byte_data(client, SILEAD_REG_TOUCH_NR,
-					data->max_fingers);
+					  SILEAD_MAX_FINGERS);
 	if (error)
 		goto i2c_write_err;
 	usleep_range(SILEAD_CMD_SLEEP_MIN, SILEAD_CMD_SLEEP_MAX);
@@ -437,13 +435,6 @@ static void silead_ts_read_props(struct i2c_client *client)
 	const char *str;
 	int error;
 
-	error = device_property_read_u32(dev, "silead,max-fingers",
-					 &data->max_fingers);
-	if (error) {
-		dev_dbg(dev, "Max fingers read error %d\n", error);
-		data->max_fingers = 5; /* Most devices handle up-to 5 fingers */
-	}
-
 	error = device_property_read_string(dev, "firmware-name", &str);
 	if (!error)
 		snprintf(data->fw_name, sizeof(data->fw_name),
-- 
2.43.0



