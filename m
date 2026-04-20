Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E2533DEDF;
	Mon, 20 Apr 2026 15:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700109; cv=none; b=tpRDb3y+Pybh3D7q0b6q8EkGnqFZ5f25rjTqL5ZIC449w5WqMgkSgbNjUxyUKYCr4PElzzQp+7G803NYJMUpqE5O+6M+gjf51x+JMK5GW+WDe0mRsXCtOs2fd0wmKmswO+stpyBp+FNlwmFKT3wfYteTT/fRziCbBrtSn0cbZH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700109; c=relaxed/simple;
	bh=BN4BHu7WLeUUgSeKCsWRbckd42PB50EhJvVLXiXvAtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYS76aC/Aoq6muu6DyA+/driFgmxbYcE6zWFLNUQufM5LvSXjfiv7ouz4w14wytlSZzgAYYc1FNkaju1GvODv98qKRJJE5J1qu7ODTi5roRGmihFIgAlk2OZl28j73yyXWz8CySPW/VlwXUuxKUpQ41/5GQn0ihl3qOuE9kDFNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lk7/bSeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lk7/bSeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B8FC19425;
	Mon, 20 Apr 2026 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700109;
	bh=BN4BHu7WLeUUgSeKCsWRbckd42PB50EhJvVLXiXvAtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lk7/bSeOuiZ976eu6/PE5o+EQv+bbzGidbexAw+i4Ar8zitUd2C9YRiOJ1G76e382
	 Ry/Gf9WCxnflpeQ3AveOl7Djcu+5w+zbLCTiaIotsAx6J56AzbrSvYtrgRLuiMLAsm
	 2YxZfZp1LolSoukrcnr+DOsb2dURUa+U5O4mq9Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Merta <tommerta@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 046/220] ASoC: stm32_sai: fix incorrect BCLK polarity for DSP_A/B, LEFT_J
Date: Mon, 20 Apr 2026 17:39:47 +0200
Message-ID: <20260420153935.696375108@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Merta <tomasz.merta@arrow.com>

[ Upstream commit 0669631dbccd41cf3ca7aa70213fcd8bb41c4b38 ]

The STM32 SAI driver do not set the clock strobing bit (CKSTR) for DSP_A,
DSP_B and LEFT_J formats, causing data to be sampled on the wrong BCLK
edge when SND_SOC_DAIFMT_NB_NF is used.

Per ALSA convention, NB_NF requires sampling on the rising BCLK edge.
The STM32MP25 SAI reference manual states that CKSTR=1 is required for
signals received by the SAI to be sampled on the SCK rising edge.
Without setting CKSTR=1, the SAI samples on the falling edge, violating
the NB_NF convention. For comparison, the NXP FSL SAI driver correctly
sets FSL_SAI_CR2_BCP for DSP_A, DSP_B and LEFT_J, consistent with its
I2S handling.

This patch adds SAI_XCR1_CKSTR for DSP_A, DSP_B and LEFT_J in
stm32_sai_set_dai_fmt which was verified empirically with a cs47l35 codec.
RIGHT_J (LSB) is not investigated and addressed by this patch.

Note: the STM32 I2S driver (stm32_i2s_set_dai_fmt) may have the same issue
for DSP_A mode, as I2S_CGFR_CKPOL is not set. This has not been verified
and is left for a separate investigation.

Signed-off-by: Tomasz Merta <tommerta@gmail.com>
Link: https://patch.msgid.link/20260408084056.20588-1-tommerta@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 450e1585edeee..3e82fa90e719a 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -802,6 +802,7 @@ static int stm32_sai_set_dai_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
 		break;
 	/* Left justified */
 	case SND_SOC_DAIFMT_MSB:
+		cr1 |= SAI_XCR1_CKSTR;
 		frcr |= SAI_XFRCR_FSPOL | SAI_XFRCR_FSDEF;
 		break;
 	/* Right justified */
@@ -809,9 +810,11 @@ static int stm32_sai_set_dai_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
 		frcr |= SAI_XFRCR_FSPOL | SAI_XFRCR_FSDEF;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
+		cr1 |= SAI_XCR1_CKSTR;
 		frcr |= SAI_XFRCR_FSPOL | SAI_XFRCR_FSOFF;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
+		cr1 |= SAI_XCR1_CKSTR;
 		frcr |= SAI_XFRCR_FSPOL;
 		break;
 	default:
-- 
2.53.0



