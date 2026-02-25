Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A924E1D5ABA;
	Wed, 25 Feb 2026 01:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983056; cv=none; b=YJ7lpvLM/ge6tkMAGZpfVexSLsymBz2crMpR2o3eXUES25+rXMuSz3pll4vOSsCeCLI/ltw7mMDKgOPFEeTezm0kDee3HbOsADnYdSlegz4ZZELMMql/x7M6GIDs3CDPdjXbPGmQIq+Tk6CcxM3VMJeohHyPDt5djWLFxnO7n8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983056; c=relaxed/simple;
	bh=1IQxgHc1NaUAizKRRjcyuTRrFzVlDjXbNT3m2TdEtMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiH2zd2JiGP/7bbraenB223vjEDxIrvSF5016eP+J2MVz4i261UUtrqU1XY8xb0ogn37k6Ly5xPy3iso2i1exwhoJJqAV1q0dATfeYH3zPVZXUNH1uTATndxLp82uGqyRjOSNZ1zcdYIa5IbvDuu81/Nqf5GerKaRZOT6hK5jr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCdyJsy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCdyJsy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670D8C116D0;
	Wed, 25 Feb 2026 01:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983056;
	bh=1IQxgHc1NaUAizKRRjcyuTRrFzVlDjXbNT3m2TdEtMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCdyJsy8D1PpRHNTuHlqEqwgRKank031gArlc6KJoxHcQyza9ELiw3nw6FAwwNeLY
	 Dlr1/Ynr9nRwYal5gY7Z0ydOClidaa8ksRWfppZbbaHB0jcBeQ9PhZmFOA0A5nO9/8
	 chkq/zFQOt4IWBSVa2LgiQTIN2hgHaM6geUJiE8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 221/781] ALSA: hda: Relax __free() variable declarations
Date: Tue, 24 Feb 2026 17:15:30 -0800
Message-ID: <20260225012405.133903699@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 04c654624f41d3c3eee48e9837a52d8a2bbc7332 ]

We used to have a variable declaration with __free() initialized with
NULL.  This was to keep the old coding style rule, but recently it's
relaxed and rather recommends to follow the new rule to declare in
place of use for __free() -- which avoids potential deadlocks or UAFs
with nested cleanups.

Although the current code has no bug, per se, let's follow the new
standard and move the declaration to the place of assignment (or
directly assign the allocated result) instead of NULL initializations.

Fixes: ee0b0f5d32fe ("ALSA: hda/generic: Use auto cleanup for temporary buffers")
Fixes: 03c5c350e38d ("ALSA: hda/realtek: Add support for new HP G12 laptops")
Fixes: b0550d4c2dd8 ("ALSA: hda/common: Use auto cleanup for temporary buffers")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251216140634.171890-10-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/generic.c         | 4 ++--
 sound/hda/codecs/realtek/alc269.c  | 4 ++--
 sound/hda/codecs/realtek/realtek.c | 5 +++--
 sound/hda/common/codec.c           | 4 ++--
 sound/hda/common/sysfs.c           | 5 +++--
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/sound/hda/codecs/generic.c b/sound/hda/codecs/generic.c
index 7bcf9aef8275f..443500a3518f4 100644
--- a/sound/hda/codecs/generic.c
+++ b/sound/hda/codecs/generic.c
@@ -1984,15 +1984,15 @@ static int parse_output_paths(struct hda_codec *codec)
 {
 	struct hda_gen_spec *spec = codec->spec;
 	struct auto_pin_cfg *cfg = &spec->autocfg;
-	struct auto_pin_cfg *best_cfg __free(kfree) = NULL;
 	unsigned int val;
 	int best_badness = INT_MAX;
 	int badness;
 	bool fill_hardwired = true, fill_mio_first = true;
 	bool best_wired = true, best_mio = true;
 	bool hp_spk_swapped = false;
+	struct auto_pin_cfg *best_cfg __free(kfree) =
+		kmalloc(sizeof(*best_cfg), GFP_KERNEL);
 
-	best_cfg = kmalloc(sizeof(*best_cfg), GFP_KERNEL);
 	if (!best_cfg)
 		return -ENOMEM;
 	*best_cfg = *cfg;
diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b66965a521076..0618a61413580 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -2916,7 +2916,6 @@ static void find_cirrus_companion_amps(struct hda_codec *cdc)
 {
 	struct device *dev = hda_codec_dev(cdc);
 	struct acpi_device *adev;
-	struct fwnode_handle *fwnode __free(fwnode_handle) = NULL;
 	const char *bus = NULL;
 	static const struct {
 		const char *hid;
@@ -2946,7 +2945,8 @@ static void find_cirrus_companion_amps(struct hda_codec *cdc)
 			bus = "spi";
 	}
 
-	fwnode = fwnode_handle_get(acpi_fwnode_handle(adev));
+	struct fwnode_handle *fwnode __free(fwnode_handle) =
+		fwnode_handle_get(acpi_fwnode_handle(adev));
 	acpi_dev_put(adev);
 
 	if (!bus) {
diff --git a/sound/hda/codecs/realtek/realtek.c b/sound/hda/codecs/realtek/realtek.c
index ca377a5adadb5..efe20b4505290 100644
--- a/sound/hda/codecs/realtek/realtek.c
+++ b/sound/hda/codecs/realtek/realtek.c
@@ -215,12 +215,13 @@ void alc_update_knob_master(struct hda_codec *codec,
 {
 	unsigned int val;
 	struct snd_kcontrol *kctl;
-	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 
 	kctl = snd_hda_find_mixer_ctl(codec, "Master Playback Volume");
 	if (!kctl)
 		return;
-	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
+
+	struct snd_ctl_elem_value *uctl __free(kfree) =
+		kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (!uctl)
 		return;
 	val = snd_hda_codec_read(codec, jack->nid, 0,
diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index c6d44168c7f9d..ffe7c69d5a32c 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -1854,9 +1854,9 @@ static int check_follower_present(struct hda_codec *codec,
 /* call kctl->put with the given value(s) */
 static int put_kctl_with_value(struct snd_kcontrol *kctl, int val)
 {
-	struct snd_ctl_elem_value *ucontrol __free(kfree) = NULL;
+	struct snd_ctl_elem_value *ucontrol __free(kfree) =
+		kzalloc(sizeof(*ucontrol), GFP_KERNEL);
 
-	ucontrol = kzalloc(sizeof(*ucontrol), GFP_KERNEL);
 	if (!ucontrol)
 		return -ENOMEM;
 	ucontrol->value.integer.value[0] = val;
diff --git a/sound/hda/common/sysfs.c b/sound/hda/common/sysfs.c
index f8c8483fd5e5f..bedf10b308850 100644
--- a/sound/hda/common/sysfs.c
+++ b/sound/hda/common/sysfs.c
@@ -299,7 +299,6 @@ static void remove_trail_spaces(char *str)
 
 static int parse_hints(struct hda_codec *codec, const char *buf)
 {
-	char *key __free(kfree) = NULL;
 	char *val;
 	struct hda_hint *hint;
 
@@ -308,7 +307,9 @@ static int parse_hints(struct hda_codec *codec, const char *buf)
 		return 0;
 	if (*buf == '=')
 		return -EINVAL;
-	key = kstrndup_noeol(buf, 1024);
+
+	char *key __free(kfree) =
+		kstrndup_noeol(buf, 1024);
 	if (!key)
 		return -ENOMEM;
 	/* extract key and val */
-- 
2.51.0



