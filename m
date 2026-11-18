Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019967;
	b=xeMWw2t1naBy4y9/7nr+v1R3E6wVWF6VPEuOXE+fY15ZOJzpcnl/E5VUUa5Un6aEX/Q7
	 zMvFk0b/AEwUL94XNTKrg66IEn5pRLMUoEtELpq77mqEPT2QBnIrEPwnIkPtnuKcLv+6z
	 OxkUrriCu9rLMqLnpmEbtyvXaKQsHLlUhgP3pBK8FYmLCVAbxzPK+WTiVwApCDTCwUjRF
	 yfIBTaEjBdDa776kNM+LeJLeLzaBuHj0y6Z7aY6ASCQWVpmPMa3/Cmy0niMfsVIGsIDX3
	 xRD9AXE8Ok+f8NW63UxL7+iIH5fr9Hu1txW6SHOhZ4IItWYsocqpziIbVuznpE1nUYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q3VigueMY2vlEdkxyMxGzDiOt1ArP15u/182Ow/3Ay4=;
	b=TBNLuV47Y7rPOhAlvBMPlz5D4yVPT4NMXxveVaSlzs5AGJIsxtNcLeEFz67K2C4Amngu
	 Wqb6Tbl7l/zDjsoYxdDbFxhud8H9OMykw5tGSeqp8iEhzVBNUckVJ4rLmg2NzMbUlFq25
	 KfjSE5qndiCuAd69VCmtl2HwUxf94W9L3PtWWb4AA/l49TI3Ywk003TykIo+ImTXrufa1
	 /lu/opGsUkd/jkwykYwWgqt2gkpQ6/nwNlxXvxePEQmZNSkmHQpbt/hPuDaN6DW/Y3TH9
	 fRPtKIzjw8tt0yn+QJmn+umYaPORRiszL+C66dukjleUHiMZLof1XKNysa/KkI7+KbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5OSArs5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB47606A31C;
	Wed, 18 Nov 2026 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5OSArs5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8A11F000C4;
	Wed, 18 Nov 2026 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019967;
	bh=q3VigueMY2vlEdkxyMxGzDiOt1ArP15u/182Ow/3Ay4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5OSArs5FO+ndaK0c+7sX8KYpyPEyCYX4arkpizB2h6SpXGPZ/rTTuT6u5U6bTxaT
	 n8MRBphTQJO5KNCKz34kxBUsPu1DozlKxmZ7oTWIfJYw4FdySDeN8vzZ8gJv0J4Khj
	 LvAObwqq6ypfCCpEKolhaB1p0sC9dveRok5XH/F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1783/2651] ASoC: amd: yc: Fix acp6x_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:23 +0100
Message-ID: <20261118150351.543649891@linuxfoundation.org>
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

[ Upstream commit 06654a3ef5137719be880a6cd12bd453050eafc5 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp6x_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: ceb4fcc13ae5 ("ASoC: amd: add acp6x pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-pdm-dma.c b/sound/soc/amd/yc/acp6x-pdm-dma.c
index 40c4d833f4ed3..afa9f66533e34 100644
--- a/sound/soc/amd/yc/acp6x-pdm-dma.c
+++ b/sound/soc/amd/yc/acp6x-pdm-dma.c
@@ -209,7 +209,7 @@ static int acp6x_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp6x_base = adata->acp6x_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp6x_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



