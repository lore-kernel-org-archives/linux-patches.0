Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8CB2248B3;
	Sat, 17 Oct 2026 16:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254158; cv=none; b=g0j9Ef/WZXMOamh+qIJK9ycdn0k2y9vxdhKfHZAffVsGCMt7y9t2MPD1aXJvN9t4NLNz0pun8Zlax8rI2g39eb0XrWDxTmpQz+rxrhqqDFOx5yNJDpjvOWw6DPQ2oAf+uTmf4sRlDMF7xsn89lglmzokSCZJRu9qA06wrVFriAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254158; c=relaxed/simple;
	bh=/At0vJrax9AjEOYPSgEuEJAbaIhQ+Mv8INMM1O7HwdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtKeM4nBoij7a5Cq5ERPVhS/lGaG7hDGru6mhLWdMJ3OUMgnGd+mM+5/6EC2tyniqCFFBCKAaggHTJglqejQoeCyukbPDW7Iu8EDokyMlOB+0jzkbN5nBOvaNVsgX61mJx9Ji/naJfErPsv292e7ucf5HP9h5WfPI4Q6s9YA1/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmowQx6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmowQx6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A451F000C4;
	Sat, 17 Oct 2026 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254156;
	bh=U9xxy/SisQVlRE1Y0cvSQ/lFXDroHgLtka6x3pibQs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmowQx6TV77+oOfE+yrXpYjFmlRIGLvUrGffCQI5QXw/z0Kb5+9HlRb1k9ZUgpHbD
	 6fRCPGL5wpa57fvVELaPiisJl/0vdwdV66qPPtxSlE07B7VRWx1Vo/UYL2MwbR63Fk
	 5DfOVoOUr9iX0T4w2ehzYT0H4H88Ee30nEzUh4vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 354/869] hwmon: (lm90) Stop work before releasing hwmon device
Date: Sat, 17 Oct 2026 17:53:15 +0200
Message-ID: <20261017160046.178339659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 45d5a2427dcb1..d79f6d091e3ef 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -695,6 +695,7 @@ struct lm90_data {
 	struct mutex update_lock;
 	struct delayed_work alert_work;
 	struct work_struct report_work;
+	bool shutdown;		/* true if shutting down */
 	bool valid;		/* true if register values are valid */
 	bool alarms_valid;	/* true if status register values are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -1113,6 +1114,9 @@ static void lm90_report_alarms(struct work_struct *work)
 
 static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
 {
+	if (data->shutdown)
+		return 0;
+
 	if (force || !data->alarms_valid ||
 	    time_after(jiffies, data->alarms_updated + msecs_to_jiffies(data->update_interval))) {
 		struct i2c_client *client = data->client;
@@ -2522,15 +2526,23 @@ static void lm90_restore_conf(void *_data)
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
@@ -2841,6 +2853,10 @@ static int lm90_probe(struct i2c_client *client)
 
 	data->hwmon_dev = hwmon_dev;
 
+	err = devm_add_action_or_reset(&client->dev, lm90_stop_work, data);
+	if (err)
+		return err;
+
 	if (client->irq) {
 		dev_dbg(dev, "IRQ: %d\n", client->irq);
 		err = devm_request_threaded_irq(dev, client->irq,
@@ -2869,7 +2885,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		 */
 		struct lm90_data *data = i2c_get_clientdata(client);
 
-		if ((data->flags & LM90_HAVE_BROKEN_ALERT) &&
+		if (!data->shutdown && (data->flags & LM90_HAVE_BROKEN_ALERT) &&
 		    (data->current_alarms & data->alert_alarms)) {
 			if (!(data->config & 0x80)) {
 				dev_dbg(&client->dev, "Disabling ALERT#\n");
-- 
2.53.0



