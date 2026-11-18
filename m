Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032196;
	b=XAx3il3MXg2x3sByq1+xLehAwYdHiz+oEtZvET5NdlOpKZiUSZijFtVs1rsVNGC4almu
	 m5JxD7D9qBOrg2NF3gUMsV6nvjf7mufZXz0pcYO6+1ijlhOsxRausfQCqCA81XhULCYC7
	 7wfDHzjWX4qI7JnR5Sc1gnDdU2mlkLRcbzlCknL2+skePKEQatAM63qUnhWUdbLbxPVoa
	 8daGRxz0FKUrkBT3whVmP7MXqmkT4JvloA1EoDj1lJm2czOogqOc//O2oaAxRvtxkc/dk
	 fbej7WJPPGNBtHJU9hPRuokRX9xA+kSnhQdrOn3OBHYVsa9/wLzr7hqI5V64gbM/GAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IwppAB08EF9XVRAXTLMpjPKhS68YDxFhjax4zzPRaMs=;
	b=Cn68tipK6uKW7n3g6ryFYW8zl8gEDQQyfc1cFONVQc0uTYtxnEoIVHxP9xLduTypC2QX
	 lBf2qDvy8F14XUSredS/YDpOq8KmdHPn3WGOt8KIVHSVvaQhaQPj1PG7gSN7+Zdm2vgKg
	 ZtRHbK2X2y9p+iJMwfvekDbELtaIH/N+zSusOvD97+kJcXrxKS+Q5QEvDBUDc0o+K3Jn1
	 S9oz2T+ZhihMnCcLKKpf1tFbHMUQGjn3pdKxBKMclIBd219HtaDInmzrzXhNv38WgWfU7
	 tghU5f8SHFzg3CSAyvqcUM5oXaRbGtd21Pzy6TNzTbxzkn3RaoIhjcO86clU4HpbzdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smHriSTQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4145C606A325;
	Wed, 18 Nov 2026 20:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smHriSTQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986471F000C7;
	Wed, 18 Nov 2026 20:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032196;
	bh=IwppAB08EF9XVRAXTLMpjPKhS68YDxFhjax4zzPRaMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smHriSTQSC1NjEDMtdQ3ekdB/OjiyKbHIXrQ9/uZ5XAA5B3JhhzIRiAFMN+mQ3ScY
	 KMIq/+UlPIa1Z9NWbcn2Itf5LAw7zLWKku7sxD7vteANK3Qsw3k1LR+Y0WXurgoxhe
	 fpnFK485qGeZlHMcnBAdx2a+Em5EUxWKHYgxAeSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1285/1756] ASoC: Intel: avs: Unprepare a stream when recovery occurs
Date: Wed, 18 Nov 2026 15:56:52 +0100
Message-ID: <20261118150100.715533234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 78b330e225704..993d323046cc5 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -379,6 +379,8 @@ static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct sn
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	link_stream = data->link_stream;
 
+	if (substream->runtime->state != SNDRV_PCM_STATE_PREPARED)
+		link_stream->link_prepared = false;
 	if (link_stream->link_prepared)
 		return 0;
 
-- 
2.53.0



