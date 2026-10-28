Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209920;
	b=mIbefBl6798U2GUE+5Yfr6CtVr9aPJVdRjL4lKXCZTPj2/sTUaDu6eBQIb2swV97Fyyu
	 Rfor5wi/WQSXgBEzkHZH3kNRO8KrefCQq21Jjx+Ca706Gf5iBTth898sBonSaA46blzGS
	 0uhFx4TuJodsRXY9Hyg9kuJF4IzGCy4iB9TruxuMcknhHrvBKd1HslAIAMtMf2GQv2lXM
	 Mvee13PK0gGTCzAnJDvJJVJsllsK+ZxKuBdY/H9eQBrT2MjhOXHckOUEF6LpA4UPJkNug
	 atIWAGR5lQveMK+CMFRkPIaqsZak8j5YvbdEaSMhA6df9B/NyYoCuRdAAOYScMduT6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E1AC+cne6zsn1+idMNmszCjNc0fWHGG8+pEZc7Hoya0=;
	b=OkXj4NYAhnDL+7il+3coNs/6M3XfTV8hOZuogO70htA4T3CFu1AHI77DcSpooP4wL+m9
	 axsu4NASzxbH7fXsW57GFVrR23zxbUPcL3HJ04g9F7U9F5rHpJbUmZx6fqb9VL3P9AL9x
	 U4TQA5kUOf72lrDJTxjuZxUhA3SGcKkPkZ5cgw0KhDnPIic4DIo/JFwo7UNBSA97LCBUf
	 7XpD//67UQ+JqR29P39a7wsAj8Er/Ly8108zQ3/yEH9bj4K+QADEmoSX7RvPdd1Y0/uUy
	 lr1yJodRNhu7YH7PEJlFeAP0WRj4EHYF2qWgspaygCOKwXifTYE5ZgWTmud1RZunTWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oE0tQiER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3447606A335;
	Wed, 28 Oct 2026 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oE0tQiER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA3A1F01825;
	Wed, 28 Oct 2026 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209919;
	bh=E1AC+cne6zsn1+idMNmszCjNc0fWHGG8+pEZc7Hoya0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oE0tQiERi3UOcr2dFFzh2w5IpULPLAvwffjqoo3CYYvREdkcE4lGGdHvMQfe1xP3b
	 67UEjVdLKtpGHV1ChE27ERom0Kwm9JbsvTFXHsdFaeg2wVsh8YP0RFIX/w6jB/cEbm
	 qnxM9KLH4SUpoBPXI5QRewrnKCceLYzSB5H2M7Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Tiraspolsky <stiraspo@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/168] ASoC: Intel: avs: Reset the stream unless it is already prepared
Date: Wed, 28 Oct 2026 17:59:10 +0100
Message-ID: <20261028165943.436384226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Tiraspolsky <stiraspo@gmail.com>

[ Upstream commit f6be9f558a83fe30a03bd3adae461c821a0cef8c ]

Commit cfca1637bc2b ("ASoC: Intel: avs: Unprepare a stream when XRUN
occurs") resets the HDA stream when ->prepare() is called in the XRUN
state. User space does not always recover that way. PipeWire's ALSA
backend recovers from an underrun with snd_pcm_drop(), snd_pcm_prepare()
and a new start, so ->prepare() runs in the SETUP state,
hdac_stream->prepared is still set and the reset is skipped. Every
recovery attempt then fails the same way:

  spa.alsa: hw:avsmax98927,1p: snd_pcm_avail after recover: Broken pipe

On a Google Pixelbook (Kaby Lake, max98927 speakers) this happens after
an occasional underrun during normal playback and silences the speakers
for one to four minutes, until the PCM is closed. It can be provoked by
stopping PipeWire with SIGSTOP for 0.5 s during playback: in one run
that single underrun led to 1297 failed recoveries over two minutes,
until the sink was suspended. A plain alsa-lib program that recovers
with snd_pcm_drop() and snd_pcm_prepare() hits the same loop, while
snd_pcm_prepare() straight from XRUN recovers at once.

Skip the reset only when the stream is already PREPARED, the repeated
->prepare() case the check exists for, and reset it otherwise. With
this change both kinds of recovery succeed with a single restart.

Fixes: cfca1637bc2b ("ASoC: Intel: avs: Unprepare a stream when XRUN occurs")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Sergey Tiraspolsky <stiraspo@gmail.com>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261010103753.16969-1-stiraspo@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 12e31027d99c2..69bb01ae25765 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -611,7 +611,7 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	host_stream = data->host_stream;
 
-	if (runtime->state == SNDRV_PCM_STATE_XRUN)
+	if (runtime->state != SNDRV_PCM_STATE_PREPARED)
 		hdac_stream(host_stream)->prepared = false;
 	if (hdac_stream(host_stream)->prepared)
 		return 0;
-- 
2.53.0



