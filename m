Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AB14078D3;
	Thu, 17 Sep 2026 18:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670661; cv=none; b=NhxX/9cKYYcz5KsXfx3fAAbvopYfdGsDlHh5L/LlRMqMihmkt6nI/dyB5uaclJsKLtINEfylo37YsODbMIJVF837eddwzb8269G0Z68F/N4GUTjWP9yluxTMFzOYYuPVDNwEp2cFHdb2LLzOjYC/M6E+m/8FdZj02Yu682ualb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670661; c=relaxed/simple;
	bh=iLX65W4HRWk+rhIGtHUPKd3yxMyoKec8tgPpuKH9GYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S20v0P+9xXT1ggkDP0HIRQefN+QZFmbouzQRhrXM/SD//wsIZX3iz01D18KUEXrkC9PgTbv/xX5Dm27kXH3OwJ0sXj/2ojvPkxs3gv5ytXCcIqtr2R/Y4ntq6Nzk54UHqRECUj3A+c0eccyBv8fawu7d5nl99OETc4dwXzh95RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2U9br6c+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2U9br6c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648981F000FF;
	Thu, 17 Sep 2026 18:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670660;
	bh=0EmtNnvMGmnT6Am77fFx3E4IzoiGN8Fvh2w9pzZaD+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2U9br6c+xGuzouGlWScw5TvYYHHFGSZ4jJaiZ0zVMVtnWV1r3MFs0TuBX5ETZYEEv
	 cA3DW6kLbxxWNLKVgPVEjgT2GCkTy9A11rf3N02JQfgSHVGqg9H8BF8cltFqneSq++
	 SFmKjrHpLCL4jxk3oRkDGFiOzfuUKurp+I20R5vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0732/1102] ALSA: hda: Introduce auto cleanup macros for PM
Date: Thu, 17 Sep 2026 16:11:15 +0100
Message-ID: <20260917151558.755025365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index c1fe6290d04dc..908258fb23eaf 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -499,6 +499,36 @@ static inline bool hda_codec_need_resume(struct hda_codec *codec)
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



