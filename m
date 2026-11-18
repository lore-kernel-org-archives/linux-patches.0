Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031728;
	b=2L1NCs1wjYVT9MizheiOTaKmkSvEFX0M9ZZS6gQ5EV6jYqJEg14nwb/f4nTqth8hjw0F
	 9GyQoE2insrHU6yu2jeNY4N2s+GClIlEwcnU/RTbeaY/MiakvVMeGSl7lTuqHVg/Gsl7e
	 SIzJnE/OwONetzyWptjME4Z0Hl0/nQI9EDwMse3iWTTAEkboM21CgRHUTeGQUSDPTbcia
	 8mVE2DQTsxFSdMtn7m4s2bw4ajKExU96Tv+q6VtEUviZRu+OHSESMncxeGCTH7tK9fs0j
	 AsC1kalKcqdACdawyXGssXWyopMzmtygv0R/IcJxJlZ80qHMTJXP6bgpcU0SeTjM7hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nH6+sjPNCzDyidc1tGgaBp45A6IQ2fRMYzoTvxzHBTQ=;
	b=uLgqhKgcbjDmJWUtzh5IBhtUB/cMSDKrJQNk0oWMAOdQ8IKbSwsBcldbbEI4EB3pm+tS
	 CLKFXmSbil1iVrrx8jcIDutNbIOk0AZmr3Zm1othaaivjaxxYcSppt8uh0a1UEhEfrXLP
	 wOuf8+WXrvr3wq+cL2v9XakEtD9LZ89fQhFbz1a0VjDUAeVOoLoVGzzeRGKUStHBvfhus
	 XRHebQnnphOQRK31SPCZEVdXXvDz/3FMnWSVNTFAtcHJ7Q/pDMuOtnfMpHdvubAZBgase
	 M4HmFNE4Ot6epNO6gUqVty37weBItUjY6T+ufxMKsdg4RXRYHDzV3hBxaRZwsx52bDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuNbVuE2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168E9606A32A;
	Wed, 18 Nov 2026 19:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuNbVuE2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E7C1F000C5;
	Wed, 18 Nov 2026 19:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031727;
	bh=nH6+sjPNCzDyidc1tGgaBp45A6IQ2fRMYzoTvxzHBTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuNbVuE2ylw2DqZJqxD/L4mB81KCfNn1d1FPe/YoZQZEEIZey9PrRRdlEnRw+evNo
	 AWvJr7LrJRu1rEnALXApVilCPcLiLA0lXeSOLEk2oeL/Su5VrtiavwFx0CP0MFqdFa
	 5TiLpGcMuqDxYxYXNAlpjGB8l7hcBYxz1EA4sVE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1161/1756] ASoC: intel: atom: Fix .shutdown() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:48 +0100
Message-ID: <20261118150056.223924015@linuxfoundation.org>
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

[ Upstream commit e3bb575811042ca30ac9b7b4dacc74aab8efa512 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from sst_media_open(). ASoC only marks the DAI as started when
.startup() returns 0, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 4889a8a73f65 ("ASoC: intel: atom: Use __free(kfree) for stream pointer")
Fixes: 6cc0f4e63994 ("ASoC: Intel: mfld_pcm: move stream handling to dai_ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-20-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 2feb09f90f8e6..d546915534dc9 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -355,7 +355,7 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 
 	stream = NULL;
 
-	return ret_val;
+	return 0;
 }
 
 static void sst_media_close(struct snd_pcm_substream *substream,
-- 
2.53.0



