Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E71333121F;
	Wed,  8 Apr 2026 18:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674033; cv=none; b=kc9pi/+0q/BFbSLJjB4PlnSRFgYdZjjzmK7yDDeWlAXiwhL8NeASYE+YmFfmTfGmXaY3avpE/8Mkl6EZRUBYKxdfpNGoJfZ9lq0UnaHugdgbn2TI2nJugksguayITonQBQ0R9ym9/hQbtsHpsqVJR/ZSdW6ymMFOZxE/SyNoAI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674033; c=relaxed/simple;
	bh=DpwIjvT6UQUZQftdL2Fm+dYwZuxeiRfiKixifQA5e54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BT+YHlwxcmOutc6bMevAvDYDzyWxeVnZtke+F3kduRLA0ZoxlMeGeYmicvFukZZbYQUc4rWPJEzrxMtT0G0sUJLwq3rQlyaRI3YKBmFoXnjYwvvGsoMdlfFi+4y2tRgF8om880rQi3WtUfEI3VeuczCsWfktUva7K2SKHS4EwXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9qIrqeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9qIrqeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A92EC19421;
	Wed,  8 Apr 2026 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674032;
	bh=DpwIjvT6UQUZQftdL2Fm+dYwZuxeiRfiKixifQA5e54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9qIrqeB37qovJhnK4LahX6TSflaQHv/qEiS1/7s9I7HOknjaJLaRkbiHjcgGY1kE
	 /19CTp8Gn0M8nQdSbDMuowuQm3w1At1IbEN8tYnBy/3wuMFR0tVAWw0xPkch+a5TwV
	 Z42sWXNPajJVFdmXl0C9rBcXQsvbiQz/mM1MWMIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.12 184/242] counter: rz-mtu3-cnt: do not use struct rz_mtu3_channels dev member
Date: Wed,  8 Apr 2026 20:03:44 +0200
Message-ID: <20260408175933.969421460@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

commit 2932095c114b98cbb40ccf34fc00d613cb17cead upstream.

The counter driver can use HW channels 1 and 2, while the PWM driver can
use HW channels 0, 1, 2, 3, 4, 6, 7.

The dev member is assigned both by the counter driver and the PWM driver
for channels 1 and 2, to their own struct device instance, overwriting
the previous value.

The sub-drivers race to assign their own struct device pointer to the
same struct rz_mtu3_channel's dev member.

The dev member of struct rz_mtu3_channel is used by the counter
sub-driver for runtime PM.

Depending on the probe order of the counter and PWM sub-drivers, the
dev member may point to the wrong struct device instance, causing the
counter sub-driver to do runtime PM actions on the wrong device.

To fix this, use the parent pointer of the counter, which is assigned
during probe to the correct struct device, not the struct device pointer
inside the shared struct rz_mtu3_channel.

Cc: stable@vger.kernel.org
Fixes: 0be8907359df ("counter: Add Renesas RZ/G2L MTU3a counter driver")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Link: https://lore.kernel.org/r/20260130122353.2263273-6-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/rz-mtu3-cnt.c |   55 ++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

--- a/drivers/counter/rz-mtu3-cnt.c
+++ b/drivers/counter/rz-mtu3-cnt.c
@@ -107,9 +107,9 @@ static bool rz_mtu3_is_counter_invalid(s
 	struct rz_mtu3_cnt *const priv = counter_priv(counter);
 	unsigned long tmdr;
 
-	pm_runtime_get_sync(priv->ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	tmdr = rz_mtu3_shared_reg_read(priv->ch, RZ_MTU3_TMDR3);
-	pm_runtime_put(priv->ch->dev);
+	pm_runtime_put(counter->parent);
 
 	if (id == RZ_MTU3_32_BIT_CH && test_bit(RZ_MTU3_TMDR3_LWA, &tmdr))
 		return false;
@@ -165,12 +165,12 @@ static int rz_mtu3_count_read(struct cou
 	if (ret)
 		return ret;
 
-	pm_runtime_get_sync(ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	if (count->id == RZ_MTU3_32_BIT_CH)
 		*val = rz_mtu3_32bit_ch_read(ch, RZ_MTU3_TCNTLW);
 	else
 		*val = rz_mtu3_16bit_ch_read(ch, RZ_MTU3_TCNT);
-	pm_runtime_put(ch->dev);
+	pm_runtime_put(counter->parent);
 	mutex_unlock(&priv->lock);
 
 	return 0;
@@ -187,26 +187,26 @@ static int rz_mtu3_count_write(struct co
 	if (ret)
 		return ret;
 
-	pm_runtime_get_sync(ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	if (count->id == RZ_MTU3_32_BIT_CH)
 		rz_mtu3_32bit_ch_write(ch, RZ_MTU3_TCNTLW, val);
 	else
 		rz_mtu3_16bit_ch_write(ch, RZ_MTU3_TCNT, val);
-	pm_runtime_put(ch->dev);
+	pm_runtime_put(counter->parent);
 	mutex_unlock(&priv->lock);
 
 	return 0;
 }
 
 static int rz_mtu3_count_function_read_helper(struct rz_mtu3_channel *const ch,
-					      struct rz_mtu3_cnt *const priv,
+					      struct counter_device *const counter,
 					      enum counter_function *function)
 {
 	u8 timer_mode;
 
-	pm_runtime_get_sync(ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	timer_mode = rz_mtu3_8bit_ch_read(ch, RZ_MTU3_TMDR1);
-	pm_runtime_put(ch->dev);
+	pm_runtime_put(counter->parent);
 
 	switch (timer_mode & RZ_MTU3_TMDR1_PH_CNT_MODE_MASK) {
 	case RZ_MTU3_TMDR1_PH_CNT_MODE_1:
@@ -240,7 +240,7 @@ static int rz_mtu3_count_function_read(s
 	if (ret)
 		return ret;
 
-	ret = rz_mtu3_count_function_read_helper(ch, priv, function);
+	ret = rz_mtu3_count_function_read_helper(ch, counter, function);
 	mutex_unlock(&priv->lock);
 
 	return ret;
@@ -279,9 +279,9 @@ static int rz_mtu3_count_function_write(
 		return -EINVAL;
 	}
 
-	pm_runtime_get_sync(ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	rz_mtu3_8bit_ch_write(ch, RZ_MTU3_TMDR1, timer_mode);
-	pm_runtime_put(ch->dev);
+	pm_runtime_put(counter->parent);
 	mutex_unlock(&priv->lock);
 
 	return 0;
@@ -300,9 +300,9 @@ static int rz_mtu3_count_direction_read(
 	if (ret)
 		return ret;
 
-	pm_runtime_get_sync(ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	tsr = rz_mtu3_8bit_ch_read(ch, RZ_MTU3_TSR);
-	pm_runtime_put(ch->dev);
+	pm_runtime_put(counter->parent);
 
 	*direction = (tsr & RZ_MTU3_TSR_TCFD) ?
 		COUNTER_COUNT_DIRECTION_FORWARD : COUNTER_COUNT_DIRECTION_BACKWARD;
@@ -377,14 +377,14 @@ static int rz_mtu3_count_ceiling_write(s
 		return -EINVAL;
 	}
 
-	pm_runtime_get_sync(ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	if (count->id == RZ_MTU3_32_BIT_CH)
 		rz_mtu3_32bit_ch_write(ch, RZ_MTU3_TGRALW, ceiling);
 	else
 		rz_mtu3_16bit_ch_write(ch, RZ_MTU3_TGRA, ceiling);
 
 	rz_mtu3_8bit_ch_write(ch, RZ_MTU3_TCR, RZ_MTU3_TCR_CCLR_TGRA);
-	pm_runtime_put(ch->dev);
+	pm_runtime_put(counter->parent);
 	mutex_unlock(&priv->lock);
 
 	return 0;
@@ -495,7 +495,6 @@ static int rz_mtu3_count_enable_read(str
 static int rz_mtu3_count_enable_write(struct counter_device *counter,
 				      struct counter_count *count, u8 enable)
 {
-	struct rz_mtu3_channel *const ch = rz_mtu3_get_ch(counter, count->id);
 	struct rz_mtu3_cnt *const priv = counter_priv(counter);
 	int ret = 0;
 
@@ -505,14 +504,14 @@ static int rz_mtu3_count_enable_write(st
 		goto exit;
 
 	if (enable) {
-		pm_runtime_get_sync(ch->dev);
+		pm_runtime_get_sync(counter->parent);
 		ret = rz_mtu3_initialize_counter(counter, count->id);
 		if (ret == 0)
 			priv->count_is_enabled[count->id] = true;
 	} else {
 		rz_mtu3_terminate_counter(counter, count->id);
 		priv->count_is_enabled[count->id] = false;
-		pm_runtime_put(ch->dev);
+		pm_runtime_put(counter->parent);
 	}
 
 exit:
@@ -544,9 +543,9 @@ static int rz_mtu3_cascade_counts_enable
 	if (ret)
 		return ret;
 
-	pm_runtime_get_sync(priv->ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	tmdr = rz_mtu3_shared_reg_read(priv->ch, RZ_MTU3_TMDR3);
-	pm_runtime_put(priv->ch->dev);
+	pm_runtime_put(counter->parent);
 	*cascade_enable = test_bit(RZ_MTU3_TMDR3_LWA, &tmdr);
 	mutex_unlock(&priv->lock);
 
@@ -563,10 +562,10 @@ static int rz_mtu3_cascade_counts_enable
 	if (ret)
 		return ret;
 
-	pm_runtime_get_sync(priv->ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	rz_mtu3_shared_reg_update_bit(priv->ch, RZ_MTU3_TMDR3,
 				      RZ_MTU3_TMDR3_LWA, cascade_enable);
-	pm_runtime_put(priv->ch->dev);
+	pm_runtime_put(counter->parent);
 	mutex_unlock(&priv->lock);
 
 	return 0;
@@ -583,9 +582,9 @@ static int rz_mtu3_ext_input_phase_clock
 	if (ret)
 		return ret;
 
-	pm_runtime_get_sync(priv->ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	tmdr = rz_mtu3_shared_reg_read(priv->ch, RZ_MTU3_TMDR3);
-	pm_runtime_put(priv->ch->dev);
+	pm_runtime_put(counter->parent);
 	*ext_input_phase_clock_select = test_bit(RZ_MTU3_TMDR3_PHCKSEL, &tmdr);
 	mutex_unlock(&priv->lock);
 
@@ -602,11 +601,11 @@ static int rz_mtu3_ext_input_phase_clock
 	if (ret)
 		return ret;
 
-	pm_runtime_get_sync(priv->ch->dev);
+	pm_runtime_get_sync(counter->parent);
 	rz_mtu3_shared_reg_update_bit(priv->ch, RZ_MTU3_TMDR3,
 				      RZ_MTU3_TMDR3_PHCKSEL,
 				      ext_input_phase_clock_select);
-	pm_runtime_put(priv->ch->dev);
+	pm_runtime_put(counter->parent);
 	mutex_unlock(&priv->lock);
 
 	return 0;
@@ -644,7 +643,7 @@ static int rz_mtu3_action_read(struct co
 	if (ret)
 		return ret;
 
-	ret = rz_mtu3_count_function_read_helper(ch, priv, &function);
+	ret = rz_mtu3_count_function_read_helper(ch, counter, &function);
 	if (ret) {
 		mutex_unlock(&priv->lock);
 		return ret;


