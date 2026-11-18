Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031711;
	b=dXwiRHD31CtnQAg4s4hAsIL2s2hCWNaQVlFCcCENLgrsNUxchgnPrb/oO4tExM0ntSNC
	 kamGiHkCSlB0UtsCe7DdPaRDbtylHbhURTrroKP6U9kEU11rNQRLKQQx7O1mm2GYSY9oZ
	 dW+8hC5aBrF9g7qQuodwwX8LYjd+nv1R7V3Fz8kKKyjfTZ38CMbVEGJe1dgvYpDD6h75D
	 sEe1kDG/TMCcC+3kuXwMQMi98ahuXNfnWBVoTsb2hGLRs+XnF15U8+FcC9IGVLtgQcOwf
	 egqM2GI4hoeLn+uLJfNp8j1vT+F1YrP/mNtySiTlj7+iRgmcSppPssf4nbDX9WoqKLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5zc7fOrtEKoaamAmhGR/eVR55y9Ns17tUWzqyMsBHZk=;
	b=KpORds3Bm4T9hhlzupm5MuedoZucO5ALqg1FVubTsnADAbePddSsqES0VETAzdLjuMpF
	 qQ9poRUi837aMv10TaunEUL3RPcYQG6+yaiyVeHI9USIxrM93E/WDAaavt3oSOmFJLsdO
	 B/s16+zGs3NR0cP7ryuBXUK+GsFpS5fpwANDiF7TfMT3XffGbRyaky77qOnj0spUb7NVt
	 q4/xQdTZBW5Iq/Z88tu6KKAr7uQZj7HhWHRz8BzKy1RAsCUmkqcVY+OTp8+DCWfMs2NKF
	 lTiCRP7bCtErS+MOTbmPXPbTS2GHzHu1ZuF9+TyyosAO5warYqppJDwqKdjblkndtng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUZvNb2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C43B606A31C;
	Wed, 18 Nov 2026 19:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUZvNb2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BDC1F000C4;
	Wed, 18 Nov 2026 19:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031711;
	bh=5zc7fOrtEKoaamAmhGR/eVR55y9Ns17tUWzqyMsBHZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUZvNb2D8rUebtg1gcDTpllHlzeY3ZFysPfV19lUTiG3YW1F5IHNtj/4pPoZvJhVS
	 HL+R9Muj4UYpiZjhXDvy/5sibx+QlWYo3+cn8zUjuSbQ9aA51fw6WmViliCQgd3fQe
	 x1SR4Jco1+403XCp3uscM4QolvT/3Q1IIpkbB5m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1155/1756] ASoC: amd: vangogh: Fix acp5x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:42 +0100
Message-ID: <20261118150056.004547705@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 38559fcd1c518a33055ef0a2cf7c04b57bfa9215 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp5x_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: cab396d8b22c ("ASoC: amd: add ACP5x pcm dma driver ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-7-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/vangogh/acp5x-pcm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/vangogh/acp5x-pcm-dma.c b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
index d5965f2b09bc6..503ca9015b749 100644
--- a/sound/soc/amd/vangogh/acp5x-pcm-dma.c
+++ b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
@@ -231,7 +231,7 @@ static int acp5x_dma_open(struct snd_soc_component *component,
 	}
 	i2s_data->acp5x_base = adata->acp5x_base;
 	runtime->private_data = i2s_data;
-	return ret;
+	return 0;
 }
 
 static int acp5x_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



