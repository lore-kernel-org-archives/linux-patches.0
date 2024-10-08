Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CE01DE2CD;
	Tue,  8 Oct 2024 12:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389698; cv=none; b=E/H1+ks9anYVZaSRD72waBJzwSPe5oagriY8IUVY+a+slHhNIF8TxdKnEnBo5LEbhPc58cgrq/yzqSlfimjFdyEsr0VQb0P8MBoRPb2ozHAMz449hDBt0eEVZHBI4i/WBo2cEpTgSQSk8/1LpJvnCo13CT6jgHvJZr0KsnPmX48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389698; c=relaxed/simple;
	bh=+nFhgzs+6FDmV09gTG7kC6znU756X+2hG8ehus6OytU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utjWMxHA62/xAoGulp2w6ec8opYY7rwa6CLfi5TEG31wG8S2r61qCGxrv9wDh5zke4fGHE5crCubF0c6TSryvYJt8ST7GJ6EoqM5pVqBB6JAcgjuS5vO0jLr6cNx/3AnpQHY4OaxqqCMAMbfqE1cx3ePGcfbCmTUo1xWfB+Y9gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgB3OfOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgB3OfOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78614C4CEC7;
	Tue,  8 Oct 2024 12:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389697;
	bh=+nFhgzs+6FDmV09gTG7kC6znU756X+2hG8ehus6OytU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgB3OfOl/ITYTcERx1PBrTwDL+ozk82tR9/kidbPlyBwEOEg8UTMVnZxDT789plhd
	 bvF3BCY5wvMrVudPwZZHq+XMOr/f77FfSSIoMJqqXvFNCpWe5PfcPjjMU0fanubvs3
	 x1IV/y8NRO1kDAQ7I2bai4XwXSEqAE70g0h4NoKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Jerry <jerryluo225@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 070/482] ALSA: hda/conexant: Fix conflicting quirk for System76 Pangolin
Date: Tue,  8 Oct 2024 14:02:13 +0200
Message-ID: <20241008115651.061564488@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b3ebb007060f89d5a45c9b99f06a55e36a1945b5 ]

We received a regression report for System76 Pangolin (pang14) due to
the recent fix for Tuxedo Sirius devices to support the top speaker.
The reason was the conflicting PCI SSID, as often seen.

As a workaround, now the codec SSID is checked and the quirk is
applied conditionally only to Sirius devices.

Fixes: 4178d78cd7a8 ("ALSA: hda/conexant: Add pincfg quirk to enable top speakers on Sirius devices")
Reported-by: Christian Heusel <christian@heusel.eu>
Reported-by: Jerry <jerryluo225@gmail.com>
Closes: https://lore.kernel.org/c930b6a6-64e5-498f-b65a-1cd5e0a1d733@heusel.eu
Link: https://patch.msgid.link/20241004082602.29016-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index e851785ff0581..4a2c8274c3df7 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -816,6 +816,23 @@ static const struct hda_pintbl cxt_pincfg_sws_js201d[] = {
 	{}
 };
 
+/* pincfg quirk for Tuxedo Sirius;
+ * unfortunately the (PCI) SSID conflicts with System76 Pangolin pang14,
+ * which has incompatible pin setup, so we check the codec SSID (luckily
+ * different one!) and conditionally apply the quirk here
+ */
+static void cxt_fixup_sirius_top_speaker(struct hda_codec *codec,
+					 const struct hda_fixup *fix,
+					 int action)
+{
+	/* ignore for incorrectly picked-up pang14 */
+	if (codec->core.subsystem_id == 0x278212b3)
+		return;
+	/* set up the top speaker pin */
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		snd_hda_codec_set_pincfg(codec, 0x1d, 0x82170111);
+}
+
 static const struct hda_fixup cxt_fixups[] = {
 	[CXT_PINCFG_LENOVO_X200] = {
 		.type = HDA_FIXUP_PINS,
@@ -976,11 +993,8 @@ static const struct hda_fixup cxt_fixups[] = {
 		.v.pins = cxt_pincfg_sws_js201d,
 	},
 	[CXT_PINCFG_TOP_SPEAKER] = {
-		.type = HDA_FIXUP_PINS,
-		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x1d, 0x82170111 },
-			{ }
-		},
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cxt_fixup_sirius_top_speaker,
 	},
 };
 
-- 
2.43.0



