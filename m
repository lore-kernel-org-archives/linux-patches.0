Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061598;
	b=qzQ0gxev70fDE9eBbpxyJVMj0JVDg7GlqP4wL9ln+n5NaB+RzOcqOE8rePjIrKC3duJW
	 +ZP+ONtLBvCdao6nJigdcNsJReFW3kiJKJreQ5Ar88BPKh9VgMK6phf4sUanSK2Slt+7b
	 u9xF39k4Z3gGR29Y7dTZnHAlow4oVbb2TI0emXK4ZWL+WhlBZ85xh03MLu/m3WcgiKruM
	 MG4vV9R1aR83S7cHErE0N9E6+gtWb12TzI0CB9TbdjdFBxL7mIOXUQAemBH1i2N0atVDg
	 VzceZnx4+rIrwZEh31ZAbmEC9AlYhlPaDTrJNGAm0Z47ErmaXiAT+etqrsPCrN3pVBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dzDQwNpgtEu4ML09eYK7HOnz0OKBIsKk34w0nk2RgYo=;
	b=uPLSgxvszeluldruGiFyNsMWlr4fQXgyYsp7Es7+jXbHJeESB2aqrzSFiApD0F+8ehjL
	 sUMfT4xmQNJGDpEQBFd2CmjyW8LtY8RgtngsCqO5/2JE9A+pMF1rntPgfELaZfcJ5jkAz
	 lwPxj2KMTR2fUAMO7MknNXej2l/ppSb1JeTsVbh/UU0RPBaMnpMsT35ZrTEk9WIXqWrXU
	 HF7GuvqtJoTTWHj8odtJVPYilUNUn2IOlaUCjPq9p+ovTu1JaQVyQzVnObsyVN1EeTnvp
	 vVQ71oghT/VnVix1ZN26AwX9QqU+mnmOnmFObPIseiwNHTP7phgNTH1qu/UquLldYLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mIbJkPXx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3F1606A320;
	Thu, 19 Nov 2026 04:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mIbJkPXx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BC91F000C4;
	Thu, 19 Nov 2026 04:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061598;
	bh=dzDQwNpgtEu4ML09eYK7HOnz0OKBIsKk34w0nk2RgYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIbJkPXx4kQvKSL3mzLFUuPck7m7qk1EJZ9BWSdhcAidXX7u/55JuwGrbW9molc/g
	 YCaRqGdOhIU2BG1Ds+7ZaVp8OdMXGYYomty3Us8YC1kblw/MQ+Lovs1XVy1ZCe+hVf
	 KRl27gxMSDUp8ySLrlag1IadtduUp5+rYTYIGt2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1611/1848] ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 16:00:49 +0100
Message-ID: <20261118150026.968447106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c23f3d9be5885..4b75836a8f28d 100644
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



