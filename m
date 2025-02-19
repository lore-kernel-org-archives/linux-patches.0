Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7331DF74E;
	Wed, 19 Feb 2025 09:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956803; cv=none; b=df+i2DL+H/SzFPsCm2lRR2lcs7svcvtY5jroYSmOrhzdgp56eYrS3uFeBZHiYxhkI/HlwK7m4DTUz+3RoH9INFRmHCULEVBwce75S/0MmnUGcc8IU5RdR94oKCy0b99/s/ejLGs3nXH+iSXn+Ca1JefUL+sOLd8L16hPTg5vf3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956803; c=relaxed/simple;
	bh=mMow3kyevgckS9FHRrtp8vcVwVn71oFPfDZU5xRofCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fid74GaUKeUO8NYwyYLXIqrLeF9ewDfWVb7BSw+HGm3V0yNZvhRTXqRNaLXFXXtxfxlJcmxeXg8cKFwYuA97y4wFTps/pN8CV1Awg+aH8uWckeJOsn+LSmmOwY02N7Z0avmf4JBhqfBbmDbUchXg6FvQluk1Akc/kgRTK8lrrlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sa2TTuXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sa2TTuXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD54DC4CED1;
	Wed, 19 Feb 2025 09:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956803;
	bh=mMow3kyevgckS9FHRrtp8vcVwVn71oFPfDZU5xRofCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sa2TTuXKIncY5Is5azSnA0BAuAraLT6oPOL4lkrTV45Rkbttu8L4pmbsZFQKfoFpr
	 XWZtvwYavtV/iev5hr2yyotxBz3kcw/5+00P+JF13Yk8yW7RuRuJlfcgGqqJEwjPi3
	 mM2sm3axrYbw80M6cFPdkVohuIodDOJnbB9kig6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 305/578] ASoC: soc-pcm: dont use soc_pcm_ret() on .prepare callback
Date: Wed, 19 Feb 2025 09:25:09 +0100
Message-ID: <20250219082705.014765953@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 301c26a018acb94dd537a4418cefa0f654500c6f ]

commit 1f5664351410 ("ASoC: lower "no backend DAIs enabled for ... Port"
log severity") ignores -EINVAL error message on common soc_pcm_ret().
It is used from many functions, ignoring -EINVAL is over-kill.

The reason why -EINVAL was ignored was it really should only be used
upon invalid parameters coming from userspace and in that case we don't
want to log an error since we do not want to give userspace a way to do
a denial-of-service attack on the syslog / diskspace.

So don't use soc_pcm_ret() on .prepare callback is better idea.

Link: https://lore.kernel.org/r/87v7vptzap.wl-kuninori.morimoto.gx@renesas.com
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87bjxg8jju.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index f3964060a0447..3f998a09fc42e 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -906,7 +906,13 @@ static int __soc_pcm_prepare(struct snd_soc_pcm_runtime *rtd,
 		snd_soc_dai_digital_mute(dai, 0, substream->stream);
 
 out:
-	return soc_pcm_ret(rtd, ret);
+	/*
+	 * Don't use soc_pcm_ret() on .prepare callback to lower error log severity
+	 *
+	 * We don't want to log an error since we do not want to give userspace a way to do a
+	 * denial-of-service attack on the syslog / diskspace.
+	 */
+	return ret;
 }
 
 /* PCM prepare ops for non-DPCM streams */
@@ -918,6 +924,13 @@ static int soc_pcm_prepare(struct snd_pcm_substream *substream)
 	snd_soc_dpcm_mutex_lock(rtd);
 	ret = __soc_pcm_prepare(rtd, substream);
 	snd_soc_dpcm_mutex_unlock(rtd);
+
+	/*
+	 * Don't use soc_pcm_ret() on .prepare callback to lower error log severity
+	 *
+	 * We don't want to log an error since we do not want to give userspace a way to do a
+	 * denial-of-service attack on the syslog / diskspace.
+	 */
 	return ret;
 }
 
@@ -2422,7 +2435,13 @@ int dpcm_be_dai_prepare(struct snd_soc_pcm_runtime *fe, int stream)
 		be->dpcm[stream].state = SND_SOC_DPCM_STATE_PREPARE;
 	}
 
-	return soc_pcm_ret(fe, ret);
+	/*
+	 * Don't use soc_pcm_ret() on .prepare callback to lower error log severity
+	 *
+	 * We don't want to log an error since we do not want to give userspace a way to do a
+	 * denial-of-service attack on the syslog / diskspace.
+	 */
+	return ret;
 }
 
 static int dpcm_fe_dai_prepare(struct snd_pcm_substream *substream)
@@ -2459,7 +2478,13 @@ static int dpcm_fe_dai_prepare(struct snd_pcm_substream *substream)
 	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_NO);
 	snd_soc_dpcm_mutex_unlock(fe);
 
-	return soc_pcm_ret(fe, ret);
+	/*
+	 * Don't use soc_pcm_ret() on .prepare callback to lower error log severity
+	 *
+	 * We don't want to log an error since we do not want to give userspace a way to do a
+	 * denial-of-service attack on the syslog / diskspace.
+	 */
+	return ret;
 }
 
 static int dpcm_run_update_shutdown(struct snd_soc_pcm_runtime *fe, int stream)
-- 
2.39.5



