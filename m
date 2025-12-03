Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DAE348886;
	Wed,  3 Dec 2025 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778728; cv=none; b=UyVa0VCr+NiM3GaCMyxNWXI5BFy+SF5y3j4CzQnIqG0PESGh24LmJbqdlTsrN/gOmVsWGFdyEcXJajmHl5dTp1cWN3dotrSLmgpPPj8Elw4OnmRP7T9I56tv+7Rw1+/y6gUpitITJKA0Bj4Gy4SNcTs5ADaHcNdvqDuau6ysnGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778728; c=relaxed/simple;
	bh=IpUyAK9Ul1KcsG7cdxT9cXHvsl8+X7v2SghFFXWXSBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7JjCIjIu01BKmo5YqF3Zovypm3gBr0pZEUmcipzvvwBckTSS7H4lT5eG/1Zf9ZZ4xXcuBAEYND5xzlt7agm3TzUUk/Db7yrG+pKc1cEGuFWCvJUYQv+SLeQIQBtuy1p+ssSSVAZxvh8eeMaodauLEmdg+YUhcXKNJZItUy+K00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOFn/5yI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOFn/5yI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F28C4CEF5;
	Wed,  3 Dec 2025 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778728;
	bh=IpUyAK9Ul1KcsG7cdxT9cXHvsl8+X7v2SghFFXWXSBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOFn/5yIuva5U49MgxZkvafq7AJRG5cwvkozEGMdt0DEAdyUX3aYp063dCG2fUjL5
	 K+WHADuyQXs8eTC1qg0pQjcdffrkDwOD3QWraQIeEp1j8VILxD79S2iea/x4qjmpOc
	 B4q5y+A597eYHpnDQ00mY25bPgq855DiqME/B8bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/568] ASoC: Intel: avs: Unprepare a stream when XRUN occurs
Date: Wed,  3 Dec 2025 16:20:44 +0100
Message-ID: <20251203152442.233806257@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit cfca1637bc2b6b1e4f191d2f0b25f12402fbbb26 ]

The pcm->prepare() function may be called multiple times in a row by the
userspace, as mentioned in the documentation. The driver shall take that
into account and prevent redundancy. However, the exact same function is
called during XRUNs and in such case, the particular stream shall be
reset and setup anew.

Fixes: 9114700b496c ("ASoC: Intel: avs: Generic PCM FE operations")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20251023092348.3119313-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 07428b5755b8a..9d3c0ea99a298 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -556,6 +556,8 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	host_stream = data->host_stream;
 
+	if (runtime->state == SNDRV_PCM_STATE_XRUN)
+		hdac_stream(host_stream)->prepared = false;
 	if (hdac_stream(host_stream)->prepared)
 		return 0;
 
-- 
2.51.0



