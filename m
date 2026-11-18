Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019979;
	b=UGWlDSUvL/TVdCtNyyM0lQ6vimF4mi8VLaz8qfVwXE98qYz6eKTJTzQcc9+BX7BtAzxQ
	 FWT26cA2ht3TuQtvq3n/HC7Bu9v+3yVpQWWTYb3d/Hxknyt+I4iLhVfonz9IjafuCJxOX
	 dt/Fbz3Ac20SBjZG1HrYisCkF7oHIEzHr0sLWdwstj3VZQErj95/3cTEuFkJV86CMUivB
	 AdFM5rZoVwnsgBnCvwMyXh2PfqGJ0zCNF5k9n38pTvfWmN6gqxe6h3G1SOfEhN9CMnYFh
	 uc5InwtUNmMGe71R5Hns4JaXpaa6T3pezZWTLrEyRsSyuwvJcHjFZt5hVVOAV4YrhQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cn1FJMRtB+UoUZjmxF2lL9knDmizJC/XAFr4YZkol14=;
	b=QwOGF1ILmNpYHqMqOo8jOo/OwB0frIfmDdYba4H0TRLAKT1eBeBxyZoBUsdA+L43zXot
	 GA64X04Ls4xtm21UTGyjaxel6jPyjXAG/+VoK/RPUC0UCh2l4Bm3qKqxpVQFQJqHX9jsM
	 NE58r1B7K76FkhLds7Z9CaAcJ/b7f9f5/jrm2JqU/9dV+RHyndFrktICWsqK6fWd+XZIZ
	 tlsWomvK2tMOTkeK/xwOXIAwZOywmrb9NGvfTuYgcR8jwn8iEiAzSCUgkYhigZAuU7whS
	 89SdXr33+tVGTPHrj74eOABqf+UZXiwcHim054ER9KZJuJbgYUqjKvINyAF3TO0ss4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Silmc73J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C588606A31C;
	Wed, 18 Nov 2026 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Silmc73J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AF01F000C4;
	Wed, 18 Nov 2026 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019979;
	bh=Cn1FJMRtB+UoUZjmxF2lL9knDmizJC/XAFr4YZkol14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Silmc73JZ6KsI/38k/sB/LlOgg2iT3Tdae4zllCsjTPH9fYkkyBM64NgVyNFmK7ES
	 A2FGox9ViFgDRKK0PZ/gQkDvLBlMT6vtWMW5j/vy0qBUx59ucgEj7+rpffnhnQnBFL
	 L9BpiH/8/egBWD+x/WU4v6/TeFaVmF/+2EGxz8vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1786/2651] ASoC: intel: atom: Fix .shutdown() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:26 +0100
Message-ID: <20261118150351.644274707@linuxfoundation.org>
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
index a4c8cbfba0963..db1fb3b26909f 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -341,7 +341,7 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 
 	stream = NULL;
 
-	return ret_val;
+	return 0;
 }
 
 static void sst_media_close(struct snd_pcm_substream *substream,
-- 
2.53.0



