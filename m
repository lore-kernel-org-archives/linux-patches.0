Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019965;
	b=LGUENeuFvUMOcyWQA1tf9fDmn4wkYHYNi/+bVN7o1jXtc+Vk1fMXsc4GYg/MMqNZXJoj
	 NxZ7O9xmGhAM8uUKMctMZBybhjW8eyr6T84WnHfKUbocdoo7jjSGNHuGsmyDTIAvvbZ9B
	 50qTRoRG8b1XMT+sS1oD2EvelqCFOVhjuQN244GQPRkDg/ViXX1zchmgmdocxFWr2O96o
	 eDfD6ZweOo5EpNzIL7ii57VNKLZeHHcFYmJXQgkaBBG2c67TA4wFubaDUMPJIXRgYE+WL
	 SYx3NVk0H78EUC04pOn/7OYLk3XlORuRVwi+rPXwBe0LgX7P8gXHhyrLvzEnxNLbFyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ARMQ5cNbMxT2ZbpJQEfxgwyLYEt7a2/LT495hCT33Mc=;
	b=VbJd7/p9zzUPoEImHy4VFBvLtKQ47jcs/54Z43cEKkyxmv3SY6TE8aNNYdsbn3214biA
	 tb4qnCuejG1tIOl+rkP2oZA0/jrr3QG7Xy53WgbdtJp3bgTOBv4dvyjMdZYhRnCGe5loX
	 fuY9Gpg12Z3bod3AwoIWg1QSWFftq+QBhgLDGWKgRvKBPRr56+y5BEmSzHysDiF4S7ArT
	 lnQiDEdr7jZDK2ZFnUOgtZUO1tR4Ebg0juRnR8JbbTlx7dDNJYV2ukKW2JxFjOwjRtppg
	 CfddqbaMWLS1XlveVmaSBJyQUnQY82y09+glZyZKVliWxYD+mqpNs3JQwocZ01D4dUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F698vHaE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A220606A31C;
	Wed, 18 Nov 2026 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F698vHaE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB051F000C4;
	Wed, 18 Nov 2026 16:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019965;
	bh=ARMQ5cNbMxT2ZbpJQEfxgwyLYEt7a2/LT495hCT33Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F698vHaELZXJj+ojaJhn086yNQmakLKFuHcaulRx/Tgl6lGbf9MF2dj6VnfIWDOX3
	 woCWVZLUCqhrNgbKMBfhif+oMIRM3o8HCJIxG6rNHM9o1tcxtwyEIumwad1i8yYcs5
	 NchG4uQQOdmZsrViWGVKl8FAsbGwjfUa8Hngikck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1782/2651] ASoC: amd: vangogh: Fix acp5x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:22 +0100
Message-ID: <20261118150351.512931052@linuxfoundation.org>
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
index 831e30e9b0426..33d59d992ee0c 100644
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



