Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208275;
	b=NmgsYd1gGK8x+sMnqyrZMrdss0KxoLAr3wMTOJN+7BFFLHKF1nG9WBwr3tq+RrgHSlfA
	 bxRJ5Og9JFNP27H4Q3EdRk0XjkAr0DsvGR0sI9MRnvbCyf09z6Q6+ZL7bB/av2Kc6gD74
	 n3o1P2J8jF6L4pWlZPO4FyEqViPVhIJflMrdxJNeWxWXmKEoPsOawB1BV6hFMgITOP9E6
	 QIatg93sXGEcp1E18EpuCbLP8mn50i/uXJ5w+2UEmX1Fz45vp1qM3KCRjQBCXFWPjft4f
	 SepDyT9n89P2MZY/wBFDH54OK2VqfMlbCrE4IMHVCbrVS5d5zhx770Wz96imsWAAmhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Sycd57rxYx4ysGhyv5+eBH6nLdtJzbkVZE7sXQdHFII=;
	b=sT+So9VD54y2o4pNpsQ2D0IETM6mqjGEn1SYYZR4O2opaBKp8P3CNWRrtqCxudnnpmoA
	 bKze1igF6r+kY8hixlgmzcpzrudzXVDrqM6rpowL1Qz+4T65X6cCsuM7kws8c8GpVyfjT
	 ppIpE5G14CARchWJ9Pg/eXvYeWWEdl3lZHnzcMepjmPGAXuQmy/lDTaKaVNGk2FmCcFHg
	 JNEFvRB1GE26WvNXjh9cHJw4w2WZA/zNAw8JR6Jru5Z/guIYmALoyUoA2ok77yGDkl+Ko
	 z+NvyQrMDM591llISYvq8la6z1a+2UcdpeDk0b8yib10zCpvZAxJdgLBSQewYi05m3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPaTEjzM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FEE606A321;
	Wed, 28 Oct 2026 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPaTEjzM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74431F031E1;
	Wed, 28 Oct 2026 17:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208274;
	bh=Sycd57rxYx4ysGhyv5+eBH6nLdtJzbkVZE7sXQdHFII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPaTEjzMaWMEtrSWA9P8WzEVe3vrDy2qtK8gjOPZhZLK+vySAiIDDMY2VYivjB2oc
	 LuolMqx62EAVBhQctqYZzw67i50/3KFwIjJsOsiZiePP23xwnpEQixonA+6gUuemts
	 AbcpemQkDEiNR9HTBAmBkO4+QEa/nzXZlkknfdrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/516] power: supply: rt9455: quiesce delayed work before teardown
Date: Wed, 28 Oct 2026 17:53:35 +0100
Message-ID: <20261028170005.019100882@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 3e7a1ebc32fad5a558254a478efd401c17a24381 ]

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
[ retained the int-returning rt9455_remove() callback required by the older I²C interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9455_charger.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/rt9455_charger.c b/drivers/power/supply/rt9455_charger.c
index 6f6adc7446a6d..310cae3f61f09 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -1583,6 +1583,19 @@ static const struct regmap_config rt9455_regmap_config = {
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
@@ -1673,6 +1686,10 @@ static int rt9455_probe(struct i2c_client *client)
 		goto put_usb_notifier;
 	}
 
+	ret = devm_add_action_or_reset(dev, rt9455_cancel_all_delayed_works, info);
+	if (ret)
+		goto put_usb_notifier;
+
 	ret = devm_request_threaded_irq(dev, client->irq, NULL,
 					rt9455_irq_handler_thread,
 					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
@@ -1714,10 +1731,6 @@ static int rt9455_remove(struct i2c_client *client)
 		usb_unregister_notifier(info->usb_phy, &info->nb);
 #endif
 
-	cancel_delayed_work_sync(&info->pwr_rdy_work);
-	cancel_delayed_work_sync(&info->max_charging_time_work);
-	cancel_delayed_work_sync(&info->batt_presence_work);
-
 	return ret;
 }
 
-- 
2.53.0



