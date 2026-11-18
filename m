Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056076;
	b=ANzdkIyJhyOXyXoKCx/HQ83TRsONaJFzfSx9H7DSF5hu4jeInbLhlm9q1MtPWyMjaxpG
	 Fs+Rji/PWJDKsZabjYtou8IHtXJgsxt5XAO8ru9Hb6PE1SIX0mq01ZUpmQuUiiQEeotTr
	 gmz1O2r620IuFHkRNP65ybSTPzROHOsbmXiQRXoUE2x9ezOKRyPh2h13hjmP1kfe4p5as
	 6D8YtNMTKz3kmzPQwS22vJ7M9PSdyQZWvSg5qlJTHOiDkMT/KMls78X2U9Xh84Wuz9HTp
	 8lMYQ/m1A1fNLbI0gVPhFr5TyMWDGLABGQ3HPIDx+rpjn/zlM+txbNCGtlu6fu8Q4/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pegr/umGpNVsDVzLfXDlz6fV592gN2LDdQlhXZeOutk=;
	b=lUqVR0VXAZIZV2LKOeU5uBP2iy8UiXDNHD4ETfm+1Pgxob6FoHZI0BdQwVXqnkRbtJC2
	 2euhaTmk+WyFjBfdXHWp6KDyi+wwG8YicD3EGkhBz0C3pOUraNYsMVNX1BcpsWdjbORJ2
	 7MITGtjONIkw9JAslK2E33jyNIhAY4NMIfq01xtXuLHt8ISjvwrn8jaV3ZQnnINolN9As
	 xVnMIgftdcOUVdIUdqY/F8srmUwRLcCm48f1Y//GEu1zUP06+NYIyaE1T4bCNywQ2Ih05
	 ZjRrO/TtGn8tm3a2snrU08whkiLuxY50ENeurw9SJ6PYFP7D33i03wJuY5fkN9gM/2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgYqqkvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2C5606A325;
	Thu, 19 Nov 2026 02:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgYqqkvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1111F000C4;
	Thu, 19 Nov 2026 02:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056076;
	bh=Pegr/umGpNVsDVzLfXDlz6fV592gN2LDdQlhXZeOutk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgYqqkvqWSZzMh5TTq0kX11E87urg6js6Allx9VUwGJ8Vyxzv89VfHHE0xBT5aLxR
	 iUkQrNeORHavCz0uANGyTuMpNrxwReCepMVgpyWi8gVSrydEimpqzqsDNCNOokLDxA
	 1Wz2JQXQ0JaXk4qN1ibGuFSRRi8RURIRbOpteOZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1818/2214] crypto: talitos - init tasklets before requesting IRQs
Date: Wed, 18 Nov 2026 15:58:14 +0100
Message-ID: <20261118150124.193901058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0cd39784a2ef..6429a43e4e604 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3288,21 +3288,13 @@ static int talitos_probe_irq(struct platform_device *ofdev)
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
@@ -3314,7 +3306,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	if (err)
 		goto primary_out;
 
-	/* get the secondary irq line */
+	/* secondary irq line */
 	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
 			  dev_driver_string(dev), dev);
 	if (err) {
@@ -3327,7 +3319,9 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 primary_out:
 	if (err) {
 		dev_err(dev, "failed to request primary irq\n");
+		/* neither line is requested, keep remove() from freeing them */
 		priv->irq[0] = 0;
+		priv->irq[1] = 0;
 	}
 
 	return err;
@@ -3339,12 +3333,27 @@ static int talitos_probe(struct platform_device *ofdev)
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
@@ -3359,12 +3368,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
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
@@ -3415,9 +3419,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		stride = TALITOS2_CH_STRIDE;
 	}
 
-	err = talitos_probe_irq(ofdev);
-	if (err)
-		goto err_out;
+	priv->irq[0] = irq0;
 
 	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
@@ -3427,6 +3429,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
 				     (unsigned long)dev);
 	} else {
+		priv->irq[1] = irq1;
 		if (priv->irq[1] > 0) {
 			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
 				     (unsigned long)dev);
@@ -3458,7 +3461,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		if (!priv->chan[i].fifo) {
 			dev_err(dev, "failed to allocate request fifo %d\n", i);
 			err = -ENOMEM;
-			goto err_out;
+			goto err_noirq;
 		}
 
 		atomic_set(&priv->chan[i].submit_count,
@@ -3471,9 +3474,14 @@ static int talitos_probe(struct platform_device *ofdev)
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
@@ -3531,6 +3539,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	return 0;
 
+err_noirq:
+	/* the irq numbers are known, but the lines are not requested yet */
+	priv->irq[0] = 0;
+	priv->irq[1] = 0;
 err_out:
 	talitos_remove(ofdev);
 
-- 
2.53.0



