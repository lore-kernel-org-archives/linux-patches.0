Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DCC40860A;
	Tue, 21 Jul 2026 18:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659711; cv=none; b=tOToyvTpWWVuH4/5mjWuVCFGEeo7T5llQ8pFx+AzB9dECCHBIHBSnn9rQR4ExjaQNZcAal34w+PgyqlIrVRNw9jM1QG0gcCAECAJn0ZSGze7iVM6zx43rXw19x87zrSZOoeJ5lsmPpfe4h9XZ1bkezESpsf0hzqGDeFvyOZhkvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659711; c=relaxed/simple;
	bh=XSpB7APv6IlrOhj1eQ6SsKj9nDQfXlT1JW9XRh5kLB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTCL0iuQpj56gOx7KTUPY5yEcqG/mrUgTvauJH/bp3PormYMqDJXpSZv7QSMdq9PXsipfkmwW1bfJPYPTZhWc+Ptmm1CEuoEVHuF5BVieRLUulmV6Ngb4hLxxw6WIT/YZiXSrs2f230LxEeYkEU7lRJgYjQwpVV1xKTV2/vI8JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAgq1nvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAgq1nvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142C71F000E9;
	Tue, 21 Jul 2026 18:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659709;
	bh=NPzbj3XWGYXCUu4A4Hk8avMLuhCdVUq3lNHrnAB7FRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAgq1nvWd+xeMY+7fgVji/OwCdFdtX5Q5BP+e4u7hCs2H+FXaUIElKHDsKDsIvfu2
	 GpTeO1JfAhuc6OlVa3JzW0vaR2LW97LAyXUD+vT94LnduY7J47y04pqDSHYDiAnI3u
	 M+IZXg4n1tO/dXKZAAfLPcF64YFPLB1Zo3SJr36k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0705/2077] ASoC: fsl: fsl_audmix: Validate written enum values
Date: Tue, 21 Jul 2026 17:06:18 +0200
Message-ID: <20260721152609.422089192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 3cd17e4e2871114d5579fa7bc8da66faf7fc1930 ]

fsl_audmix_put_mix_clk_src() and fsl_audmix_put_out_src()
convert the user-provided enum item with snd_soc_enum_item_to_val()
before checking whether the item is within the enum's item count.

The generic snd_soc_put_enum_double() helper performs that
validation, but these callbacks use the converted value first: the
clock-source path tests it with BIT(), and the output-source path
indexes the prms transition table with it.

Reject out-of-range enum items before converting them.

Fixes: be1df61cf06e ("ASoC: fsl: Add Audio Mixer CPU DAI driver")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260609124317.38046-4-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_audmix.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/fsl/fsl_audmix.c b/sound/soc/fsl/fsl_audmix.c
index 40a3b743217442..f819f33ec46b84 100644
--- a/sound/soc/fsl/fsl_audmix.c
+++ b/sound/soc/fsl/fsl_audmix.c
@@ -117,6 +117,9 @@ static int fsl_audmix_put_mix_clk_src(struct snd_kcontrol *kcontrol,
 	unsigned int *item = ucontrol->value.enumerated.item;
 	unsigned int reg_val, val, mix_clk;
 
+	if (item[0] >= e->items)
+		return -EINVAL;
+
 	/* Get current state */
 	reg_val = snd_soc_component_read(comp, FSL_AUDMIX_CTR);
 	mix_clk = ((reg_val & FSL_AUDMIX_CTR_MIXCLK_MASK)
@@ -157,6 +160,9 @@ static int fsl_audmix_put_out_src(struct snd_kcontrol *kcontrol,
 	unsigned int reg_val, val, mask = 0, ctr = 0;
 	int ret;
 
+	if (item[0] >= e->items)
+		return -EINVAL;
+
 	/* Get current state */
 	reg_val = snd_soc_component_read(comp, FSL_AUDMIX_CTR);
 
-- 
2.53.0



