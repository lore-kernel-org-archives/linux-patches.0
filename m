Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9483876B0;
	Tue, 10 Mar 2026 11:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141648; cv=none; b=JSrpv+25jN1WPluT+1UGuvTchDtlI6UqTwxs/7LwtRtgAleV7FjiY968MC97/gvuRRdXn7zMUYs9tBlo59dkixDh5Y2zicB3qG6IZw08Jh9NSTi2QprERAoQ0O0Irk3DIWv+4cGZFPi//l/LvSlWa6/QGyXiKIAyZAz3NCAgl1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141648; c=relaxed/simple;
	bh=7ZWzIH+LIj1JuCim8sVnBObiH+7uSBtrDoGIGC3GBts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2Pc0RH7KRbtQfEauSmHpxclPjdRUQEQ/0pnzPG6Ro8IbI0xzOtV1yYwjccgljvmG+mH2B8ef2EqBv2KGgqR8nEuMEWmFXd5WRVVY2zabeAJqFdHQajN0iMxTdHx6v4jwNN9h7BcGFwTlg3X66jpK3mU7sFQuI3y7jJaJGTT6OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hENj7EkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hENj7EkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73D9C2BC86;
	Tue, 10 Mar 2026 11:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141648;
	bh=7ZWzIH+LIj1JuCim8sVnBObiH+7uSBtrDoGIGC3GBts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hENj7EkNsjLqUX6WvT71yDvj5gpw3zyF/j9an3bq7hGl09kElS8iLZ0tad4nYE0sF
	 vYo6lZf9jqYo74isgzmHaTXbOjP0aAqlM1CppZTuEQmyBsx97i8H0TsroR9JywWk8r
	 +wDf0noQRKF/QSCVJ0Hb+V/UEyCeq5qkGV3LJJqvSYsqV/tXWHYj87oCJHw0KtAgrv
	 7fie4Igw++t5vPOEY9RwLz2Wnnkc7vrnVPTocXWrCqNkopwtyQSje+fdIMncC1HQx8
	 jFhLN2SrFqUfPj/RyIKll/g/9zq6bTn8CXwjDTGdMXNNo1YdrHc359bI97dCERGx0T
	 AX04h+OWi4spQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/314] ALSA: scarlett2: Fix DSP filter control array handling
Date: Tue, 10 Mar 2026 07:14:33 -0400
Message-ID: <f074b49cc97d13c828cda482e65f38510acc93bf.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit 1d241483368f2fd87fbaba64d6aec6bad3a1e12e ]

scarlett2_add_dsp_ctls() was incorrectly storing the precomp and PEQ
filter coefficient control pointers into the precomp_flt_switch_ctls
and peq_flt_switch_ctls arrays instead of the intended targets
precomp_flt_ctls and peq_flt_ctls. Pass NULL instead, as the filter
coefficient control pointers are not used, and remove the unused
precomp_flt_ctls and peq_flt_ctls arrays from struct scarlett2_data.

Additionally, scarlett2_update_filter_values() was reading
dsp_input_count * peq_flt_count values for
SCARLETT2_CONFIG_PEQ_FLT_SWITCH, but the peq_flt_switch array is
indexed only by dsp_input_count (one switch per DSP input, not per
filter). Fix the read count.

Fixes: b64678eb4e70 ("ALSA: scarlett2: Add DSP controls")
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/86497b71db060677d97c38a6ce5f89bb3b25361b.1771581197.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index bef8c9e544dd3..380beb7ed4cf8 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -1328,8 +1328,6 @@ struct scarlett2_data {
 	struct snd_kcontrol *mux_ctls[SCARLETT2_MUX_MAX];
 	struct snd_kcontrol *mix_ctls[SCARLETT2_MIX_MAX];
 	struct snd_kcontrol *compressor_ctls[SCARLETT2_COMPRESSOR_CTLS_MAX];
-	struct snd_kcontrol *precomp_flt_ctls[SCARLETT2_PRECOMP_FLT_CTLS_MAX];
-	struct snd_kcontrol *peq_flt_ctls[SCARLETT2_PEQ_FLT_CTLS_MAX];
 	struct snd_kcontrol *precomp_flt_switch_ctls[SCARLETT2_DSP_SWITCH_MAX];
 	struct snd_kcontrol *peq_flt_switch_ctls[SCARLETT2_DSP_SWITCH_MAX];
 	struct snd_kcontrol *direct_monitor_ctl;
@@ -3447,7 +3445,6 @@ static int scarlett2_update_autogain(struct usb_mixer_interface *mixer)
 			private->autogain_status[i] =
 				private->num_autogain_status_texts - 1;
 
-
 	for (i = 0; i < SCARLETT2_AG_TARGET_COUNT; i++)
 		if (scarlett2_has_config_item(private,
 					      scarlett2_ag_target_configs[i])) {
@@ -5372,8 +5369,7 @@ static int scarlett2_update_filter_values(struct usb_mixer_interface *mixer)
 
 	err = scarlett2_usb_get_config(
 		mixer, SCARLETT2_CONFIG_PEQ_FLT_SWITCH,
-		info->dsp_input_count * info->peq_flt_count,
-		private->peq_flt_switch);
+		info->dsp_input_count, private->peq_flt_switch);
 	if (err < 0)
 		return err;
 
@@ -6546,7 +6542,7 @@ static int scarlett2_add_dsp_ctls(struct usb_mixer_interface *mixer, int i)
 		err = scarlett2_add_new_ctl(
 			mixer, &scarlett2_precomp_flt_ctl,
 			i * info->precomp_flt_count + j,
-			1, s, &private->precomp_flt_switch_ctls[j]);
+			1, s, NULL);
 		if (err < 0)
 			return err;
 	}
@@ -6556,7 +6552,7 @@ static int scarlett2_add_dsp_ctls(struct usb_mixer_interface *mixer, int i)
 		err = scarlett2_add_new_ctl(
 			mixer, &scarlett2_peq_flt_ctl,
 			i * info->peq_flt_count + j,
-			1, s, &private->peq_flt_switch_ctls[j]);
+			1, s, NULL);
 		if (err < 0)
 			return err;
 	}
-- 
2.51.0

