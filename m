Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A493C8728;
	Wed, 30 Sep 2026 19:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795408; cv=none; b=lQD/hMyIKC4BGJMFm9JISiSgIs8LPNw6q0cskx6bNjjUfzj5MFsjjghB3myugkPWe0z1TO+0y+xOgv7kKK7J0bJ4xVqG0G7/2LzVdCEA5SXzl+NAwp+ygIhXTjw27PZ5qx6BUlQejPVRQKreesPBppYx7YzseeYSbiiUTcnlU5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795408; c=relaxed/simple;
	bh=uoak8KW5gNTLnH1Nd+K+mHJkEH6p9MWNAKgAPLFvWqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTPTY7gMNSocCkLI6It8U+GFgsNrribW390aIN7sswJAugogPHTg3HZrbqr8Xj56NyW8T7gxd5JuBh5tDQtM55qM/J0YK1cZV64YzeadljzVWCkVBtNl12qNzgQv8Gi/obggJnp0RsTXCoOVIe80mJhRbNy4iph2D3051meEOJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNUNv1o6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNUNv1o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D61E1F000FF;
	Wed, 30 Sep 2026 19:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795407;
	bh=RCm/hMoGKCT+Mx82rpJ+UEULhHR1wv52VCHGadNevF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNUNv1o6jucaH1lU5lPOMY2PBLkB7EQxfUB5F3cOFm0Y4t0C0N9mxm9D4lzcNEO/x
	 Ss1ZcqTX4DguuGIyrXPU+tFRHaPie0YsVRITsUo90k0AKkHJRoXa6VzQpEY9Ezoo0f
	 5dmaFrMQUj6GhIeDpAHNap7WTcTvOzI4JNFosVXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0550/1193] ALSA: hda: Introduce auto cleanup macros for PM
Date: Wed, 30 Sep 2026 17:20:34 +0200
Message-ID: <20260930152446.455242029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5d8c9c987fbdd65677315198c2b1f35a440d7cdf ]

The temporary power up/down of the codec via snd_hda_power_up() and
_down() (or snd_hda_power_up_pm() and _down_pm()) is seen in various
places.  This patch introduces simple auto-cleanup macros for those
call patterns, so that the drivers don't have to call the
corresponding power-down calls explicitly.

Namely,
	err = snd_hda_power_up(codec);
	if (err < 0)
		return err;
	....
	snd_power_down(codec);

can drop the *_down() call by replacing with
	CLASS(snd_hda_power, pm)(codec);
	if (pm.err < 0)
		return pm.err;

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250827072916.31933-2-tiwai@suse.de
Stable-dep-of: 728478874312 ("ALSA: hda: Report a change when only the channel status bytes move")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index b58dc869cf77e..de9fdfe35447a 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -509,6 +509,36 @@ static inline bool hda_codec_need_resume(struct hda_codec *codec)
 	return !codec->relaxed_resume && codec->jacktbl.used;
 }
 
+/*
+ * PM with auto-cleanup: call like CLASS(snd_hda_power, pm)(codec)
+ * If the error handling is needed, refer pm.err.
+ */
+struct __hda_power_obj {
+	struct hda_codec *codec;
+	int err;
+};
+
+static inline struct __hda_power_obj __snd_hda_power_up(struct hda_codec *codec)
+{
+	struct __hda_power_obj T = { .codec = codec };
+	T.err = snd_hda_power_up(codec);
+	return T;
+}
+
+static inline struct __hda_power_obj __snd_hda_power_up_pm(struct hda_codec *codec)
+{
+	struct __hda_power_obj T = { .codec = codec };
+	T.err = snd_hda_power_up_pm(codec);
+	return T;
+}
+
+DEFINE_CLASS(snd_hda_power, struct __hda_power_obj,
+	     snd_hda_power_down((_T).codec), __snd_hda_power_up(codec),
+	     struct hda_codec *codec)
+DEFINE_CLASS(snd_hda_power_pm, struct __hda_power_obj,
+	     snd_hda_power_down_pm((_T).codec), __snd_hda_power_up_pm(codec),
+	     struct hda_codec *codec)
+
 #ifdef CONFIG_SND_HDA_PATCH_LOADER
 /*
  * patch firmware
-- 
2.53.0



