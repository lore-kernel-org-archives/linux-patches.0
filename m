Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027829;
	b=Al/TgaolPTJb+dy5PEPaTf4kgf/amO+TjFltObQ13XonUiFEeT/imwTJear74HMSq7/Q
	 uMYVCpQ4iYVflAcPtqgRtx8BdQk/tJvEHhq5l6Iuz8Pr4hnms5Yohg4XC3ODw7Gel7mjh
	 /57L7n7X6udrzxCGRJJ9xGyFNE1Jdr7qSIZQrvb/QV/0qGY2PjB4CMLOs62PPG8c+w/0Y
	 EDEjAh35hQKAwEv0JuS1J8hoAEWQksDmq4+5OTVJX63EFnXKezCt9mHRUO6XriAoG58fO
	 YL55N9ca8D8P/nyS3XGtaE7k4rneGOe+2UC/Bm0mdmYd/+FmQVfUd7eXB6ZtUZhGivw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sbWUYYvocICKeF4WsNdUWniR9XqzERGr78/3r9zAIzA=;
	b=0hdKDhr9VOHVZG7Fs0NXMW157H/Ki7K+cN+7+1k3JOKJ75IcbK/S1P0mgLd5q9FIPv2D
	 1l5HqG6t8xeL3P4AygJU6xERFcbvYrcOGL+IMhi5TnRVAt38Mdtu4EgiIeujN0pV+dk8a
	 Fi+hFPwSiMvQQ0Obia3c+aKJ4SyjuMdjyItm1/kBbyVPRRgsrL5TH1rSfkUhHxKQIEX1n
	 k1kayx8/x/RNNKaSM+skmU5ti0vZFFqSXKBIEb7RZ7mO8VvJXL9OKNbN8wrIouunFHF+O
	 tOh1v8PzN2llOo6jhCrMiYdmemTLUtLHTdU8oD0PaouoDc1eiNC/xyjWVicG8N06/Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1e8bZoNt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9273606A31C;
	Wed, 18 Nov 2026 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1e8bZoNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66BA1F000C4;
	Wed, 18 Nov 2026 18:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027828;
	bh=sbWUYYvocICKeF4WsNdUWniR9XqzERGr78/3r9zAIzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1e8bZoNtsa+/grTG2G797U4YW9O0yTaApNKgAduM6CAXlPG2DmGbMnaB+sNaqDia7
	 h59tSil5Vfj74UO9Cmr367m1WmxNOnRzY9MN43PLHTyPDtMC2qq62sCG9V6cBhbirP
	 O0IBHE/6qvIFOn0hsi1+n6mRGfKdEGXSxIgh81kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-reviews <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1911/2151] ASoC: amd: raven: Fix memory leak in acp3x_dma_close()
Date: Wed, 18 Nov 2026 16:00:46 +0100
Message-ID: <20261118150231.400182442@linuxfoundation.org>
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

[ Upstream commit e0b17f84f6e3fa1201b8e2857094023c42ce5636 ]

acp3x_dma_open() allocates a struct i2s_stream_instance for
each substream, but acp3x_dma_close() never frees it, leaking
it on every open/close cycle.

Free it in acp3x_dma_close().

Fixes: 9f7041b71a2f ("ASoC: amd: closing specific instance.")
Reported-by: sashiko-reviews <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-173760@kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261016085047.535265-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/raven/acp3x-pcm-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index 3ba58a7795973..61b07195f3a8e 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -354,6 +354,8 @@ static int acp3x_dma_close(struct snd_soc_component *component,
 		}
 	}
 
+	kfree(ins);
+
 	return 0;
 }
 
-- 
2.53.0



