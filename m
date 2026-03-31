Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47064218AF;
	Tue, 31 Mar 2026 16:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975665; cv=none; b=quIuzCRxLulWGvTzRKE2gpVGNQr2gEql/xQ+rhNH6dMUXHjTBG6tPMV6HkAuiwUmxvePAfJmQmAU9fzVsUMz15wrLIjtq31PFNXLRbKSvegh1CpRdpozaZJCtbX7jUOwP+xLaYuBlp0pm6rbZomRm5QMpCpppDjGd0BXrBE6cF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975665; c=relaxed/simple;
	bh=s+lm5+NhbMVPM1WP/KvH0ovvV37RtXHA3BIXOL1oLy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMcoy4lCQWhAO8CPC4bBm0+dSbpH6ebRHspOkI8b0a4QiVYMAevOoCYigoqtjJWuN/w53BAAaHzlgtYTZ9AAZVDWF2t4w+COqDH2tJ701IYrAIuQHPyeyZXPb9s3sUHLd3m8Fws7d/Stb2Lrf99mF5hNJob6SXcNKPoL1lKdHro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcxpy7CE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcxpy7CE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B6FC19424;
	Tue, 31 Mar 2026 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975665;
	bh=s+lm5+NhbMVPM1WP/KvH0ovvV37RtXHA3BIXOL1oLy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcxpy7CE4nF9q06PHw6ce9HW9FHu14u66E7Gi+Ee/wn2mRdRJQlihjPXK88vLdXL8
	 sPlEMxbSoWbjt1wJxTqwbQupZgySiwq4wAKsw3hOrkf0HkKUcvjkwru6RQ2O7sqC3c
	 HXSnUbyh/JBlc6FHhGMK72C2Tqe2AiOQzl3PjI6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/244] ALSA: hda/senary: Ensure EAPD is enabled during init
Date: Tue, 31 Mar 2026 18:19:42 +0200
Message-ID: <20260331161742.887487476@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/patch_senarytech.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/hda/patch_senarytech.c b/sound/pci/hda/patch_senarytech.c
index 0691996fa971c..2ebc5b5a4fc36 100644
--- a/sound/pci/hda/patch_senarytech.c
+++ b/sound/pci/hda/patch_senarytech.c
@@ -25,6 +25,7 @@ struct senary_spec {
 	/* extra EAPD pins */
 	unsigned int num_eapds;
 	hda_nid_t eapds[4];
+	bool dynamic_eapd;
 	hda_nid_t mute_led_eapd;
 
 	unsigned int parse_flags; /* flag for snd_hda_parse_pin_defcfg() */
@@ -131,8 +132,12 @@ static void senary_init_gpio_led(struct hda_codec *codec)
 
 static int senary_auto_init(struct hda_codec *codec)
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



