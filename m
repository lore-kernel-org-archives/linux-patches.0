Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E660133C187;
	Mon, 20 Apr 2026 15:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700058; cv=none; b=ECQzOzXpnhJI9sYJUKVlmlihn4K0myfrcXVD0mUdnrsoyrZMIxjKeieG/KRwYZXXIC6PkPb/wKZuEXkPiuYDEn0B7knHXtgrpqdkXsBW8jJI5r5hOTxDVds4BRer3wn2yDMyTukjJvLT5pa6q54457Nfakdvlwe9wOwSQP+j1Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700058; c=relaxed/simple;
	bh=nK80jKlIcTndJArCYB/FwNIqfC6TM2ZL0utBv1ESBWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmG16jI0t4bNKsn813mhGYKPL/eSxDNy3XPE1JjBCgQdZReZTplhsq1qg9ZNBX8zaFbqfc2n9/qilR8LMGzM8W8qQ+ihNq7L/+jVzZooIeXeorL954Mb3rMvN0OMUeBtpZfUIAJwmuhSHTb+iDwPQrrnIu5xl1HXAlrc6nigMjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxmjxSi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxmjxSi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E510C2BCB4;
	Mon, 20 Apr 2026 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700057;
	bh=nK80jKlIcTndJArCYB/FwNIqfC6TM2ZL0utBv1ESBWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxmjxSi65AwlhdhsB/Hks9DoJ/ju7/jnKrCJE8uI1ohQijzwxMfRY7FECpsn/yVOf
	 /rDAQ036h1RzhzE3G1Bd9JEnjohx6+wJrwtorP2egIH3xN9m8oFvMhcBQZHlshqiZr
	 6HVFva72XVfG0mvIXv4aaA/BsavOVO8V6hv3n64s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 025/220] ALSA: hda/realtek - Fixed Speaker Mute LED for HP EliteBoard G1a platform
Date: Mon, 20 Apr 2026 17:39:26 +0200
Message-ID: <20260420153934.935917746@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit d3be95efc6a1e03230ef646b498050152efe2888 ]

On the HP EliteBoard G1a platform (models without a headphone jack).
the speaker mute LED failed to function. The Sysfs ctl-led info showed
empty values because the standard LED registration couldn't correctly
bind to the master switch.
Adding this patch will fix and enable the speaker mute LED feature.

Tested-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/279e929e884849df84687dbd67f20037@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 8733f57c4aafe..1791ed0f3b4df 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3725,22 +3725,42 @@ static void alc245_tas2781_spi_hp_fixup_muteled(struct hda_codec *codec,
 	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x0);
 	alc285_fixup_hp_coef_micmute_led(codec, fix, action);
 }
+
+static void alc245_hp_spk_mute_led_update(void *private_data, int enabled)
+{
+	struct hda_codec *codec = private_data;
+	unsigned int val;
+
+	val = enabled ? 0x08 : 0x04; /* 0x08 led on, 0x04 led off */
+	alc_update_coef_idx(codec, 0x0b, 0x0c, val);
+}
+
 /* JD2: mute led GPIO3: micmute led */
 static void alc245_tas2781_i2c_hp_fixup_muteled(struct hda_codec *codec,
 					  const struct hda_fixup *fix, int action)
 {
 	struct alc_spec *spec = codec->spec;
+	hda_nid_t hp_pin = alc_get_hp_pin(spec);
 	static const hda_nid_t conn[] = { 0x02 };
 
 	switch (action) {
 	case HDA_FIXUP_ACT_PRE_PROBE:
+		if (!hp_pin) {
+			spec->gen.vmaster_mute.hook = alc245_hp_spk_mute_led_update;
+			spec->gen.vmaster_mute_led = 1;
+		}
 		spec->gen.auto_mute_via_amp = 1;
 		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
 		break;
+	case HDA_FIXUP_ACT_INIT:
+		if (!hp_pin)
+			alc245_hp_spk_mute_led_update(codec, !spec->gen.master_mute);
+		break;
 	}
 
 	tas2781_fixup_txnw_i2c(codec, fix, action);
-	alc245_fixup_hp_mute_led_coefbit(codec, fix, action);
+	if (hp_pin)
+		alc245_fixup_hp_mute_led_coefbit(codec, fix, action);
 	alc285_fixup_hp_coef_micmute_led(codec, fix, action);
 }
 /*
-- 
2.53.0



