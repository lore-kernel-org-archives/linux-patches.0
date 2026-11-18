Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019982;
	b=mR2bNXtMe3Ry0+2t0VY77aVpkuenRga/+1EBXgo5RoqlSAOco9EEYsEIjFO42omugkIy
	 QdRgAQXo89hSO3OCYQrwZ8dCfc92RAyh2pfOlRH+F0FX7RAnci+MPyR+FXgZK7e4nfra+
	 IyxjR/D22yDVjmKGB9/8rHDkQBc045YXnpz51kGtMdQJq9CYPys+030F566MDvZUlBLch
	 IOu0w4sFmElviz2V9vXJwd0eAfrEGJWkQXH77IY84tCZQ12H8t7czRyYuY8r4YknRLGBH
	 j2Tzatxag8msse17OEGVjgzYYYug05kyKBMJzdEundslac1UxiVha7Tl3Sxm1Un8oEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pmvvfHODLnzVbCDwm9GechmTVauUKeAhLl9Q5F+3/mk=;
	b=jjkW1e+lepfgthsiZdcmIO6oYRm7fT3xsbx9+bbF+farTqjf6Q9/C6wzj8Q+mocrZSwU
	 dcjK5iTTyXr9Qk9sxVHbBDE1+OvcJBdJZVo8tzmJf4yXDvwjQk7460/pcZIp1ZA6sAfIw
	 eIrTe//OhlrFzr4q24g4P1HIjgfTgqhrCX6+9Na0NURvPh0g6dmXCXV60ou1UN6Qre2ft
	 B+2oBkWO19KBVe409j2v296o/zUxBzEIKsuYt/FqUQmZmES4wzBjX5Xs03qYXa6lyNLyN
	 inAPlHAzzlwjsCLNiBYLPDtyRnMc4XJ11ey0dsbLDjgMOL/tHu2Dma0eII+J7sYA19Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoSvAiXd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D95606A31C;
	Wed, 18 Nov 2026 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoSvAiXd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644A01F000C4;
	Wed, 18 Nov 2026 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019981;
	bh=pmvvfHODLnzVbCDwm9GechmTVauUKeAhLl9Q5F+3/mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoSvAiXda45GJu8Vy/2ntiXqO6Y+PXLgotwshkh0bkfMSHNSekV3D9tbJJpY0hZVu
	 BVXUC8rPc+wNaPhp0C1mGLpYLdOPceXnL5bKMzo9JG14MWo8O1qfn9wZtBYqDeZInT
	 E7HnrppQKiOoozhmdc+CGIclUarO6t9PJJgp0M0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1787/2651] ASoC: renesas: msiof: Fix msiof_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:27 +0100
Message-ID: <20261118150351.673662183@linuxfoundation.org>
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

[ Upstream commit b7c58a55fd9b71c0b11b0365fdf53f49702c39b5 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from msiof_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: c61caec22820 ("ASoC: renesas: add MSIOF sound support")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-22-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/renesas/rcar/msiof.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/renesas/rcar/msiof.c b/sound/soc/renesas/rcar/msiof.c
index 128543fc4fc97..9fead9a22cdc4 100644
--- a/sound/soc/renesas/rcar/msiof.c
+++ b/sound/soc/renesas/rcar/msiof.c
@@ -427,10 +427,12 @@ static int msiof_open(struct snd_soc_component *component,
 	ret = snd_pcm_hw_constraint_integer(substream->runtime, SNDRV_PCM_HW_PARAM_PERIODS);
 
 open_err_dma:
-	if (ret < 0)
+	if (ret < 0) {
 		dma_release_channel(chan);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int msiof_close(struct snd_soc_component *component,
-- 
2.53.0



