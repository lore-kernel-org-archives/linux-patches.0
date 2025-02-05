Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEB213C9C4;
	Wed,  5 Feb 2025 14:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764467; cv=none; b=UlC6TMC52YC4YV5z4Aw+Cp9iTwxOlsEhEQB9TAr/FHNtzJ/PhiosZBvLmc+t18cK8IJYFULOECFlrd/iv/H9D0zT0pdiWXl5sRXMWR4Uo7USWzj4qTW7egmMP1lIiDCn3bI8A9otmQUCXNPug5eFriq9kRsE+COxet4fmVXFFqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764467; c=relaxed/simple;
	bh=93ernUaTr6kV46zLtCezpwwe86ixSvZuqRYDfxiXcwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8rGdkgBXtxIkNpoxNjMC7BiFXoz/BaArewhjyLzoQY7OKpce0LtR7QxbYfw8oTu/0l26ubAlJDFiuNywLl7xuIPHRW+HQ6uLQLyU5Ns/1I1FbQkign58NDErhC6U68XsGvSzxyW3KGa35Ucv4y/pZq7q/YrSNgaYqD1hc/uXhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GduzQiv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GduzQiv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AF5C4CED1;
	Wed,  5 Feb 2025 14:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764467;
	bh=93ernUaTr6kV46zLtCezpwwe86ixSvZuqRYDfxiXcwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GduzQiv7Md8KMWukKC7+Hf7bZObW33XzzJhKNogBMx8BfsueS8ZfRFeJQKnt1Idsf
	 nRconlVLhpw72fY7VdOQkqPnwCdPSxvgyfYNR2JvZupb0sxSWdoMUemDAVfzITcYle
	 znHzScnXzizmXFddCarauZ6uvDtC/pCZtQYscqfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Lander <lander@jagmn.com>,
	Marcus Cooper <codekipper@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/393] ASoC: sun4i-spdif: Add clock multiplier settings
Date: Wed,  5 Feb 2025 14:41:15 +0100
Message-ID: <20250205134426.268598671@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: George Lander <lander@jagmn.com>

[ Upstream commit 0a2319308de88b9e819c0b43d0fccd857123eb31 ]

There have been intermittent issues with the SPDIF output on H3
and H2+ devices which has been fixed by setting the s_clk to 4
times the audio pll.
Add a quirk for the clock multiplier as not every supported SoC
requires it. Without the multiplier, the audio at normal sampling
rates was distorted and did not play at higher sampling rates.

Fixes: 1bd92af877ab ("ASoC: sun4i-spdif: Add support for the H3 SoC")
Signed-off-by: George Lander <lander@jagmn.com>
Signed-off-by: Marcus Cooper <codekipper@gmail.com>
Link: https://patch.msgid.link/20241111165600.57219-2-codekipper@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-spdif.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/sunxi/sun4i-spdif.c b/sound/soc/sunxi/sun4i-spdif.c
index 2347aeb049bcc..e482238388de1 100644
--- a/sound/soc/sunxi/sun4i-spdif.c
+++ b/sound/soc/sunxi/sun4i-spdif.c
@@ -177,6 +177,7 @@ struct sun4i_spdif_quirks {
 	unsigned int reg_dac_txdata;
 	bool has_reset;
 	unsigned int val_fctl_ftx;
+	unsigned int mclk_multiplier;
 };
 
 struct sun4i_spdif_dev {
@@ -314,6 +315,7 @@ static int sun4i_spdif_hw_params(struct snd_pcm_substream *substream,
 	default:
 		return -EINVAL;
 	}
+	mclk *= host->quirks->mclk_multiplier;
 
 	ret = clk_set_rate(host->spdif_clk, mclk);
 	if (ret < 0) {
@@ -348,6 +350,7 @@ static int sun4i_spdif_hw_params(struct snd_pcm_substream *substream,
 	default:
 		return -EINVAL;
 	}
+	mclk_div *= host->quirks->mclk_multiplier;
 
 	reg_val = 0;
 	reg_val |= SUN4I_SPDIF_TXCFG_ASS;
@@ -541,24 +544,28 @@ static struct snd_soc_dai_driver sun4i_spdif_dai = {
 static const struct sun4i_spdif_quirks sun4i_a10_spdif_quirks = {
 	.reg_dac_txdata	= SUN4I_SPDIF_TXFIFO,
 	.val_fctl_ftx   = SUN4I_SPDIF_FCTL_FTX,
+	.mclk_multiplier = 1,
 };
 
 static const struct sun4i_spdif_quirks sun6i_a31_spdif_quirks = {
 	.reg_dac_txdata	= SUN4I_SPDIF_TXFIFO,
 	.val_fctl_ftx   = SUN4I_SPDIF_FCTL_FTX,
 	.has_reset	= true,
+	.mclk_multiplier = 1,
 };
 
 static const struct sun4i_spdif_quirks sun8i_h3_spdif_quirks = {
 	.reg_dac_txdata	= SUN8I_SPDIF_TXFIFO,
 	.val_fctl_ftx   = SUN4I_SPDIF_FCTL_FTX,
 	.has_reset	= true,
+	.mclk_multiplier = 4,
 };
 
 static const struct sun4i_spdif_quirks sun50i_h6_spdif_quirks = {
 	.reg_dac_txdata = SUN8I_SPDIF_TXFIFO,
 	.val_fctl_ftx   = SUN50I_H6_SPDIF_FCTL_FTX,
 	.has_reset      = true,
+	.mclk_multiplier = 1,
 };
 
 static const struct of_device_id sun4i_spdif_of_match[] = {
-- 
2.39.5



