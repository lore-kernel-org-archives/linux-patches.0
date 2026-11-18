Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019956;
	b=kHz9xfXB9rwm1yZ+l12OnOX9/XgVdpc2h02JuhCRTLcpNkkZLyuRN9pwZs/EAh1Ueonf
	 oXq6vL3SJ4oLScmtijfZUnnjUMj46Yd1+j2tTmLjFRpvnTVGLhlpr7SP8P6lzY7kTPFhg
	 K6ICzwmps0SWjHuF3uKIOitDkJxoSllIF6bqkc2o5cE2TISkqlLG8picJMsmV1cF/s1n+
	 79Z2ShAJCpjmOc9mZS92pnyUqFDV1n3vV+7FjMebEf87ssj9UH4yYISYih6gf2bmnG1B/
	 iioxBPCHrEM+TXD5NmTFNd5PLyGZ/NWtgw+qeOslbLscSSNeT2qqKnW/6JDdWnHb84w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/WjuyCfwYFbYr3+oysZpwmlIOH+HEDqiiMDqdGF/hNA=;
	b=kKhHGpwzjLOrU/hmzFJ/zjsiBx9ooKTiSFMpMSuFQZcfaGsA/tyZoqVbS6bZ+c0oF2Q/
	 kPOP/xnLuQjFS5KWxx5i9xNxHS6J/wh5XGFFoFA4T6JTJF7w7QjEQdfHjCe7E0D8F3sB2
	 fVSmcvm+jtJY3eq8338w8HLkqX2DlrYST8iyePl4MdnYKw4c0zDbJqasxgOHmLeketsQg
	 dsyvUIPlGsV+fHdcujtviOPtvpYfNuoZYiKde2xewHK7fG/STcH9tKon1HG0J8Vjx3QYR
	 NLhOlgFvdmAcQztbnpmKJH3ytZyeiFudGKpg/vPcZYm81hfHBulhMqq7njGr3dTHZEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvfHpeSI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE529606A320;
	Wed, 18 Nov 2026 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvfHpeSI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205861F000C4;
	Wed, 18 Nov 2026 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019956;
	bh=/WjuyCfwYFbYr3+oysZpwmlIOH+HEDqiiMDqdGF/hNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvfHpeSIfzStYur9eBsszD7Trdl2PP9XGl2rXR/85NfTrwhxxBAxt0BEKr+uGkdrw
	 2D+Wgqv2gRJGn9awYUU2qGIxyYeRLujLqf338mYMdSGeBJ6ktHqOFO7Pv7J7XRxU26
	 W+gxUX0KmtZztc5RdW34QJ/bxT8UyiZFoIApYXA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1779/2651] ASoC: amd: ps: Fix acp63_sdw_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:19 +0100
Message-ID: <20261118150351.416012246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 45dd2b22ea8934ed69dd05e6ecbf3c66ac3baebf ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp63_sdw_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: f722917350ee ("ASoC: amd: ps: add SoundWire dma driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/ps-sdw-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/ps-sdw-dma.c b/sound/soc/amd/ps/ps-sdw-dma.c
index f27ebbd213798..553fe11a2e509 100644
--- a/sound/soc/amd/ps/ps-sdw-dma.c
+++ b/sound/soc/amd/ps/ps-sdw-dma.c
@@ -337,7 +337,7 @@ static int acp63_sdw_dma_open(struct snd_soc_component *component,
 	stream->stream_id = cpu_dai->id;
 	stream->instance = amd_manager->instance;
 	runtime->private_data = stream;
-	return ret;
+	return 0;
 }
 
 static int acp63_sdw_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



