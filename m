Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B342F260C;
	Thu, 28 May 2026 20:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998917; cv=none; b=DGo9w51KxIhRPOHPYb8ma8g2v1mcxOn8NnO8UMTXNq7s92HHj9bxjaDKH60RFUi2C08wBkNG6MKZicDLwZrGWGBiqS8VQPZ/5Yxsn49L4YUhZjw3xWVFMX9CyEN0Lmowc+UBHiLsHuBgtUb15h6lKk/Fhl02eOKvX14bh7pdr5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998917; c=relaxed/simple;
	bh=Y7trVZk8GmUGRByGXPAZVLyx/CXeDR9BcI1vmfJAKnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5BWVwAgBxqyMWwFLQNPB4kblYS0NLzQjPfmAKKy8ediuu4QlLTMmhe2VPshE6sCdhUK7p9Q0WW/tMkRVNjjU5Iu+/ah9DqAsGUQMRpqIq74yM68iXNHVh/zEImc1hDOPyaKN0BpBCeGg3QXrWcDwF7VAhabjCYcYMJ6djE1FQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgjjDZDs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgjjDZDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CFC1F000E9;
	Thu, 28 May 2026 20:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998916;
	bh=4QD93byJk8mCQShRfpSRFsEmcl/lBZv0UNBKIhOasno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgjjDZDsK1maIQ4B98/F7K7F74a7dQit7uiVMw45b82fwtxh5tsOcTCCZN2gEBzY9
	 1FTcuP3P8Q7RIIkHbuYyTSmpdbGODTbnbYJeK33ntRFpTW38Pwy7LH8O2jCcSP6O17
	 FtKuhCeCbqDOaaxA0RLoqg2I7Yci3bG/SeQ8cKrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt DeVillier <matt.devillier@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 342/461] ALSA: hda/ca0132: Disable auto-detect on manual output select
Date: Thu, 28 May 2026 21:47:51 +0200
Message-ID: <20260528194657.267124626@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt DeVillier <matt.devillier@gmail.com>

[ Upstream commit 6fd9f6e870ea285f05102e8e00e6a7f4495a9a02 ]

Commit 778031e1658d ("ALSA: hda/ca0132: Set HP/Speaker
auto-detect default from headphone pin verb") enables HP/Speaker
auto-detect by default when the headphone pin supports presence detect.

With auto-detect enabled, ca0132_select_out() and ca0132_alt_select_out()
choose the output from jack presence instead of the manual HP/Speaker
selection. This means selecting speaker output while headphones are
plugged in updates the control state, but audio still routes to the
headphones.

Treat an explicit manual output selection as a request to leave
auto-detect mode. Clear the HP/Speaker auto-detect switch before applying
the manual selection, and notify userspace so the auto-detect control
state is updated in mixers. Do this for both the normal HP/Speaker
Playback Switch and the alternate Output Select control used by desktop
cards.

This keeps auto-detect enabled by default for devices with jack presence
detection, while preserving the expected behavior that a manual output
choice takes effect immediately.

Fixes: 778031e1658d ("ALSA: hda/ca0132: Set HP/Speaker auto-detect default from headphone pin verb")
Signed-off-by: Matt DeVillier <matt.devillier@gmail.com>
Link: https://lore.kernel.org/CAFTm+6AfeXKf=b2frG4xC5yC4jjM9TkD6c8+dOWWFw6BDjDESw@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/ca0132.c | 44 +++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/sound/hda/codecs/ca0132.c b/sound/hda/codecs/ca0132.c
index a0677d7da8e2d..b4e10957ac6db 100644
--- a/sound/hda/codecs/ca0132.c
+++ b/sound/hda/codecs/ca0132.c
@@ -5508,6 +5508,30 @@ static int zxr_headphone_gain_set(struct hda_codec *codec, long val)
 	return 0;
 }
 
+/*
+ * Manual output selection (HP/Speaker Playback Switch or alt Output Select)
+ * is meaningful only when HP/Speaker auto-detect is disabled, since the
+ * select_out path always prefers jack presence when auto-detect is on. When
+ * the user explicitly chooses an output, turn auto-detect off so the manual
+ * choice actually takes effect, and notify userspace so the auto-detect
+ * control reflects the new state.
+ */
+static void ca0132_disable_hp_auto_detect(struct hda_codec *codec)
+{
+	struct ca0132_spec *spec = codec->spec;
+	struct snd_kcontrol *kctl;
+
+	if (!spec->vnode_lswitch[VNID_HP_ASEL - VNODE_START_NID])
+		return;
+
+	spec->vnode_lswitch[VNID_HP_ASEL - VNODE_START_NID] = 0;
+	kctl = snd_hda_find_mixer_ctl(codec,
+				      "HP/Speaker Auto Detect Playback Switch");
+	if (kctl)
+		snd_ctl_notify(codec->card, SNDRV_CTL_EVENT_MASK_VALUE,
+			       &kctl->id);
+}
+
 static int ca0132_vnode_switch_set(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
 {
@@ -5520,14 +5544,11 @@ static int ca0132_vnode_switch_set(struct snd_kcontrol *kcontrol,
 	int auto_jack;
 
 	if (nid == VNID_HP_SEL) {
-		auto_jack =
-			spec->vnode_lswitch[VNID_HP_ASEL - VNODE_START_NID];
-		if (!auto_jack) {
-			if (ca0132_use_alt_functions(spec))
-				ca0132_alt_select_out(codec);
-			else
-				ca0132_select_out(codec);
-		}
+		ca0132_disable_hp_auto_detect(codec);
+		if (ca0132_use_alt_functions(spec))
+			ca0132_alt_select_out(codec);
+		else
+			ca0132_select_out(codec);
 		return 1;
 	}
 
@@ -5988,7 +6009,6 @@ static int ca0132_alt_output_select_put(struct snd_kcontrol *kcontrol,
 	struct ca0132_spec *spec = codec->spec;
 	int sel = ucontrol->value.enumerated.item[0];
 	unsigned int items = NUM_OF_OUTPUTS;
-	unsigned int auto_jack;
 
 	if (sel >= items)
 		return 0;
@@ -5998,10 +6018,8 @@ static int ca0132_alt_output_select_put(struct snd_kcontrol *kcontrol,
 
 	spec->out_enum_val = sel;
 
-	auto_jack = spec->vnode_lswitch[VNID_HP_ASEL - VNODE_START_NID];
-
-	if (!auto_jack)
-		ca0132_alt_select_out(codec);
+	ca0132_disable_hp_auto_detect(codec);
+	ca0132_alt_select_out(codec);
 
 	return 1;
 }
-- 
2.53.0



