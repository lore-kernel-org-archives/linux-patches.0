Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209156;
	b=wAa6wLJw5iHhuSnT5fTZoieeKfhcYzbBC7QtASOQ76yrRcB5EbaEbPWHYVZKWJkBcRwa
	 n9W5NpP2r0aYdcRJtZckQ2hIgNll44rfv9An21pRDBa9cMCQJ9+vXLyHCkoKA3ekFmvSr
	 W031xVMEl+E7aIcjXe4f5nqqd/GYyMulw1nMJ7ImA0upa9vb1vmqv5/GTTFv+EC7mkBQG
	 +tzC70dlPan39xu1tK1xeDYVtVxk/aF+OH1PYDKIC+hjerxLZr2us9/z8XFVTmlP4qjNx
	 xseJOklzEz7TXX2O4q7nWFk/sOOaBEfGJSjWvN1mFQPtn/JAYCbH2UJnjTp2AxfSFUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8itYPoirajcgB60hMWYvyMq/Qx/GzJhSALHiXy9drF0=;
	b=bZQ1PuxAnmNLU0YwdpRmJsgYk6w5WOlmj5RCBcDcq4d6n2IKAV1Z5lA4XN9+TJNsHMxx
	 4RGKLTjtoTO6pXFPZjT8BI8LGiHzImhuMfXAcxwuC/EHjWf/S8AIRPHzuchZPLB/0uGyc
	 F37SCQ5s5VmoRxn6nMK2CIdIJVmoeJFa/wC1FFcj4SBmI4QgyI95tvAW9m6GyktlqpV8V
	 wKAcCRbZjYJvMCpvH9/k0Lq1C8JEaPkUFFq5ern+kQTxFmcq2cd55INWRfLV1xGVd8gBd
	 UcUsdyj6ugMryAe2rm0ASnlA970+vaV7rWs4UIU7+q1RRCztDiL1Zx9lotvB89B+o3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLFZS3vD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871FD606A31A;
	Wed, 28 Oct 2026 17:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLFZS3vD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EF51F01828;
	Wed, 28 Oct 2026 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209156;
	bh=8itYPoirajcgB60hMWYvyMq/Qx/GzJhSALHiXy9drF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLFZS3vDPFeojUSfazBTQeimdvMzM12V+qYHYv8rDUPYRF+I6ZhZpy48NCHk6OvLB
	 VuMVh6mlIx+UtmEp650j9QtGAXJrU8LyHTtdw0oD4lkp8V7qnzEy0X2L4FVuh+3WbK
	 bCvPVW+bDfyI0gX7ud9dAHl/mVZnmL7Le4+zRhWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 370/516] HID: steam: Clean up locking
Date: Wed, 28 Oct 2026 17:58:42 +0100
Message-ID: <20261028170012.251138112@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit de1d341b9b3ec9655f31fb8b44f784cca5e670ad ]

This cleans up several issues with locking behavior, including RCU accesses
not being guarded behind a lock.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Use explicit lock/unlock calls instead of guard(), adapt to
      steam->mutex, and omit Steam Deck sensors, mode_switch,
      rumble_work, coalesce_rumble_work and Ibex changes as
      691ead124a0c, e133dc99fc07, a0fbd9437d7d, 1d4549fd1115,
      fcfa7db89f7a and 0a80b4e8ec6a are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 61 +++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 544d45f3fc6b5..4ba922d750df3 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -114,6 +114,7 @@ struct steam_device {
 	spinlock_t lock;
 	struct hid_device *hdev, *client_hdev;
 	struct mutex mutex;
+	struct mutex registration_mutex;
 	unsigned long client_opened;
 	struct input_dev __rcu *input;
 	unsigned long quirks;
@@ -294,9 +295,14 @@ static void steam_set_lizard_mode(struct steam_device *steam, bool enable)
 static int steam_input_open(struct input_dev *dev)
 {
 	struct steam_device *steam = input_get_drvdata(dev);
+	unsigned long flags;
+	bool client_opened;
 
+	spin_lock_irqsave(&steam->lock, flags);
+	client_opened = steam->client_opened;
+	spin_unlock_irqrestore(&steam->lock, flags);
 	mutex_lock(&steam->mutex);
-	if (!steam->client_opened && lizard_mode)
+	if (!client_opened && lizard_mode)
 		steam_set_lizard_mode(steam, false);
 	mutex_unlock(&steam->mutex);
 	return 0;
@@ -305,9 +311,14 @@ static int steam_input_open(struct input_dev *dev)
 static void steam_input_close(struct input_dev *dev)
 {
 	struct steam_device *steam = input_get_drvdata(dev);
+	unsigned long flags;
+	bool client_opened;
 
+	spin_lock_irqsave(&steam->lock, flags);
+	client_opened = steam->client_opened;
+	spin_unlock_irqrestore(&steam->lock, flags);
 	mutex_lock(&steam->mutex);
-	if (!steam->client_opened && lizard_mode)
+	if (!client_opened && lizard_mode)
 		steam_set_lizard_mode(steam, true);
 	mutex_unlock(&steam->mutex);
 }
@@ -513,40 +524,43 @@ static int steam_register(struct steam_device *steam)
 {
 	int ret;
 
+	mutex_lock(&steam->registration_mutex);
 	/*
 	 * This function can be called several times in a row with the
 	 * wireless adaptor, without steam_unregister() between them, because
 	 * another client send a get_connection_status command, for example.
 	 * The battery and serial number are set just once per device.
 	 */
-	if (steam->registered)
+	if (steam->registered) {
+		mutex_unlock(&steam->registration_mutex);
 		return 0;
+	}
 
+	mutex_lock(&steam->mutex);
 	/*
 	 * Unlikely, but getting the serial could fail, and it is not so
 	 * important, so make up a serial number and go on.
 	 */
-	mutex_lock(&steam->mutex);
 	if (steam_get_serial(steam) < 0 || !steam->serial_no[0])
 		strlcpy(steam->serial_no, "XXXXXXXXXX",
 				sizeof(steam->serial_no));
-	mutex_unlock(&steam->mutex);
 
 	hid_info(steam->hdev, "Steam Controller '%s' connected",
 			steam->serial_no);
 
+	steam_set_lizard_mode(steam, lizard_mode);
+	mutex_unlock(&steam->mutex);
+
 	/* ignore battery errors, we can live without it */
 	if (steam->quirks & STEAM_QUIRK_WIRELESS)
 		steam_battery_register(steam);
 
-	mutex_lock(&steam->mutex);
-	steam_set_lizard_mode(steam, lizard_mode);
-	mutex_unlock(&steam->mutex);
 	ret = steam_input_register(steam);
 	if (ret != 0)
 		goto steam_register_input_fail;
 
 	steam->registered = true;
+	mutex_unlock(&steam->registration_mutex);
 	mutex_lock(&steam_devices_lock);
 	if (list_empty(&steam->list))
 		list_add(&steam->list, &steam_devices);
@@ -555,6 +569,7 @@ static int steam_register(struct steam_device *steam)
 
 steam_register_input_fail:
 	steam_battery_unregister(steam);
+	mutex_unlock(&steam->registration_mutex);
 	return ret;
 }
 
@@ -565,9 +580,11 @@ static void steam_unregister(struct steam_device *steam)
 
 	hid_info(steam->hdev, "Steam Controller '%s' disconnected",
 			steam->serial_no);
+	mutex_lock(&steam->registration_mutex);
 	steam->registered = false;
 	steam_battery_unregister(steam);
 	steam_input_unregister(steam);
+	mutex_unlock(&steam->registration_mutex);
 	mutex_lock(&steam_devices_lock);
 	list_del_init(&steam->list);
 	mutex_unlock(&steam_devices_lock);
@@ -745,6 +762,7 @@ static int steam_probe(struct hid_device *hdev,
 	hid_set_drvdata(hdev, steam);
 	spin_lock_init(&steam->lock);
 	mutex_init(&steam->mutex);
+	mutex_init(&steam->registration_mutex);
 	steam->quirks = id->driver_data;
 	INIT_WORK(&steam->work_connect, steam_work_connect_cb);
 	INIT_LIST_HEAD(&steam->list);
@@ -835,13 +853,10 @@ static void steam_remove(struct hid_device *hdev)
 
 static void steam_do_connect_event(struct steam_device *steam, bool connected)
 {
-	unsigned long flags;
 	bool changed;
 
-	spin_lock_irqsave(&steam->lock, flags);
 	changed = steam->connected != connected;
 	steam->connected = connected;
-	spin_unlock_irqrestore(&steam->lock, flags);
 
 	if (changed && schedule_work(&steam->work_connect) == 0)
 		dbg_hid("%s: connected=%d event already queued\n",
@@ -1008,8 +1023,6 @@ static void steam_do_input_event(struct steam_device *steam,
 static void steam_do_battery_event(struct steam_device *steam,
 		struct power_supply *battery, u8 *data)
 {
-	unsigned long flags;
-
 	s16 volts = steam_le16(data + 12);
 	u8 batt = data[14];
 
@@ -1017,10 +1030,8 @@ static void steam_do_battery_event(struct steam_device *steam,
 	rcu_read_lock();
 	battery = rcu_dereference(steam->battery);
 	if (likely(battery)) {
-		spin_lock_irqsave(&steam->lock, flags);
 		steam->voltage = volts;
 		steam->battery_charge = batt;
-		spin_unlock_irqrestore(&steam->lock, flags);
 		power_supply_changed(battery);
 	}
 	rcu_read_unlock();
@@ -1033,10 +1044,12 @@ static int steam_raw_event(struct hid_device *hdev,
 	struct steam_device *steam = hid_get_drvdata(hdev);
 	struct input_dev *input;
 	struct power_supply *battery;
+	unsigned long flags;
 
 	if (!steam)
 		return 0;
 
+	spin_lock_irqsave(&steam->lock, flags);
 	if (steam->client_opened)
 		hid_input_report(steam->client_hdev, HID_FEATURE_REPORT,
 				data, size, 0);
@@ -1057,12 +1070,12 @@ static int steam_raw_event(struct hid_device *hdev,
 	 */
 
 	if (size != 64 || data[0] != 1 || data[1] != 0)
-		return 0;
+		goto out;
 
 	switch (data[2]) {
 	case STEAM_EV_INPUT_DATA:
 		if (steam->client_opened)
-			return 0;
+			goto out;
 		rcu_read_lock();
 		input = rcu_dereference(steam->input);
 		if (likely(input))
@@ -1100,6 +1113,8 @@ static int steam_raw_event(struct hid_device *hdev,
 		}
 		break;
 	}
+out:
+	spin_unlock_irqrestore(&steam->lock, flags);
 	return 0;
 }
 
@@ -1108,6 +1123,8 @@ static int steam_param_set_lizard_mode(const char *val,
 {
 	struct steam_device *steam;
 	int ret;
+	bool client_opened;
+	unsigned long flags;
 
 	ret = param_set_bool(val, kp);
 	if (ret)
@@ -1115,10 +1132,14 @@ static int steam_param_set_lizard_mode(const char *val,
 
 	mutex_lock(&steam_devices_lock);
 	list_for_each_entry(steam, &steam_devices, list) {
-		mutex_lock(&steam->mutex);
-		if (!steam->client_opened)
+		spin_lock_irqsave(&steam->lock, flags);
+		client_opened = steam->client_opened;
+		spin_unlock_irqrestore(&steam->lock, flags);
+		if (!client_opened) {
+			mutex_lock(&steam->mutex);
 			steam_set_lizard_mode(steam, lizard_mode);
-		mutex_unlock(&steam->mutex);
+			mutex_unlock(&steam->mutex);
+		}
 	}
 	mutex_unlock(&steam_devices_lock);
 	return 0;
-- 
2.53.0



