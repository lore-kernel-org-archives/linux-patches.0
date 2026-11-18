Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026471;
	b=CsRUWLkQPrIvJHh70zTaDDHEAqK1q9gG1PSgaO1/LTP6A1Hdwe1sxFnqAbQ0CIiMovWS
	 yUSfW20XTjE1pf/4j1v+LAp/K7/I/2cGQ4pCMvNT2lN+ELlMx32IB2x0cZ00qWIJ9tsWP
	 YOIQDjOuG16No1wlO9BO4Te1c2BUz95ZBe5HbbathQurchLKwa7nEOG/+N5SseIef8Jvw
	 ItOlSqPErBMhIJDH28A77HkutwgEatk+rgjQx5fsk1WFgy2AiydXiU6g/URUeMZFLil6u
	 4ruvFw9EGllYeROOnNJHvF4QTa1bYRRlNzI9DMr2m98wQyoNai42jvu+a8p19scDCOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lwn9n6TA5bFh8fQsuzBydnIzcVnewoqu2cxwc3V8hC8=;
	b=qnHPZZnc1qQZ4gRTRYWO9VRZRpsj+dk5tMJcW2PIe9j/BFGafrQ+DQbYMTj4L7sXIHJ/
	 qnAUjiM1lt/0EkCX5c/C8YFehS+Ihfg4f3PcK0tuj9qlOD0Ecwv2JM3G52wNR3NiNpmxs
	 lf+ma0/cJAToMMWQMZtcE3hASOzS8fBETtGzEM+JE7BUxWgWsix7EivxM2kA4sV1TR8VN
	 1YObj/9q7m5ZEJM95+p6o1bIuAivpHGVUtVGPxjYWVfLSTxrIMEzCJe3Fb1Uali1elxCf
	 +QL312m5af2+aQ4k+b/FKNRT9wxH8ljsu0109WHc4LRCiY6V9389zB1mndeM+m7Nzzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7fxmjSy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CE5606A31C;
	Wed, 18 Nov 2026 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7fxmjSy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575751F000C4;
	Wed, 18 Nov 2026 18:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026470;
	bh=lwn9n6TA5bFh8fQsuzBydnIzcVnewoqu2cxwc3V8hC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7fxmjSywXerhYDONXHvR2Y2eTCcnjNpZyNl+kVdH1mDpuf32/SrNYh9+Bzr+wePL
	 zlL071oqQ99PPqkNcJClBeJpF/lPnvvZxwLt/EBxQXNUoyNyXPjy2p+9iJALU9iHO+
	 DA+tYyDT8/VShCFWS18VkFtlRagtGlYFcdpONw4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1447/2151] ASoC: amd: ps: Fix acp63_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:02 +0100
Message-ID: <20261118150214.636898301@linuxfoundation.org>
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
index 9cfbe05ad9963..1e69cb05c8832 100644
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



