Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738F114AD2D;
	Thu, 13 Feb 2025 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460221; cv=none; b=iCo03QGqgwJVlt+EdyJfTTLIevq8OeZtu9yy8KkyzvnWFKIZqPmtDJ0okBb98xQfoM/eRhWl/DFvpG2q46XnjtcAiNzU4YH8kh3+gEKGF+Ng+BQYrWkQ8GHMwfrRin6ahHKOfySSqynTM2AlFfcAP3Ss6B08dF4AsenhHTFjo2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460221; c=relaxed/simple;
	bh=fR4t/vEEUYTBhNagWZ3BR/3fUko4AYC+/5Gvw7FV3CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feoOhjis5X565ozlxfNCgddQBr1nAUQjEob0W/CAlz4QkcfcnLFuHDwUSd2kTfq9i31NpVjkdFJKYoiYhekgCVYtjYUHZ0Cu7fTzZTK1cQVV5sFpGGOq0XyhNN8YdOxhYMY/uduIPPrAAVNu0XI6hSvFTmf34aK9TNlasvLIwN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lzrsjvkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lzrsjvkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85C8C4CED1;
	Thu, 13 Feb 2025 15:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460221;
	bh=fR4t/vEEUYTBhNagWZ3BR/3fUko4AYC+/5Gvw7FV3CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzrsjvkhNN+GpFMv9mW8bBq85+k5KGpRTBJYEboJaS5h5ZROmjJlff6NDb10zrNS+
	 mMsiaaQetvNtcHgVG5YsvQAQG7eDylh6zESsBcHOEtSZZJifJ/yv4ZEeMV49qUdMs3
	 xeVFiM+qKGfhsb+StCX9UC/SiAnoI+KLaxD94Kzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/273] ASoC: soc-pcm: dont use soc_pcm_ret() on .prepare callback
Date: Thu, 13 Feb 2025 15:27:02 +0100
Message-ID: <20250213142409.328388909@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 sound/soc/soc-pcm.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 511446a30c057..60248a6820aac 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -38,7 +38,6 @@ static inline int _soc_pcm_ret(struct snd_soc_pcm_runtime *rtd,
 	switch (ret) {
 	case -EPROBE_DEFER:
 	case -ENOTSUPP:
-	case -EINVAL:
 		break;
 	default:
 		dev_err(rtd->dev,
@@ -902,7 +901,13 @@ static int __soc_pcm_prepare(struct snd_soc_pcm_runtime *rtd,
 	}
 
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
@@ -914,6 +919,13 @@ static int soc_pcm_prepare(struct snd_pcm_substream *substream)
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
 
@@ -2461,7 +2473,13 @@ int dpcm_be_dai_prepare(struct snd_soc_pcm_runtime *fe, int stream)
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
@@ -2501,7 +2519,13 @@ static int dpcm_fe_dai_prepare(struct snd_pcm_substream *substream)
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



