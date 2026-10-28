Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215270;
	b=pNzyNdp6yyIXk+WLALlJObXJ3wh4BTvGcExRu7Qaa6nV2bOJjKbTzLXwWh1//NAklQKJ
	 5+HCukdc42Q1Bc6Yv0s68vEsUth4G8BzRDC9avCqsOkvXW1XFM/uqsMDpX0c4BbV2/cQB
	 XTVYR+SnXFlioi1Y0E1aFylgZHpCUxJ8eKMNlwxCa1Z2Czz0siI+/Fd0slOWdG5fyPk0K
	 Sp/CmKv5CxBgQC2nERZf2QRwZQgL9Z/oVfyNvnvxJr/ZEpRDzzGKcw6nwR2ct6dFRISVI
	 1VFV+r6pGSn+znKTZ2eu+orZ26IFc5MiZwr6m2uuOmKTYQeiq/aRf1xIdk7N3JmtUcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+JvT7RdxK1R9y0S+os5YxoQJuRQGsOZeoIMV6iUSWS0=;
	b=SOLQM26LhjN5Ks4+++zdI0+lR5Y9WAJmuGtIVvP0MLBjmus8PuZCysWMLZiycJoWsIbK
	 iTEKcMNzqSRpTNviMt4dY8xB0Tg00Zpz8rkntuP4mV/Ce2yDRaioQ/sEDpFH8O2hQVmTL
	 hu7lrwB9++PVVVzcm4QyYwKSEltHevUnYFEDAMoJ4iCnSaf6XkQPlGrmUj0wgjTiV3bmz
	 DnuTyp/Z2zrFbd6bEuN491upDCYo0ajOSDXDA8C1bEcCcTEhhPkPBNusXoeMCNda0adZY
	 tPt0110dzbKQvMiuJ5d7RqLpuxulhbf5zZZt5d1+T4PyYCE6ypLumeC5A78yueuImpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZCC17/F9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030B5606A31A;
	Wed, 28 Oct 2026 19:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZCC17/F9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521E61F01825;
	Wed, 28 Oct 2026 19:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215269;
	bh=+JvT7RdxK1R9y0S+os5YxoQJuRQGsOZeoIMV6iUSWS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZCC17/F9P6TLOQBiA+hhASoBAFUmtd0KouFue7s/FhCBm4AktykSIlMHmCCgi+U/V
	 u1+MF0BEkUm5M3UUxKxe4SHta7VOic6xuBWJVqg1UVLipQ7v++3zMSmUYpemwA3DXN
	 AAMoMWHBc9hBqonkuYzVH+qsKRpWGpTyL4ULHkEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1135/1887] hwmon: (lm90) Stop work before releasing hwmon device
Date: Wed, 28 Oct 2026 17:53:51 +0100
Message-ID: <20261028170525.234326902@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b09a45601094c7f4ec4db8090b825fa61e169d93 ]

Sashiko reports:

In lm90_probe(), the devm action to cancel the alert_work and report_work
(lm90_restore_conf) is registered in lm90_init_client() before
devm_hwmon_device_register_with_info() is called.

Because devm executes cleanup actions in reverse order during module
unbind or probe failure, the hwmon device is unregistered and freed first.

If lm90_alert_work() or lm90_report_alarms() runs in the window between
the hwmon device being freed and the delayed works being cancelled,
lm90_update_alarms() will dereference the freed data->hwmon_dev here.

Fix the problem by canceling the workers separately after registering
the hwmon device and before registering the interrupt handler. This ensures
that the workers are canceled after interrupts are disabled and before
the hwmon device is released. Add "shutdown" flag to indicate that device
shutdown is in progress to prevent workers from being re-armed.

Fixes: f6d0775119fb9 ("hwmon: (lm90) Rework alarm/status handling")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 7ce75e64cc3ca..8970927bef8ab 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -694,6 +694,7 @@ struct lm90_data {
 	struct mutex update_lock;
 	struct delayed_work alert_work;
 	struct work_struct report_work;
+	bool shutdown;		/* true if shutting down */
 	bool valid;		/* true if register values are valid */
 	bool alarms_valid;	/* true if status register values are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -1112,6 +1113,9 @@ static void lm90_report_alarms(struct work_struct *work)
 
 static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
 {
+	if (data->shutdown)
+		return 0;
+
 	if (force || !data->alarms_valid ||
 	    time_after(jiffies, data->alarms_updated + msecs_to_jiffies(data->update_interval))) {
 		struct i2c_client *client = data->client;
@@ -2557,15 +2561,23 @@ static void lm90_restore_conf(void *_data)
 	struct lm90_data *data = _data;
 	struct i2c_client *client = data->client;
 
-	cancel_delayed_work_sync(&data->alert_work);
-	cancel_work_sync(&data->report_work);
-
 	/* Restore initial configuration */
 	if (data->flags & LM90_HAVE_CONVRATE)
 		lm90_write_convrate(data, data->convrate_orig);
 	lm90_write_reg(client, LM90_REG_CONFIG1, data->config_orig);
 }
 
+static void lm90_stop_work(void *_data)
+{
+	struct lm90_data *data = _data;
+
+	mutex_lock(&data->update_lock);
+	data->shutdown = true;
+	mutex_unlock(&data->update_lock);
+	cancel_delayed_work_sync(&data->alert_work);
+	cancel_work_sync(&data->report_work);
+}
+
 static int lm90_init_client(struct i2c_client *client, struct lm90_data *data)
 {
 	struct device_node *np = client->dev.of_node;
@@ -2914,6 +2926,10 @@ static int lm90_probe(struct i2c_client *client)
 
 	data->hwmon_dev = hwmon_dev;
 
+	err = devm_add_action_or_reset(&client->dev, lm90_stop_work, data);
+	if (err)
+		return err;
+
 	if (client->irq) {
 		dev_dbg(dev, "IRQ: %d\n", client->irq);
 		err = devm_request_threaded_irq(dev, client->irq,
@@ -2942,7 +2958,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		 */
 		struct lm90_data *data = i2c_get_clientdata(client);
 
-		if ((data->flags & LM90_HAVE_BROKEN_ALERT) &&
+		if (!data->shutdown && (data->flags & LM90_HAVE_BROKEN_ALERT) &&
 		    (data->current_alarms & data->alert_alarms)) {
 			if (!(data->config & 0x80)) {
 				dev_dbg(&client->dev, "Disabling ALERT#\n");
-- 
2.53.0



