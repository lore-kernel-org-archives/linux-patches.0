Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047328;
	b=qKjIMOyvVpNIBcWF4cxfZIL9F5oyTCtCTwyD01JCDcyn1McZbQmIVP0m+OPIpDeAbyzP
	 wHRTJmUIybokY0ffhsBynzenbD2BmDdmdsv9419oBP5MO1FHW8VKcqQK81b6q7lFrhF/A
	 r4P+eYbaunXx3ujF0wYinVo4/E7Im9DNEOwG5EPM5g5uoCvQ1tIYkhw0Iz2WvYVM7w8mP
	 wa9+0hAXy54Jqz4TNj1D86pJgf+9t8obF2H+LEoIRcs77exmygdv6xaclPEC9vVpOO1iO
	 0ZiqYJeWycQgF7844CP69Q9XVAoZXLksncbIyPe682ZCcdbW3bP9Nv3USVoTYH3nUpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kwbdqDvUeacKk7E132oh2E7M/SwbC0n4gpIi5bpcFc4=;
	b=2vYNxStFTeMXWFcnY4I+j6rjzVnYeHy9o8ZE8X7uUaMI4rokc7DmI8Ynu7c9BUcbpiLc
	 isBMUzb1bkQ83ELKff8a+qSG52wF7DBTCLI6PYvhypKmrSXhL/rIEAhylGE9lu1Hq6KJB
	 dBeCIl8ncyBYXGOFZG5eMX2YqOsb2paaI9gAbsYeCwqo7rUs/Qi2ASs5ZPRG4J14Fe3D7
	 ueBYlE44iSO5nj+P69ATALPD9P5VGMJHdu0L4WSIlZsjgBFn9jrgauMi1jGZFJq26o6Dz
	 g4MA+ATm2bFzH+dEUwtJeuZNgRCfBKDqyBiHsDbB4DjzigViZWlSUm0FW6NI1SJb9Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruiN6WqV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B707606A325;
	Thu, 19 Nov 2026 00:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruiN6WqV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5181F000C4;
	Thu, 19 Nov 2026 00:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047328;
	bh=kwbdqDvUeacKk7E132oh2E7M/SwbC0n4gpIi5bpcFc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruiN6WqVU6Bvm7j4h2bLUiZXErrOEU+Xo+PXJBhVaMVSEpzL3MOTDKtB4D60pJcP2
	 huVacJBnHBMk4g5IvJxlUFoG/wweiMZXrOOw5HbsM+p0kncpajtwN3Ei/vP/+2bi/R
	 K9O30a/SlpFgzxMW1rjYGzze6kolsitleuGiXHSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1558/2857] mfd: tps65217: Use devres for IRQ domain and wake teardown
Date: Wed, 18 Nov 2026 15:43:12 +0100
Message-ID: <20261118150257.480551044@linuxfoundation.org>
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
[ sashal: Adjusted driver registration context to retain .probe_new instead of .probe. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 57 +++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 0d050693d296e..df645d3f4673e 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -147,6 +147,31 @@ static const struct irq_domain_ops tps65217_irq_domain_ops = {
 	.map = tps65217_irq_map,
 };
 
+static void tps65217_irq_cleanup(void *data)
+{
+	struct tps65217 *tps = data;
+	unsigned int virq;
+
+	if (!tps->irq_domain)
+		return;
+
+	for (int i = 0; i < TPS65217_NUM_IRQ; i++) {
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
@@ -170,6 +195,10 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
 		return -ENOMEM;
 	}
 
+	ret = devm_add_action_or_reset(tps->dev, tps65217_irq_cleanup, tps);
+	if (ret)
+		return ret;
+
 	ret = devm_request_threaded_irq(tps->dev, irq, NULL,
 					tps65217_irq_thread, IRQF_ONESHOT,
 					"tps65217-irq", tps);
@@ -179,7 +208,16 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
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
@@ -380,22 +418,6 @@ static int tps65217_probe(struct i2c_client *client)
 	return 0;
 }
 
-static void tps65217_remove(struct i2c_client *client)
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
-}
-
 static const struct i2c_device_id tps65217_id_table[] = {
 	{"tps65217", TPS65217},
 	{ /* sentinel */ }
@@ -409,7 +431,6 @@ static struct i2c_driver tps65217_driver = {
 	},
 	.id_table	= tps65217_id_table,
 	.probe_new	= tps65217_probe,
-	.remove		= tps65217_remove,
 };
 
 static int __init tps65217_init(void)
-- 
2.53.0



