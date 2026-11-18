Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026479;
	b=Kq1v74mn3ljArCv5bvwodRrxqjc/q4wEDf6M3/4ElvyO1KQ0KIyLOsesUjJRleWMkKlj
	 lJ9CaFi4fYt+ag3sVyXvEnfLou95+5A4d1/wmKPn7U8UCfuPbJPnKcn3g52L5zm/NTFpB
	 YkVyNI8G6tUnDqLPJySDCZiUZ2HCIMRNrcZLFqdZh5XaDU1FVKmtnwO1ldPknNQHhUbwL
	 PPX9fUrXnotJbRTAiLWDIRalwS4EkSV5AAhOg2MuSRvdGbns227tKLttQ3rz3AzqOsbUp
	 CLASWETaWMpY5Sj36LMFkCoMqbsBcI861tXHMTmDgX61enQDcb3/jmhKpynPsQe0N6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2kynzJdgNbAjirQT3U80aHrXLmGT7OMF/o+085lNoSE=;
	b=DGDAaXQXLsTg4fcUEQTkSxrJgsFoEXz9GiRfSkYhdtuxeDRZ1R6ldD9xe6AqauzUT+9c
	 mVbWGW7vQLXK1+tyKyWeXj/sjsL/1t9N9epu9m7dZOgY1oPLZgRd1DJ35B3gccMysaMaS
	 1WPTqKmidERCuRBuAbz4ccSTadkKK8IM12ktqTIYdCPFhTJLR4cExSjcSdGKY7yriOZbT
	 cNce3zLUgc5JZFFK+e8c3ByGau6/dd/8fBTqGNEGI92twSdRpe0gi/etcMOvBjiGb8Ink
	 NcITsmSaS5eZ9jsuTi52jBdeDDX5N6N5RQ2SClfBev3G77hRS8/SiA/mdyd5Pc4qIyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFZAoQ0a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D49606A32A;
	Wed, 18 Nov 2026 18:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFZAoQ0a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66441F000C4;
	Wed, 18 Nov 2026 18:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026479;
	bh=2kynzJdgNbAjirQT3U80aHrXLmGT7OMF/o+085lNoSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFZAoQ0aMFg1JCdJVVHOFYlqT5bruqHaljLwDA6g+h3w09p5HYeSfyP6s3CRqwDkn
	 kz2m0z0TlrJonPMFNruWr/Wd06qPoO5isstsGJb7HoT0B9/35plFMQIsP9Nztq4mBR
	 0I5Wm0A2Eq+GDNCGYlAbIIGQyR8YyAMiiYTHLx1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1449/2151] ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:04 +0100
Message-ID: <20261118150214.708392956@linuxfoundation.org>
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

[ Upstream commit 37ceef26df57c4a86a5e984b1951995aa96d4342 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp3x_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 703a6e22888b ("ASoC: amd: Enabling I2S instance in DMA and DAI")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/raven/acp3x-pcm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index bb9ed52d744d3..3ba58a7795973 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -237,7 +237,7 @@ static int acp3x_dma_open(struct snd_soc_component *component,
 
 	i2s_data->acp3x_base = adata->acp3x_base;
 	runtime->private_data = i2s_data;
-	return ret;
+	return 0;
 }
 
 
-- 
2.53.0



