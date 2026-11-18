Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049682;
	b=V7g2oSGYt6eACuuvzsp7uC1BhV4jy+oH04fEm0x+FbLBzY/wTNKeLmT96mq4cLOOh24S
	 tgcBWojA1oRYWLUf5+HlQZGtm6tbj8k4B4WcmNO2VZ5zZe3RKlGimgVrrzmyT4/EhW3vf
	 YVMk2cncVDokGhOT0wZ4pWLDzYcgefhfZR9kZgwBJqYwTw6RIOcabPuT+0dYPHIPZ4NVQ
	 6trbhs18OMnYJ3Q7MjT/3IOd/1yJM6syWMkVcTz1/irGkjgvFjGJ3dr3r3KnIEcJtJ4Ly
	 XDwz3w7BDXf3IJiIEAqU7bEkO7mV45zHhkQ4x8iCP717xmhQmmaxMT3wYnnddMbl9/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2pdIUnnjIP4WlnraEejSXFNTcKP1tSGQpLXkOsCUMzw=;
	b=jo7crD8SkViLxEIhfpd203hWi0Jcq7lgu4h/w49UDpgNEKdA1UzGpkprLMFBY3SMuFx3
	 pOZI7nj6CR6k2Q2Wk2i+agdicZvbmv+MFPPUPux8t58Mcm8bESJb9P4/deinvlmPo09g8
	 w2ALt22RByhNyzX6uZfpejIhwbguxDnGI2Me3ZZjOSsAkXieFQnF3jf5DeHLTr/DomhiK
	 8DGWJdiQaJOGD1VtFpZsxGOk7Wf4COKNv/sHLgGpQENqEJ3ePVujabOAcTY+vic+batqC
	 iPghI4jMugHa58kQsFfEAOOi4d8LfiDCZr7rGPMgG2Hzpr59XVbLIz6fKQJ9HWRNKZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1aUBoUBB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2C7606A330;
	Thu, 19 Nov 2026 00:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1aUBoUBB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290F31F000C9;
	Thu, 19 Nov 2026 00:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049682;
	bh=2pdIUnnjIP4WlnraEejSXFNTcKP1tSGQpLXkOsCUMzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1aUBoUBBiomarhQF3nVljacHE4SvC72WG4s8PbCg5qqOw3INkuBhVkcu3veSoAatW
	 Fx2SDP0sKzfCJmj+FHrfFFONCKBlrpmoRKKFK4imMBLIfvvSvVYYZnP3FgUqo2MjBv
	 jq0q1K3pugaEs01iq8zSZk3LyzQi8DgQ5HSrJJVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2438/2857] ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:52 +0100
Message-ID: <20261118150329.354785175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 617b1fe8b28b9..eb0d4511fa4a8 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -227,7 +227,7 @@ static int acp_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp_base = adata->acp_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



