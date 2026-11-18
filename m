Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041123;
	b=MQDhfhwfFmdmogKYX1mYduYbVu+vjXRtWSdqJkB25hco/MQjF1vPA2hsdMtJcdc6TVBL
	 MmM0C1WXjigQMrNycF9S0wl/ii3yWrXW1sIYYgQNqJMv5uDT8wTjSLe3npIpv2tPZLlUh
	 sMyBNb7pbHYLq/4G4mtkoyZ3Q0RmjSQRBMiMw3RfViXbXN27n2on83W2VxKANnfKQVqt4
	 lRJHcVF8+/28gfP6sJ7MUzewzWEH+w74dHiEeOgqwSefhp4u0LCqPO4iKbhBiSc1qgEkR
	 Fh/2+nNSXVQsNFVsxDLXVzly9qcISQ/wQytk4MqRCnb74qhBsaVXaKRiG2GGQ/6ME8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jzcGUmyqVdjp1fjDI2SNKbCuWvcydEkdE/jsaF+l5eA=;
	b=Pr9m28wyOXQtSuSgslLkZ14hz/IUZpU3PBhxtM6P4/VyeLFSlcLE1jZyT+aYGhpvDZnU
	 Xlh+GEGhLcAxNsp+rMjDgOnvOS07keYaoYjB1+tN1mol4sMXj+dyA45BxJgAJZR94/r1b
	 fux30rLz9FmUa9VTYNwTKTSJFr4TA+Il2zeEiEoLaeLuGTS4GzkwJke2ngT8cNr8fMJzy
	 mBYey2yr11V0GiVi4tJpIOWz88D9zZ5JPF6nm3u44aGGRrhyWER5SrQr0J1oNIar7LWUw
	 HUlBQJv5+iBpUeTpKCLCk0tV9gtN2SBRoh4bSInY0gHF3S2HEvegxIwzNFrArzjYT6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYPEh3bW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED80606A325;
	Wed, 18 Nov 2026 22:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYPEh3bW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1191F000C4;
	Wed, 18 Nov 2026 22:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041123;
	bh=jzcGUmyqVdjp1fjDI2SNKbCuWvcydEkdE/jsaF+l5eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYPEh3bW0YcRATQuUj8nq63Tx7rzoWnhK5Cy/giddoEqx8O5r3dvqNjyCFznWUoDJ
	 EhQsaeCCPgO+t5z0FakWRTVLJmgaRA/8KlpvJa2QweGVSpxTBhpZDmaIAcMmUXX7OE
	 Uo/8ZTx26AhCAPB0N1SkEEbifVr+ITxvQaOJcTOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2700/3318] crypto: talitos - init tasklets before requesting IRQs
Date: Wed, 18 Nov 2026 15:55:22 +0100
Message-ID: <20261118150441.918719685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index be758b98135fc..d37e8858a6416 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3358,21 +3358,13 @@ static int talitos_probe_irq(struct platform_device *ofdev)
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
@@ -3384,7 +3376,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	if (err)
 		goto primary_out;
 
-	/* get the secondary irq line */
+	/* secondary irq line */
 	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
 			  dev_driver_string(dev), dev);
 	if (err) {
@@ -3397,7 +3389,9 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 primary_out:
 	if (err) {
 		dev_err(dev, "failed to request primary irq\n");
+		/* neither line is requested, keep remove() from freeing them */
 		priv->irq[0] = 0;
+		priv->irq[1] = 0;
 	}
 
 	return err;
@@ -3409,12 +3403,27 @@ static int talitos_probe(struct platform_device *ofdev)
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
@@ -3429,12 +3438,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
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
@@ -3485,9 +3489,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		stride = TALITOS2_CH_STRIDE;
 	}
 
-	err = talitos_probe_irq(ofdev);
-	if (err)
-		goto err_out;
+	priv->irq[0] = irq0;
 
 	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
@@ -3497,6 +3499,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
 				     (unsigned long)dev);
 	} else {
+		priv->irq[1] = irq1;
 		if (priv->irq[1] > 0) {
 			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
 				     (unsigned long)dev);
@@ -3528,7 +3531,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		if (!priv->chan[i].fifo) {
 			dev_err(dev, "failed to allocate request fifo %d\n", i);
 			err = -ENOMEM;
-			goto err_out;
+			goto err_noirq;
 		}
 
 		atomic_set(&priv->chan[i].submit_count,
@@ -3541,9 +3544,14 @@ static int talitos_probe(struct platform_device *ofdev)
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
@@ -3601,6 +3609,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	return 0;
 
+err_noirq:
+	/* the irq numbers are known, but the lines are not requested yet */
+	priv->irq[0] = 0;
+	priv->irq[1] = 0;
 err_out:
 	talitos_remove(ofdev);
 
-- 
2.53.0



