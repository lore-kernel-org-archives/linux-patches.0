Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028631;
	b=t6AM/wApG48McVuo/5a6pbAInweconsMko3NqL7JkLv1QVjsiIx0JRl27crTQ28Q0OAe
	 eusrGz9iwGMQMIC0BRKAjHEu3RViW9IO0ANB3DrDDQGDhgAc2WouAEEnV1o15/S8IbCOg
	 SXUzLugRX7zSgDyCx9BwFaa2SD53vxG5p65YQOiQhvlmGki00dRSusBMwO2LnE3OEnl+o
	 Fj3shrefHYR2bTeFqHRfnVmqdHfORDGHTDGOKavTEZh394le2dl7cj+ZSgPS9pJoo59MW
	 DO+XEypflyIkVEy+GEEc/sfNNo2BI2kR/QzcFb1TXTiyEBs8tsg0Acppv3diPySSKQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Se/aLGidmBzKpSWqqVAYIfVJmHMWQF5zuUtMchiZJl8=;
	b=A9hRwvbPcK5X4koVOiodYYLIG+effDYRief6U85oNm+OdsB2IHV5Q15XoF9ty4qCpfyH
	 9vlTnx7aXeldNeGhhqdDNfYPj2eRU3zg2UE927fxFW31SIlcn18D7TOTO2AzOH9P1wdoZ
	 4kssGaDice66GJtfiK221+SZn9JkHYOGZklQkWjBycDdaO0++Qh18MlwkM7LynaRKLJZg
	 TvAMzfJxQ8wsKdaVUV4KsqFczsibvo9LcRx/OCo6QAZRKuWa6Ldsc3y9WbMgDpsbXk/JT
	 n2t/Yj0Rj9GbFiegrVOfxLGJkuKK+qlBrmlKRoH/n7J1//I9QiZ7JVXFOUnIob2h1GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+obTus+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F4E606A325;
	Wed, 18 Nov 2026 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+obTus+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2821F000C4;
	Wed, 18 Nov 2026 19:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028631;
	bh=Se/aLGidmBzKpSWqqVAYIfVJmHMWQF5zuUtMchiZJl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+obTus+4OyAT+OgH1OtGuctCO4sK7tvt0Ch/tGSN7pf3sqQyHjejTz1+F4Ky6fSD
	 Z5wM5zeUkwJFc5U1gW3glDpFt9MqljqwyeOroWjlONNV876E4wjAsPM/rVNtj6PlVY
	 iQl482gUyO/90QCtHx0R0gL4CFALqfjOYpBgtQ4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0062/1756] hwmon: chipcap2: serialize access to the alarm indicators
Date: Wed, 18 Nov 2026 15:36:29 +0100
Message-ID: <20261118150010.823542148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit bed5f0c075eb99442fca6a61c009a32752eceda2 ]

low_alarm and high_alarm are accessed from the threaded interrupt
handlers and from sysfs without any locking, which can lead to lost
alarms.

Add a mutex to serialize the access to the alarm indicators and to
process_irqs, which the handlers use to decide whether an interrupt
belongs to an ongoing operation.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-10-27ebfc2c5b9e@gmail.com
[groeck: Dropped obsolete 'Assisted-by: tag]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 58 +++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 4a9c51c792aed..8d2f7ba4c1789 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -20,6 +20,7 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
 #include <linux/regulator/consumer.h>
@@ -88,6 +89,8 @@ struct cc2_data {
 	int irq_low;
 	int irq_high;
 	bool process_irqs;
+	/* protects process_irqs and the alarm indicators */
+	struct mutex irq_lock;
 	bool regulator_enabled;
 };
 
@@ -119,7 +122,8 @@ static int cc2_enable(struct cc2_data *data)
 
 	/* exclusive regulator, check in case a disable failed */
 	if (data->regulator_enabled) {
-		data->process_irqs = true;
+		scoped_guard(mutex, &data->irq_lock)
+			data->process_irqs = true;
 		return 0;
 	}
 
@@ -134,7 +138,8 @@ static int cc2_enable(struct cc2_data *data)
 
 	usleep_range(CC2_STARTUP_TIME_US, CC2_STARTUP_TIME_US + 125);
 
-	data->process_irqs = true;
+	scoped_guard(mutex, &data->irq_lock)
+		data->process_irqs = true;
 
 	return 0;
 }
@@ -151,7 +156,8 @@ static void cc2_disable(struct cc2_data *data)
 		synchronize_irq(data->irq_high);
 
 	/* ignore alarms triggered by voltage toggling when powering up */
-	data->process_irqs = false;
+	scoped_guard(mutex, &data->irq_lock)
+		data->process_irqs = false;
 
 	/* exclusive regulator, check in case an enable failed */
 	if (!data->regulator_enabled)
@@ -507,10 +513,12 @@ static irqreturn_t cc2_low_interrupt(int irq, void *data)
 {
 	struct cc2_data *cc2 = data;
 
-	if (cc2->process_irqs) {
-		hwmon_notify_event(cc2->hwmon, hwmon_humidity,
-				   hwmon_humidity_min_alarm, 0);
-		cc2->rh_alarm.low_alarm = true;
+	scoped_guard(mutex, &cc2->irq_lock) {
+		if (cc2->process_irqs) {
+			hwmon_notify_event(cc2->hwmon, hwmon_humidity,
+					   hwmon_humidity_min_alarm, 0);
+			cc2->rh_alarm.low_alarm = true;
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -520,10 +528,12 @@ static irqreturn_t cc2_high_interrupt(int irq, void *data)
 {
 	struct cc2_data *cc2 = data;
 
-	if (cc2->process_irqs) {
-		hwmon_notify_event(cc2->hwmon, hwmon_humidity,
-				   hwmon_humidity_max_alarm, 0);
-		cc2->rh_alarm.high_alarm = true;
+	scoped_guard(mutex, &cc2->irq_lock) {
+		if (cc2->process_irqs) {
+			hwmon_notify_event(cc2->hwmon, hwmon_humidity,
+					   hwmon_humidity_max_alarm, 0);
+			cc2->rh_alarm.high_alarm = true;
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -539,11 +549,13 @@ static int cc2_humidity_min_alarm_status(struct cc2_data *data, long *val)
 	if (ret < 0)
 		return ret;
 
-	if (data->rh_alarm.low_alarm) {
-		*val = (measurement < min_hyst) ? 1 : 0;
-		data->rh_alarm.low_alarm = *val;
-	} else {
-		*val = 0;
+	scoped_guard(mutex, &data->irq_lock) {
+		if (data->rh_alarm.low_alarm) {
+			*val = (measurement < min_hyst) ? 1 : 0;
+			data->rh_alarm.low_alarm = *val;
+		} else {
+			*val = 0;
+		}
 	}
 
 	return 0;
@@ -559,11 +571,13 @@ static int cc2_humidity_max_alarm_status(struct cc2_data *data, long *val)
 	if (ret < 0)
 		return ret;
 
-	if (data->rh_alarm.high_alarm) {
-		*val = (measurement > max_hyst) ? 1 : 0;
-		data->rh_alarm.high_alarm = *val;
-	} else {
-		*val = 0;
+	scoped_guard(mutex, &data->irq_lock) {
+		if (data->rh_alarm.high_alarm) {
+			*val = (measurement > max_hyst) ? 1 : 0;
+			data->rh_alarm.high_alarm = *val;
+		} else {
+			*val = 0;
+		}
 	}
 
 	return 0;
@@ -707,6 +721,8 @@ static int cc2_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, data);
 
+	mutex_init(&data->irq_lock);
+
 	data->client = client;
 
 	data->regulator = devm_regulator_get_exclusive(dev, "vdd");
-- 
2.53.0



