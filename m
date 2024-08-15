Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34ED1714A8;
	Thu, 15 Aug 2024 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729115; cv=none; b=EEAwn6Z9zPOE+bpSTiNH3Ks1nxvYzVHjhF6vhB3bl5OueTOhY9apsqhQIbXSBiC7PEPBdmDUmRotz5arPSKz8mjXjOnH1rN7Hd0etdseu2kFDb+0E90yCq/OBu9YZ2RujCq5EH3bKdQ3S6oZ4m1uX24FNzpJfBspnSqA9Dw44D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729115; c=relaxed/simple;
	bh=s18Y2g7iaePcNNXnnLNPHbPs/ZG2h5k0C5N5Qr4kHv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqrB6Ifd4dhAp82kou3LKqt/3rLZhsP4L083czZSmIWOFtEh2MIZdWgAacrPH/dFmlVXJOuU7mnX6KM0aBOZyS+9wyGvrAsIleiUUXQWGk2K8Y+otttef1WjMt4ummKFFzD6uBxqnn6aDKU6oKa5Ta4sra6wWWPoABZIkDmJpts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBbG5hnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBbG5hnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEA0C32786;
	Thu, 15 Aug 2024 13:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729114;
	bh=s18Y2g7iaePcNNXnnLNPHbPs/ZG2h5k0C5N5Qr4kHv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBbG5hnNbQ4L3ADWgvF+dRZyGO/LjwzvqXCn5Ul02jHWZOU1p2Os09iJ2iJFPcrUa
	 +oGPe0SNSMhmMAR32SnQPl0iecsHn2B03Zia4cltwuwWhkcLn2IgJ8B9n97K1/qy/f
	 /clO6oUijPotYDohlGds2JwmQLgLqUk30DGJ5X4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 19/22] platform/x86: ideapad-laptop: add a mutex to synchronize VPC commands
Date: Thu, 15 Aug 2024 15:25:27 +0200
Message-ID: <20240815131831.997389189@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit 7cc06e729460a209b84d3db4db56c9f85f048cc2 ]

Calling VPC commands consists of several VPCW and VPCR ACPI calls.
These calls and their results can get mixed up if they are called
simultaneously from different threads, like acpi notify handler,
sysfs, debugfs, notification chain.

The commit e2ffcda16290 ("ACPI: OSL: Allow Notify () handlers to run on
all CPUs") made the race issues much worse than before it but some
races were possible even before that commit.

Add a mutex to synchronize VPC commands.

Fixes: e2ffcda16290 ("ACPI: OSL: Allow Notify () handlers to run on all CPUs")
Fixes: e82882cdd241 ("platform/x86: Add driver for Yoga Tablet Mode switch")
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/f26782fa1194ad11ed5d9ba121a804e59b58b026.1721898747.git.soyer@irl.hu
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 64 ++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 96e1caf549c43..490815917adec 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -125,6 +125,7 @@ struct ideapad_rfk_priv {
 
 struct ideapad_private {
 	struct acpi_device *adev;
+	struct mutex vpc_mutex; /* protects the VPC calls */
 	struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
 	struct ideapad_rfk_priv rfk_priv[IDEAPAD_RFKILL_DEV_NUM];
 	struct platform_device *platform_device;
@@ -304,6 +305,8 @@ static int debugfs_status_show(struct seq_file *s, void *data)
 	struct ideapad_private *priv = s->private;
 	unsigned long value;
 
+	guard(mutex)(&priv->vpc_mutex);
+
 	if (!read_ec_data(priv->adev->handle, VPCCMD_R_BL_MAX, &value))
 		seq_printf(s, "Backlight max:  %lu\n", value);
 	if (!read_ec_data(priv->adev->handle, VPCCMD_R_BL, &value))
@@ -422,7 +425,8 @@ static ssize_t camera_power_show(struct device *dev,
 	unsigned long result;
 	int err;
 
-	err = read_ec_data(priv->adev->handle, VPCCMD_R_CAMERA, &result);
+	scoped_guard(mutex, &priv->vpc_mutex)
+		err = read_ec_data(priv->adev->handle, VPCCMD_R_CAMERA, &result);
 	if (err)
 		return err;
 
@@ -441,7 +445,8 @@ static ssize_t camera_power_store(struct device *dev,
 	if (err)
 		return err;
 
-	err = write_ec_cmd(priv->adev->handle, VPCCMD_W_CAMERA, state);
+	scoped_guard(mutex, &priv->vpc_mutex)
+		err = write_ec_cmd(priv->adev->handle, VPCCMD_W_CAMERA, state);
 	if (err)
 		return err;
 
@@ -494,7 +499,8 @@ static ssize_t fan_mode_show(struct device *dev,
 	unsigned long result;
 	int err;
 
-	err = read_ec_data(priv->adev->handle, VPCCMD_R_FAN, &result);
+	scoped_guard(mutex, &priv->vpc_mutex)
+		err = read_ec_data(priv->adev->handle, VPCCMD_R_FAN, &result);
 	if (err)
 		return err;
 
@@ -516,7 +522,8 @@ static ssize_t fan_mode_store(struct device *dev,
 	if (state > 4 || state == 3)
 		return -EINVAL;
 
-	err = write_ec_cmd(priv->adev->handle, VPCCMD_W_FAN, state);
+	scoped_guard(mutex, &priv->vpc_mutex)
+		err = write_ec_cmd(priv->adev->handle, VPCCMD_W_FAN, state);
 	if (err)
 		return err;
 
@@ -601,7 +608,8 @@ static ssize_t touchpad_show(struct device *dev,
 	unsigned long result;
 	int err;
 
-	err = read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &result);
+	scoped_guard(mutex, &priv->vpc_mutex)
+		err = read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &result);
 	if (err)
 		return err;
 
@@ -622,7 +630,8 @@ static ssize_t touchpad_store(struct device *dev,
 	if (err)
 		return err;
 
-	err = write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, state);
+	scoped_guard(mutex, &priv->vpc_mutex)
+		err = write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, state);
 	if (err)
 		return err;
 
@@ -1019,6 +1028,8 @@ static int ideapad_rfk_set(void *data, bool blocked)
 	struct ideapad_rfk_priv *priv = data;
 	int opcode = ideapad_rfk_data[priv->dev].opcode;
 
+	guard(mutex)(&priv->priv->vpc_mutex);
+
 	return write_ec_cmd(priv->priv->adev->handle, opcode, !blocked);
 }
 
@@ -1032,6 +1043,8 @@ static void ideapad_sync_rfk_state(struct ideapad_private *priv)
 	int i;
 
 	if (priv->features.hw_rfkill_switch) {
+		guard(mutex)(&priv->vpc_mutex);
+
 		if (read_ec_data(priv->adev->handle, VPCCMD_R_RF, &hw_blocked))
 			return;
 		hw_blocked = !hw_blocked;
@@ -1205,8 +1218,9 @@ static void ideapad_input_novokey(struct ideapad_private *priv)
 {
 	unsigned long long_pressed;
 
-	if (read_ec_data(priv->adev->handle, VPCCMD_R_NOVO, &long_pressed))
-		return;
+	scoped_guard(mutex, &priv->vpc_mutex)
+		if (read_ec_data(priv->adev->handle, VPCCMD_R_NOVO, &long_pressed))
+			return;
 
 	if (long_pressed)
 		ideapad_input_report(priv, 17);
@@ -1218,8 +1232,9 @@ static void ideapad_check_special_buttons(struct ideapad_private *priv)
 {
 	unsigned long bit, value;
 
-	if (read_ec_data(priv->adev->handle, VPCCMD_R_SPECIAL_BUTTONS, &value))
-		return;
+	scoped_guard(mutex, &priv->vpc_mutex)
+		if (read_ec_data(priv->adev->handle, VPCCMD_R_SPECIAL_BUTTONS, &value))
+			return;
 
 	for_each_set_bit (bit, &value, 16) {
 		switch (bit) {
@@ -1252,6 +1267,8 @@ static int ideapad_backlight_get_brightness(struct backlight_device *blightdev)
 	unsigned long now;
 	int err;
 
+	guard(mutex)(&priv->vpc_mutex);
+
 	err = read_ec_data(priv->adev->handle, VPCCMD_R_BL, &now);
 	if (err)
 		return err;
@@ -1264,6 +1281,8 @@ static int ideapad_backlight_update_status(struct backlight_device *blightdev)
 	struct ideapad_private *priv = bl_get_data(blightdev);
 	int err;
 
+	guard(mutex)(&priv->vpc_mutex);
+
 	err = write_ec_cmd(priv->adev->handle, VPCCMD_W_BL,
 			   blightdev->props.brightness);
 	if (err)
@@ -1341,6 +1360,8 @@ static void ideapad_backlight_notify_power(struct ideapad_private *priv)
 	if (!blightdev)
 		return;
 
+	guard(mutex)(&priv->vpc_mutex);
+
 	if (read_ec_data(priv->adev->handle, VPCCMD_R_BL_POWER, &power))
 		return;
 
@@ -1353,7 +1374,8 @@ static void ideapad_backlight_notify_brightness(struct ideapad_private *priv)
 
 	/* if we control brightness via acpi video driver */
 	if (!priv->blightdev)
-		read_ec_data(priv->adev->handle, VPCCMD_R_BL, &now);
+		scoped_guard(mutex, &priv->vpc_mutex)
+			read_ec_data(priv->adev->handle, VPCCMD_R_BL, &now);
 	else
 		backlight_force_update(priv->blightdev, BACKLIGHT_UPDATE_HOTKEY);
 }
@@ -1578,7 +1600,8 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_
 	int ret;
 
 	/* Without reading from EC touchpad LED doesn't switch state */
-	ret = read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value);
+	scoped_guard(mutex, &priv->vpc_mutex)
+		ret = read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value);
 	if (ret)
 		return;
 
@@ -1638,7 +1661,8 @@ static void ideapad_laptop_trigger_ec(void)
 	if (!priv->features.ymc_ec_trigger)
 		return;
 
-	ret = write_ec_cmd(priv->adev->handle, VPCCMD_W_YMC, 1);
+	scoped_guard(mutex, &priv->vpc_mutex)
+		ret = write_ec_cmd(priv->adev->handle, VPCCMD_W_YMC, 1);
 	if (ret)
 		dev_warn(&priv->platform_device->dev, "Could not write YMC: %d\n", ret);
 }
@@ -1684,11 +1708,13 @@ static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
 	struct ideapad_private *priv = data;
 	unsigned long vpc1, vpc2, bit;
 
-	if (read_ec_data(handle, VPCCMD_R_VPC1, &vpc1))
-		return;
+	scoped_guard(mutex, &priv->vpc_mutex) {
+		if (read_ec_data(handle, VPCCMD_R_VPC1, &vpc1))
+			return;
 
-	if (read_ec_data(handle, VPCCMD_R_VPC2, &vpc2))
-		return;
+		if (read_ec_data(handle, VPCCMD_R_VPC2, &vpc2))
+			return;
+	}
 
 	vpc1 = (vpc2 << 8) | vpc1;
 
@@ -1997,6 +2023,10 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	priv->adev = adev;
 	priv->platform_device = pdev;
 
+	err = devm_mutex_init(&pdev->dev, &priv->vpc_mutex);
+	if (err)
+		return err;
+
 	ideapad_check_features(priv);
 
 	err = ideapad_sysfs_init(priv);
-- 
2.43.0



