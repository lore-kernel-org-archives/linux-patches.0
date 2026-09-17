Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1024D17A6;
	Thu, 17 Sep 2026 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664613; cv=none; b=CmGK/L+kBQkaiB82y9pwU/SjZFntuLuJzzqVMTDTXQDoe9+omG0uwgDQdF+NzdhEyzcb9F7+dvE02HnYT66V9yZxSRc4XtKcU21ygdYDtUrYvbfpO4OSMeiUA+nISHXdy2Ob0F/zEcTgXouNWmf7Ur87d3wM9oTuvTUBI3SD50w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664613; c=relaxed/simple;
	bh=4H8XffDa+7YIgJQY+c85zQCCZDZczfsiU6V+wqhKkBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bj4NQBVNzserlJQv4SJndEoKx6ypo5eMlWTH3cBHnDiZyY5MO7DsgmiRv1C9flXIpRJ7BiZvpLnM3AciLjfDzTgFsBiEvDccQOtyo19KI5/l94WIpYSh0D88o/5kC8fdoklkrL7kKCG0N8zjWZEylWiMDLYL+AVlhwi++7GmXfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPDjGFLI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPDjGFLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3221F000FF;
	Thu, 17 Sep 2026 17:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664612;
	bh=UL/fGjXmng3nlLQaiTlTOOiLO8e1dkOvqHDgHNmYTfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPDjGFLIxreZ8AtLMojphj01cOjQoiWA+TzWt3N2lwJOC3u6PmcvdmKU1UQnJpyuZ
	 XUwatqLQyuRSV0T2TMuKTQ83BZoBV7AbbfXEk1mZRslRigHrjt9x2Kt7v6u9xkDe0M
	 FS3BErqFBS9y+xEMpgKgH03HFV929wItg/WrPTvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Galen Hassen <rwekyes@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0428/1250] ALSA: hda/conexant: Add pin config quirk for Lenovo IdeaPad Slim 5 16AKP10
Date: Thu, 17 Sep 2026 16:03:43 +0100
Message-ID: <20260917151603.617630805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Galen Hassen <rwekyes@gmail.com>

[ Upstream commit f7c4968ae3af3e819428da5416c2dfd361473f5c ]

The Lenovo IdeaPad Slim 5 16AKP10 (PCI SSID 17aa:38b6) uses the
Conexant SN6140 codec. The internal microphone is on pin 0x1a but
the BIOS configures it with pin default 0x95a60120, which includes
a jack detection bit that causes the kernel to treat it as an
unplugged external mic rather than a fixed internal mic.

Add a pin config quirk that overrides pin 0x1a to 0x95a60130,
setting the connectivity bits to indicate a fixed/always-connected
device. This allows the internal microphone to be correctly
identified and used.

Signed-off-by: Galen Hassen <rwekyes@gmail.com>
Link: https://patch.msgid.link/20260616173257.37373-1-rwekyes@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/conexant.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index c3c8326d0b77a..fe7445fabb887 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -294,6 +294,7 @@ enum {
 	CXT_FIXUP_HEADSET_MIC,
 	CXT_FIXUP_HP_MIC_NO_PRESENCE,
 	CXT_PINCFG_SWS_JS201D,
+	CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10,
 	CXT_PINCFG_TOP_SPEAKER,
 	CXT_FIXUP_HP_A_U,
 	CXT_FIXUP_ACER_SWIFT_HP,
@@ -831,6 +832,12 @@ static const struct hda_pintbl cxt_pincfg_lemote[] = {
 	{}
 };
 
+/* Lenovo IdeaPad Slim 5 16AKP10 with SN6140 */
+static const struct hda_pintbl cxt_pincfg_lenovo_ideapad_slim5_16akp10[] = {
+	{ 0x1a, 0x95a60130 }, /* Internal mic, fixed/always-connected */
+	{}
+};
+
 /* SuoWoSi/South-holding JS201D with sn6140 */
 static const struct hda_pintbl cxt_pincfg_sws_js201d[] = {
 	{ 0x16, 0x03211040 }, /* hp out */
@@ -1011,6 +1018,10 @@ static const struct hda_fixup cxt_fixups[] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = cxt_pincfg_sws_js201d,
 	},
+	[CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = cxt_pincfg_lenovo_ideapad_slim5_16akp10,
+	},
 	[CXT_PINCFG_TOP_SPEAKER] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -1119,6 +1130,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo IdeaPad Z560", CXT_FIXUP_MUTE_LED_EAPD),
+	SND_PCI_QUIRK(0x17aa, 0x38b6, "Lenovo IdeaPad Slim 5 16AKP10", CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10),
 	SND_PCI_QUIRK(0x17aa, 0x3905, "Lenovo G50-30", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x390b, "Lenovo G50-80", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
-- 
2.53.0



