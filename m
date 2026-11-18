Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019959;
	b=oXKDaOBzZeUpmSJyjI4TFnS+owBaOmWHHU7/Jch8whIeDL+bp/rnC5549O8tWxiUSYDy
	 o3o7eZHLWvipYhoVFDLCxFTNQrB9R0bLjuUBnX8bdcuCa/blz1Cn8tz8c8oTn22CdTmoP
	 66frEOqr6vQKYUXaXQKHCOxGQgMHoZ9ZT/7TN2lpTmm6cTZ3xETG5BR7FAyqpOu7RMCEv
	 iYZJXPsuJIp/rTdTSgR6Wdq7OJNRSgcX8337jUUaWvPPBl7Y/cqOHzR4Vx28l4G7j5gTG
	 NmmW0Rf2m7NiBYFlUjcHCZHaEBjo2F4BYrnkjE9m4dKe3Ub9FmTFC/nH/pA/4oXMDVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xatVIY8uO33SGkdzfuMENDgEf27sGtx5oTCVlAmuE7o=;
	b=dNQiFaNp+ptrygp/C0AYgWMRaLNtcHHGiL6Y3aGu0aDvK+kS6lF9BJ5PEjDrbvoE3bKx
	 0hJUXufeWMbdmwG9082eYZchUppZOt8mZZoJJkfuxecIUzHO/28fYOA6NdOPrBkfJNHN4
	 qP/ehmwQXES4jOfrzXqwYJKg0CZwlskQlrElPSciHI0dAnFgROvl6fPzGQx3YZ7qrSiGb
	 383mCD5viCa/H0enAsvDy8pMrV8PxdgQKnmACEcHIat57UO2P1uCX4Un6nTInoDDXJsdC
	 q+Kh4WSkYHCe+nPYO0EXehfzimExOVpvjTfE79PShkvA1l1J3qcoG7qXVxtdesnYAvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KKGqZOI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DB2606A320;
	Wed, 18 Nov 2026 16:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KKGqZOI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C4D1F000C4;
	Wed, 18 Nov 2026 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019959;
	bh=xatVIY8uO33SGkdzfuMENDgEf27sGtx5oTCVlAmuE7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KKGqZOId2ePoWWYGj7Hog5R+395Vyygi2kwSTkg1VmnC8V7mhq+tZ2ndXz28dfUe
	 AJlK/HCxiBcKyHKsB7l/SDrputcFdvqvtFdBbkk8XyFk/NtyuUhkrU7K5RyN2LjNv7
	 7bfUzqUpwyP8nrdIaZpnJxUFUCoV4p7bY+qYSe1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1780/2651] ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:20 +0100
Message-ID: <20261118150351.452354902@linuxfoundation.org>
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
index 37ea5c572eb94..072f3dc35d402 100644
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



