Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041463;
	b=l18jAQ7L5/HuB3ShlRqKcd2wGyyVKYQFpFFgXs+K6bBifF2v1gBxoLeZytiqwp7+lvM6
	 HSoYyNKI6pGlelkTUNlY9r5Av1tUTu1FkuhPYcxEK62RAS8wVEKscJ/81laSlgRrSZh/G
	 QMCW9A38zocidBA2z8cEhEv87tzL3oHjOUUmvcezm4oKHTBAFf37IRz2f7nMOA5rFInJk
	 zoIf0SDWD0wip1SdD/YVo7fSXbUf0tlIT4tbC5y4vPBOeLS//u+8tUywBTaTvP51U5sbY
	 e8nYQhlzE1OaTMZ7o0mQLxVrcwbWc+EwRN3mjudDOGzBeU65tc52aSvM9DrfBrqORlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FyHWrweXRKaNYtN9u4BE3Gwnibqr5WxaEvAwS1VniyI=;
	b=Ha3gAqNQPCzrhM9bUxMsDa2PC3ntPMYCnSNla7wZR3O7YlDAvxsTWxZ1rEbXcgv3UTUT
	 jKGFMowC1lMCg8QDsNBRqyyDjiAI/Kbeza9i+vlvAx0EQffXjlS8EkVuboX7UGt8Lk5/B
	 AHTNc2pVfuo2pNxvZLtWBst7XhpM15SyJr5a2Jz1vASRXo8WfgQCCoxrrQCqnqD+Uex5V
	 n9b2ZLAHgAfXUB/8jXm2vzPcHxkyiLQTWZl2VcfDEWZf68sD4UxZ02tAHY4kJpoKPeBz5
	 p3+TKG44wbHtzZRg073P+eO4kNfrwPS/lIq6b4y+GfjW5A142YiOhm/Ix/TvobDn9FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUIvBhWh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F1860A382A;
	Wed, 18 Nov 2026 22:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUIvBhWh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283091F000CA;
	Wed, 18 Nov 2026 22:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041463;
	bh=FyHWrweXRKaNYtN9u4BE3Gwnibqr5WxaEvAwS1VniyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUIvBhWhODZtqr+yXvt8H0oigH+hmphEVG59m0JYCWoQJArVjCi73FiAWqQT5zMzG
	 SLBzY0NUyxXaeACyQ4eKuEmXDp+7xGoqB7b1QfRSvRVc1aPidJ6yxggImIwXWszmdz
	 ZrdULmDYuWZnUF5dwACnRS3F8XJXIToTkyAbtIeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2823/3318] ASoC: amd: vangogh: Fix acp5x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:25 +0100
Message-ID: <20261118150445.331969883@linuxfoundation.org>
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
index 587dec5bb33d9..0eb5097af9565 100644
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



