Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3641FF5EC;
	Wed,  7 May 2025 18:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643983; cv=none; b=FvT8tF/H9SQxvSZG49VPfHukspSCPrcxxEXsJMog+h4JluJK97n27vz5RdMvnWGaIrm757APYmkthPKOMWiB3b5s15zqznQBDSO312bD0MINxLxAl8HCnOXfxsL3JJGdTXFQvskxZAYgZuFY+xdm30yET2nHHuAun53cTkHGmF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643983; c=relaxed/simple;
	bh=cdtzGWrYujYyjjGQbL8nEXOALBUN8vovDuS6PJVC358=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSQMAkLaTpAbkkFR9kyfREr4owRDgoT/T4U8/xGryq5sH41ng3GqkpERCr/Ngac9pb6VpQOPKfhXBFhMEG5Cu/dRV5sqbox5NolvBvBZvSMqfGEm8Gop9WdWLlQ1vkE1lTSzuRnVIQryh3C/ky1LtGuiAXX5ddwPuxaf6MwgWo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JynN1gst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JynN1gst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EC2C4CEE2;
	Wed,  7 May 2025 18:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643983;
	bh=cdtzGWrYujYyjjGQbL8nEXOALBUN8vovDuS6PJVC358=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JynN1gstC4Yw9gKWxSOJAtTCvO8314R22MTsjVCtsRZG03fMKbFszNxhTG5/uguAK
	 /HbmzTQfgGDCkknWa+yxwmuuQ12382btSl4KAeglzOYw8ZOXnD97Dq05/dio+/JyJ1
	 dbobH5Rpc+yDBsAUjyIzfH3UQ2xGGoXd/atRNIX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 052/183] ASoC: soc-pcm: Fix hw_params() and DAPM widget sequence
Date: Wed,  7 May 2025 20:38:17 +0200
Message-ID: <20250507183826.798381628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 88b3ad5a25520..53b0ea68b939f 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1618,10 +1618,13 @@ static int dpcm_add_paths(struct snd_soc_pcm_runtime *fe, int stream,
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



