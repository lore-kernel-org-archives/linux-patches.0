Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A75404BC7;
	Tue, 21 Jul 2026 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656557; cv=none; b=T6a/ryA8HLYXljysbT38ejMKnpQIpApu/sino7QBjvDxiTwJEWNhM1l6MlrbJJTa9L2aeeho1syGLMi8ZNNrlRtoB6hOymOK3cvSw1yCof6+TnJSzgpc/RirSB0ObNQwLeT8irfthcbcOAei0ytVlMY3u5AODS3pg02jS5niiDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656557; c=relaxed/simple;
	bh=TmATBBukoKWx6LNxl/cEu5ZB0qK3rP3FmQ84o8FiXLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkHcNRsOlNqRvHxcAvt9q+ZSdGSJA+zWPajVRiY1rOM8ECFhElt5offoyGDP6BtD0a5JjjFvF3TyKRFxePode/eT6buDVpywCkGW4nVXMWLTL+Q4W6Cx2ggL+Xl5YZkjTWglxckZ/SyGbZ1B3a1FaiprK0sm9NvbnV4nKTXssEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQ2ooDwu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQ2ooDwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2B11F000E9;
	Tue, 21 Jul 2026 17:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656555;
	bh=ZZblogHVEemVo4+uVU5X0lNPEzNdBcIcuftuITm+JC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQ2ooDwuWTRYX9SCy4o0cbFbPc+rFchPH3t+teyzFO44QWYSdE/T2hFWpRP243uAY
	 BViv6xfT6aWOWGJpeSYjvzq1XG0xvAF3XXqSvRR+uY4ZFra1l0gR30Ud9OM4pCn3uo
	 s0sm5Fv0WmVtMysc/yuUa6M3UybxtBKxdYm8PfRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0433/1611] ASoC: codecs: aw88261: fix incorrect masks for boost regs
Date: Tue, 21 Jul 2026 17:09:09 +0200
Message-ID: <20260721152525.019722915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit 79c053a1ff9d3ab31cefbc791e8d7816ba830491 ]

The boost-related register fields used in aw88261_reg_force_set use the
exact same definitions as the rest of the fields, where the mask must be
inverted when passing it to regmap_update_bits, but they weren't
inverted here.

Fixes: 028a2ae25691 ("ASoC: codecs: Add aw88261 amplifier driver")
Signed-off-by: Val Packett <val@packett.cool>
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://patch.msgid.link/20260529200550.529719-7-val@packett.cool
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/aw88261.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/aw88261.c b/sound/soc/codecs/aw88261.c
index 124c0a58d08bd2..3270319c32a1f4 100644
--- a/sound/soc/codecs/aw88261.c
+++ b/sound/soc/codecs/aw88261.c
@@ -283,22 +283,22 @@ static void aw88261_reg_force_set(struct aw88261 *aw88261)
 	if (aw88261->frcset_en == AW88261_FRCSET_ENABLE) {
 		/* set FORCE_PWM */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL3_REG,
-				AW88261_FORCE_PWM_MASK, AW88261_FORCE_PWM_FORCEMINUS_PWM_VALUE);
+				~AW88261_FORCE_PWM_MASK, AW88261_FORCE_PWM_FORCEMINUS_PWM_VALUE);
 		/* set BOOST_OS_WIDTH */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL5_REG,
-				AW88261_BST_OS_WIDTH_MASK, AW88261_BST_OS_WIDTH_50NS_VALUE);
+				~AW88261_BST_OS_WIDTH_MASK, AW88261_BST_OS_WIDTH_50NS_VALUE);
 		/* set BURST_LOOPR */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL6_REG,
-				AW88261_BST_LOOPR_MASK, AW88261_BST_LOOPR_340K_VALUE);
+				~AW88261_BST_LOOPR_MASK, AW88261_BST_LOOPR_340K_VALUE);
 		/* set RSQN_DLY */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL7_REG,
-				AW88261_RSQN_DLY_MASK, AW88261_RSQN_DLY_35NS_VALUE);
+				~AW88261_RSQN_DLY_MASK, AW88261_RSQN_DLY_35NS_VALUE);
 		/* set BURST_SSMODE */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL8_REG,
-				AW88261_BURST_SSMODE_MASK, AW88261_BURST_SSMODE_FAST_VALUE);
+				~AW88261_BURST_SSMODE_MASK, AW88261_BURST_SSMODE_FAST_VALUE);
 		/* set BST_BURST */
 		regmap_update_bits(aw88261->regmap, AW88261_BSTCTRL9_REG,
-				AW88261_BST_BURST_MASK, AW88261_BST_BURST_30MA_VALUE);
+				~AW88261_BST_BURST_MASK, AW88261_BST_BURST_30MA_VALUE);
 	} else {
 		dev_dbg(aw88261->aw_pa->dev, "needn't set reg value");
 	}
-- 
2.53.0



