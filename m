Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F17186616;
	Sun,  1 Sep 2024 16:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209203; cv=none; b=VJhmbQ0vg9Dvy62OOFo8l66dptZZRFYipltsgT0TdGvNbYdUCpJIax2eR/illMxfdnWv/2XV9VxuB0PG3iltISBP/TkOo2UEg72b1kDtS8GQFfvaEgVEyQIJsFLcTD/2R0unCdZD7K15uEHpOCPB5KcjtWeGNzg0RKSbijm85Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209203; c=relaxed/simple;
	bh=90P532pvxsuLeCRkjh7VtyYB+ahCa6bAtowsQzu6T0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mmZ7TGjMbiCxj8Lt4IUyba86r5ki3Sv3bYVpjdyl6/qCPORUc8HyWL1r6eaYsaGwRxsK4FEzbngzz70lWC5aYoyCWWgK4Bzwig58Nr5LSGprpRwckzyc31PIrLdW9Vdt1rwARSYhEMdPsew2xw2JSAB0xxvZUMxtHtAJHOTgT9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyqJ8xUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyqJ8xUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CB5C4CEC3;
	Sun,  1 Sep 2024 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209202;
	bh=90P532pvxsuLeCRkjh7VtyYB+ahCa6bAtowsQzu6T0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyqJ8xUDDV2ygcXjKxus8i/uhupajZp60nyqq3lLv+FgslboLhxaZAQIs21mFg+yG
	 PZLUVfGq0z67PiSNph07eOqpAtijNlS6VlvjWosdSfx7HR2jady96sf48Z0gLBPLds
	 H6Vtjrqp7YxJ9fag6IkTcrW8te6J52D7AyQy/UQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/71] pinctrl: mediatek: common-v2: Fix broken bias-disable for PULL_PU_PD_RSEL_TYPE
Date: Sun,  1 Sep 2024 18:17:38 +0200
Message-ID: <20240901160803.141681172@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 166bf8af91225576f85208a31eaedbadd182d1ea ]

Despite its name, commit fed74d75277d ("pinctrl: mediatek: common-v2:
Fix bias-disable for PULL_PU_PD_RSEL_TYPE") actually broke bias-disable
for PULL_PU_PD_RSEL_TYPE.

mtk_pinconf_bias_set_combo() tries every bias method supported by the
pin until one succeeds. For PULL_PU_PD_RSEL_TYPE pins, before the
breaking commit, mtk_pinconf_bias_set_rsel() would be called first to
try and set the RSEL value (as well as PU and PD), and if that failed,
the only other valid option was that bias-disable was specified, which
would then be handled by calling mtk_pinconf_bias_set_pu_pd() and
disabling both PU and PD.

The breaking commit misunderstood this logic and added an early "return
0" in mtk_pinconf_bias_set_rsel(). The result was that in the
bias-disable case, the bias was left unchanged, since by returning
success, mtk_pinconf_bias_set_combo() no longer tried calling
mtk_pinconf_bias_set_pu_pd() to disable the bias.

Since the logic for configuring bias-disable on PULL_PU_PD_RSEL_TYPE
pins required mtk_pinconf_bias_set_rsel() to fail first, in that case,
an error was printed to the log, eg:

  mt8195-pinctrl 10005000.pinctrl: Not support rsel value 0 Ohm for pin = 29 (GPIO29)

This is what the breaking commit actually got rid of, and likely part of
the reason why that commit was thought to be fixing functionality, while
in reality it was breaking it.

Instead of simply reverting that commit, restore the functionality but
in a way that avoids the error from being printed and makes the code
less confusing:
* Return 0 explicitly if a bias method was successful
* Introduce an extra function mtk_pinconf_bias_set_pu_pd_rsel() that
  calls both mtk_pinconf_bias_set_rsel() (only if needed) and
  mtk_pinconf_bias_set_pu_pd()
  * And analogously for the corresponding getters

Fixes: fed74d75277d ("pinctrl: mediatek: common-v2: Fix bias-disable for PULL_PU_PD_RSEL_TYPE")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/20240808-mtk-rsel-bias-disable-fix-v1-1-1b4e85bf596c@collabora.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pinctrl/mediatek/pinctrl-mtk-common-v2.c  | 55 ++++++++++---------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index b7921b59eb7b1..54301fbba524a 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -709,32 +709,35 @@ static int mtk_pinconf_bias_set_rsel(struct mtk_pinctrl *hw,
 {
 	int err, rsel_val;
 
-	if (!pullup && arg == MTK_DISABLE)
-		return 0;
-
 	if (hw->rsel_si_unit) {
 		/* find pin rsel_index from pin_rsel array*/
 		err = mtk_hw_pin_rsel_lookup(hw, desc, pullup, arg, &rsel_val);
 		if (err)
-			goto out;
+			return err;
 	} else {
-		if (arg < MTK_PULL_SET_RSEL_000 ||
-		    arg > MTK_PULL_SET_RSEL_111) {
-			err = -EINVAL;
-			goto out;
-		}
+		if (arg < MTK_PULL_SET_RSEL_000 || arg > MTK_PULL_SET_RSEL_111)
+			return -EINVAL;
 
 		rsel_val = arg - MTK_PULL_SET_RSEL_000;
 	}
 
-	err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_RSEL, rsel_val);
-	if (err)
-		goto out;
+	return mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_RSEL, rsel_val);
+}
 
-	err = mtk_pinconf_bias_set_pu_pd(hw, desc, pullup, MTK_ENABLE);
+static int mtk_pinconf_bias_set_pu_pd_rsel(struct mtk_pinctrl *hw,
+					   const struct mtk_pin_desc *desc,
+					   u32 pullup, u32 arg)
+{
+	u32 enable = arg == MTK_DISABLE ? MTK_DISABLE : MTK_ENABLE;
+	int err;
 
-out:
-	return err;
+	if (arg != MTK_DISABLE) {
+		err = mtk_pinconf_bias_set_rsel(hw, desc, pullup, arg);
+		if (err)
+			return err;
+	}
+
+	return mtk_pinconf_bias_set_pu_pd(hw, desc, pullup, enable);
 }
 
 int mtk_pinconf_bias_set_combo(struct mtk_pinctrl *hw,
@@ -750,22 +753,22 @@ int mtk_pinconf_bias_set_combo(struct mtk_pinctrl *hw,
 		try_all_type = MTK_PULL_TYPE_MASK;
 
 	if (try_all_type & MTK_PULL_RSEL_TYPE) {
-		err = mtk_pinconf_bias_set_rsel(hw, desc, pullup, arg);
+		err = mtk_pinconf_bias_set_pu_pd_rsel(hw, desc, pullup, arg);
 		if (!err)
-			return err;
+			return 0;
 	}
 
 	if (try_all_type & MTK_PULL_PU_PD_TYPE) {
 		err = mtk_pinconf_bias_set_pu_pd(hw, desc, pullup, arg);
 		if (!err)
-			return err;
+			return 0;
 	}
 
 	if (try_all_type & MTK_PULL_PULLSEL_TYPE) {
 		err = mtk_pinconf_bias_set_pullsel_pullen(hw, desc,
 							  pullup, arg);
 		if (!err)
-			return err;
+			return 0;
 	}
 
 	if (try_all_type & MTK_PULL_PUPD_R1R0_TYPE)
@@ -803,9 +806,9 @@ static int mtk_rsel_get_si_unit(struct mtk_pinctrl *hw,
 	return 0;
 }
 
-static int mtk_pinconf_bias_get_rsel(struct mtk_pinctrl *hw,
-				     const struct mtk_pin_desc *desc,
-				     u32 *pullup, u32 *enable)
+static int mtk_pinconf_bias_get_pu_pd_rsel(struct mtk_pinctrl *hw,
+					   const struct mtk_pin_desc *desc,
+					   u32 *pullup, u32 *enable)
 {
 	int pu, pd, rsel, err;
 
@@ -939,22 +942,22 @@ int mtk_pinconf_bias_get_combo(struct mtk_pinctrl *hw,
 		try_all_type = MTK_PULL_TYPE_MASK;
 
 	if (try_all_type & MTK_PULL_RSEL_TYPE) {
-		err = mtk_pinconf_bias_get_rsel(hw, desc, pullup, enable);
+		err = mtk_pinconf_bias_get_pu_pd_rsel(hw, desc, pullup, enable);
 		if (!err)
-			return err;
+			return 0;
 	}
 
 	if (try_all_type & MTK_PULL_PU_PD_TYPE) {
 		err = mtk_pinconf_bias_get_pu_pd(hw, desc, pullup, enable);
 		if (!err)
-			return err;
+			return 0;
 	}
 
 	if (try_all_type & MTK_PULL_PULLSEL_TYPE) {
 		err = mtk_pinconf_bias_get_pullsel_pullen(hw, desc,
 							  pullup, enable);
 		if (!err)
-			return err;
+			return 0;
 	}
 
 	if (try_all_type & MTK_PULL_PUPD_R1R0_TYPE)
-- 
2.43.0



