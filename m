Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B252116E9;
	Wed,  7 May 2025 18:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644137; cv=none; b=atl6CgWg67xfPSEeFz1OH9NxI5WwlsvWyccWPIgwu165CIplI+WUnqbOOyAT4GU9x62yIoTBJQoVMOuTjFLzRcKRf7HBR89nuDcbwP/ZN5ksOpeVKFkpd1oi0CP/4T+0Td2KBYjtP06JV2H7Cv2MRbw207nMAddBip0vqdO2pyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644137; c=relaxed/simple;
	bh=qXtGjBZfBmmB9PZ0HBrgRsUgt9AEvjwcC1fSvIIwAus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzoe9I2hRqOws8v832UBlBys/UUTHDWxFsl3yxGRM2Ts6hQKmRsjp2Tqyb99iN/WvPLuxLNEx9jD1PcpF9eZpyoDsC0N3ETl5TI72i8ZpNIRmydNGDjQEBRh49cou6Sr6ZkZ8PjX2xj5hnatd3drFExnUcEAHlXR7kS3qgY2dYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltGKdXJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltGKdXJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770CBC4CEE2;
	Wed,  7 May 2025 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644136;
	bh=qXtGjBZfBmmB9PZ0HBrgRsUgt9AEvjwcC1fSvIIwAus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltGKdXJQBIvLXsoH9MJfDZYuT80DoCgRtw+PAiXANdL1xf2v3EMwthMloUZl5kdJQ
	 EbV1qQ1xEwZvrFxX75TrtQqiboC9e2D5Nv2Wr5SHjBD5zc7fegVeIYSPoZKPz+w63b
	 zLkyN1vK/ZKPMD2cEmaVCso6hI/JSebB3imRA0yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 131/183] ASoC: stm32: sai: skip useless iterations on kernel rate loop
Date: Wed,  7 May 2025 20:39:36 +0200
Message-ID: <20250507183830.126304668@linuxfoundation.org>
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

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit edea92770a3b6454dc796fc5436a3315bb402181 ]

the frequency of the kernel clock must be greater than or equal to the
bitclock rate. When searching for a convenient kernel clock rate in
stm32_sai_set_parent_rate() function, it is useless to continue the loop
below bitclock rate, as it will result in a invalid kernel clock rate.
Change the loop output condition.

Fixes: 2cfe1ff22555 ("ASoC: stm32: sai: add stm32mp25 support")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20250430165210.321273-2-olivier.moysan@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 3efbf4aaf9654..5a5acc67569fe 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -409,11 +409,11 @@ static int stm32_sai_set_parent_rate(struct stm32_sai_sub_data *sai,
 				     unsigned int rate)
 {
 	struct platform_device *pdev = sai->pdev;
-	unsigned int sai_ck_rate, sai_ck_max_rate, sai_curr_rate, sai_new_rate;
+	unsigned int sai_ck_rate, sai_ck_max_rate, sai_ck_min_rate, sai_curr_rate, sai_new_rate;
 	int div, ret;
 
 	/*
-	 * Set maximum expected kernel clock frequency
+	 * Set minimum and maximum expected kernel clock frequency
 	 * - mclk on or spdif:
 	 *   f_sai_ck = MCKDIV * mclk-fs * fs
 	 *   Here typical 256 ratio is assumed for mclk-fs
@@ -423,13 +423,16 @@ static int stm32_sai_set_parent_rate(struct stm32_sai_sub_data *sai,
 	 *   Set constraint MCKDIV * FRL <= 256, to ensure MCKDIV is in available range
 	 *   f_sai_ck = sai_ck_max_rate * pow_of_two(FRL) / 256
 	 */
+	sai_ck_min_rate = rate * 256;
 	if (!(rate % SAI_RATE_11K))
 		sai_ck_max_rate = SAI_MAX_SAMPLE_RATE_11K * 256;
 	else
 		sai_ck_max_rate = SAI_MAX_SAMPLE_RATE_8K * 256;
 
-	if (!sai->sai_mclk && !STM_SAI_PROTOCOL_IS_SPDIF(sai))
+	if (!sai->sai_mclk && !STM_SAI_PROTOCOL_IS_SPDIF(sai)) {
+		sai_ck_min_rate = rate * sai->fs_length;
 		sai_ck_max_rate /= DIV_ROUND_CLOSEST(256, roundup_pow_of_two(sai->fs_length));
+	}
 
 	/*
 	 * Request exclusivity, as the clock is shared by SAI sub-blocks and by
@@ -472,7 +475,7 @@ static int stm32_sai_set_parent_rate(struct stm32_sai_sub_data *sai,
 		/* Try a lower frequency */
 		div++;
 		sai_ck_rate = sai_ck_max_rate / div;
-	} while (sai_ck_rate > rate);
+	} while (sai_ck_rate >= sai_ck_min_rate);
 
 	/* No accurate rate found */
 	dev_err(&pdev->dev, "Failed to find an accurate rate");
-- 
2.39.5



