Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5664B2C15AB;
	Wed, 20 May 2026 18:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302847; cv=none; b=olY4XkBjwJ5li+7dHpvNFGLsxacNHjg+ZlDMb23PCOcogJ/IMv7+4esNwXhEpCH7ZPCOvChSm0aXO00Snqs33G4zsUR1lPvp54J1H7PVwC+d4O8oaor/qUS1YPFpDyVbClwOupUsLo+UmrbhahB2DG6QinW431i+DPCtxKxFssk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302847; c=relaxed/simple;
	bh=+UaEJl36i12vFspxQEVyDRNDiqHsp462LCH0mPsxE1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0jZO39zl0XbLgY63wqCkNbhYnE0uonxAMa+fFVtK62+poWf8F+w5OLlSzxIhV5/38zWy/2lQSzc1O6HpLUB4y1ClB+dkFUW2qXnAF4yxNgcEhI91di/egvuZzhlKBcg/8mrTAogh5tdAAFQ8pDexXzNOBmmbKTlT3FS/WsMkmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNkRseuC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNkRseuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0A91F000E9;
	Wed, 20 May 2026 18:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302846;
	bh=/UPz3A1xHoBsYXjFt8K3asW3teIqbc/j/Ws+GSFX834=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNkRseuCEl/26OxljW+WdEhZYArQbst68pg8H4Hf14chaWhh1tar6fVE8yqX3M531
	 aY3pwNJG+1KxYmrccZEnnRc8wvh4AMZQx63t9kBDEZ5HMVaqCIcDRYLo/qppuDiZbL
	 jzYd8Y2RYfr5tTtRsf47KTFNnmdwfktdrw+6dkrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 421/508] ALSA: hda/conexant: Fix missing error check for jack detection
Date: Wed, 20 May 2026 18:24:04 +0200
Message-ID: <20260520162107.727149049@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/patch_conexant.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index abcad66356d59..f6e563e03edf2 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1186,6 +1186,7 @@ static void add_cx5051_fake_mutes(struct hda_codec *codec)
 static int patch_conexant_auto(struct hda_codec *codec)
 {
 	struct conexant_spec *spec;
+	struct hda_jack_callback *callback;
 	int err;
 
 	codec_info(codec, "%s: BIOS auto-probing.\n", codec->core.chip_name);
@@ -1202,7 +1203,12 @@ static int patch_conexant_auto(struct hda_codec *codec)
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



