Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A0611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419C7C433D2;
	Sun, 28 May 2023 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301670;
	bh=A5teO7gBE3DPeEqU7lxTT0ld878SMHL3TMrwNSx7JoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1TdkenqW5TkkXZlR7q5NYRzIGiwYkZA1y+F/Esw8B9d0efX/BvCMLzGkQZaZ8pik
	 Ljef9LgydwOyeTU5qQ+gUFp3SwR/2bR3iodT+HvQYcHoVtmrdHfZRm5QFM9witHLqB
	 BzBjcXSjJlq4uMUaXtUjf1orwSjK1cg+dhoqqyd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Subject: [PATCH 4.19 114/132] ALSA: hda/realtek - Fix inverted bass GPIO pin on Acer 8951G
Date: Sun, 28 May 2023 20:10:53 +0100
Message-Id: <20230528190837.266462336@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit 336820c4374bc065317f247dc2bb37c0e41b64a6 upstream.

We've added the bass speaker support on Acer 8951G by the commit
00066e9733f6 ("Add Acer Aspire Ethos 8951G model quirk"), but it seems
that the GPIO pin was wrongly set: while the commit turns off the bit
to power up the amp, the actual hardware reacts other way round,
i.e. GPIO bit on = amp on.

So this patch fixes the bug, turning on the GPIO bit 0x02 as default.
Since turning on the GPIO bit can be more easily managed with
alc_setup_gpio() call, we simplify the quirk code by integrating the
GPIO setup into the existing alc662_fixup_aspire_ethos_hp() and
dropping the whole ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER quirk.

Fixes: 00066e9733f6 ("Add Acer Aspire Ethos 8951G model quirk")
Reported-and-tested-by: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191128202630.6626-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8540,6 +8540,8 @@ static void alc662_fixup_aspire_ethos_hp
 	case HDA_FIXUP_ACT_PRE_PROBE:
 		snd_hda_jack_detect_enable_callback(codec, 0x1b,
 				alc662_aspire_ethos_mute_speakers);
+		/* subwoofer needs an extra GPIO setting to become audible */
+		alc_setup_gpio(codec, 0x02);
 		break;
 	case HDA_FIXUP_ACT_INIT:
 		/* Make sure to start in a correct state, i.e. if
@@ -8666,7 +8668,6 @@ enum {
 	ALC662_FIXUP_USI_HEADSET_MODE,
 	ALC662_FIXUP_LENOVO_MULTI_CODECS,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS,
-	ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
 	ALC671_FIXUP_HP_HEADSET_MIC2,
 	ALC662_FIXUP_ACER_X2660G_HEADSET_MODE,
@@ -9007,18 +9008,6 @@ static const struct hda_fixup alc662_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc662_fixup_aspire_ethos_hp,
 	},
-	[ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER] = {
-		.type = HDA_FIXUP_VERBS,
-		/* subwoofer needs an extra GPIO setting to become audible */
-		.v.verbs = (const struct hda_verb[]) {
-			{0x01, AC_VERB_SET_GPIO_MASK, 0x02},
-			{0x01, AC_VERB_SET_GPIO_DIRECTION, 0x02},
-			{0x01, AC_VERB_SET_GPIO_DATA, 0x00},
-			{ }
-		},
-		.chained = true,
-		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET
-	},
 	[ALC669_FIXUP_ACER_ASPIRE_ETHOS] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -9028,7 +9017,7 @@ static const struct hda_fixup alc662_fix
 			{ }
 		},
 		.chained = true,
-		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER
+		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET
 	},
 	[ALC671_FIXUP_HP_HEADSET_MIC2] = {
 		.type = HDA_FIXUP_FUNC,


