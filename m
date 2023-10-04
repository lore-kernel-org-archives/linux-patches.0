Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1317A1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869FEC433C7;
	Wed,  4 Oct 2023 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442854;
	bh=DejkkhDYMMxASA/M30VMM2b+Wb01VCntYvYK1TKecxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7VN+mr7MnTE466RXBSJ9sD6Y3MnSLz5K2iYZ+kG0oDZdh9oZ3uH3l2w1R5upLCY+
	 OSHVyS+ifOjo50SNn1DvgEjejg4Cw8zWedGf9eHnzVF75RGVZFZuMHxXIGW1cfF5HW
	 RNuok1Q/pZjXXSdXwcHUv7H8R1kmp10m0tUups0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/183] ASoC: fsl: imx-pcm-rpmsg: Add SNDRV_PCM_INFO_BATCH flag
Date: Wed,  4 Oct 2023 19:56:04 +0200
Message-ID: <20231004175209.502156603@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 2f9426905a63be7ccf8cd10109caf1848aa0993a ]

The rpmsg pcm device is a device which should support
double buffering.

Found this issue with pipewire. When there is no
SNDRV_PCM_INFO_BATCH flag in driver, the pipewire will
set headroom to be zero, and because rpmsg pcm device
don't support residue report, when the latency setting
is small, the "delay" always larger than "target" in
alsa-pcm.c, that reading next period data is not
scheduled on time.

With SNDRV_PCM_INFO_BATCH flag in driver, the pipewire
will select a smaller period size for device, then
the task of reading next period data will be scheduled
on time.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1694414287-13291-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-pcm-rpmsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/imx-pcm-rpmsg.c b/sound/soc/fsl/imx-pcm-rpmsg.c
index 35049043e5322..933bac7ea1864 100644
--- a/sound/soc/fsl/imx-pcm-rpmsg.c
+++ b/sound/soc/fsl/imx-pcm-rpmsg.c
@@ -19,6 +19,7 @@
 static struct snd_pcm_hardware imx_rpmsg_pcm_hardware = {
 	.info = SNDRV_PCM_INFO_INTERLEAVED |
 		SNDRV_PCM_INFO_BLOCK_TRANSFER |
+		SNDRV_PCM_INFO_BATCH |
 		SNDRV_PCM_INFO_MMAP |
 		SNDRV_PCM_INFO_MMAP_VALID |
 		SNDRV_PCM_INFO_NO_PERIOD_WAKEUP |
-- 
2.40.1



