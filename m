Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095B3419FC5;
	Fri,  4 Sep 2026 06:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502766; cv=none; b=um8x4rRb+mOZov5TJF3fc0Yv58VAiKje2RJ2YIyEccEzL94WJFU5L6IC05ispneQAUCwv9O6elbyfDbIEipdMJkzuQGJImd/BMSdCCIQpEUxT9UPyvX61nssMEFy4xqkpoST39AQi9zMG0nn8v3sWfGHGWecAnxfbL3MYD6kxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502766; c=relaxed/simple;
	bh=pmpNojgOE31FgHORU+jtRYnI3B5XKEL1m0VnQ7dtpxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVLmigtk59Nf/6Y5RbA2N7vMES6jg3xDE1kCGacj/0DVrksL/di0B2o10OqqNKvCL+QKAzbpyyPhKuLClqGlsrURhtmEnb0BI6qtvIxoFrMujvcM6mT+aAakfeyrFZ4CPZxOMF50/+QOYgerHYa+zQcX+QGmdWKNRmzMmqZIY3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HB0Mg9oA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HB0Mg9oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607B31F00A3D;
	Fri,  4 Sep 2026 06:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502764;
	bh=WNM8uFXxPuUHtD10HnGTV+ncWUT7NhWrbxgdLQpi/GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HB0Mg9oAR9RC/pQjOaA0vusotDz83r5KnW+ot6dL3U3DnZIYiCkeKfpMxbjlH+u+m
	 n8DxfY1T1Xs3Ah4IHn7kjx+TXb7wsO+iabJYhYHlSSEFCf722RunIiGe97/93Y0agZ
	 UKAwJJczeCMQAcut2pPD/MFB5OQHhiukZT0RTFlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 279/403] power: supply: rt9455: quiesce delayed work before teardown
Date: Fri,  4 Sep 2026 07:01:22 +0200
Message-ID: <20260904045741.205549223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 3e7a1ebc32fad5a558254a478efd401c17a24381 upstream.

The threaded IRQ handler can queue pwr_rdy_work,
max_charging_time_work and batt_presence_work.  pwr_rdy_work and
batt_presence_work can also queue max_charging_time_work, while
batt_presence_work can requeue itself.

rt9455_remove() cancels max_charging_time_work before
batt_presence_work.  The latter can therefore queue
max_charging_time_work after it has already been cancelled:

  rt9455_remove()                   workqueue
    cancel pwr_rdy_work
    cancel max_charging_time_work
                                      batt_presence_work queues
                                        max_charging_time_work
    cancel batt_presence_work
    return
    devres frees rt9455_info
                                      max_charging_time_work dereferences
                                        rt9455_info

The IRQ also remains registered until devres cleanup and can queue more
work after any of the cancellation calls.  If rt9455_hw_init() fails
after the IRQ has been requested, probe returns without cancelling work
that may already have been queued.  A pending callback can then access
rt9455_info after it has been freed.

Register rt9455_cancel_all_delayed_works() through
devm_add_action_or_reset() right after devm_power_supply_register().
devres invokes the action in reverse registration order, after the
managed IRQ has been freed and before rt9455_info is released, so the
delayed works are drained in both rt9455_remove() and the probe error
path.  Cancel pwr_rdy_work and batt_presence_work before
max_charging_time_work because both can queue the latter.

This issue was found by an in-house static analysis tool.

Fixes: e86d69dd786e ("power_supply: Add support for Richtek RT9455 battery charger")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260723225310.12663-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/rt9455_charger.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -1582,6 +1582,19 @@ static const struct regmap_config rt9455
 	.cache_type	= REGCACHE_RBTREE,
 };
 
+static void rt9455_cancel_all_delayed_works(void *data)
+{
+	struct rt9455_info *info = data;
+
+	/*
+	 * Both pwr_rdy_work and batt_presence_work can queue
+	 * max_charging_time_work, so cancel them first.
+	 */
+	cancel_delayed_work_sync(&info->pwr_rdy_work);
+	cancel_delayed_work_sync(&info->batt_presence_work);
+	cancel_delayed_work_sync(&info->max_charging_time_work);
+}
+
 static int rt9455_probe(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
@@ -1672,6 +1685,10 @@ static int rt9455_probe(struct i2c_clien
 		goto put_usb_notifier;
 	}
 
+	ret = devm_add_action_or_reset(dev, rt9455_cancel_all_delayed_works, info);
+	if (ret)
+		goto put_usb_notifier;
+
 	ret = devm_request_threaded_irq(dev, client->irq, NULL,
 					rt9455_irq_handler_thread,
 					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
@@ -1712,10 +1729,6 @@ static void rt9455_remove(struct i2c_cli
 	if (info->nb.notifier_call)
 		usb_unregister_notifier(info->usb_phy, &info->nb);
 #endif
-
-	cancel_delayed_work_sync(&info->pwr_rdy_work);
-	cancel_delayed_work_sync(&info->max_charging_time_work);
-	cancel_delayed_work_sync(&info->batt_presence_work);
 }
 
 static const struct i2c_device_id rt9455_i2c_id_table[] = {


