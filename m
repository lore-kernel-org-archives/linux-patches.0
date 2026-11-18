Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056172;
	b=ZpF5WUsYlJIWhIOYHwFSPh63rv7mpF61fqitz76PmHXNOjUjyIva30mQkblqCAp/4jg/
	 hlPRRucOT5BW1aycXpIH6ATHTvu8vZS09bffX60HyS3oGuB1WoU+O84bfwG0oRKBdplCI
	 C/IHoTh0ZIXTl7z4t6+TmjmDz0uvI0DQdmicaMEf22yAa0SLodcAfijUuhPW45+fNZUAr
	 ukQA6B8wA5yMxAs8wzYadf6C2461fgUv8da/j7rmW2sHKzN9Crn6OxJF37V2NgfE2A8oh
	 7i0JQxXOP8hlVWlx3Rnb6NwCkKfif4ZhJfcve6ovO/vT0B7/5MMnxm0Qpwj+cWbnO3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MqBfnhmsg37cVZVYCVvy4Am3Q9r0StylFW9yexk/zlA=;
	b=V/6r1dfcnRA8N8Ucj5WfIqaoFUtz5kgm8taF6Eir3AMXDrxRpvOra/cGOIM0c1nNF0dB
	 WPM56EZo94aFnoS+UuNr09gZt3ooS8cA01EVa33PU8G6Q6ZgKm40tPOaTGg25jTvU476j
	 AKh9Mpp2LM/RVvYjjaZRuuzTiJUPj5y3+HoS1r3WaZsU5bpLoylnGOZ2jUMGNc8BUBbyf
	 LRrqFMLknsJn95Wn9mqSXu6hmZGTY7UzM73mdhCcjs80XDtaD5eLqBMlRBL0rpZltE4F8
	 c7QYYo8DZPOuQX7PI+1WphkAn+gUb8MvZeZ3qGF0rgf0rq3YcZh8ges1KNzjNSMFFXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WX6l7XZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4878F606A31C;
	Thu, 19 Nov 2026 02:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WX6l7XZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A851F000C4;
	Thu, 19 Nov 2026 02:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056172;
	bh=MqBfnhmsg37cVZVYCVvy4Am3Q9r0StylFW9yexk/zlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WX6l7XZB66Sbk9QMCjCMowodZ2W7BlysoL6B7iH2oJ2U+u+1khz9KQXFjzhJGScde
	 jNQi+px5uiyb2GguM4qUsnkAOGRzfYL/aYRvO9lLrqPioLOUZAeL3pSjUJ0c+ZCrr2
	 IxOpUXD37FQlw3wfqctzZz4m4fBf11qKhc9LQiaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1892/2214] ASoC: amd: vangogh: Fix acp5x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:59:28 +0100
Message-ID: <20261118150126.879654975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bfca4cf423cf1..4d33b748f3c74 100644
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



