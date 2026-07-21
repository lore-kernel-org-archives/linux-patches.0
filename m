Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A8946EF8C;
	Tue, 21 Jul 2026 20:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664290; cv=none; b=l7IPB10eFDr1hNqH2dVJIpndtcevG3wdYeamZ7ABjOFKVmIFZBTmABgHqAC5+RORAVP40+05H3Wj+Ug6o4i2wilRRiEq+FmUhy1NafdqTLr12CZHZTsuI4WoH2DhvN0zfrDvIjy4QC57m3hKoPPpjCqArTFEyWi5sEt8gwysv/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664290; c=relaxed/simple;
	bh=D4dB6ZbylyPC9NbxPqjPGx5zVDcFszmsdqvjuEIEo7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPL7n83EczyWLDZ0lHPhze6ylcnH78wrhB/dbCuYEnsnX51kUSTBhqkzIlbhL+BYemoiqFDAND0dKHg/1QeCbikq1fCUhmVjzbdIRAgLogDMpDvjoElO1vli0W3RdWC5Q4Ud2rQuipE35dU9S+ASSWTFXYGlR+ttOsPf1Tp9wic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xq6uJKLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xq6uJKLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BDF1F000E9;
	Tue, 21 Jul 2026 20:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664289;
	bh=LhyiF/I5sjkbR9N27VPn4Ohm+IkzQIckp5nj3vkyoKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xq6uJKLJzhY2Sqe2Kj2wuJMd8k1npxqMbLm5hA1qxvq390KyMlazlYtA3TAXFNEjS
	 CxuQkxuwteaCVpuyQcae6Nix7mTFAk2DkbVmaQZAEovLWvud8KZSvc587+iwgmwlko
	 bCrpCBlGIUUk7UUZwvnA5yjpjd9nRhAcEWDWkI2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1143/1276] ALSA: scarlett2: Allow selecting config_set by firmware version
Date: Tue, 21 Jul 2026 17:26:26 +0200
Message-ID: <20260721152511.583444030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -588,6 +588,20 @@ struct scarlett2_config_set {
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
@@ -1073,8 +1087,8 @@ struct scarlett2_meter_entry {
 };
 
 struct scarlett2_device_info {
-	/* which set of configuration parameters the device uses */
-	const struct scarlett2_config_set *config_set;
+	/* which sets of configuration parameters the device uses */
+	const struct scarlett2_config_set_entry *config_sets;
 
 	/* minimum firmware version required */
 	u16 min_firmware_version;
@@ -1309,7 +1323,10 @@ struct scarlett2_data {
 /*** Model-specific data ***/
 
 static const struct scarlett2_device_info s6i6_gen2_info = {
-	.config_set = &scarlett2_config_set_gen2a,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen2a },
+		{ }
+	},
 	.level_input_count = 2,
 	.pad_input_count = 2,
 
@@ -1359,7 +1376,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s18i8_gen2_info = {
-	.config_set = &scarlett2_config_set_gen2a,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen2a },
+		{ }
+	},
 	.level_input_count = 2,
 	.pad_input_count = 4,
 
@@ -1412,7 +1432,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s18i20_gen2_info = {
-	.config_set = &scarlett2_config_set_gen2b,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_gen2b },
+		{ }
+	},
 
 	.line_out_descrs = {
 		"Monitor L",
@@ -1469,7 +1492,10 @@ static const struct scarlett2_device_inf
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
@@ -1479,7 +1505,10 @@ static const struct scarlett2_device_inf
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
@@ -1488,7 +1517,10 @@ static const struct scarlett2_device_inf
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
@@ -1537,7 +1569,10 @@ static const struct scarlett2_device_inf
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
@@ -1603,7 +1638,10 @@ static const char * const scarlett2_spdi
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
@@ -1695,7 +1733,10 @@ static const char * const scarlett2_spdi
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
@@ -1769,7 +1810,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info vocaster_one_info = {
-	.config_set = &scarlett2_config_set_vocaster,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 1769, &scarlett2_config_set_vocaster },
+		{ }
+	},
 	.min_firmware_version = 1769,
 
 	.phantom_count = 1,
@@ -1811,7 +1855,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info vocaster_two_info = {
-	.config_set = &scarlett2_config_set_vocaster,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 1769, &scarlett2_config_set_vocaster },
+		{ }
+	},
 	.min_firmware_version = 1769,
 
 	.phantom_count = 2,
@@ -1854,7 +1901,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info solo_gen4_info = {
-	.config_set = &scarlett2_config_set_gen4_solo,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 2115, &scarlett2_config_set_gen4_solo },
+		{ }
+	},
 	.min_firmware_version = 2115,
 
 	.level_input_count = 1,
@@ -1908,7 +1958,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s2i2_gen4_info = {
-	.config_set = &scarlett2_config_set_gen4_2i2,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 2115, &scarlett2_config_set_gen4_2i2 },
+		{ }
+	},
 	.min_firmware_version = 2115,
 
 	.level_input_count = 2,
@@ -1962,7 +2015,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info s4i4_gen4_info = {
-	.config_set = &scarlett2_config_set_gen4_4i4,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 2089, &scarlett2_config_set_gen4_4i4 },
+		{ }
+	},
 	.min_firmware_version = 2089,
 
 	.level_input_count = 2,
@@ -2010,7 +2066,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info clarett_2pre_info = {
-	.config_set = &scarlett2_config_set_clarett,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_clarett },
+		{ }
+	},
 	.level_input_count = 2,
 	.air_input_count = 2,
 
@@ -2066,7 +2125,10 @@ static const char * const scarlett2_spdi
 };
 
 static const struct scarlett2_device_info clarett_4pre_info = {
-	.config_set = &scarlett2_config_set_clarett,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_clarett },
+		{ }
+	},
 	.level_input_count = 2,
 	.air_input_count = 4,
 
@@ -2122,7 +2184,10 @@ static const struct scarlett2_device_inf
 };
 
 static const struct scarlett2_device_info clarett_8pre_info = {
-	.config_set = &scarlett2_config_set_clarett,
+	.config_sets = (const struct scarlett2_config_set_entry[]) {
+		{ 0, &scarlett2_config_set_clarett },
+		{ }
+	},
 	.level_input_count = 2,
 	.air_input_count = 8,
 
@@ -8539,10 +8604,32 @@ static void scarlett2_private_suspend(st
 
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
 
@@ -8640,9 +8727,14 @@ static int scarlett2_init_private(struct
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
 
@@ -9046,6 +9138,13 @@ static int snd_scarlett2_controls_create
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


