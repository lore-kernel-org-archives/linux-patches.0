Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041863;
	b=5T5TLqVy7dauubyKbhWt6Qu54sVLfclIPwOdeXQfBTrOwphm/p5VtTYJPk8MufwZM5Zm
	 /Y17HfgBQ7UWq/9dUIRLtXsRDVM3QCwiyGJdoN/+O2HLhUOJRLMJbV4U7JB5/XjVxNbgI
	 ISGkymfnl0yE6jjM7Yrah/qvEeEvzKMIMnT4wC4CbBEh6v0q0a+wfJWoP7L56IgqBYQ2m
	 eE+mlpGA+oGIJnTabEyrAMubgFCdsNBjKHwKAPjzTmIKHbVzVuuC4nHOgqihsPcCA9K5b
	 3+cfQjGlwHn78ymhz/fkhXqw6qCtw3vjzJrShhCgEoVUqsNb65S6BVGj7/hF827DIAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SnxplM7aoxRE3g4AVt897QoVqH86fFe2M4Pc/9S++Io=;
	b=k6JlJ0CHxmyG/nhve9+BGF8+EC0zgwIE8/0ceYxoLzZe/uW1a3hLREJyRc6SH5KhXJYF
	 QSxOCVNyh0+UGViPk6nOnZVIVQ3fxrGGWulcLSQFzmfs1cZMxpCCjwgSO6NkUhKn9vdNv
	 A9vIsNPIsdp2rCQG8c4RBf6bcqW1ojL4vKzMdNJHmdwky/cRnRQrOGmAa59WvGTS1S5O+
	 lJSQWw/LZRQXK8ie9CUKWBKSHx5vI/toZIsXZvP4qfOvXoAkwx2RImRflHaM7s3gBWND+
	 V7jkt1YVeBMmXS3z5Qo5Xw39d3AfPB8PCBQDnoox8AmlB66ZUy0PvdFv6FK3oHHpnyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zskXGKZ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F530606A320;
	Wed, 18 Nov 2026 22:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zskXGKZ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C551F000CD;
	Wed, 18 Nov 2026 22:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041863;
	bh=SnxplM7aoxRE3g4AVt897QoVqH86fFe2M4Pc/9S++Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zskXGKZ9t+fXeqijScCwbkKZMEhKPACu+fjWrd76/TchuKhEukZz+hwxaJmLhGnCo
	 xXoFI9eGitXdax6S/VRe3w1hZXtvU+6WBzzQG4bhlTyCHZ3cKOm5uFIT6swIDKE1lw
	 qQZ02li6Z/fe81gGyNvEfaIY4MtuVq32IPO3zSF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2938/3318] ASoC: Intel: avs: Unprepare a stream when recovery occurs
Date: Wed, 18 Nov 2026 15:59:20 +0100
Message-ID: <20261118150448.503007536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 85bc213f96ac03d74a3e531968c68861e5598281 ]

Recovery on alsa-lib side is handled with either:
1) snd_pcm_prepare(state=XRUN)
2) snd_pcm_drop/drain() -> snd_pcm_prepare(state=SETUP)

before starting the PCM anew. Relying solely on state=XRUN leaves 2)
unaccounted for. sound/core/pcm_native.c ensures correctness of the
state machine so plain state!=PREPARED check suffices.

This is the BE equivalent of job done previously for FE side only with
commit cfca1637bc2b ("ASoC: Intel: avs: Unprepare a stream when XRUN
occurs") and its follow up titled: ("ASoC: Intel: avs: Reset the stream
unless it is already prepared").

Link: https://lore.kernel.org/linux-sound/20261010103753.16969-1-stiraspo@gmail.com/T/
Fixes: d070002a20fc ("ASoC: Intel: avs: HDA PCM BE operations")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261015190240.729793-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 4c3ed762bedf8..62305dfe773de 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -369,6 +369,8 @@ static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct sn
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	link_stream = data->link_stream;
 
+	if (substream->runtime->state != SNDRV_PCM_STATE_PREPARED)
+		link_stream->link_prepared = false;
 	if (link_stream->link_prepared)
 		return 0;
 
-- 
2.53.0



