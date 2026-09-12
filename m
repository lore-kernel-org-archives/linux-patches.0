Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0C03DA7D2;
	Sat, 12 Sep 2026 08:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201936; cv=none; b=mP8DH9PVzzUrcdfqnqlg4wEt2Zpn9phdbaBWswXxYkPm/Nd2DgEL97Dm7RiR4roSwKOG0lWscChDWwlSFCbYDOIHZuUZ3fqtQhM1EdK7jqANJazs66rSm8HEfFNCBWK1LsNqHiKPRFAg4W7kyMV6w3ETUO+Yhw4AUhZrFWEAGyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201936; c=relaxed/simple;
	bh=8tli17OrVzgPQEjW15FlggnGOm6oHfcwKMma004WQRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdXE+NtvWrYfUGcvqrYNigX1mMycDp8Ik9TA7LTomwc3Vp9BWBhWfCPGcQfNB79yFgUjgvGT/RmRmONwF1ERE1l9un/Z4h8iN4r4JoqTSlw157rKJnO1aBM4E4fwSqA78fQpSvGxEDksWx4MEoyF7cSl97h+L0G3jyhVviSzA8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGWBbB+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGWBbB+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A471F00893;
	Sat, 12 Sep 2026 08:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201931;
	bh=ePqk99XZLyk87z2f1KZHp3b/vEorpHkUNlH6DRhyjmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGWBbB+RpR/KQjHTg035VWFz1ulzTT6HW1JmSZ9zJA2QEUfMRgPw5KcYsWInzsxWT
	 nqNwKDykqUGEsqREFzT4zBS0eevCRrEHtg8ynTvAfIgdC5GO+FEcVwacr9J5NDSxXh
	 X2X02Wd1Pzm9hoN9PZWJpd9IHcFfd1y3LJ+U0tF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Dong <xy-jackie@139.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1055/1815] ALSA: hda/realtek: ALC269 fixup for Yoga/Legion Mic noise
Date: Sat, 12 Sep 2026 08:46:45 +0200
Message-ID: <20260912065713.783349972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackie Dong <xy-jackie@139.com>

[ Upstream commit 6cd3d2c82651a9e77aa5b1b9c12aa918c0d6c0a9 ]

Lenovo Yoga Pro 7 15ASH11 and Legion 7 15ASH11 use the same audio
subsystem implementation and support only analog microphone.

Limit Amp-In Vals to 0x00 and 0x01 for the internal microphone to reduce
recording noise. Values 0x02 and 0x03 introduce significant noise on
them.

Fixes: 17065203e1bc ("ALSA: hda/realtek:ALC269 fixup for Yoga Pro 7 15ASH11 mic mute LED")
Signed-off-by: Jackie Dong <xy-jackie@139.com>
Link: https://patch.msgid.link/20260804123637.21001-1-xy-jackie@139.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 3c18f7cae047a..c31fed171c419 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3524,6 +3524,16 @@ static void alc287_fixup_yoga9_14iap7_bass_spk_pin(struct hda_codec *codec,
 	}
 }
 
+static void alc_fixup_yoga_pro7_audio(struct hda_codec *codec,
+				      const struct hda_fixup *fix, int action)
+{
+	/* Reuse the DAC routing selected for ThinkPad X1 Gen7 */
+	alc285_fixup_thinkpad_x1_gen7(codec, fix, action);
+
+	/* Limit the internal mic boost to 0 or 1 to avoid noise */
+	alc269_fixup_limit_int_mic_boost(codec, fix, action);
+}
+
 static void alc295_fixup_dell_inspiron_top_speakers(struct hda_codec *codec,
 					  const struct hda_fixup *fix, int action)
 {
@@ -6209,8 +6219,7 @@ static const struct hda_fixup alc269_fixups[] = {
 	},
 	[ALC287_FIXUP_LENOVO_YOGA_PRO7] = {
 		.type = HDA_FIXUP_FUNC,
-		/* Reuse the DAC routing selected for ThinkPad X1 Gen7 */
-		.v.func = alc285_fixup_thinkpad_x1_gen7,
+		.v.func = alc_fixup_yoga_pro7_audio,
 		.chained = true,
 		.chain_id = ALC269_FIXUP_LENOVO_XPAD_ACPI,
 	},
-- 
2.53.0



