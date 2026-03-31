Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B784D421A1D;
	Tue, 31 Mar 2026 16:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975070; cv=none; b=ZQ77ZI5oRc0lAQytCgjQN54/udfDTzNpTGSd6V2HAHfdRdEY3E4B8i6JOVFPZ2rdazK2q+WVKjB4XTHJ18T4eCcoiwhmG54/AA4C7u964ZAPQc+2VH+NmFbDiUDYvl5lGC4zRvl8h2aXydyUXqOg6/+WNTc9lE+lmGBwuNrOHl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975070; c=relaxed/simple;
	bh=kr3dax1OYXwAjpB1yPn06IPn6ceYpr55Bz1cwnq8fqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A97MSXvcrLl9ltIQl8wzXjchIwllieETreLUK8Gnlvi7ApAPjguNhISt1ZeT82aKvEBL4dgEZWMoWdtIW0i8WSGDykNjm0B/fudPb75LQqrqGNkGa9XboNMUHPjBSl8eLp5fFfTbzzu5bpA7xTrOlu4pwCC9vZI3Uql4+Y0SFis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1mAYtxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1mAYtxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8B5C19423;
	Tue, 31 Mar 2026 16:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975070;
	bh=kr3dax1OYXwAjpB1yPn06IPn6ceYpr55Bz1cwnq8fqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1mAYtxWpD2JIDmmCIz6qP9Ypc07wS92NlyEMKObiIhhwnv88lcbiGQrhGDTSYy4V
	 nVPiU8b4tTpyVNzYPzn8pJ3cl+kBJDwV63S9t8MO+mSrLCV9cIT76YmCPo57NMvVPp
	 53u8iSbTiuQtRLwPNITCPBuxJCt3lDXxjKggeh4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Rhodes <sean@starlabs.systems>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 152/342] ALSA: hda/realtek: Sequence GPIO2 on Star Labs StarFighter
Date: Tue, 31 Mar 2026 18:19:45 +0200
Message-ID: <20260331161804.599910056@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit a6919f2a01f8fbf807b015e5b26aecae7db8117b ]

The initial StarFighter quirk fixed the runtime suspend pop by muting
speakers in the shutup callback before power-down. Further hardware
validation showed that the speaker path is controlled directly by LINE2
EAPD on NID 0x1b together with GPIO2 for the external amplifier.

Replace the shutup-delay workaround with explicit sequencing of those
controls at playback start and stop:
- assert LINE2 EAPD and drive GPIO2 high on PREPARE
- deassert LINE2 EAPD and drive GPIO2 low on CLEANUP

This avoids the runtime suspend pop without a sleep, and also fixes pops
around G3 entry and display-manager start that the original workaround
did not cover.

Fixes: 1cb3c20688fc ("ALSA: hda/realtek: Fix speaker pop on Star Labs StarFighter")
Tested-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Link: https://patch.msgid.link/20260315201127.33744-1-sean@starlabs.systems
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 38 ++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index ab4b22fcb72ed..eba7afef302f7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1017,12 +1017,30 @@ static int alc269_resume(struct hda_codec *codec)
 	return 0;
 }
 
-#define STARLABS_STARFIGHTER_SHUTUP_DELAY_MS	30
+#define ALC233_STARFIGHTER_SPK_PIN	0x1b
+#define ALC233_STARFIGHTER_GPIO2	0x04
 
-static void starlabs_starfighter_shutup(struct hda_codec *codec)
+static void alc233_starfighter_update_amp(struct hda_codec *codec, bool on)
 {
-	if (snd_hda_gen_shutup_speakers(codec))
-		msleep(STARLABS_STARFIGHTER_SHUTUP_DELAY_MS);
+	snd_hda_codec_write(codec, ALC233_STARFIGHTER_SPK_PIN, 0,
+			    AC_VERB_SET_EAPD_BTLENABLE,
+			    on ? AC_EAPDBTL_EAPD : 0);
+	alc_update_gpio_data(codec, ALC233_STARFIGHTER_GPIO2, on);
+}
+
+static void alc233_starfighter_pcm_hook(struct hda_pcm_stream *hinfo,
+					struct hda_codec *codec,
+					struct snd_pcm_substream *substream,
+					int action)
+{
+	switch (action) {
+	case HDA_GEN_PCM_ACT_PREPARE:
+		alc233_starfighter_update_amp(codec, true);
+		break;
+	case HDA_GEN_PCM_ACT_CLEANUP:
+		alc233_starfighter_update_amp(codec, false);
+		break;
+	}
 }
 
 static void alc233_fixup_starlabs_starfighter(struct hda_codec *codec,
@@ -1031,8 +1049,16 @@ static void alc233_fixup_starlabs_starfighter(struct hda_codec *codec,
 {
 	struct alc_spec *spec = codec->spec;
 
-	if (action == HDA_FIXUP_ACT_PRE_PROBE)
-		spec->shutup = starlabs_starfighter_shutup;
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->gpio_mask |= ALC233_STARFIGHTER_GPIO2;
+		spec->gpio_dir |= ALC233_STARFIGHTER_GPIO2;
+		spec->gpio_data &= ~ALC233_STARFIGHTER_GPIO2;
+		break;
+	case HDA_FIXUP_ACT_PROBE:
+		spec->gen.pcm_playback_hook = alc233_starfighter_pcm_hook;
+		break;
+	}
 }
 
 static void alc269_fixup_pincfg_no_hp_to_lineout(struct hda_codec *codec,
-- 
2.53.0



