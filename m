Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C93621504D;
	Wed,  7 May 2025 19:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644957; cv=none; b=rpuEQm602g75NOIuAqVpstpdei93nMsQ/po5pyGTuRfLZy1cO60Rlo9Ov/kcEncu5SdxYuCyDl08vtY5hTkNkk5PAuDiTyBwNnJb6XLPo5JMmXpby4aRsgU1ToPZSCpp6OD7D/WUigk/jXLSXMnGqvRMhOYXewHyt0gRnsHr9GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644957; c=relaxed/simple;
	bh=3N8D5S5C5hPdUxfWhUKdQl2Tg5AQ+LZg/s6Vaw897DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qz4FmzNW1v0aOxpbf73hC87kUz0PaakpYtBkgyBVZeS2jmpYZ+gaMqWKXhW1HsZ/tRWCdkXa0E2mJwiRHhGQyp4eixyyM8Bnvor9izb6JRP2bucKa71dJln0d1obTifOX25tfeav03Gy3ZP/YJurED3UjGD/7z+1zAnyBQ5I5i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HacdPea/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HacdPea/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27DCC4CEE2;
	Wed,  7 May 2025 19:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644957;
	bh=3N8D5S5C5hPdUxfWhUKdQl2Tg5AQ+LZg/s6Vaw897DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HacdPea/6z7/chi8+L+Mk25mHyB+hMKvFhKw/mGnu+fBmmUuL5/rPRAD+fSAmtus+
	 0MGlVSt3VHE7IJwnYdZndANN85cuP4nwNsDggHfcRJI4EIqSIBYDd3j/btGGq0YoMy
	 oGOSSeD3DtoSW7vxzoIM6AK62cUN+yS036177Rj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/129] ASoC: soc-pcm: Fix hw_params() and DAPM widget sequence
Date: Wed,  7 May 2025 20:39:43 +0200
Message-ID: <20250507183815.445441317@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60248a6820aac..30e93f9aad762 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1534,10 +1534,13 @@ static int dpcm_add_paths(struct snd_soc_pcm_runtime *fe, int stream,
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



