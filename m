Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050420;
	b=r5MjqhKGRkBuzGV7BPBT++vjxsc2ztLCQn6YHnvKoZRBmj/MFZ8d8PWMXedUJup2yK4W
	 GArbv71qR1Sb8ix/nHL/UqEPNkW3krBkC3OYDgxiet6XYVwtZYKRSNgYVdVZ0Htzzs2uh
	 sU2dg1hoieeZ+VzoYVbgyS5KRBGeDqa0QrQjQOTH8qqBH/CAi3AZnM9iOPzQdjjor7M2v
	 dFO0nQfNK3IEPBjocxHCgaFVnXN5+SM/AGfRLLJ8Lh1cqQMSyjtvntziWYQgRFSpLclJ4
	 A7/Gv/uN9Wl5F2b7gFA9Ke7C2br4L+I827BwtGNEPRXB8RDCMOw1RsBC1BmtoSYfITQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ImyuGb+4ovCR1/wypJBgDYAwwEPdt38RtmTuWuAEOQ=;
	b=R40oAeJlGlyIuDL0hDb8Uh1PykQE51cJpZywQxdDMeQQuPzaLPDIKHAkxrvvLHLKml9L
	 ylPy1DaCBoDDHaojCns+2Be3XAdItUrmftuotepXoolxqHl+FTNQuzDsxC+jRmtxCIn3u
	 K3ebvg4WwL3Sdkaw+KyU7zMKlaKeEN3pLOLu7MhQVzIia+wm1n2y2Ang/vrc6JAWROOuD
	 9/jyLV7e9AYP50zvd+qwMnrBhhpLuYkCmw3VULZhL7joonmymc9z5GGS93BKtKvahs1BK
	 qPz/8P+5TcdlOi9J8PwWMV/fEQjyU6aj7pEkXs9sMJ6laLPROqxqjqJSR30uMCwxDXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qt6FUDTB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF00606A31C;
	Thu, 19 Nov 2026 01:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qt6FUDTB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556151F000C4;
	Thu, 19 Nov 2026 01:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050419;
	bh=+ImyuGb+4ovCR1/wypJBgDYAwwEPdt38RtmTuWuAEOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qt6FUDTBTnQhvN9MQsgHFF97s3AvKY6wBzykKXgJUHQJGGxaVR06H8jxeM62tF5UH
	 P1qwcvkGoJ/ongUGDi2uar5ly7/Ta1arS/hZ/QWK2aWESYTCkUWMRII3lMaStKPIac
	 Be2VZ2ZVACIU+ejmaLmD6WZThCEm/T0HnlaORKEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-reviews <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2700/2857] ASoC: amd: raven: Fix memory leak in acp3x_dma_close()
Date: Wed, 18 Nov 2026 16:02:14 +0100
Message-ID: <20261118150338.780190666@linuxfoundation.org>
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
index 1ad2e70704eb9..114ea4a3c1e9c 100644
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



