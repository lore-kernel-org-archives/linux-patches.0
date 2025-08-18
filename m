Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB59F335BA7;
	Mon, 18 Aug 2025 13:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525048; cv=none; b=VAzXSMHpyzIkf4mmv6jKnBYiQ+WTX4j9eGVQM2B3P51rlZdj6O13CAe3ZhcuuZAP/CI1XQF/DS+yvz3Hu+GRlKKfOxsjPN9JKEIUHGZdmKaG5sM9/FKLus/E2Q5dh2r0wXmKnn9tsZAkrTX0cxmgZniAgvIOJrZ82kQ04rAqeUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525048; c=relaxed/simple;
	bh=5EeRcbDGoeYqCCpK6qcQZgcaHs1KcR7xWiVMfBH89vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YM/c9KruuORUkBYFeR2GCicPZFhb6EVZcZ2pEo5rRsjM+fRM17acUa4yNLJ++quVLc0HGVsNnuWnbt3FQswCune9DnEZ251CZlK6CbCEMEy5REMUr3YxhLV13Eo+iu8oVDT/jagQTMzhI0mfEqSM4cu4pz71SrElKHykjIC7XPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tk5kNfWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tk5kNfWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2964C4CEEB;
	Mon, 18 Aug 2025 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525048;
	bh=5EeRcbDGoeYqCCpK6qcQZgcaHs1KcR7xWiVMfBH89vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tk5kNfWwGCj7V7yfQPKlZ4/kRcmw8Cnp7w3nRXDRXIuKZQqgrdvh+CA24clHn5zau
	 pKleT2VdA6+nbsoAUonxZIwm5uIy9GIpdzNUE+bboIK1pjSgyaibFQ27Ao2Sc4x2Z1
	 m+vWkD/P0fCqOmDK9u24wrByHdIJEmHBm/HGyAtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 143/570] usb: typec: tcpm/tcpci_maxim: fix irq wake usage
Date: Mon, 18 Aug 2025 14:42:10 +0200
Message-ID: <20250818124511.333255665@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit 31611223fb34a3e9320cdfc4f4395072a13ea78e ]

This driver calls enable_irq_wake() during probe() unconditionally, and
never issues the required corresponding disable_irq_wake() to disable
hardware interrupt wakeup signals.

Additionally, whether or not a device should wake-up the system is
meant to be a policy decision based on sysfs (.../power/wakeup) in the
first place.

Update the driver to use the standard approach to enable/disable IRQ
wake during the suspend/resume callbacks. This solves both issues
described above.

Signed-off-by: André Draszik <andre.draszik@linaro.org>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20250707-max77759-irq-wake-v1-1-d367f633e4bc@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci_maxim_core.c | 46 +++++++++++++++--------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci_maxim_core.c b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
index b5a5ed40faea..ff3604be79da 100644
--- a/drivers/usb/typec/tcpm/tcpci_maxim_core.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
@@ -421,21 +421,6 @@ static irqreturn_t max_tcpci_isr(int irq, void *dev_id)
 	return IRQ_WAKE_THREAD;
 }
 
-static int max_tcpci_init_alert(struct max_tcpci_chip *chip, struct i2c_client *client)
-{
-	int ret;
-
-	ret = devm_request_threaded_irq(chip->dev, client->irq, max_tcpci_isr, max_tcpci_irq,
-					(IRQF_TRIGGER_LOW | IRQF_ONESHOT), dev_name(chip->dev),
-					chip);
-
-	if (ret < 0)
-		return ret;
-
-	enable_irq_wake(client->irq);
-	return 0;
-}
-
 static int max_tcpci_start_toggling(struct tcpci *tcpci, struct tcpci_data *tdata,
 				    enum typec_cc_status cc)
 {
@@ -532,7 +517,9 @@ static int max_tcpci_probe(struct i2c_client *client)
 
 	chip->port = tcpci_get_tcpm_port(chip->tcpci);
 
-	ret = max_tcpci_init_alert(chip, client);
+	ret = devm_request_threaded_irq(&client->dev, client->irq, max_tcpci_isr, max_tcpci_irq,
+					(IRQF_TRIGGER_LOW | IRQF_ONESHOT), dev_name(chip->dev),
+					chip);
 	if (ret < 0)
 		return dev_err_probe(&client->dev, ret,
 				     "IRQ initialization failed\n");
@@ -544,6 +531,32 @@ static int max_tcpci_probe(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int max_tcpci_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret = 0;
+
+	if (client->irq && device_may_wakeup(dev))
+		ret = disable_irq_wake(client->irq);
+
+	return ret;
+}
+
+static int max_tcpci_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret = 0;
+
+	if (client->irq && device_may_wakeup(dev))
+		ret = enable_irq_wake(client->irq);
+
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static SIMPLE_DEV_PM_OPS(max_tcpci_pm_ops, max_tcpci_suspend, max_tcpci_resume);
+
 static const struct i2c_device_id max_tcpci_id[] = {
 	{ "maxtcpc" },
 	{ }
@@ -562,6 +575,7 @@ static struct i2c_driver max_tcpci_i2c_driver = {
 	.driver = {
 		.name = "maxtcpc",
 		.of_match_table = of_match_ptr(max_tcpci_of_match),
+		.pm = &max_tcpci_pm_ops,
 	},
 	.probe = max_tcpci_probe,
 	.id_table = max_tcpci_id,
-- 
2.39.5



