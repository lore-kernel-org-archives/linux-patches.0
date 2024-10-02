Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BF71D0493;
	Wed,  2 Oct 2024 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878182; cv=none; b=i2WetYwjwPX3aTb0ZS1oWu0l5Wa/SZz8+0zb4TnJ34Xma5ANxFkf8swrOP91R5DCR/c5BhExR0yWzTu6aG8NU4enqWrxZAFdSf1lgQLvkhNgeSeSucqIwGGxvERisyFLnOR+EB1q6lvh/l8xueZPfX1lXvV+ThwL2zI0odCFKP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878182; c=relaxed/simple;
	bh=0ul/1+KjG7CBnuVBtq0vH13P7b4P2BYKeyYpgyynbd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiQzaC3d7yk7gLjRkdIOj5r9GlQjDCFAMDrVAy8tMgLnGR+jV5DLA0AfD+PWRxb1kkw75oMNaoRJRF0je+/Whr1wj6nc0TZUUpSdtbJs+pwp132//NrdHDFSDzzG94AiUJzx24e0myezO/+zulXibRl4AAYiv5O1RQ+1XmxfX3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8GF99LQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8GF99LQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C793C4CEC2;
	Wed,  2 Oct 2024 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878181;
	bh=0ul/1+KjG7CBnuVBtq0vH13P7b4P2BYKeyYpgyynbd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8GF99LQKFVnBYhgJeBqRqtyj5VopMTvG09Dex1j1SGl5OA9Q4wfrm5Bly5LHB1yv
	 BU9kOuL/Peykovw/0+Z9lOtFytsYCibg4lgBifzvRKFh0xTQL7H9pLwJd17brzWckr
	 0mMlCO1/OlJfAwETdwfwj3E+yVpE9np1sfMacoaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 327/634] pinctrl: ti: ti-iodelay: Fix some error handling paths
Date: Wed,  2 Oct 2024 14:57:07 +0200
Message-ID: <20241002125824.006673659@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a9f2b249adeef2b9744a884355fa8f5e581d507f ]

In the probe, if an error occurs after the ti_iodelay_pinconf_init_dev()
call, it is likely that ti_iodelay_pinconf_deinit_dev() should be called,
as already done in the remove function.

Also in ti_iodelay_pinconf_init_dev(), if an error occurs after the first
regmap_update_bits() call, it is also likely that the deinit() function
should be called.

The easier way to fix it is to add a devm_add_action_or_reset() at the
rigtht place to have ti_iodelay_pinconf_deinit_dev() called when needed.

Doing so, the .remove() function can be removed, and the associated
platform_set_drvdata() call in the probe as well.

Fixes: 003910ebc83b ("pinctrl: Introduce TI IOdelay configuration driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/0220fa5b925bd08e361be8206a5438f6229deaac.1720556038.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c | 52 ++++++++++---------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
index f5e5a23d22260..451801acdc403 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -273,6 +273,22 @@ static int ti_iodelay_pinconf_set(struct ti_iodelay_device *iod,
 	return r;
 }
 
+/**
+ * ti_iodelay_pinconf_deinit_dev() - deinit the iodelay device
+ * @data:	IODelay device
+ *
+ * Deinitialize the IODelay device (basically just lock the region back up.
+ */
+static void ti_iodelay_pinconf_deinit_dev(void *data)
+{
+	struct ti_iodelay_device *iod = data;
+	const struct ti_iodelay_reg_data *reg = iod->reg_data;
+
+	/* lock the iodelay region back again */
+	regmap_update_bits(iod->regmap, reg->reg_global_lock_offset,
+			   reg->global_lock_mask, reg->global_lock_val);
+}
+
 /**
  * ti_iodelay_pinconf_init_dev() - Initialize IODelay device
  * @iod: iodelay device
@@ -295,6 +311,11 @@ static int ti_iodelay_pinconf_init_dev(struct ti_iodelay_device *iod)
 	if (r)
 		return r;
 
+	r = devm_add_action_or_reset(iod->dev, ti_iodelay_pinconf_deinit_dev,
+				     iod);
+	if (r)
+		return r;
+
 	/* Read up Recalibration sequence done by bootloader */
 	r = regmap_read(iod->regmap, reg->reg_refclk_offset, &val);
 	if (r)
@@ -353,21 +374,6 @@ static int ti_iodelay_pinconf_init_dev(struct ti_iodelay_device *iod)
 	return 0;
 }
 
-/**
- * ti_iodelay_pinconf_deinit_dev() - deinit the iodelay device
- * @iod:	IODelay device
- *
- * Deinitialize the IODelay device (basically just lock the region back up.
- */
-static void ti_iodelay_pinconf_deinit_dev(struct ti_iodelay_device *iod)
-{
-	const struct ti_iodelay_reg_data *reg = iod->reg_data;
-
-	/* lock the iodelay region back again */
-	regmap_update_bits(iod->regmap, reg->reg_global_lock_offset,
-			   reg->global_lock_mask, reg->global_lock_val);
-}
-
 /**
  * ti_iodelay_get_pingroup() - Find the group mapped by a group selector
  * @iod: iodelay device
@@ -877,27 +883,11 @@ static int ti_iodelay_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, iod);
-
 	return pinctrl_enable(iod->pctl);
 }
 
-/**
- * ti_iodelay_remove() - standard remove
- * @pdev: platform device
- */
-static void ti_iodelay_remove(struct platform_device *pdev)
-{
-	struct ti_iodelay_device *iod = platform_get_drvdata(pdev);
-
-	ti_iodelay_pinconf_deinit_dev(iod);
-
-	/* Expect other allocations to be freed by devm */
-}
-
 static struct platform_driver ti_iodelay_driver = {
 	.probe = ti_iodelay_probe,
-	.remove_new = ti_iodelay_remove,
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .of_match_table = ti_iodelay_of_match,
-- 
2.43.0



