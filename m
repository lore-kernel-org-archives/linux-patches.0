Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FD738389;
	Thu, 13 Feb 2025 15:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459460; cv=none; b=ewVOxmOd7M+Q2/LtN59rvYSgVU5KFBaYe1fQ+1e4ubZVGqsziWMaY/g6v/xHMdtC+KriwcEwyB0P8qCq9coHNeSY0jKbKVhqYa/ylm83+K2o4+jssJRZGFmHGxd+2+nLdqW49oplYkndpMo9xLNzSD9AVZDWHMfHuDxP8A3IDI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459460; c=relaxed/simple;
	bh=bA+AxUHgA2eDo+/ZsG11wwjy0VJZmcyHgVTZ0pcmbUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8AOYmK5Sg0/Yo/Lh3xaBw2Usj0HaMJGltOovV3HHCxMTEZE3ipWIVhnQ4b2tT3NC/qcAfv5RJvwU4AM2sj7+0ocKsRLf7VUKj+wUntUarkRtqo6oUW7xcfLdAJBXGxIzELmh9w+XKUzZim4/4IwX2MQlE3h631kgODihW8QDO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYbi0k3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYbi0k3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2465EC4CED1;
	Thu, 13 Feb 2025 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459460;
	bh=bA+AxUHgA2eDo+/ZsG11wwjy0VJZmcyHgVTZ0pcmbUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYbi0k3L63og+0XCNsaFG7KQtnLHOzksTuRKWnB49LBl2MS6+2DtxOXyhtnz+fYpn
	 Nl3e0RsdsIYoee74/jPOHeLVaq4mS77nkNGJ0yK013zDvAg+ZWq5x4RMEyJxmcbf/P
	 A4tTUWewYs4QmFHpjFE2JHwWBrP9tTHZwbAdduBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 270/443] ALSA: hda/realtek: Workaround for resume on Dell Venue 11 Pro 7130
Date: Thu, 13 Feb 2025 15:27:15 +0100
Message-ID: <20250213142451.030896014@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8c2fa44132e8cd1b05c77a705adb8d1f5a5daf3f upstream.

It was reported that the headphone output on Dell Venue 11 Pro 7130
becomes mono after PM resume.  The cause seems to be the BIOS setting
up the codec COEF 0x0d bit 0x40 wrongly by some reason, and restoring
the original value 0x2800 fixes the problem.

This patch adds the quirk entry to perform the COEF restore.

Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219697
Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1235686
Link: https://patch.msgid.link/20250130123301.8996-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7485,6 +7485,16 @@ static void alc287_fixup_lenovo_thinkpad
 	spec->gen.pcm_playback_hook = alc287_alc1318_playback_pcm_hook;
 }
 
+/*
+ * Clear COEF 0x0d (PCBEEP passthrough) bit 0x40 where BIOS sets it wrongly
+ * at PM resume
+ */
+static void alc283_fixup_dell_hp_resume(struct hda_codec *codec,
+					const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_INIT)
+		alc_write_coef_idx(codec, 0xd, 0x2800);
+}
 
 enum {
 	ALC269_FIXUP_GPIO2,
@@ -7785,6 +7795,7 @@ enum {
 	ALC269_FIXUP_VAIO_VJFH52_MIC_NO_PRESENCE,
 	ALC233_FIXUP_MEDION_MTL_SPK,
 	ALC294_FIXUP_BASS_SPEAKER_15,
+	ALC283_FIXUP_DELL_HP_RESUME,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -10117,6 +10128,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc294_fixup_bass_speaker_15,
 	},
+	[ALC283_FIXUP_DELL_HP_RESUME] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc283_fixup_dell_hp_resume,
+	},
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -10177,6 +10192,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1028, 0x05f4, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x05f5, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x05f6, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0604, "Dell Venue 11 Pro 7130", ALC283_FIXUP_DELL_HP_RESUME),
 	SND_PCI_QUIRK(0x1028, 0x0615, "Dell Vostro 5470", ALC290_FIXUP_SUBWOOFER_HSJACK),
 	SND_PCI_QUIRK(0x1028, 0x0616, "Dell Vostro 5470", ALC290_FIXUP_SUBWOOFER_HSJACK),
 	SND_PCI_QUIRK(0x1028, 0x062c, "Dell Latitude E5550", ALC292_FIXUP_DELL_E7X),


