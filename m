Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2823806C1;
	Tue, 10 Mar 2026 11:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140781; cv=none; b=PwsNylmCktl8uWjCB4qmk3yGlLC/aw1J7OgPaClJmWmCyFTLFAHRzzqVpfgDZC6Ddhz1MQbJLuD5Iatq4SzsWmjUOaNJTWPimd+SegR6+m2MGa3jMS4OxGVmQM7xj17dw1fKO6qEWOEv0U0FfGPzu/qeUWXIX7e/wPWt/MuAiJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140781; c=relaxed/simple;
	bh=sQqVp/PjTLvC99jakrFYQNDrspigirmMYodQuSpYgwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw48JAL3jMbldk7HxdCdRPjVem3/qIYzdDwXVqKSIfgoDHvJm1H6xhGMUxPr0eCQZ26oZZ6jF2oZ3LB8Fg9byp1vDbZVVLuR1NZekMH32Zp0HdsWRYymlKe7R+meBxaORzZ5pU0u4WfZhUycP8NyDuaksUBOXLDXWxlB9O8ntiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i54KF2oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i54KF2oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC90C19423;
	Tue, 10 Mar 2026 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140781;
	bh=sQqVp/PjTLvC99jakrFYQNDrspigirmMYodQuSpYgwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i54KF2ojwkBGtjVrEntjYuyNI9WdL2PU9WIADA0BzrJExv1x6BV5mRHZG/pka+61m
	 MIsl9KkKX2q1lH240VZ3ijKjMn5o4jz47CHUkcS+8eRMnqXNZDhC3kh9IGTFxnLvEN
	 R+UCGDqiT+h9281DuP9Ze8WxQOe+8GPscJiIj3zsia8gpAcrBtojPW3vuzpGst8zqR
	 T/mpCHyC57I5TwwDvb0GUnQfXdGb6VoAug6LXNQzydqK+/vaGkDbZ+JdoLhurjzKvV
	 g+drST+YrkvNkmMclBvsOMjRXI/wkNdLhHz7xjtmzRBw27c6Cg2AbJhoOD5p7pXmAf
	 aTLFrYTd9iwfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 016/311] ALSA: scarlett2: Fix DSP filter control array handling
Date: Tue, 10 Mar 2026 07:01:03 -0400
Message-ID: <689286c6502a7aa91075208fd71bde748d651055.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 88b7e42d159e0..7b31504c5f24c 100644
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

