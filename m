Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041461;
	b=fB26Xyx2dA5VGrAh6GAUmjDmh7HZPftq+2POkbCo2myntpDgCAOxSThU7B1+CsFcPwYf
	 tYgiwL+jciMxBPyPX3Fl5DYix8KcMLRp6pAY21MUE7IQ+uocI6ZXe+I5yRsiVrX6RIHnu
	 OEfbAjWx4ScQSFOJ/tHNS+2wpYpy3hxusr7op0r4j+++LSmqMDdnxTZ78y7BGkOT8i+W/
	 TcH7o+DfVhhF+r1On72pzI0/UKWOiFpHorIwrIiGTKR8suYkBXdrqB+t/DtiMAIUUNPy5
	 aNF+W2gDua0NvKi6ng1W4fvsEDrl3oqWu0jlCE0u3vOEKbj5uqkdgFata8lY8f9UgLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g+suUGR3lbfXAAKqsgBSNvJdnZAu3UmBypHSO7SwLZQ=;
	b=R3VgHRAsxZzYoRqiagsrr1DoH/SFI2aQVoHOMFDLDI7fsL7CocG8RKPgfH+kZCX4vS8b
	 wunH98O7sABjpOnjyE7iSetz/PHEuUyhNON1qLZ05KszudFx4zGa1wB29wj8Kz5gKb0jA
	 GUrSQ7gqKW1O8KOI+GsDPQCwoN5cUYjpsoV/B1UdWtMJXyl3VCUPUJZEr9gAbTAqZ9VRi
	 254bEebRNML1H54365ePtShukJDexFMhBorsTxzojJ0q6zNmBhdSl7uKSmP83FIp38M0c
	 U9dbM1dk+FeXVS5nNlVot6XnDgNSMFKItUXrhCgjkkqDZ6bCm3xwcvxnmY5XYsI1QCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yt+4g6cd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238AF60A3815;
	Wed, 18 Nov 2026 22:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yt+4g6cd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798BE1F000C9;
	Wed, 18 Nov 2026 22:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041461;
	bh=g+suUGR3lbfXAAKqsgBSNvJdnZAu3UmBypHSO7SwLZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yt+4g6cdIl8PkOQ/aKaSKem1edkxoxkXTeTg4p+FxFKFS0R49+oumj1bYWp1Yv48v
	 Ry/j6W/MsAQ0FRx1j3SDA66/NjJiO7uUl3uWR4ZxHW0hXMvmUEWmwlJZf3l2vBa/9g
	 gup5XauCIY8MHpRSkvshCgj/edCgr242dHGQ6LHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2822/3318] ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:24 +0100
Message-ID: <20261118150445.303421492@linuxfoundation.org>
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
index c7c4d0829564c..e366f5f229565 100644
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



