Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019962;
	b=DtJIHSJRW02f8wyihPbj2T3xmxsMFWkwm9I/06EJNV5s4vBeTpCiIhneBH9NScLGXW1r
	 i3icYEmnAtK59A5sT1hVHUQS9m61/S13u9TdzBuK1X+rLuoYrwx1i+94WO1DHlpOA+jVe
	 ve5Qq2yonM4PIfYHaIlAPrOnaNlCUG/WeMvzf4LB2pZCcf6efbw/hBnc1juK9x6KmBRv4
	 aH1jhZfllpbMkxe6rwcqzZ4GLXvU1rxp1f8LJV8jQW+Iskj4Ck6/XWxK2qZGP8OeUafKA
	 +aJJWybMnqylE/QiCZ+46na/icHkKrVaLzdIWnGPbYL0nlabqycKYMnsejeZ0rdKTxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ap/ZSmR7My83HArVGJZ7fC4uA3JOMBAtDRZNjUTvYXU=;
	b=fAw2ZXtTsqM4XiB0Io75GdtfZ8AE1Yr7SCNQshyQBrfwKMEOvjJkOUDdgUKqk193O1ZR
	 KL67NpqsYtpWelhp5y1VehNYrwDljx5NWS+dL8PSQleVajigqoMgzXKAOdfojLUChFA43
	 4XAQYQn6GEeR/qxG64wZjEdcuMsPXMkhSIc0CEgzGZyjntc/LMeSwLg0ebOqzogqo23ry
	 U0hxZw7eNTysnM53hI7wD5Blm/p56EdPM/x1N+KLH53Lg3Z5nCI8KcLJjd/Xzh5sUyVjc
	 wh5DJQk/MyUydemobYwvYW7FGlZxoCBR5Cwyio1ggkGYJbCl36lTOfYMP6Uc4E2W8fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxYvjl+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE4B606A31C;
	Wed, 18 Nov 2026 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxYvjl+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25C21F000C4;
	Wed, 18 Nov 2026 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019962;
	bh=ap/ZSmR7My83HArVGJZ7fC4uA3JOMBAtDRZNjUTvYXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxYvjl+D0DfWmx1m7RwKuduhN8CLu0HFNLq588dxYHtixE/Zm+mO87VSBG4k8/DtQ
	 M0ibSqUsp3fWkKaLQD16Ot9LboBnjr0cgdZTBUe9T6vIZ+IkZAd6lr8qS9ThedKWp9
	 9cglKvsVKUhBAK1ld+0rV4DIPGVT9DrMztbadDm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1781/2651] ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:21 +0100
Message-ID: <20261118150351.482701993@linuxfoundation.org>
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

[ Upstream commit a92571113ef297840270e4d8d4263a842302c9c4 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 4a767b1d039a ("ASoC: amd: add acp3x pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index 3f59b753243d5..c0481a9ba8586 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -233,7 +233,7 @@ static int acp_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp_base = adata->acp_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



