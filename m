Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4848BEB;
	Sat, 30 Dec 2023 12:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvG8xdlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82B9C433C7;
	Sat, 30 Dec 2023 12:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937816;
	bh=1qFoKBWuw4/D7WZd/g0s6TH2Xoh8Oi9ebrb81slnF2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvG8xdlO4mlgaNCdSojGAN0ZxnqWKdchpUi6/Tg1lAJnF41+32NUWp+Q1rp+AU9jf
	 OYwtiK0/DUwoZRbeqhP3ofOJKdiK4dJtD1Wc1ng66jXRcbQ+qFOtm3e8ndk9m95PGT
	 78ri7YJUkVlojT6fanqlWFbLK3aBibF14zuoKc4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/156] ASoC: fsl_sai: Fix channel swap issue on i.MX8MP
Date: Sat, 30 Dec 2023 11:58:47 +0000
Message-ID: <20231230115814.743684934@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 8f0f01647550daf9cd8752c1656dcb0136d79ce1 ]

When flag mclk_with_tere and mclk_direction_output enabled,
The SAI transmitter or receiver will be enabled in very early
stage, that if FSL_SAI_xMR is set by previous case,
for example previous case is one channel, current case is
two channels, then current case started with wrong xMR in
the beginning, then channel swap happen.

The patch is to clear xMR in hw_free() to avoid such
channel swap issue.

Fixes: 3e4a82612998 ("ASoC: fsl_sai: MCLK bind with TX/RX enable bit")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://msgid.link/r/1702953057-4499-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 3252eefc4bc0e..3d202398c5411 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -715,6 +715,9 @@ static int fsl_sai_hw_free(struct snd_pcm_substream *substream,
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	unsigned int ofs = sai->soc_data->reg_offset;
 
+	/* Clear xMR to avoid channel swap with mclk_with_tere enabled case */
+	regmap_write(sai->regmap, FSL_SAI_xMR(tx), 0);
+
 	regmap_update_bits(sai->regmap, FSL_SAI_xCR3(tx, ofs),
 			   FSL_SAI_CR3_TRCE_MASK, 0);
 
-- 
2.43.0



