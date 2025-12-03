Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8840C303C91;
	Wed,  3 Dec 2025 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776346; cv=none; b=FZnYmjqdGpuqSCbuTY8IV5M2WRfLYVTzuXVn7M47RRWtwsdBiLnONftMm4UeLo0REEhurZfj3FNOkYPmVtgqDo+P2D1kcShHrM1h+VoUhpsmDuI4ocoxH6iyM2NQifUNoEg0j2dPrrOEkRb9zaAUA4pTER8HcT056CMuX1/XbF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776346; c=relaxed/simple;
	bh=w2uXhK7Lo2Wi3iqNMkOXbHkYJzZKuZOfc4C35pEywHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OButc9Eu6V8oAJyC57eFfl4PWKYKr5g/Yo+G0Ksqo0D8VgNjLBac2wq/T2jULi9KfVrZMGWVBmJMwPxKZmEKLye9fRQ087bdVQVvOT7KBRitWD/VP2O7yWofhqxMyWQdAEStPvj+X75Fd9uJoUGuZcS/j341J8qP75nRvlPDBFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWUGG3NC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWUGG3NC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB201C4CEF5;
	Wed,  3 Dec 2025 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776346;
	bh=w2uXhK7Lo2Wi3iqNMkOXbHkYJzZKuZOfc4C35pEywHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWUGG3NCguvhRXYoSHultw/7WuwH9xyF+TDhcClfkHBZ7qn2/c2Sv8Qe752lRKVF4
	 Kmc9Jv2008UhKd1cHxKpcW9QoFlvCwJargttC9YudC7c6/4OemH7560Sja4xI0t/Hr
	 Oj9WhJ9ldWMuFtbWOq9680u85qkP9DF10qUAjfzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valerio Setti <vsetti@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/300] ASoC: meson: aiu-encoder-i2s: fix bit clock polarity
Date: Wed,  3 Dec 2025 16:25:59 +0100
Message-ID: <20251203152406.359508992@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 67729de41a73e..a512cd49bc507 100644
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



