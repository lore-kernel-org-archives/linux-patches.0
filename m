Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B8746D092;
	Tue, 21 Jul 2026 17:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655355; cv=none; b=fC9wyV5pR8g3aYrW3aV1zQ2drsySZlQf8/w0d7zRMsL3C85z2kD7kEY5CVHPGjnS3BQI/DykWzxBK/Mf1FkQW2pq+yZx+8rpIyOcTqSWFnZUsHtnVjsgCRKG1ScCzsodzCADytdEKQ/HOZzHlD5BAfQzr3rdiDNE689xvIGWr90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655355; c=relaxed/simple;
	bh=oFLrFPxQnc24p/JDY2O/W+is5RYDCgOXfYwwlTioGlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cemzm+XLex15TKhvC56L7phsdaTSJ0ntVlG9Bdasuc+r2aAoC/aViex2zV+huwsFJcFmNP0GO/0iWRXQCgjbhMtMH+PIrzRj8GXJAKZvNiWAqdj3sQTTOOUUiT1JYBWdoU9cK+G6uVrFmf+tEIUmeD0lo5XDZkuoFD1SBku3Zo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JODacfFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JODacfFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1281F000E9;
	Tue, 21 Jul 2026 17:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655354;
	bh=ZNebppXFINSybcktuDOTepN95X0lAGIq6c1pV3NGNK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JODacfFGALTV8WDXU3EXoNByshCRBtqUaeZj8g7fZ/gpc9IOykDAtfG9UjO05oT4E
	 K90p9cp+WOCc86cDDkqeNcYSqpm0SFzDwM2o9ULA0js1SNmorAayQPGhm5waJ0s1Pp
	 Z20bDn62+ogQtoyUfV3aQGE/uvShNc2WmULMpVCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2052/2077] ALSA: scarlett2: Allow selecting config_set by firmware version
Date: Tue, 21 Jul 2026 17:28:45 +0200
Message-ID: <20260721152641.102249774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit 732a6397a526c025cd29c3c9309b0db6a2c08837 ]

The Scarlett 2i2 Gen 4 firmware 2417 moved the direct monitor gain
parameters, so we now need to allow each device to list multiple
scarlett2_config_set entries, one per applicable firmware version
range, and pick the matching one at probe time.

No functional change yet: each device gets a single config_sets
entry whose from_firmware_version matches the existing
min_firmware_version (0 where none was set). This both prepares for
selection and lets a follow-up commit remove the now-redundant
min_firmware_version field.

scarlett2_count_io() depends on the resolved config_set so it moves
out of scarlett2_init_private() into snd_scarlett2_controls_create()
after the firmware version has been read.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/ae1695b4c4825f365b4c86b22174035f742807e3.1777151532.git.g@b4.vu
Stable-dep-of: 3ca15754b561 ("ALSA: scarlett2: Update offsets for 2i2 Gen 4 firmware 2417")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c |  143 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 121 insertions(+), 22 deletions(-)

--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -612,6 +612,20 @@ struct scarlett2_config_set {
 	const struct scarlett2_config items[SCARLETT2_CONFIG_COUNT];
 };
 
+/* Map firmware versions to config sets per-device.
+ *
+ * Each device lists one or more entries, sorted in ascending order of
+ * from_firmware_version. At probe time the running firmware version
+ * is looked up against this list and the last entry whose
+ * from_firmware_version is <= the running version is selected.
+ *
+ * The list is terminated by a sentinel entry with config_set == NULL.
+ */
+struct scarlett2_config_set_entry {
+	u16 from_firmware_version;
+	const struct scarlett2_config_set *config_set;
+};
+
 /* Input gain TLV dB ranges */
 
 static const DECLARE_TLV_DB_MINMAX(
@@ -1100,8 +1114,8 @@ struct scarlett2_meter_entry {
 };
 
 struct scarlett2_device_info {
-	/* which set of configuration parameters the device uses */
-	const struct scarlett2_config_set *config_set;
+	/* which sets of configuration parameters the device uses */
+	const struct scarlett2_config_set_entry *config_sets;
 
 	/* minimum firmware version required */
 	u16 min_firmware_version;
@@ -1343,7 +1357,10 @@ struct scarlett2_data {
 /*** Model-specific data ***/
 
 static const struct scarlett2_device_info s6i6_gen2_info = {
-	.config_set = &scarlett2_config_set_gen2a,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen2a },
+		{ }
+	},
 	.level_input_count = 2,
 	.pad_input_count = 2,
 
@@ -1393,7 +1410,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s18i8_gen2_info = {
-	.config_set = &scarlett2_config_set_gen2a,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen2a },
+		{ }
+	},
 	.level_input_count = 2,
 	.pad_input_count = 4,
 
@@ -1446,7 +1466,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s18i20_gen2_info = {
-	.config_set = &scarlett2_config_set_gen2b,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen2b },
+		{ }
+	},
 
 	.line_out_descrs = {
 		"Monitor L",
@@ -1503,7 +1526,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info solo_gen3_info = {
-	.config_set = &scarlett2_config_set_gen3a,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen3a },
+		{ }
+	},
 	.level_input_count = 1,
 	.level_input_first = 1,
 	.air_input_count = 1,
@@ -1513,7 +1539,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s2i2_gen3_info = {
-	.config_set = &scarlett2_config_set_gen3a,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen3a },
+		{ }
+	},
 	.level_input_count = 2,
 	.air_input_count = 2,
 	.phantom_count = 1,
@@ -1522,7 +1551,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s4i4_gen3_info = {
-	.config_set = &scarlett2_config_set_gen3b,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen3b },
+		{ }
+	},
 	.level_input_count = 2,
 	.pad_input_count = 2,
 	.air_input_count = 2,
@@ -1571,7 +1603,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s8i6_gen3_info = {
-	.config_set = &scarlett2_config_set_gen3b,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen3b },
+		{ }
+	},
 	.level_input_count = 2,
 	.pad_input_count = 2,
 	.air_input_count = 2,
@@ -1637,7 +1672,10 @@ static const char * const scarlett2_spdi
 };
 
 static const struct scarlett2_device_info s18i8_gen3_info = {
-	.config_set = &scarlett2_config_set_gen3c,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen3c },
+		{ }
+	},
 	.has_speaker_switching = 1,
 	.level_input_count = 2,
 	.pad_input_count = 4,
@@ -1729,7 +1767,10 @@ static const char * const scarlett2_spdi
 };
 
 static const struct scarlett2_device_info s18i20_gen3_info = {
-	.config_set = &scarlett2_config_set_gen3c,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen3c },
+		{ }
+	},
 	.has_speaker_switching = 1,
 	.has_talkback = 1,
 	.level_input_count = 2,
@@ -1803,7 +1844,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info vocaster_one_info = {
-	.config_set = &scarlett2_config_set_vocaster,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 1769, &scarlett2_config_set_vocaster },
+		{ }
+	},
 	.min_firmware_version = 1769,
 	.has_devmap = 1,
 
@@ -1847,7 +1891,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info vocaster_two_info = {
-	.config_set = &scarlett2_config_set_vocaster,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 1769, &scarlett2_config_set_vocaster },
+		{ }
+	},
 	.min_firmware_version = 1769,
 	.has_devmap = 1,
 
@@ -1892,7 +1939,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info solo_gen4_info = {
-	.config_set = &scarlett2_config_set_gen4_solo,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 2115, &scarlett2_config_set_gen4_solo },
+		{ }
+	},
 	.min_firmware_version = 2115,
 	.has_devmap = 1,
 
@@ -1947,7 +1997,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s2i2_gen4_info = {
-	.config_set = &scarlett2_config_set_gen4_2i2,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 2115, &scarlett2_config_set_gen4_2i2 },
+		{ }
+	},
 	.min_firmware_version = 2115,
 	.has_devmap = 1,
 
@@ -2002,7 +2055,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s4i4_gen4_info = {
-	.config_set = &scarlett2_config_set_gen4_4i4,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 2089, &scarlett2_config_set_gen4_4i4 },
+		{ }
+	},
 	.min_firmware_version = 2089,
 	.has_devmap = 1,
 
@@ -2051,7 +2107,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info clarett_2pre_info = {
-	.config_set = &scarlett2_config_set_clarett,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_clarett },
+		{ }
+	},
 	.level_input_count = 2,
 	.air_input_count = 2,
 
@@ -2107,7 +2166,10 @@ static const char * const scarlett2_spdi
 };
 
 static const struct scarlett2_device_info clarett_4pre_info = {
-	.config_set = &scarlett2_config_set_clarett,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_clarett },
+		{ }
+	},
 	.level_input_count = 2,
 	.air_input_count = 4,
 
@@ -2163,7 +2225,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info clarett_8pre_info = {
-	.config_set = &scarlett2_config_set_clarett,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_clarett },
+		{ }
+	},
 	.level_input_count = 2,
 	.air_input_count = 8,
 
@@ -8211,10 +8276,32 @@ static void scarlett2_private_suspend(st
 
 /*** Initialisation ***/
 
+/* Select the config_set matching the running firmware version.
+ *
+ * The device info's config_sets array is ordered by ascending
+ * from_firmware_version; pick the last entry whose version is <= the
+ * running firmware version. If the running firmware is older than the
+ * first entry's from_firmware_version (i.e. older than the driver's
+ * minimum supported version for this device), the first entry's
+ * config_set is selected anyway so firmware updates can still be done
+ * (requires only the ACK handler), but the usual mixer controls
+ * aren't created.
+ */
+static void scarlett2_resolve_config_set(struct scarlett2_data *private)
+{
+	const struct scarlett2_config_set_entry *entry =
+		private->info->config_sets;
+
+	private->config_set = entry->config_set;
+	for (entry++; entry->config_set; entry++)
+		if (entry->from_firmware_version <= private->firmware_version)
+			private->config_set = entry->config_set;
+}
+
 static void scarlett2_count_io(struct scarlett2_data *private)
 {
 	const struct scarlett2_device_info *info = private->info;
-	const struct scarlett2_config_set *config_set = info->config_set;
+	const struct scarlett2_config_set *config_set = private->config_set;
 	const int (*port_count)[SCARLETT2_PORT_DIRNS] = info->port_count;
 	int port_type, srcs = 0, dsts = 0, i;
 
@@ -8311,9 +8398,14 @@ static int scarlett2_init_private(struct
 	mixer->private_suspend = scarlett2_private_suspend;
 
 	private->info = entry->info;
-	private->config_set = entry->info->config_set;
+
+	/* Set config_set to the first entry's config_set so the
+	 * notify handler has a valid pointer while USB init runs; it
+	 * is re-resolved once the firmware version has been read.
+	 */
+	private->config_set = entry->info->config_sets[0].config_set;
+
 	private->series_name = entry->series_name;
-	scarlett2_count_io(private);
 	private->scarlett2_seq = 0;
 	private->mixer = mixer;
 
@@ -8717,6 +8809,13 @@ static int snd_scarlett2_controls_create
 	if (err < 0)
 		return err;
 
+	/* Now that the firmware version is known, pick the matching
+	 * config_set
+	 */
+	scarlett2_resolve_config_set(private);
+
+	scarlett2_count_io(private);
+
 	/* Get the upgrade & settings flash segment numbers */
 	err = scarlett2_get_flash_segment_nums(mixer);
 	if (err < 0)


