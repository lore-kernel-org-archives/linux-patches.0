Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243BE410D27;
	Tue, 31 Mar 2026 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974905; cv=none; b=bIPC5g5G+EbPjRYZqaBqfNfmf19aIEnGhhW/35m7b3vsP2vHZt1h/OTL9vwr6zAfdPSDHebVkUqvrN1jmFHx82Mux/T5LOiPyvx+ia1KOaOV1w9rPGeLTTSth5wIM8we8xuiQFxlS+WYb9kgRo08iPWqxZWV7QvIv3DCxYywkdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974905; c=relaxed/simple;
	bh=ZMTSrmfV0UlUvvwoD1/CB4ddij/k9arRkuAU3uZMgDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3IWVSUhOc4UhFdDj4b4YpgXDALsFBTAHUWRd7hVGO3g2gTERUG8G2ZaJsGWJU3jvkNoAsYzIEqciZCgf3wrRrFF6f2HVdlkkF43vad6QDbOP06QrB0sASC+kg+kPemVZq4fAk33v0+RJUBykCamL5s7wRY7crvpIf1auyEHviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0uuSkQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0uuSkQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFE2C19423;
	Tue, 31 Mar 2026 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974905;
	bh=ZMTSrmfV0UlUvvwoD1/CB4ddij/k9arRkuAU3uZMgDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0uuSkQsMBIeWUa/fanD0hMiC4gCrzZQ/8Clu2HgJDMqJ+wD1yWsHcQk7rhcbzk4t
	 yDgJhZg3s0ZqpKRxyw0sJDO+JnzXx187XuYIzaOhjsic2SYdcHmXfYJtxElYbtB+8I
	 mnXpKpdQ7yzMI8M1JlWXF3Z3yEF0KWIryaTgN3lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 057/342] ALSA: hda/senary: Ensure EAPD is enabled during init
Date: Tue, 31 Mar 2026 18:18:10 +0200
Message-ID: <20260331161800.995457324@linuxfoundation.org>
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

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 7ae0d8f1abbbba6f98cac735145e1206927c67d9 ]

The driver sets spec->gen.own_eapd_ctl to take manual control of the
EAPD (External Amplifier). However, senary_init does not turn on the
EAPD, while senary_shutdown turns it off.

Since the generic driver skips EAPD handling when own_eapd_ctl is set,
the EAPD remains off after initialization (e.g., after resume), leaving
the codec in a non-functional state.

Explicitly call senary_auto_turn_eapd in senary_init to ensure the EAPD
is enabled and the codec is functional.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260303081516.583438-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/senarytech.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/codecs/senarytech.c b/sound/hda/codecs/senarytech.c
index 63cda57cf7868..f4732a8d7955d 100644
--- a/sound/hda/codecs/senarytech.c
+++ b/sound/hda/codecs/senarytech.c
@@ -28,6 +28,7 @@ struct senary_spec {
 	/* extra EAPD pins */
 	unsigned int num_eapds;
 	hda_nid_t eapds[4];
+	bool dynamic_eapd;
 	hda_nid_t mute_led_eapd;
 
 	unsigned int parse_flags; /* flag for snd_hda_parse_pin_defcfg() */
@@ -134,8 +135,12 @@ static void senary_init_gpio_led(struct hda_codec *codec)
 
 static int senary_init(struct hda_codec *codec)
 {
+	struct senary_spec *spec = codec->spec;
+
 	snd_hda_gen_init(codec);
 	senary_init_gpio_led(codec);
+	if (!spec->dynamic_eapd)
+		senary_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, true);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_INIT);
 
 	return 0;
-- 
2.51.0



