Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E11423A8E;
	Tue, 31 Mar 2026 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976328; cv=none; b=H5Ucuv+Zu3VnKRe1LNkcKZm0YL7GiLrsfG5yYKGfCkzZRJ0p1Cu/cV/tTOh1jzquTf6LteWAWSROowuGHALSIusuOxpnUPkJaaKbfvjF2bGH71DsSAJ1BhF0CN+C1Sgc01alO6Zpg3/mIJtFJtINowLkWSsCPqs1sB4FaMTUX0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976328; c=relaxed/simple;
	bh=P/U05GB+kR5iqDvlZ4Teoy3a5CT5xkjL4yRubZ7MC40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oY+azrFbDIjhtFxs9pqZ2Ud/LOsJJEhaJc7L45K/fXbavdtr1wHPx7K5r0VwEF/eAO2KYJSL9nipXC71vyrR83GF/8CAdyrw082z0eS2Bmdxbah8E16kINU/M5bpgRDwvP2nXrWBHHrImz6a4nDFQGrG8RmcQamnWOfm0HUu9hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htdoTzfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htdoTzfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C68C19423;
	Tue, 31 Mar 2026 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976328;
	bh=P/U05GB+kR5iqDvlZ4Teoy3a5CT5xkjL4yRubZ7MC40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htdoTzfPT+kFvy2Mzb0UVbVU2pI5UTLbVsT4lGvM9VyhTKWxZbhCU8oaSxEMlgBT1
	 zASqmtXnM58KLj47QlHyt+T0Rk9TzqxehrDt3r+/OUtRVF2YRWxWseylGnSa4/jcpb
	 eYR/M/q+nSusiB2Ph6Kz8ThVgMnhA0eTXy4dWmug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/309] ALSA: hda/senary: Ensure EAPD is enabled during init
Date: Tue, 31 Mar 2026 18:19:13 +0200
Message-ID: <20260331161755.327694393@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index 9aa1e9bcd9ec0..601b7eb38eb13 100644
--- a/sound/hda/codecs/senarytech.c
+++ b/sound/hda/codecs/senarytech.c
@@ -25,6 +25,7 @@ struct senary_spec {
 	/* extra EAPD pins */
 	unsigned int num_eapds;
 	hda_nid_t eapds[4];
+	bool dynamic_eapd;
 	hda_nid_t mute_led_eapd;
 
 	unsigned int parse_flags; /* flag for snd_hda_parse_pin_defcfg() */
@@ -131,8 +132,12 @@ static void senary_init_gpio_led(struct hda_codec *codec)
 
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



