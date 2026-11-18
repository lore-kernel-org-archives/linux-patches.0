Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019954;
	b=G1HeBH5RdA9Nc/K5H5mL2g0ZnzyC6qBULWaxCzMgx04RFCj2ut+X64q2wKNYXtiXcaFw
	 hxKw0aDLkzdK4gdf0pY4QIelTRvhzbfFlYKmx+uUcKowqlyIdgnduLCca/Qu3XBIhLoiF
	 v5LndHv7KZxZG5y546eRI1GOqauSTdMzal3d2z+suCCXrwABs7vgS+fHieHhZYi/zubK3
	 nlyJdjITWjmvIRv57zpX9jLcq4M1HopxpMR8UfzwdidT9VS0I2FyQ6F81xYWQ+1d6KVy/
	 LIn0jdJinnQkqvmvrJjKNrqedu3FX7bIPLnEjNvGvBEoZ4sy+oNCFhZAFglERlJT6pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k3o+49GYjzbHaFtec99m0y7yG2THV+V3b5EPDxATJZU=;
	b=ODbd8OPOFexexcsYZfAnVGhUAZuj2ohBSfsku3HPIgHSi7mBkgS8hRlFCGnBnDGj/HGt
	 EzRYNqTZPASSI412QfuSsXDIqHE4+ZeBiIZcIvVN/BZXmsNuOdW9ACSzEz0Y9NTmrXTnF
	 frYY1sAlB201rPpr6CwUulyyYSQtiVtG18jOabI+oibntGNAf3Js13Bl3CLDruo7s5yEc
	 RVjedIGMQBDATN9i8UgWwrH7Uc1ExY5ZVuZSbbEBDspc2+EB397BGuGZY15xXh7oaLhfo
	 43Isw7IjSmgM5SZltz3bsqyA4A5AheoU4b3ELaF0SUiIR2oadAslG21+Not2TmDGmcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ul3dWG67;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CB6606A31C;
	Wed, 18 Nov 2026 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ul3dWG67
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EC61F000C7;
	Wed, 18 Nov 2026 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019953;
	bh=k3o+49GYjzbHaFtec99m0y7yG2THV+V3b5EPDxATJZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ul3dWG67DWDPuWv4VrgzispBKq0sNbQNBNkkBT2Uwr6HG+wW7JYB/1uwFh16cfgvE
	 0tOL+MPv8XspvtrN6HT7Rn+dNptpUr0hE+qGqjYSn+g7M3cbgFSJd8aL0n75lmOTJY
	 H+Wop5JYGS4KaYKg5ZqRt8IpeOsqtUvfSui7WBGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1778/2651] ASoC: amd: ps: Fix acp63_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:18 +0100
Message-ID: <20261118150351.383660375@linuxfoundation.org>
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
index 04c014349347e..28e0686e9373d 100644
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



