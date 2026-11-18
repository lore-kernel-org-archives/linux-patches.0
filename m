Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054155;
	b=modTnF3OSSIE3ze0KRVvQZVox7mwbNsrPL9Z6ECfdrIQSOPqfcfOri/UkVzCidsIqJlH
	 qODkXDkmTjvCKQdR8y0bhrDPN24e4V8wohIFKBUDTck+ekzrNVCUPnoQ4vLXM9uf79e7b
	 4iP6U78+/2N08AE2Qzs1tHTAayTUHcFdgrTFdgS7dfTHvXdb6Vp+k8lg6yK9YeCkekxQ8
	 IBvQfqShkxaKZkMDgSzxzx2fHpZ3LSWNuAmB1Xtf0DxltkVV8PRqZtmBWDCeFtHQ7LNvW
	 zMz1rHB9PWz37i/K+RDrE+Es1CRmLUPma5PbCMSUYWsJ8wHaqJM2FX1oZrNwkwx5mWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eXOdKLBczQL3jDy8RI3S0ikkSkFpBLLVmrDWtprfweo=;
	b=yyt1XP5K1GsNUT2QXc11TdMiXyq5EjTf8Q0IOSecTaoq/4F0vYIlcxo/tvFBDrRr4szW
	 LyY1J3TFMoq5RwlkGnRdfeAgrw6M2JybVpjjprwxORfaYxzi2Fug92zkkrfPO3MiMaqkn
	 KTAddz0tJLr3pv2dCIq0uiiLa0VcqVrH5pAlv4a3HTmgniUZqPKW5uJJlrPtzgJuSLIIH
	 WuNpMlwPWWnjXTRk2JZfLRBYPpNhQINbjxDROMunRGKObHPc1iNn7IKRkbqHn/R/6Bh8P
	 Rad0Mt0dr9/lHIM37efTmMSIYFeFuR7ECMQn24phY9geznr3oHb8Wr4+RuLxHXHFAbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e/sc+h7j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99EE606A330;
	Thu, 19 Nov 2026 02:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e/sc+h7j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FCE1F000C4;
	Thu, 19 Nov 2026 02:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054155;
	bh=eXOdKLBczQL3jDy8RI3S0ikkSkFpBLLVmrDWtprfweo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/sc+h7j5CUy93mRw7VsLdMa36qsuiFcwMOwxMD99c/LYKc3EtCwDu2fQhqkUP/8+
	 ECt1yVKHn/4G/pA79wgeMDkyDCNUYqaAPQtq9309xM1o55diXfsMpmSwI1kbg7vDU0
	 54JpgFkMKhDGJRCD7NMT4X/6JNz37eQZZEsG4cC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1157/2214] mfd: tps65217: Use devres for IRQ domain and wake teardown
Date: Wed, 18 Nov 2026 15:47:13 +0100
Message-ID: <20261118150058.253824475@linuxfoundation.org>
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

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit cffd44d2d89524e2dda6adc7b0dd59363be1c8e6 ]

Removing the parent device used to tear the IRQ domain down in
tps65217_remove() before the MFD children are unbound: the i2c core
only releases the parent's devres after the remove callback returns,
whereas devm_mfd_add_devices() registered its own devres action which
unbinds the children. Children that requested interrupts from the
domain (e.g. tps65217-charger) therefore call free_irq() on virtual
IRQs whose descriptors have already been disposed. With
CONFIG_SPARSE_IRQ free_irq() then returns early without stopping the
threaded handler, leaking the irqaction, the IRQ kthread and a module
reference.

Register the domain teardown as a devres action right after the domain
is created instead. Devres actions are released in reverse order of
registration, so the MFD children release their IRQs first, then the
parent interrupt is freed and its thread stopped, and only then is the
domain torn down. The same ordering covers probe failure, which no
longer needs manual cleanup, and the remove callback can be dropped
entirely.

Balance the enable_irq_wake() in tps65217_irq_init() by registering
disable_irq_wake() as a devres action as well. Only do so when
enabling actually succeeded, since the parent chip may not support
setting wake-up.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Link: https://patch.msgid.link/20261002113624.178588-4-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
[ sashal: adapted cleanup changes to the older I2C callback API and GNU89 variable declaration rules. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 60 ++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index e11d325967c3d..2f5d9177d6718 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -155,6 +155,32 @@ static const struct irq_domain_ops tps65217_irq_domain_ops = {
 	.map = tps65217_irq_map,
 };
 
+static void tps65217_irq_cleanup(void *data)
+{
+	struct tps65217 *tps = data;
+	unsigned int virq;
+	int i;
+
+	if (!tps->irq_domain)
+		return;
+
+	for (i = 0; i < TPS65217_NUM_IRQ; i++) {
+		virq = irq_find_mapping(tps->irq_domain, i);
+		if (virq)
+			irq_dispose_mapping(virq);
+	}
+
+	irq_domain_remove(tps->irq_domain);
+	tps->irq_domain = NULL;
+}
+
+static void tps65217_irq_wake_disable(void *data)
+{
+	unsigned long irq = (unsigned long)data;
+
+	disable_irq_wake(irq);
+}
+
 static int tps65217_irq_init(struct tps65217 *tps, int irq)
 {
 	int ret;
@@ -178,6 +204,10 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
 		return -ENOMEM;
 	}
 
+	ret = devm_add_action_or_reset(tps->dev, tps65217_irq_cleanup, tps);
+	if (ret)
+		return ret;
+
 	ret = devm_request_threaded_irq(tps->dev, irq, NULL,
 					tps65217_irq_thread, IRQF_ONESHOT,
 					"tps65217-irq", tps);
@@ -187,7 +217,16 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
 		return ret;
 	}
 
-	enable_irq_wake(irq);
+	ret = enable_irq_wake(irq);
+	if (ret) {
+		dev_warn(tps->dev, "failed to enable IRQ wake: %d\n", ret);
+		return 0;
+	}
+
+	ret = devm_add_action_or_reset(tps->dev, tps65217_irq_wake_disable,
+				       (void *)(unsigned long)irq);
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -388,24 +427,6 @@ static int tps65217_probe(struct i2c_client *client)
 	return 0;
 }
 
-static int tps65217_remove(struct i2c_client *client)
-{
-	struct tps65217 *tps = i2c_get_clientdata(client);
-	unsigned int virq;
-	int i;
-
-	for (i = 0; i < TPS65217_NUM_IRQ; i++) {
-		virq = irq_find_mapping(tps->irq_domain, i);
-		if (virq)
-			irq_dispose_mapping(virq);
-	}
-
-	irq_domain_remove(tps->irq_domain);
-	tps->irq_domain = NULL;
-
-	return 0;
-}
-
 static const struct i2c_device_id tps65217_id_table[] = {
 	{"tps65217", TPS65217},
 	{ /* sentinel */ }
@@ -419,7 +440,6 @@ static struct i2c_driver tps65217_driver = {
 	},
 	.id_table	= tps65217_id_table,
 	.probe_new	= tps65217_probe,
-	.remove		= tps65217_remove,
 };
 
 static int __init tps65217_init(void)
-- 
2.53.0



