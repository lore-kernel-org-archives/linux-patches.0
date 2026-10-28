Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209148;
	b=gA4vJW0KGcrw7/JNT+Ujyder8b+6SDd/vRCJ31qs9ds39niwha0zUzTPZlvIxazxwjnY
	 drO5HGx1dbyCdmn+V06BOFToZFUuZG07ogKum8mY243EBKBHxmM8FDsql6CldnXxeAAXb
	 bFMYTWFrLYZ21E2f70XNB53zPJ9OMDNpkQL/Hqqu/d1DSVDsXXFKGY5ztdbpFSnmov94D
	 +h4soGlHXYq5v0jhlmqlun5mjKmcya9M5w+cTh53URpcKOQX11K2vRlwyUItk8hrtk7xr
	 0SzXntwuYsc3DTz1WOcYnELmk2/F6pgkdy+0fiZ398BhhzEk5WJxv+jymWLGNdxW7+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cmAu+V73GYnYW/OxCSTV4+lB2cr+fkbnwkllaq7enh8=;
	b=3jeihAcgffuzTX4ijO6N5AY1SHsKAIyVnHVu62zwLsOm7tfKzbjzq1hKkciAscJhRkOZ
	 ua7h/8z+B+yvbXfosWIFP0ooHHCjDqcTDakV5fdJwEnBIjLVBnIxPE/ZU2+o4gUYe4N+D
	 He+s5JmTwPO5aoDlQ3kAjs1QU7TIuy9A/26qeFDek1BU16ugkm2jy+RAKQu7DGGl0UH2X
	 ldF7J9zXkcumxXWKcGZFQmizFN61ZfaJVH+sAjoXLw54KT3k67BrnR+wEaBYSSzZGQO8v
	 HBxHGO6wMINNG+TNlYGPk+3axb1hSnCUgLcdCYrpcsAQjzwOOKWpvdisJw7T+Gm7v9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi0jnhDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BA7606A31A;
	Wed, 28 Oct 2026 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi0jnhDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654651F01825;
	Wed, 28 Oct 2026 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209147;
	bh=cmAu+V73GYnYW/OxCSTV4+lB2cr+fkbnwkllaq7enh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pi0jnhDnrI4XVifcjJ895KXHtce+FfixwpkYixAAQSpOgDgDNuOMMItSVBuarxmws
	 dbkaHJqeFOsnzzKzc8yCD/WUbtnzMYgjEmY06sDmxG2No6ngcX6ZN4qjpACsFPdNOW
	 VpyTpiF5XSAHEkHFw5U8KsXwWMEFR7sJVQItOoPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 367/516] HID: steam: Fully unregister controller when hidraw is opened
Date: Wed, 28 Oct 2026 17:58:39 +0100
Message-ID: <20261028170012.180100024@linuxfoundation.org>
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

[ Upstream commit cd33a91d37eb4d7c6ce56aa7f4688066309808eb ]

To avoid conflicts between anything touching the hidraw and the driver we
had previously detached the evdev nodes when the hidraw is opened. However,
this isn't sufficient to avoid FEATURE reports from conflicting, so we
change to fully unregistering the controller internally, leaving only the
hidraw active until it's closed.

This also unifies the unregister and connect callbacks, as now the logic
between these two callbacks is identical.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Convert steam_client_ll_open() and steam_client_ll_close() to
      schedule work_connect directly and omit sensors, rumble_work,
      mode_switch and unregister_work changes as e133dc99fc07,
      e1147961b214 and 1d4549fd1115 are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 78 ++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 159b55dff799f..a856276b6c2cf 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -380,6 +380,7 @@ static int steam_battery_register(struct steam_device *steam)
 			&steam->battery_desc, &battery_cfg);
 	if (IS_ERR(battery)) {
 		ret = PTR_ERR(battery);
+		devm_kfree(&steam->hdev->dev, steam->battery_desc.name);
 		hid_err(steam->hdev,
 				"%s:power_supply_register failed with error %d\n",
 				__func__, ret);
@@ -504,12 +505,15 @@ static void steam_battery_unregister(struct steam_device *steam)
 	RCU_INIT_POINTER(steam->battery, NULL);
 	synchronize_rcu();
 	power_supply_unregister(battery);
+	devm_kfree(&steam->hdev->dev, steam->battery_desc.name);
 }
 
 static int steam_register(struct steam_device *steam)
 {
 	int ret;
 	unsigned long client_opened;
+	unsigned long flags;
+	bool do_add;
 
 	/*
 	 * This function can be called several times in a row with the
@@ -535,38 +539,47 @@ static int steam_register(struct steam_device *steam)
 		if (steam->quirks & STEAM_QUIRK_WIRELESS)
 			steam_battery_register(steam);
 
-		mutex_lock(&steam_devices_lock);
-		if (list_empty(&steam->list))
-			list_add(&steam->list, &steam_devices);
-		mutex_unlock(&steam_devices_lock);
+		do_add = true;
 	}
 
-	mutex_lock(&steam->mutex);
+	spin_lock_irqsave(&steam->lock, flags);
 	client_opened = steam->client_opened;
-	if (!client_opened)
-		steam_set_lizard_mode(steam, lizard_mode);
-	mutex_unlock(&steam->mutex);
+	spin_unlock_irqrestore(&steam->lock, flags);
 
-	if (!client_opened)
+	if (!client_opened) {
+		mutex_lock(&steam->mutex);
+		steam_set_lizard_mode(steam, lizard_mode);
+		mutex_unlock(&steam->mutex);
 		ret = steam_input_register(steam);
-	else
-		ret = 0;
+		if (ret != 0)
+			goto steam_register_input_fail;
+	}
+
+	if (do_add) {
+		mutex_lock(&steam_devices_lock);
+		if (list_empty(&steam->list))
+			list_add(&steam->list, &steam_devices);
+		mutex_unlock(&steam_devices_lock);
+	}
+	return 0;
 
+steam_register_input_fail:
 	return ret;
 }
 
 static void steam_unregister(struct steam_device *steam)
 {
+	if (!steam->serial_no[0])
+		return;
+
+	hid_info(steam->hdev, "Steam Controller '%s' disconnected",
+			steam->serial_no);
 	steam_battery_unregister(steam);
 	steam_input_unregister(steam);
-	if (steam->serial_no[0]) {
-		hid_info(steam->hdev, "Steam Controller '%s' disconnected",
-				steam->serial_no);
-		mutex_lock(&steam_devices_lock);
-		list_del_init(&steam->list);
-		mutex_unlock(&steam_devices_lock);
-		steam->serial_no[0] = 0;
-	}
+	mutex_lock(&steam_devices_lock);
+	list_del_init(&steam->list);
+	mutex_unlock(&steam_devices_lock);
+	steam->serial_no[0] = 0;
 }
 
 static void steam_work_connect_cb(struct work_struct *work)
@@ -575,19 +588,20 @@ static void steam_work_connect_cb(struct work_struct *work)
 							work_connect);
 	unsigned long flags;
 	bool connected;
+	bool opened;
 	int ret;
 
 	spin_lock_irqsave(&steam->lock, flags);
+	opened = steam->client_opened;
 	connected = steam->connected;
 	spin_unlock_irqrestore(&steam->lock, flags);
 
-	if (connected) {
+	if (connected && !opened) {
 		ret = steam_register(steam);
-		if (ret) {
+		if (ret)
 			hid_err(steam->hdev,
 				"%s:steam_register failed with error %d\n",
 				__func__, ret);
-		}
 	} else {
 		steam_unregister(steam);
 	}
@@ -632,12 +646,13 @@ static void steam_client_ll_stop(struct hid_device *hdev)
 static int steam_client_ll_open(struct hid_device *hdev)
 {
 	struct steam_device *steam = hdev->driver_data;
+	unsigned long flags;
 
-	mutex_lock(&steam->mutex);
+	spin_lock_irqsave(&steam->lock, flags);
 	steam->client_opened++;
-	mutex_unlock(&steam->mutex);
+	spin_unlock_irqrestore(&steam->lock, flags);
 
-	steam_input_unregister(steam);
+	schedule_work(&steam->work_connect);
 
 	return 0;
 }
@@ -645,22 +660,13 @@ static int steam_client_ll_open(struct hid_device *hdev)
 static void steam_client_ll_close(struct hid_device *hdev)
 {
 	struct steam_device *steam = hdev->driver_data;
-
 	unsigned long flags;
-	bool connected;
 
 	spin_lock_irqsave(&steam->lock, flags);
-	connected = steam->connected;
-	spin_unlock_irqrestore(&steam->lock, flags);
-
-	mutex_lock(&steam->mutex);
 	steam->client_opened--;
-	if (connected && !steam->client_opened)
-		steam_set_lizard_mode(steam, lizard_mode);
-	mutex_unlock(&steam->mutex);
+	spin_unlock_irqrestore(&steam->lock, flags);
 
-	if (connected && !steam->client_opened)
-		steam_input_register(steam);
+	schedule_work(&steam->work_connect);
 }
 
 static int steam_client_ll_raw_request(struct hid_device *hdev,
-- 
2.53.0



