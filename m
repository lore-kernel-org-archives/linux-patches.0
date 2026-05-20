Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4257C3F39C9;
	Wed, 20 May 2026 17:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299575; cv=none; b=URa8PxBc4Wx0mWHb/5I66s8pkpVxgq0lcoBAZJAgekznJTwgOzvz/ZOm1t9SHEY8GtBpRx5SjAs0GsAsF8WqAFBK+s5la97gtyon72jtBVmHM92mx2J5vS/4vOXqhjvZQPrC7u9hjG0oqFpDvi2cjPaxbB4Fd22KZ06ZqC0HZ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299575; c=relaxed/simple;
	bh=F66xDXWa5FWMQ2KiFcw3XCwsMKfFkJvkE6e+yIMpHyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiR+93j3ENszzaXl3LOdBQPtSBZ7qmpj46R04tOA5NFJ0KpleCqeYj717S9bVHGfd9hR/elz8i9g4nRcXmRB63Tqs1sk21tfUpvXSiZEKoYLsfd8wU3r4tJ0nyRbLfer4zs7/QZUUh6omjQ7151PJXRx/RxdGVOMMVuLg6D7fi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhZlbBXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhZlbBXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88C11F00893;
	Wed, 20 May 2026 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299574;
	bh=XGOJ4p+VisknIc+9m3e6sgVlPmfa4udZBZVtL1A0hb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhZlbBXydUvU2rRsokbDFmDq+s/cv+HZ+vr/vWC6k3t7cBJXUQUhuOHc4PLBrM3nT
	 pkFOt6DajVm7Jw4T9sGxBTLJfpYq7QOlHSKIo2PlunMeh4rFgP1sc02Iwt1VA7VRJb
	 Vj4nix8z8LWLulUXVBpY+3X9PRRbSkQgm4FVrTTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 824/957] ALSA: hda/conexant: Fix missing error check for jack detection
Date: Wed, 20 May 2026 18:21:47 +0200
Message-ID: <20260520162152.438424382@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index f71123a475464..263773f8bd6ae 100644
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



