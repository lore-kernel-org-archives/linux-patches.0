Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61DC33263F;
	Tue, 21 Jul 2026 20:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666221; cv=none; b=LHUV7W1eLj08C/VHYgbZFTSJcCbT5ROi2/8LbUCNdz/WC4fw9155AYIEDkfR5nGk+/WjLoQppHjSKp3ye4Y92vVkFWw0UJLnx4koupM8Efrse2/naN6essIuXQIOfEQuiQfmOlAlJ+5gvvdQBrRwLZzV9RcApy+gKzxOOnRLrt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666221; c=relaxed/simple;
	bh=8Bs4vY5MHBlawzzJiRUmRoDnf7tPuU4d+td3GdcUAG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwLcTFI3/4pGAKgtR08ApA3pUy6zCWZLuibtRMjkRzBebmZRswXWalRgb44ZHtda3WSpGbCLKxzl9YcGoiyISxninSLhUejpT24Nl7FRBLEB1B2WpqW+D9ASU3GdoCdKsL7C04epLQgOiQoSRlSEv/vn6ktKyb6rJmV3kt3SVx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlULxeEM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlULxeEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DE21F000E9;
	Tue, 21 Jul 2026 20:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666219;
	bh=tvBS55UcEvdIaY8AJaokLDjvlu/R4QmNlzBJL0amQcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlULxeEMNlq/s0MSovwecJGZG8dCXu6KYL49ICYCUNUwhmacUGmgM4Zqv/aN5S9/W
	 bLUCtf5KX/DYEF8JmgHNd9t//MnSwzO2yp8KTNjyTzFbD7j4bIV2wxc8qF9lsl6znn
	 WN1C0GA5LIZtVg/PHk1bu6D0Pf/+sFfAQHxpzHnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0557/1266] ASoC: fsl: fsl_audmix: Validate written enum values
Date: Tue, 21 Jul 2026 17:16:34 +0200
Message-ID: <20260721152454.331282358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d8e44470f501e7..8bc02ceda13c2b 100644
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



