Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E903469EF;
	Tue, 11 Nov 2025 01:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825262; cv=none; b=L6c2/jnoYMtx0PVZIJ1XKBjuwYOe1rDmuOV/S6YHv7i10HQLrI2lQMQd3xlrdGA3LlTOVVWuNn6qNbAkCM0a1PpFFkQ1aRQt8JAJnbhaUx3RgxOYAMlHkMtY9q752sOzEvPO7P4H072ONzCV+R03Ans4yaTw450d/ZimroeWGWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825262; c=relaxed/simple;
	bh=IcecD+fJyhTxeEhcvVvUGjxabnciChEoqXFUMSREJDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvNgS6bnz/RLirRmG0cWIRrx45bzt09Gu+ayPsV1eQS0slERqGQgOr1G90QEvvnWQz9tBgYs+QlN4/RVpsF6iTnHYLQP7ruLzREAxdycxu42sRV7p7JmJff5S3CU7aKHlNDBtTrTTGDee7aVk1rXK/xk1rQQ+q8HJU+J1pIH2Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8/fkYwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8/fkYwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F29C2BC86;
	Tue, 11 Nov 2025 01:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825261;
	bh=IcecD+fJyhTxeEhcvVvUGjxabnciChEoqXFUMSREJDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8/fkYwtSWkRlkS5HC25n/YZ/Doe2zRkVfFJCcXZWC+/9JXQ4Tobn2MOk3DM8PpMQ
	 dAfyRQLsLX+eopvB2T2fhOxB+OHF3GCmTh5TEwi8Gjb5FfoICG9m3oAMioDTFtY2kY
	 iUa/z29W9bR0aYGmP2ud27xgx6gEbyKv+q2Hp7SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valerio Setti <vsetti@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 729/849] ASoC: meson: aiu-encoder-i2s: fix bit clock polarity
Date: Tue, 11 Nov 2025 09:44:59 +0900
Message-ID: <20251111004554.059710498@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valerio Setti <vsetti@baylibre.com>

[ Upstream commit 4c4ed5e073a923fb3323022e1131cb51ad8df7a0 ]

According to I2S specs audio data is sampled on the rising edge of the
clock and it can change on the falling one. When operating in normal mode
this SoC behaves the opposite so a clock polarity inversion is required
in this case.

This was tested on an OdroidC2 (Amlogic S905 SoC) board.

Signed-off-by: Valerio Setti <vsetti@baylibre.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Tested-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20251007-fix-i2s-polarity-v1-1-86704d9cda10@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/aiu-encoder-i2s.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/meson/aiu-encoder-i2s.c b/sound/soc/meson/aiu-encoder-i2s.c
index a0dd914c8ed13..3b4061508c180 100644
--- a/sound/soc/meson/aiu-encoder-i2s.c
+++ b/sound/soc/meson/aiu-encoder-i2s.c
@@ -236,8 +236,12 @@ static int aiu_encoder_i2s_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	    inv == SND_SOC_DAIFMT_IB_IF)
 		val |= AIU_CLK_CTRL_LRCLK_INVERT;
 
-	if (inv == SND_SOC_DAIFMT_IB_NF ||
-	    inv == SND_SOC_DAIFMT_IB_IF)
+	/*
+	 * The SoC changes data on the rising edge of the bitclock
+	 * so an inversion of the bitclock is required in normal mode
+	 */
+	if (inv == SND_SOC_DAIFMT_NB_NF ||
+	    inv == SND_SOC_DAIFMT_NB_IF)
 		val |= AIU_CLK_CTRL_AOCLK_INVERT;
 
 	/* Signal skew */
@@ -328,4 +332,3 @@ const struct snd_soc_dai_ops aiu_encoder_i2s_dai_ops = {
 	.startup	= aiu_encoder_i2s_startup,
 	.shutdown	= aiu_encoder_i2s_shutdown,
 };
-
-- 
2.51.0



