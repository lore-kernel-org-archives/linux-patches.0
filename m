Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E05C224B01;
	Mon, 23 Jun 2025 22:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716647; cv=none; b=Oixvk9MlfH0ZCnNwJpHAaOa7+Ybi5UGM6qJaGiHrKABabQnCcGjaT2HD+TjfMcTOt6p41DXcGZv05Oz1PiNmYhh+e/Nhhvlh9uMSl2zrj1yuU9w6f4MC1l6sKv5DJboMWX8kKibt/gvIQfWFSCA8MwS7q+tV+emb9O0an0AUbAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716647; c=relaxed/simple;
	bh=hsFUNYkbto6fByHwa1+5UPgh0lvs+3Xs73/ZzWFSpMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmNHr9qV9II8vYH/6+yxUfYE8FUtSulRsho3L395U412ZpI6SStMe/2v/LPRVM9nO0snTLB7NOTdFW9t1/Jd+9LHLAQMnqY9+sEpts9BSwKVQx4acutlrLL2kilxyBF4JRtfjIc8o7kffiEtROWhbY/7EZfOwrVrk8tl/9OReCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SU1ySfQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SU1ySfQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4ABC4CEEA;
	Mon, 23 Jun 2025 22:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716647;
	bh=hsFUNYkbto6fByHwa1+5UPgh0lvs+3Xs73/ZzWFSpMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SU1ySfQ12dhyruB7PUGAHcJ99+OtMFoZ5qltjogSeCtoUqfUtybk1xOnyJjWtXTTh
	 U1sJZG/vGosJHu7lGNILXu8wJiMq4Evca9pDj2m753/UDc2M6b5wc5FCOPsXZm8bUU
	 em8pF690wlX1a/M3EUS0PpefNOR3i5U2c+615bFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 279/290] platform/loongarch: laptop: Add backlight power control support
Date: Mon, 23 Jun 2025 15:09:00 +0200
Message-ID: <20250623130635.314390752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

commit 53c762b47f726e4079a1f06f684bce2fc0d56fba upstream.

loongson_laptop_turn_{on,off}_backlight() are designed for controlling
the power of the backlight, but they aren't really used in the driver
previously.

Unify these two functions since they only differ in arguments passed to
ACPI method, and wire up loongson_laptop_backlight_update() to update
the power state of the backlight as well. Tested on the TongFang L860-T2
Loongson-3A5000 laptop.

Cc: stable@vger.kernel.org
Fixes: 6246ed09111f ("LoongArch: Add ACPI-based generic laptop driver")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/loongarch/loongson-laptop.c |   73 +++++++++++++--------------
 1 file changed, 37 insertions(+), 36 deletions(-)

--- a/drivers/platform/loongarch/loongson-laptop.c
+++ b/drivers/platform/loongarch/loongson-laptop.c
@@ -56,8 +56,7 @@ static struct input_dev *generic_inputde
 static acpi_handle hotkey_handle;
 static struct key_entry hotkey_keycode_map[GENERIC_HOTKEY_MAP_MAX];
 
-int loongson_laptop_turn_on_backlight(void);
-int loongson_laptop_turn_off_backlight(void);
+static bool bl_powered;
 static int loongson_laptop_backlight_update(struct backlight_device *bd);
 
 /* 2. ACPI Helpers and device model */
@@ -354,16 +353,42 @@ static int ec_backlight_level(u8 level)
 	return level;
 }
 
+static int ec_backlight_set_power(bool state)
+{
+	int status;
+	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
+	struct acpi_object_list args = { 1, &arg0 };
+
+	arg0.integer.value = state;
+	status = acpi_evaluate_object(NULL, "\\BLSW", &args, NULL);
+	if (ACPI_FAILURE(status)) {
+		pr_info("Loongson lvds error: 0x%x\n", status);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int loongson_laptop_backlight_update(struct backlight_device *bd)
 {
-	int lvl = ec_backlight_level(bd->props.brightness);
+	bool target_powered = !backlight_is_blank(bd);
+	int ret = 0, lvl = ec_backlight_level(bd->props.brightness);
 
 	if (lvl < 0)
 		return -EIO;
+
 	if (ec_set_brightness(lvl))
 		return -EIO;
 
-	return 0;
+	if (target_powered != bl_powered) {
+		ret = ec_backlight_set_power(target_powered);
+		if (ret < 0)
+			return ret;
+
+		bl_powered = target_powered;
+	}
+
+	return ret;
 }
 
 static int loongson_laptop_get_brightness(struct backlight_device *bd)
@@ -384,7 +409,7 @@ static const struct backlight_ops backli
 
 static int laptop_backlight_register(void)
 {
-	int status = 0;
+	int status = 0, ret;
 	struct backlight_properties props;
 
 	memset(&props, 0, sizeof(props));
@@ -392,44 +417,20 @@ static int laptop_backlight_register(voi
 	if (!acpi_evalf(hotkey_handle, &status, "ECLL", "d"))
 		return -EIO;
 
+	ret = ec_backlight_set_power(true);
+	if (ret)
+		return ret;
+
+	bl_powered = true;
+
 	props.max_brightness = status;
 	props.brightness = ec_get_brightness();
+	props.power = FB_BLANK_UNBLANK;
 	props.type = BACKLIGHT_PLATFORM;
 
 	backlight_device_register("loongson_laptop",
 				NULL, NULL, &backlight_laptop_ops, &props);
 
-	return 0;
-}
-
-int loongson_laptop_turn_on_backlight(void)
-{
-	int status;
-	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
-	struct acpi_object_list args = { 1, &arg0 };
-
-	arg0.integer.value = 1;
-	status = acpi_evaluate_object(NULL, "\\BLSW", &args, NULL);
-	if (ACPI_FAILURE(status)) {
-		pr_info("Loongson lvds error: 0x%x\n", status);
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-int loongson_laptop_turn_off_backlight(void)
-{
-	int status;
-	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
-	struct acpi_object_list args = { 1, &arg0 };
-
-	arg0.integer.value = 0;
-	status = acpi_evaluate_object(NULL, "\\BLSW", &args, NULL);
-	if (ACPI_FAILURE(status)) {
-		pr_info("Loongson lvds error: 0x%x\n", status);
-		return -ENODEV;
-	}
 
 	return 0;
 }


