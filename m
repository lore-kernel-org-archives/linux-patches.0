Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F641A2390;
	Wed,  7 May 2025 18:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643557; cv=none; b=plDTZWDXL+wS026xA1X9EA6drQAy7Zg6K2g/+mvp/EjvWqgVzdH6wbrbpTy3yN1O4XORIxhltki0/Ur2t11AY0L5oKHJ2eXSPQRxX2UgNpurNlC5nYJEIcUZ1sMH4DZoWSTUTg5T10487nyQ1KleAo298UPCb9SPj0rLsFeALQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643557; c=relaxed/simple;
	bh=6ph1Bi1sgNxiY/fMdeVVaDCheUOi06ryLNlhgKMAIQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpvZXaln/l8X1diVmAUbjG0JU4gPtn1I8M7Hrp6GP8ZC6RCVL/yC54J8Fgau+lxwj/0KjTGw2M19PbcbNwc8Jw3kq6XoZmSV5rTltQPHyim9CQf8rRuaPkYU6ohs7WZ5fPkxJnpSNs9lxe3aaYJSufrT5I/bSJy7ouXZ9Wr0cpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHc//xPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHc//xPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E568DC4CEE2;
	Wed,  7 May 2025 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643557;
	bh=6ph1Bi1sgNxiY/fMdeVVaDCheUOi06ryLNlhgKMAIQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHc//xPFTIIjxye7sdl5g+VrGpRJKSxTGgQMVNcwEnm+bs+/4onlndjP+5MaUErMR
	 //cN3bqkYcoI/Ddr0E156q31NhtanAdZqEo/f6kL2/IpQfbPgHlMym+NcbhKHg3qQH
	 XXD3bzln+scthxeqkEopqEfCJUX8sCqmoChqw9DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/97] ASoC: soc-pcm: Fix hw_params() and DAPM widget sequence
Date: Wed,  7 May 2025 20:39:16 +0200
Message-ID: <20250507183808.645374397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sheetal <sheetal@nvidia.com>

[ Upstream commit 9aff2e8df240e84a36f2607f98a0a9924a24e65d ]

Issue:
 When multiple audio streams share a common BE DAI, the BE DAI
 widget can be powered up before its hardware parameters are configured.
 This incorrect sequence leads to intermittent pcm_write errors.

 For example, the below Tegra use-case throws an error:
  aplay(2 streams) -> AMX(mux) -> ADX(demux) -> arecord(2 streams),
  here, 'AMX TX' and 'ADX RX' are common BE DAIs.

For above usecase when failure happens below sequence is observed:
 aplay(1) FE open()
  - BE DAI callbacks added to the list
  - BE DAI state = SND_SOC_DPCM_STATE_OPEN
 aplay(2) FE open()
  - BE DAI callbacks are not added to the list as the state is
    already SND_SOC_DPCM_STATE_OPEN during aplay(1) FE open().
 aplay(2) FE hw_params()
  - BE DAI hw_params() callback ignored
 aplay(2) FE prepare()
  - Widget is powered ON without BE DAI hw_params() call
 aplay(1) FE hw_params()
  - BE DAI hw_params() is now called

Fix:
 Add BE DAIs in the list if its state is either SND_SOC_DPCM_STATE_OPEN
 or SND_SOC_DPCM_STATE_HW_PARAMS as well.

It ensures the widget is powered ON after BE DAI hw_params() callback.

Fixes: 0c25db3f7621 ("ASoC: soc-pcm: Don't reconnect an already active BE")
Signed-off-by: Sheetal <sheetal@nvidia.com>
Link: https://patch.msgid.link/20250404105953.2784819-1-sheetal@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 3f998a09fc42e..5a0fec90ae259 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1499,10 +1499,13 @@ static int dpcm_add_paths(struct snd_soc_pcm_runtime *fe, int stream,
 		/*
 		 * Filter for systems with 'component_chaining' enabled.
 		 * This helps to avoid unnecessary re-configuration of an
-		 * already active BE on such systems.
+		 * already active BE on such systems and ensures the BE DAI
+		 * widget is powered ON after hw_params() BE DAI callback.
 		 */
 		if (fe->card->component_chaining &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_NEW) &&
+		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_OPEN) &&
+		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_CLOSE))
 			continue;
 
-- 
2.39.5



