Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031828;
	b=XSXjriQBEzyh5Q3K1L5eEKVLli/eVVyJ3iJ+gFVFnXWv8lzRTuyAcx6NpnSoTZSPfrFm
	 f2OcrkLnsu2/KiCPxz0lphpuIjF4c27ruUAgERT8DtVzFvx11DgDmyEdb2Tdc8NQDrYfm
	 b7zL/4pHnFONC3SQ7x81DzwviBGIBsTujGSxUA3L7R2BCaHJFlXzz6RDGLvBdl+UMShVK
	 2gt4+fIkKh8CSjEKYUEjMGRiNA7qzfOMrm7RVl5dfUkmPJk/UKpHVgz8GOqZjW4wBUnts
	 ho+1+QY5H3ylnZ25Cy52GhtCjcAAVYswxwy/P15fpcE1QlBFfA2ZQCoQgshGaP5LKwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aWcLbA5YGPL9M794mJVUZYMF/vm3+s93hhRHv8/+sN8=;
	b=Rsk+Wt0hJm3h0uIhoJNridDMoH05LbIEeslqu8LUqWJDXgyOqfD1sjlXb12OoFkTH/3T
	 hUJs9VcmOkIFNdvNbp5MkV63FM3DqJN3RZo85qMCBpNk21FJGAlzj9II3xaonWm9DfvGx
	 tg/Z43wgOHf3Dnk2PHKyDes01jW6rsM+f0/zroTQZP+4je85SOWpa/vDfJBb8UpWpgh8S
	 JN95RLyoYylsSgjwy7EPFLaaRfNQ/cJsYu2F+pHAEaKoIt3i0fZSb3hudQh/skx59/Mtt
	 UZnP/q9BYxOrB42RXEG43GEoWz0yurrVnJ59usamjoskZy9ek87fqlFo5acMG7lWgSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ARmSKgMg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9054E606A31C;
	Wed, 18 Nov 2026 19:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ARmSKgMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D121F000C4;
	Wed, 18 Nov 2026 19:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031828;
	bh=aWcLbA5YGPL9M794mJVUZYMF/vm3+s93hhRHv8/+sN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARmSKgMgKRyosiPFzu6fEEpnKnYRzICsP1ZMgwEmslx6D8jLehSzZOqRvmqhs/VQj
	 Ej1g12ZljxgZP3gHxVDn1RWsoMT6nXYrdFmgSLmec4OoYz8pLUTiLjyeZwjhD/vFJf
	 RaY4IYkvfbMhnHGQlAFi7TNJD/+hiLggFvMMJ19s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1154/1756] ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:41 +0100
Message-ID: <20261118150055.970177847@linuxfoundation.org>
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
index ecb4b79520135..f89ba818075cc 100644
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



