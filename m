Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FCF4C97;
	Tue, 11 Nov 2025 00:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822454; cv=none; b=VR0ZG34uUKiA6bRfFf5YtT3ULeHcAXIrxjSN+HsATNQlneLPIFmg588wMP67PYmJEv3q3Tx6Uw/PTyovyIJgrNxlX2AGnyihIKxvru8GAJPyyXebtrkQFPrTeqSzpbfUOSw0+gYCHQ1XLppf2+Yhrid6kUk4XSL/Kqws5jlTxck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822454; c=relaxed/simple;
	bh=rJxM9DM0FC1tYeBS156NSQp4+pehyce7i1qERKunPIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsQiQy6IlfzkgWab+uNY3SMkTxbTISzjMjt4EOBV7KfvWHH0IaOyqIxDGb6PeJN0SKbgA53o7yNBxdscYjMhXDO5O3MuTIJ3Kvlr2CI2W2AOWGUG3S3tRziFo0NuTcAIPaqlhw2bwyQHpZK4iNulHpT5gH1In6dsEgxU3sa0IRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEntDElM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEntDElM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF72C4AF0B;
	Tue, 11 Nov 2025 00:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822453;
	bh=rJxM9DM0FC1tYeBS156NSQp4+pehyce7i1qERKunPIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEntDElMFoA16AdqtGyJNLFaKT5uwufk1GlId263iGn8GTH/lbmP2ZlSAmTu92PJB
	 Q6t4rU1IIPUFWcz+w78R1/9zc8kKI1CwXbO6QYKdjoz986O5sWHEazAkUBQhMGQSw0
	 p92puT1gk0dyna0jQmuuymgAhYjq8wIpgSFGymv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Zanders <maarten@zanders.be>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/565] ASoC: fsl_sai: Fix sync error in consumer mode
Date: Tue, 11 Nov 2025 09:38:29 +0900
Message-ID: <20251111004528.106449955@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Zanders <maarten@zanders.be>

[ Upstream commit b2dd1d0d322dce5f331961c927e775b84014d5ab ]

When configured for default synchronisation (Rx syncs to Tx) and the
SAI operates in consumer mode (clocks provided externally to Tx), a
synchronisation error occurs on Tx on the first attempt after device
initialisation when the playback stream is started while a capture
stream is already active. This results in channel shift/swap on the
playback stream.
Subsequent streams (ie after that first failing one) always work
correctly, no matter the order, with or without the other stream active.

This issue was observed (and fix tested) on an i.MX6UL board connected
to an ADAU1761 codec, where the codec provides both frame and bit clock
(connected to TX pins).

To fix this, always initialize the 'other' xCR4 and xCR5 registers when
we're starting a stream which is synced to the opposite one, irregardless
of the producer/consumer status.

Fixes: 51659ca069ce ("ASoC: fsl-sai: set xCR4/xCR5/xMR for SAI master mode")

Signed-off-by: Maarten Zanders <maarten@zanders.be>
Reviewed-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://patch.msgid.link/20251024135716.584265-1-maarten@zanders.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 7e4338762f085..bc3bf1c55d3c1 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -620,12 +620,12 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 		val_cr4 |= FSL_SAI_CR4_CHMOD;
 
 	/*
-	 * For SAI provider mode, when Tx(Rx) sync with Rx(Tx) clock, Rx(Tx) will
-	 * generate bclk and frame clock for Tx(Rx), we should set RCR4(TCR4),
-	 * RCR5(TCR5) for playback(capture), or there will be sync error.
+	 * When Tx(Rx) sync with Rx(Tx) clock, Rx(Tx) will provide bclk and
+	 * frame clock for Tx(Rx). We should set RCR4(TCR4), RCR5(TCR5)
+	 * for playback(capture), or there will be sync error.
 	 */
 
-	if (!sai->is_consumer_mode[tx] && fsl_sai_dir_is_synced(sai, adir)) {
+	if (fsl_sai_dir_is_synced(sai, adir)) {
 		regmap_update_bits(sai->regmap, FSL_SAI_xCR4(!tx, ofs),
 				   FSL_SAI_CR4_SYWD_MASK | FSL_SAI_CR4_FRSZ_MASK |
 				   FSL_SAI_CR4_CHMOD_MASK,
-- 
2.51.0



