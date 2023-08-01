Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E372E1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17068C433C8;
	Tue,  1 Aug 2023 09:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883121;
	bh=jvYokCJ5F34jY8LlAShv27Ja7+q8Vny0G4oJvcQLrFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCpPCt0A9cB1pG4771s6M1RAUkXOTrwa4ila+nqOYtqN+2fMaey2eZyDux2EAJeJL
	 /cFF/Pny/dVWCJglIGFrwxSJkUlA6xGfMpyNicJmvv0BUNfjFlp8clJ3q6EsVLyUXf
	 x6/TqZ4DNAwyQM79xWBEIIonB0Pmz+ZrMU8WKfI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Gajdos <matuszpd@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 121/239] ASoC: fsl_spdif: Silence output on stop
Date: Tue,  1 Aug 2023 11:19:45 +0200
Message-ID: <20230801091930.081661428@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matus Gajdos <matuszpd@gmail.com>

[ Upstream commit 0e4c2b6b0c4a4b4014d9424c27e5e79d185229c5 ]

Clear TX registers on stop to prevent the SPDIF interface from sending
last written word over and over again.

Fixes: a2388a498ad2 ("ASoC: fsl: Add S/PDIF CPU DAI driver")
Signed-off-by: Matus Gajdos <matuszpd@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20230719164729.19969-1-matuszpd@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_spdif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 015c3708aa04e..3fd26f2cdd60f 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -751,6 +751,8 @@ static int fsl_spdif_trigger(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		regmap_update_bits(regmap, REG_SPDIF_SCR, dmaen, 0);
 		regmap_update_bits(regmap, REG_SPDIF_SIE, intr, 0);
+		regmap_write(regmap, REG_SPDIF_STL, 0x0);
+		regmap_write(regmap, REG_SPDIF_STR, 0x0);
 		break;
 	default:
 		return -EINVAL;
-- 
2.40.1



