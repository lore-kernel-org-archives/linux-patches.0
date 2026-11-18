Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049378;
	b=coPCCH6fDBX0AR2L0NheoC1KgdIHS8A+DKHRolOsVobBKgDLJ/m9/U/TEkth/C+CB34Q
	 7D8Vb1WR7ROfFRY3Ew2frCJ0gEoGtJpW36ROAQYfY8TJOIcnTmTsqepFmErwD2/so1Nvn
	 YmUOUHGqL/U1fmxjaWOWy+OAzsG9DbHOxnuPfLA7z7yYvQKSb/uV50Uqh2xSLi+w8dTRc
	 wg2ocj2yw0RZj1M6TGPOc2mo0NYNbMy+OKsMrI593Z1+n08hDgBK6CxywolJwBkxBNQyH
	 /EIbWZTFRCMl6v52nPLqPCIwTBfVvzte8TqxiYpQHaRmwDPMrGFZwYbeu1qR45x0jfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=175M3J6ChPkF/j7jzaWW3PxSf5FZudmLD1fVUITZKbc=;
	b=RBl6cMqxuZqOKlJJ0kocpdeKjZORXbfktWSv4suZL6zJUUWv2w5c1HHsTE07TgDmYuoT
	 uGMoI3vl0tq3rymDu2mNg1ruSFbtp6NKuBFlXl1ZKdys595qaRi2TcaPzUjkBqKTLVgOn
	 XKMqRDvcL+ry/VRxyyWpEjGWYX34EVumdUEIl2nK1ZMwUh2Tog+U4nHtE9Nt57o05rQQx
	 8Qhzt97TQXrPh2xAOP0CrbZQfI+mwgvSmDeiUtA3o9/mrrlznI0ejYF/QD4Bp9tE3+e7n
	 sLkixhbtE04dQ/0R7fgWJ1lQi+dBsRlMhYpIPG9g+SAxCgmiUVu+4tUm4aIh6VkUa9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UVtPTQI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D83606A320;
	Thu, 19 Nov 2026 00:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UVtPTQI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7F91F000C4;
	Thu, 19 Nov 2026 00:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049377;
	bh=175M3J6ChPkF/j7jzaWW3PxSf5FZudmLD1fVUITZKbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVtPTQI/Eeaqm/TqotqmOGOhd5yd6nYm5n32uHJ+GCX3s2fJOu3gYKdfduCV1I9GH
	 VPpg+KEXvyxB8k0RM6mei1SeRs/KLcDqAPQb6AO75jkV+N5yxJ18k2h4WCmpR5YoUj
	 IJxHVG0csfA5EyubBz5rldewQLssekbDelk3XIyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2331/2857] crypto: talitos - init tasklets before requesting IRQs
Date: Wed, 18 Nov 2026 15:56:05 +0100
Message-ID: <20261118150325.467650783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 666d66df25253070cb297cb920b0bcfcfe5eb871 ]

The talitos interrupt handlers schedule priv->done_task[] via
tasklet_schedule(). Since the second IRQ support, probe has requested
the IRQs before calling tasklet_init(), so an interrupt already pending
when a line is requested, e.g. engine state left by the bootloader or
a kexec'd kernel, would schedule a tasklet with a NULL callback.

Look up the IRQ numbers and map the registers up front, so that
-EPROBE_DEFER returns before anything is allocated and the done_task[]
selection and reset_device() can see the secondary IRQ. Only request
the IRQs once the channel fifos are allocated and init_device() has
reset the engine. This matches remove(), which frees the IRQs before
killing the tasklets.

remove() frees every IRQ number that is > 0, so make sure that only
requested lines are set when it runs from the probe error path: clear
both numbers when probe fails before the request, and clear any line
talitos_probe_irq() did not request. Previously a failed primary
request in the two-IRQ case freed the never-requested secondary line.

Fixes: c3e337f88a5b ("crypto: talitos - support for channel remap and 2nd IRQ")
Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 54 ++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 096e5edc0b3b0..ef67c4b5677fd 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3367,21 +3367,13 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	int err;
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	priv->irq[0] = platform_get_irq(ofdev, 0);
-	if (priv->irq[0] < 0)
-		return priv->irq[0];
-
 	if (is_sec1) {
 		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
 		goto primary_out;
 	}
 
-	priv->irq[1] = platform_get_irq_optional(ofdev, 1);
-	if (priv->irq[1] == -EPROBE_DEFER)
-		return priv->irq[1];
-
-	/* get the primary irq line */
+	/* single (or primary) irq line */
 	if (priv->irq[1] < 0) {
 		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
@@ -3393,7 +3385,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	if (err)
 		goto primary_out;
 
-	/* get the secondary irq line */
+	/* secondary irq line */
 	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
 			  dev_driver_string(dev), dev);
 	if (err) {
@@ -3406,7 +3398,9 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 primary_out:
 	if (err) {
 		dev_err(dev, "failed to request primary irq\n");
+		/* neither line is requested, keep remove() from freeing them */
 		priv->irq[0] = 0;
+		priv->irq[1] = 0;
 	}
 
 	return err;
@@ -3418,12 +3412,27 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv;
 	unsigned int num_channels;
+	void __iomem *reg;
 	int i, err;
 	int stride;
+	int irq0;
+	int irq1;
 
 	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
 		return -EINVAL;
 
+	irq0 = platform_get_irq(ofdev, 0);
+	if (irq0 < 0)
+		return irq0;
+
+	irq1 = platform_get_irq_optional(ofdev, 1);
+	if (irq1 == -EPROBE_DEFER)
+		return irq1;
+
+	reg = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
 	priv = devm_kzalloc(dev, struct_size(priv, chan, num_channels), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -3438,12 +3447,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	spin_lock_init(&priv->reg_lock);
 
-	priv->reg = devm_platform_ioremap_resource(ofdev, 0);
-	if (IS_ERR(priv->reg)) {
-		dev_err(dev, "failed to of_iomap\n");
-		err = PTR_ERR(priv->reg);
-		goto err_out;
-	}
+	priv->reg = reg;
 
 	/* get SEC version capabilities from device tree */
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
@@ -3494,9 +3498,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		stride = TALITOS2_CH_STRIDE;
 	}
 
-	err = talitos_probe_irq(ofdev);
-	if (err)
-		goto err_out;
+	priv->irq[0] = irq0;
 
 	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
@@ -3506,6 +3508,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
 				     (unsigned long)dev);
 	} else {
+		priv->irq[1] = irq1;
 		if (priv->irq[1] > 0) {
 			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
 				     (unsigned long)dev);
@@ -3537,7 +3540,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		if (!priv->chan[i].fifo) {
 			dev_err(dev, "failed to allocate request fifo %d\n", i);
 			err = -ENOMEM;
-			goto err_out;
+			goto err_noirq;
 		}
 
 		atomic_set(&priv->chan[i].submit_count,
@@ -3550,9 +3553,14 @@ static int talitos_probe(struct platform_device *ofdev)
 	err = init_device(dev);
 	if (err) {
 		dev_err(dev, "failed to initialize device\n");
-		goto err_out;
+		goto err_noirq;
 	}
 
+	/* enable interrupts once the channel fifos and tasklets are set up */
+	err = talitos_probe_irq(ofdev);
+	if (err)
+		goto err_out;
+
 	/* register the RNG, if available */
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
 		err = talitos_register_rng(dev);
@@ -3610,6 +3618,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	return 0;
 
+err_noirq:
+	/* the irq numbers are known, but the lines are not requested yet */
+	priv->irq[0] = 0;
+	priv->irq[1] = 0;
 err_out:
 	talitos_remove(ofdev);
 
-- 
2.53.0



