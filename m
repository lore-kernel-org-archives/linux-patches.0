Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041450;
	b=nNvvkSDsaxCqt3jxoR5gAv/nTGGh0PhuO9QTY2bAT4iu6668nW/8Czh49uYnBOWJBOdb
	 ODTrPwqsHXoQRHWIbxavUv93O8RiTNx1p4T8jSyRKa9gk1wANUSKds6m01AaeS2tetarx
	 evSC0kr/VIQGdZepGsl+aj6L4wRwvgAQqGltgPmjtGX/vo3gzAfhuGCOcCmxyZgIHkduc
	 UpozUwmGe5hJLaIRxJ304+TT+49NQ6xylfUGyO2/ijPWUOy/tb9a0eRAzvJjJjecQCHLE
	 JBUNMJCDAKLyaLmrYOfwgGpwA2lKwu//AYBEbw/7fcT3gDL32gWqDgRaNRhpfVjy6uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=89B9i3HWoe76KCp7xPHWVxwhj+l7aqWHkpsJqD3Ucdc=;
	b=ac7iOdtV5X/gNbEt17CnBQR9Ceu97sJfU+MyxPhNVkmdXSnLNZUT+3Y+S8zeU+Sm3gbr
	 U4pY1Bummzm1C9PDLaF/fYFZvcZbeYByTOsH0KmsevtN2J2yuLmKOJataMhFdbsDR0c1J
	 +QI8sKSW0oHmqCbGbUYbuQSvpNSUpruKI28ADbjhMYGW6LxzIsV/3rh0fcHS5Ds64xiHd
	 h/qT96iDp8FOzKAOUcLPI76dPxVdRagBw3BkdHauamwZcFajjkwB+wYK96JMqDj9OqCrR
	 sshXASHGf9O3gPnuNJP7Rc9/Te/h+J2zPLBTUYh19CwQ+wdt+TpCjOnpK045DfANDAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H/2QQNIy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B08606A9B2;
	Wed, 18 Nov 2026 22:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H/2QQNIy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6B41F000C5;
	Wed, 18 Nov 2026 22:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041450;
	bh=89B9i3HWoe76KCp7xPHWVxwhj+l7aqWHkpsJqD3Ucdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/2QQNIyysMiulECNEiDW3I7FRa1Q88gNLrde2ArnG4oqtSno3NoWhSbE+X2Irteu
	 Bh0ZzTc649s7GiLpi2jINr1vnT9HJM6Sh2g9dWOiWsXDp5uBpb/mCb91JBiyv5OsyQ
	 F9v7N/H/cJTgpn/guyZ5qDPgukPUBI1vREaiqunA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2819/3318] ASoC: amd: ps: Fix acp63_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:21 +0100
Message-ID: <20261118150445.219491372@linuxfoundation.org>
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

[ Upstream commit 172888114dda96492d40e4a6e0ed16146cb76e2b ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp63_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 5137305662ef ("ASoC: amd: add acp6.2 pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/ps-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/ps-pdm-dma.c b/sound/soc/amd/ps/ps-pdm-dma.c
index d48f7c5af289c..694d8e5ea826f 100644
--- a/sound/soc/amd/ps/ps-pdm-dma.c
+++ b/sound/soc/amd/ps/ps-pdm-dma.c
@@ -211,7 +211,7 @@ static int acp63_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp63_base = adata->acp63_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp63_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



