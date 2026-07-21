Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5993AA4F9;
	Tue, 21 Jul 2026 22:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673683; cv=none; b=UlycKcsTkrHX2eVAMQo/UPzedSG7Bfz1lwk9Kp4BvxfOM8l+ecqnSmzFgqQV3uO0JR1BnoA+jaETEMZ/cvkmDDJd3LdSyVnWFadFv+bvcImmkXeIcrbOozFQM92Kc7vu95FAMfxARnVIhA5UeNil/hZIXbxgisjmyGNS5BzokOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673683; c=relaxed/simple;
	bh=boFCP/sQAe7lQT+hHpSDTPk/VyhMs/Y6mAZ1YyLsknQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cf4tJtUM2G+DyCsgCb+JQxXBLgel/eb8PYs1iPMIuYFO4dIOEgBEMLOpWcad4nyu7t2Z7+1iegWdQfNH1ly8MbuPREgB7iYVIE9k96zO/P5qiGAJO3s7FE5znyTL7eBCXJwQzTxL+eaDpDVCxSqONBtaDgOkauLNCrVv7NhsSgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJWbZInq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJWbZInq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AFE1F000E9;
	Tue, 21 Jul 2026 22:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673682;
	bh=TfJjtCoUD6Z6g1YsRWz9HrRzO1m+1O2EPmx3qYcsOkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJWbZInqvWkEbhst9eOsspZs1RAiOKJzpWVbFSWxrZp2ymuTf7Z2vMPvvGuZI9B3k
	 O9XprCW003WLn4Lu3PQWOk4YQszV4yYSLpXBEMmSJMcHOrzKGFDs9SVwUNswHABrdQ
	 zRlfCUSCk2RIm739zXAduSF9V31j7wC6+hJ9FkEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/699] ASoC: fsl: fsl_audmix: Validate written enum values
Date: Tue, 21 Jul 2026 17:20:13 +0200
Message-ID: <20260721152401.428622899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
index 7ad5925772e8e1..f78e626d9a092c 100644
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



