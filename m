Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F993CAE61;
	Wed, 20 May 2026 17:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296968; cv=none; b=jv7nCsWapEN3Kt0QwmdgLm/PtNL00wT/MFk7MqN+fLWZMs18rZjlqpzA9vx96l/T3ik8QynpVYBgiKWJuDg9h9J1qstPhnC04fRPKGA5ZPfUSRXViOQnldKP8kS9DGSxke5cOg2R7BA6Rh3KbiR6WEKxQfaZkVAkppQbTCNyVHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296968; c=relaxed/simple;
	bh=XRvUB2lwORRsV8beXc/w5TGVGAhb769UgtuDQW0v/s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7rmPQr63b61kxSH+eOICnlwmavX+Qzggguf5qW6wTT8lFe9tIxhKcOeJrapbJnQsVGUaenJL2IMXcUf1/lAjZF59D+t7GhRZDF9Ag9nbvojHhg+8QDeh7NzvOHT9yRJtTxKaX3xp2hrOQKpYq73kOIyz7/EukLmSt38MWZeBUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dyz5x35u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dyz5x35u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029971F000E9;
	Wed, 20 May 2026 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296967;
	bh=MqLo0kxOXSUhJqSWjrdD6aO1kRtCgB80uz5r9a8w1I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dyz5x35usYWSF8IMrMHkx1+7H6ZvledWi5uCLbY2+Vh6f9Y78iushV5FQSRBU652W
	 dNf2RiCutnZTAiksCD/3qmsDvYpF62WVMOQsGuB91NcTBOPvVadVRYzms8jCAfJ/kC
	 rR/VRyIK0+3/3kj9dZfPlDfpD+DQuSVHVq6D/kHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0998/1146] ALSA: hda/conexant: Fix missing error check for jack detection
Date: Wed, 20 May 2026 18:20:48 +0200
Message-ID: <20260520162210.819509103@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit b0e2333a231107adedd38c6fcfe1adc6162716fc ]

In cx_probe(), the return value of snd_hda_jack_detect_enable_callback()
is ignored. This function returns a pointer, and if it fails (e.g., due
to memory allocation failure), it returns an error pointer which must
be checked using IS_ERR().

If the registration fails, the driver continues to probe, but the jack
detection callback will not be registered. This can lead to a kernel
crash later when the driver attempts to handle jack events or accesses
the uninitialized structure.

Check the return value using IS_ERR() and propagate the error via
PTR_ERR() to the probe caller.

Fixes: 7aeb25908648 ("ALSA: hda/conexant: Fix headset auto detect fail in cx8070 and SN6140")
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260428080450.108801-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/conexant.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index aa726eb323ebe..a7689f9ef9675 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -1183,6 +1183,7 @@ static void add_cx5051_fake_mutes(struct hda_codec *codec)
 static int cx_probe(struct hda_codec *codec, const struct hda_device_id *id)
 {
 	struct conexant_spec *spec;
+	struct hda_jack_callback *callback;
 	int err;
 
 	codec_info(codec, "%s: BIOS auto-probing.\n", codec->core.chip_name);
@@ -1198,7 +1199,12 @@ static int cx_probe(struct hda_codec *codec, const struct hda_device_id *id)
 	case 0x14f11f86:
 	case 0x14f11f87:
 		spec->is_cx11880_sn6140 = true;
-		snd_hda_jack_detect_enable_callback(codec, 0x19, cx_update_headset_mic_vref);
+		callback = snd_hda_jack_detect_enable_callback(codec, 0x19,
+				cx_update_headset_mic_vref);
+		if (IS_ERR(callback)) {
+			err = PTR_ERR(callback);
+			goto error;
+		}
 		break;
 	}
 
-- 
2.53.0



