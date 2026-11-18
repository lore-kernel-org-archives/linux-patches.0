Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026504;
	b=JiFttggS6YkpgsEWIrYRLatqtKXkl8kUYeHXgRx2l2RieK7FlXj4vCjIt0dFn7qBPaWt
	 mAPWOok9x3JWM2Ik05ROT5HfwYazM3n7wDXbq4n/7fhbZyYKHP//PRjPJ9PbKDbGRzDTt
	 X8Sge5ilufGzJY5W/+eFwdq6qalKLCWYkvWmzsY2QJqFOPmVAEwZAqOWpPpAM295HGckj
	 8nTvpUrff1OpJJ+UiYAusYTg0dAG/cgMk3okLQztVwyo7bXubvFPmMhp8nhAJ5horinJa
	 pyOnpdVJqWEbgEF9207Q+RxGuX+O93yrR8GxG+PjMkZpQXuMe9prMFssRk2yx38XyAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hwzd6PgtIALY7zUx9omxeHZ8BUFKL40/k255AAGQUy4=;
	b=Z31gtlqdyhRwJ+LgGT9FOfJFqxOlxXE44lljVbeQIquwBIpQ67Em7y0virl0h4hXWTUD
	 j8ej4Lpq3vWe1dV7aRgnv3XBANge9Vwecl52I/282dpeZe4U7OMv/l6exyLaRgYGBCJKS
	 eQxm+d8D/JYgi8cOrNW88ebC0y0IR8fjB8odlCc5sA/wSDKIs+gAWmUppcnRxH4bWTMRd
	 vacK8NyA6hDmVmrSgWmiJwQMUza6WS6lAHAnqFZB1nEkCiee59PwnwI+ineTpny3O7827
	 jhtXB0RXQuvuFKHHDLopdksYCcaYMWmoU9JHf1GU/X4RiKxl3Mip48afioZbUyzCKiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdQGef2U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2717606A320;
	Wed, 18 Nov 2026 18:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdQGef2U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355261F000C4;
	Wed, 18 Nov 2026 18:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026504;
	bh=hwzd6PgtIALY7zUx9omxeHZ8BUFKL40/k255AAGQUy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdQGef2UQD5RRKHeUCNmmS2CxXVmJNJmEn1uxrBabZj1OEfV2WQ/W40JJSfWs0qSM
	 l0q5nx2NK5oiZhDQOP36uhJ/s/BIpqrIBBbIDtcytaNDE2pSbfCQyUKjeHSoIU/mRu
	 +YUTzxju8vDl2/AImUpap0mqjM5/CnqDjlGyf5Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1458/2151] ASoC: renesas: msiof: Fix msiof_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:13 +0100
Message-ID: <20261118150215.021990377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit b7c58a55fd9b71c0b11b0365fdf53f49702c39b5 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from msiof_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: c61caec22820 ("ASoC: renesas: add MSIOF sound support")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-22-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/renesas/rcar/msiof.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/renesas/rcar/msiof.c b/sound/soc/renesas/rcar/msiof.c
index f2addfbac9237..8699914c8a71b 100644
--- a/sound/soc/renesas/rcar/msiof.c
+++ b/sound/soc/renesas/rcar/msiof.c
@@ -432,10 +432,12 @@ static int msiof_open(struct snd_soc_component *component,
 	ret = snd_pcm_hw_constraint_integer(substream->runtime, SNDRV_PCM_HW_PARAM_PERIODS);
 
 open_err_dma:
-	if (ret < 0)
+	if (ret < 0) {
 		dma_release_channel(chan);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int msiof_close(struct snd_soc_component *component,
-- 
2.53.0



