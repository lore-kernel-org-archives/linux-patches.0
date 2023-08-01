Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863511FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AC0C433C8;
	Tue,  1 Aug 2023 09:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882494;
	bh=IrpIoiwDB/Sxj07qL2kfVGEK05JL2gk3iyQLKzTC/go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tg4KU2dc14ieopjzDppp1kzDJpb1qM7bfV2t8atpvTJRLxj+r4ducp3K4NJoOBB4y
	 4+5i6THsuPa6eMM00RmeyDwXv90ZzUveNjXRp5ymsWi+T5+DTHdYhteiGqyha2mzSX
	 zqbg1xJoHFWhQ4VO3A1+hJFVs/oDNjo4yI6SULF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Gajdos <matuszpd@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/228] ASoC: fsl_spdif: Silence output on stop
Date: Tue,  1 Aug 2023 11:19:44 +0200
Message-ID: <20230801091927.294947161@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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
index 275aba8e0c469..fb6806b2db859 100644
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



