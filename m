Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DE219B3FF;
	Tue, 15 Oct 2024 11:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993521; cv=none; b=kyDpQuKW6tGpdXuwjeRrjko5ANt0HWrBUZGcew9bVx7mqiVk0qEf0vaaH/hmGvz49CvmFu6B4r2N2q0nLsaQ384mJHwxHJpD5sv4n94Pb+5eNK0y4vqg250OfvJrg5r6P4qcdV8ZYFpiUfx45DtM0m3va0Ippw8JVBDevjlZCRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993521; c=relaxed/simple;
	bh=cazOMpaUYCH3qQeyuYhhmorP+L81XmqfQjf17azrKII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smVApnYI7d1vywugLQKXVzNbOARHoE7LjMBEFD6ig1wmJT74Al6euUzbdJyUFC41EgYsWGH09cWKmKdRvoXXMqdBaSFUPawAyhPS6TRL5STxvIzZTLZb8ThYQyAAtOkFFC4d5OsUe2slgUmCqPN5NAR3KtioYQ26SYkwt7uuVTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmVACCfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmVACCfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64755C4CEC6;
	Tue, 15 Oct 2024 11:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993520;
	bh=cazOMpaUYCH3qQeyuYhhmorP+L81XmqfQjf17azrKII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmVACCfadATm9Ld437kOgUBv26HskXuo5HijuZSebAV+JNumYthHoulsoJR5BQcwp
	 R+yk8NNXUXTo784t1A2otHQ4IiqqO+uFpwrnaurU4UpkNp8brtzRFmPtWEuPpGramo
	 nqc4HgAuYXLn3OGrKPbkaIAMMSu75q7UySb8+ajU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/691] ALSA: usb-audio: Add input value sanity checks for standard types
Date: Tue, 15 Oct 2024 13:26:24 +0200
Message-ID: <20241015112457.646341359@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 901e85677ec0bb9a69fb9eab1feafe0c4eb7d07e ]

For an invalid input value that is out of the given range, currently
USB-audio driver corrects the value silently and accepts without
errors.  This is no wrong behavior, per se, but the recent kselftest
rather wants to have an error in such a case, hence a different
behavior is expected now.

This patch adds a sanity check at each control put for the standard
mixer types and returns an error if an invalid value is given.

Note that this covers only the standard mixer types.  The mixer quirks
that have own control callbacks would need different coverage.

Link: https://patch.msgid.link/20240806124651.28203-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 35 +++++++++++++++++++++++++++--------
 sound/usb/mixer.h |  1 +
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 9906785a02e92..ae27e5c57c70e 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1346,6 +1346,19 @@ static int get_min_max_with_quirks(struct usb_mixer_elem_info *cval,
 
 #define get_min_max(cval, def)	get_min_max_with_quirks(cval, def, NULL)
 
+/* get the max value advertised via control API */
+static int get_max_exposed(struct usb_mixer_elem_info *cval)
+{
+	if (!cval->max_exposed) {
+		if (cval->res)
+			cval->max_exposed =
+				DIV_ROUND_UP(cval->max - cval->min, cval->res);
+		else
+			cval->max_exposed = cval->max - cval->min;
+	}
+	return cval->max_exposed;
+}
+
 /* get a feature/mixer unit info */
 static int mixer_ctl_feature_info(struct snd_kcontrol *kcontrol,
 				  struct snd_ctl_elem_info *uinfo)
@@ -1358,11 +1371,8 @@ static int mixer_ctl_feature_info(struct snd_kcontrol *kcontrol,
 	else
 		uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
 	uinfo->count = cval->channels;
-	if (cval->val_type == USB_MIXER_BOOLEAN ||
-	    cval->val_type == USB_MIXER_INV_BOOLEAN) {
-		uinfo->value.integer.min = 0;
-		uinfo->value.integer.max = 1;
-	} else {
+	if (cval->val_type != USB_MIXER_BOOLEAN &&
+	    cval->val_type != USB_MIXER_INV_BOOLEAN) {
 		if (!cval->initialized) {
 			get_min_max_with_quirks(cval, 0, kcontrol);
 			if (cval->initialized && cval->dBmin >= cval->dBmax) {
@@ -1374,10 +1384,10 @@ static int mixer_ctl_feature_info(struct snd_kcontrol *kcontrol,
 					       &kcontrol->id);
 			}
 		}
-		uinfo->value.integer.min = 0;
-		uinfo->value.integer.max =
-			DIV_ROUND_UP(cval->max - cval->min, cval->res);
 	}
+
+	uinfo->value.integer.min = 0;
+	uinfo->value.integer.max = get_max_exposed(cval);
 	return 0;
 }
 
@@ -1418,6 +1428,7 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
 	struct usb_mixer_elem_info *cval = kcontrol->private_data;
+	int max_val = get_max_exposed(cval);
 	int c, cnt, val, oval, err;
 	int changed = 0;
 
@@ -1430,6 +1441,8 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 			if (err < 0)
 				return filter_error(cval, err);
 			val = ucontrol->value.integer.value[cnt];
+			if (val < 0 || val > max_val)
+				return -EINVAL;
 			val = get_abs_value(cval, val);
 			if (oval != val) {
 				snd_usb_set_cur_mix_value(cval, c + 1, cnt, val);
@@ -1443,6 +1456,8 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 		if (err < 0)
 			return filter_error(cval, err);
 		val = ucontrol->value.integer.value[0];
+		if (val < 0 || val > max_val)
+			return -EINVAL;
 		val = get_abs_value(cval, val);
 		if (val != oval) {
 			snd_usb_set_cur_mix_value(cval, 0, 0, val);
@@ -2301,6 +2316,8 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
 	if (err < 0)
 		return filter_error(cval, err);
 	val = ucontrol->value.integer.value[0];
+	if (val < 0 || val > get_max_exposed(cval))
+		return -EINVAL;
 	val = get_abs_value(cval, val);
 	if (val != oval) {
 		set_cur_ctl_value(cval, cval->control << 8, val);
@@ -2663,6 +2680,8 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
 	if (err < 0)
 		return filter_error(cval, err);
 	val = ucontrol->value.enumerated.item[0];
+	if (val < 0 || val >= cval->max) /* here cval->max = # elements */
+		return -EINVAL;
 	val = get_abs_value(cval, val);
 	if (val != oval) {
 		set_cur_ctl_value(cval, cval->control << 8, val);
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index 98ea24d91d803..e3f3740204f54 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -88,6 +88,7 @@ struct usb_mixer_elem_info {
 	int channels;
 	int val_type;
 	int min, max, res;
+	int max_exposed; /* control API exposes the value in 0..max_exposed */
 	int dBmin, dBmax;
 	int cached;
 	int cache_val[MAX_CHANNELS];
-- 
2.43.0



