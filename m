Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A25D4C97;
	Tue, 11 Nov 2025 00:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822505; cv=none; b=KPuj8NEsgG+tKdVDgARcDsYke00cQcsQykIYGht1uA26K8Q+fD/Css6GJ3/CuBDsJvkwaqKtNuBzhyT9V2+plZQaLN4VPUt17eZTkXgqiKzPoTonvjENjAZEfMZ0PcQsqSOPa0BJslYibAscInQ5/LFLxtdkgysUrOdUGMsZwo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822505; c=relaxed/simple;
	bh=V4zzSwxvCWpXM65NdnGGmiPpWgLL9PtW73dMZIGB9l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIoNEMX/9B62Tv+cXkWLjfwQ8VMug/DPiP8mUhxejWOmASYia5ORiTlhYsu42eZr3l0gI8bPFnAvBRh35+ow5aAzXNW82h8aYIG+f3PYuEzcDvRugYPVS0BczW+OQaKOHwoigquG0LliTF3jVqz/DwMTlX5q+oYDF/V8y4FKUF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxs5WCHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxs5WCHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D2BC4CEFB;
	Tue, 11 Nov 2025 00:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822505;
	bh=V4zzSwxvCWpXM65NdnGGmiPpWgLL9PtW73dMZIGB9l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxs5WCHQXBLJPWU+ifu813Nz8TMmA/K8OcGHdMFUDUw6OezudIEsaeOML7FwMADIe
	 WaGS6m9H53qOzljiGcqZrRsf/5haVAPU5INQB2hj1nxMGao8m2Xc0Lp/cxmUZR0PEq
	 ArwToD+pMyBNQi75yLC+MLhcu8CsEP7HgwSlroNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Zanders <maarten@zanders.be>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 077/849] ASoC: fsl_sai: Fix sync error in consumer mode
Date: Tue, 11 Nov 2025 09:34:07 +0900
Message-ID: <20251111004538.283831933@linuxfoundation.org>
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
index 6c0ae4b33aa4f..b6c72c4bd3cd3 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -652,12 +652,12 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
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



