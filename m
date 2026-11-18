Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041482;
	b=N4X/iM+3bCp1LXm8sx3RUTEaP4DQrxjfTMzfFDMJOnYLzrvRAomdnnkV9AKGxwEOBPX6
	 zCCGmSo1Fd2lbkvBPlTx89juAVcKgZMrdgQzZEdshue6P86YNdjLCTIrzW2+mj7SIFvhb
	 gdGW6cT3yTcGT0u/70qHRgf/Z5vFM1DOnPwRh/SqboAFZz+YY51XTEV9LizIp6whpahD7
	 aw8QYVZ8spaxDu/BpzD2N3QhOypuK5qPyyxdyLyd4hczjavrN2TUnqximmOQUZcxm0LtY
	 2IYu//m/hBgochiHdasjT9lkAfEjSJkndPYKqHRdyKGn279HKC53SZlEl90LDk+7Psg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cs5Pjq42o7ocLuFL0SHcP4YiFZNfumfd+uvtanQUBa0=;
	b=AOLJUirbwceO7ER6j9LxHerWkvlvhMT3QMda+yr74IV1gKE+LAlchRIiwOrtYA32gKmi
	 7cqFqjNykeT4k2cwwyNLqxf4bgA/wO5uj31R3kDR7dIhgc+qG0na7+b9++fOE9txJjc1X
	 O/35b/xL0FdQWsDSZVWA+VPFmppQksVmN/6qGL1U7UxbdjVrjjNaROCCy4NeVxK4Hz6Xu
	 I0MbH8XKyrFkut3XLKLNjuTIXJzq8EWwg7SN7WFScBwc/OtdLsPHCy/Bhv1NQRfEev/LB
	 EUB7HLxMJBE9Nff4npeu/vBaCEjOkQWZ/xxWrEhLJodkkmgfu4cbrDnuiUxnEGSQPUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJCam1TB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C980606A6C8;
	Wed, 18 Nov 2026 22:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJCam1TB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02581F000C6;
	Wed, 18 Nov 2026 22:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041482;
	bh=Cs5Pjq42o7ocLuFL0SHcP4YiFZNfumfd+uvtanQUBa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJCam1TBKEkVudBicQUWUWKEQYzAilntqe/ZZ5KEgzfp8h7EDOwq7C09LGotXZ2pA
	 ce7D+pbSGNtsnc90Qvhjj20tV2qtT/TiEGlqPE04WYosqqWj0D875TOs0hgwU2gkwX
	 +rhlzSUtxVg7ZLejvSCZEPrKsMNgTlKyP0YouCEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2829/3318] ASoC: intel: atom: Fix .shutdown() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:31 +0100
Message-ID: <20261118150445.505388808@linuxfoundation.org>
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
index b5a6a262fe817..201a280edcc0f 100644
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



