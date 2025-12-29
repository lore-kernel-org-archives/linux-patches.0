Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2516223C39A;
	Mon, 29 Dec 2025 16:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025327; cv=none; b=hS/ODCAzS1ZUTNI6WyIR3J2OpGQPzRTz80goYP6y6BRwSvNFG2iR6BcghKPkN+i4M5o5skKvN+qdwkCWrAIe3zdwzYNjdGmdmzJl+Ys5menKSfSU7ENsRXr2VGee7qdWctIQxcHDJFcsxhuzzgo11x6uAIjRivT2J7fXf1T03qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025327; c=relaxed/simple;
	bh=9S7FymlM62HlXvvLCZ5R6vfIXq8rXY01mduNL66bHto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjncWxjY1lui04GGldKdY3wHnQtKUyT7N1AQH+9v5aqRMxTFpA+oKEMgs/WWj2BnXa21z1N+bG9zrWrkQxn9J5UbcP7EMhjQMEss19G/GjUWACW5+l8nY3MZnR1nScqRFDUiUA/S3Kvp43CKhLUpZhfC9INK2q/x178ulHHJem4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETE5fO6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETE5fO6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A459FC116C6;
	Mon, 29 Dec 2025 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025327;
	bh=9S7FymlM62HlXvvLCZ5R6vfIXq8rXY01mduNL66bHto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETE5fO6h5gAelh6ptCR24kUbEKK6GeWyceOx9C4JHKnCLL7dfcisuFqrExmszaFU5
	 sJXrZbm7l/83Bclh+XONmt/52EE3bfahH/i6hpCLzV9MHxGiBPak5JsMrDlIeEQCrh
	 75itGsWkp9YJ6nvO8F7GiZL0eFlhgZeLefhTuMRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>
Subject: [PATCH 6.18 175/430] ASoC: ops: fix snd_soc_get_volsw for sx controls
Date: Mon, 29 Dec 2025 17:09:37 +0100
Message-ID: <20251229160730.801113869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 095d621141826a2841dae85b52c784c147ea99d3 ]

SX controls are currently broken, since the clamp introduced in
commit a0ce874cfaaa ("ASoC: ops: improve snd_soc_get_volsw") does not
handle SX controls, for example where the min value in the clamp is
greater than the max value in the clamp.

Add clamp parameter to prevent clamping in SX controls.
The nature of SX controls mean that it wraps around 0, with a variable
number of bits, therefore clamping the value becomes complicated and
prone to error.

Fixes 35 kunit tests for soc_ops_test_access.

Fixes: a0ce874cfaaa ("ASoC: ops: improve snd_soc_get_volsw")

Co-developed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Tested-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20251216134938.788625-1-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index ce86978c158d..624e9269fc25 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -111,7 +111,8 @@ int snd_soc_put_enum_double(struct snd_kcontrol *kcontrol,
 EXPORT_SYMBOL_GPL(snd_soc_put_enum_double);
 
 static int sdca_soc_q78_reg_to_ctl(struct soc_mixer_control *mc, unsigned int reg_val,
-				unsigned int mask, unsigned int shift, int max)
+				   unsigned int mask, unsigned int shift, int max,
+				   bool sx)
 {
 	int val = reg_val;
 
@@ -141,20 +142,26 @@ static unsigned int sdca_soc_q78_ctl_to_reg(struct soc_mixer_control *mc, int va
 }
 
 static int soc_mixer_reg_to_ctl(struct soc_mixer_control *mc, unsigned int reg_val,
-				unsigned int mask, unsigned int shift, int max)
+				unsigned int mask, unsigned int shift, int max,
+				bool sx)
 {
 	int val = (reg_val >> shift) & mask;
 
 	if (mc->sign_bit)
 		val = sign_extend32(val, mc->sign_bit);
 
-	val = clamp(val, mc->min, mc->max);
-	val -= mc->min;
+	if (sx) {
+		val -= mc->min; // SX controls intentionally can overflow here
+		val = min_t(unsigned int, val & mask, max);
+	} else {
+		val = clamp(val, mc->min, mc->max);
+		val -= mc->min;
+	}
 
 	if (mc->invert)
 		val = max - val;
 
-	return val & mask;
+	return val;
 }
 
 static unsigned int soc_mixer_ctl_to_reg(struct soc_mixer_control *mc, int val,
@@ -280,9 +287,10 @@ static int soc_put_volsw(struct snd_kcontrol *kcontrol,
 
 static int soc_get_volsw(struct snd_kcontrol *kcontrol,
 			 struct snd_ctl_elem_value *ucontrol,
-			 struct soc_mixer_control *mc, int mask, int max)
+			 struct soc_mixer_control *mc, int mask, int max, bool sx)
 {
-	int (*reg_to_ctl)(struct soc_mixer_control *, unsigned int, unsigned int, unsigned int, int);
+	int (*reg_to_ctl)(struct soc_mixer_control *, unsigned int, unsigned int,
+			  unsigned int, int, bool);
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	unsigned int reg_val;
 	int val;
@@ -293,16 +301,16 @@ static int soc_get_volsw(struct snd_kcontrol *kcontrol,
 		reg_to_ctl = soc_mixer_reg_to_ctl;
 
 	reg_val = snd_soc_component_read(component, mc->reg);
-	val = reg_to_ctl(mc, reg_val, mask, mc->shift, max);
+	val = reg_to_ctl(mc, reg_val, mask, mc->shift, max, sx);
 
 	ucontrol->value.integer.value[0] = val;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
 		if (mc->reg == mc->rreg) {
-			val = reg_to_ctl(mc, reg_val, mask, mc->rshift, max);
+			val = reg_to_ctl(mc, reg_val, mask, mc->rshift, max, sx);
 		} else {
 			reg_val = snd_soc_component_read(component, mc->rreg);
-			val = reg_to_ctl(mc, reg_val, mask, mc->shift, max);
+			val = reg_to_ctl(mc, reg_val, mask, mc->shift, max, sx);
 		}
 
 		ucontrol->value.integer.value[1] = val;
@@ -371,7 +379,7 @@ int snd_soc_get_volsw(struct snd_kcontrol *kcontrol,
 		(struct soc_mixer_control *)kcontrol->private_value;
 	unsigned int mask = soc_mixer_mask(mc);
 
-	return soc_get_volsw(kcontrol, ucontrol, mc, mask, mc->max - mc->min);
+	return soc_get_volsw(kcontrol, ucontrol, mc, mask, mc->max - mc->min, false);
 }
 EXPORT_SYMBOL_GPL(snd_soc_get_volsw);
 
@@ -413,7 +421,7 @@ int snd_soc_get_volsw_sx(struct snd_kcontrol *kcontrol,
 		(struct soc_mixer_control *)kcontrol->private_value;
 	unsigned int mask = soc_mixer_sx_mask(mc);
 
-	return soc_get_volsw(kcontrol, ucontrol, mc, mask, mc->max);
+	return soc_get_volsw(kcontrol, ucontrol, mc, mask, mc->max, true);
 }
 EXPORT_SYMBOL_GPL(snd_soc_get_volsw_sx);
 
-- 
2.51.0



