Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0877B36CE19;
	Sat, 17 Oct 2026 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257467; cv=none; b=Sgj4MsGF68p+PmZJKyKHNSGdNblsNvsw4WJcj+Vetwvf15CfHmK+WsGKYQM3pjE7+NEKelOqoUpOxshq7NXndg1zki3jM31UsnZxz+ZxmBH+nNjQPlT4H9gZIfGFfO+ZBa5CFhS3CjxyxTOGf9PwCgueXlJsYieoau1AzGk8k8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257467; c=relaxed/simple;
	bh=pCPeLvqBDiPn0KGdx1a8B4oJoRbjTvYUMrZQ+/d+xZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiPK5tIQ/Wq7mrlzz5Dcnn7awbh+UhOwOxaHpLnYnPQHYklRwSHuLqA+lCXSkgvJRiT3olU+rlySlilV0Dry064Gc9RhKaRZS4iLn8DNTE09kRuMA7VRvPktX3TioxyRmEUuDyU7G9n++zRWxZfoge21JSuKSDYE2kXo2/z/ER8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJ2s6GKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJ2s6GKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FBE1F000C4;
	Sat, 17 Oct 2026 17:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257465;
	bh=43NiaWjxy7/TIHYo0edktLr7R2bRNyZnufWwmyZhdZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJ2s6GKApxk3qZM2ooVdX01nqozjVTuRIgNeqfHcL25JE51P3MbA12eK9ETmCD3XR
	 4JyKkDz6uK6Ds+I4M6aDf9OA1wsgLwMrfiJKQRoiRTxagN5e8qO9aimcm/y7LA6qC4
	 QHs8Gj2U4ahVGpsMZbi9HG3Mn9nRH5P40G/ql4L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0566/1674] HID: steam: Refactor registration
Date: Sat, 17 Oct 2026 17:47:18 +0200
Message-ID: <20261017160445.621075018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 6f9b740c31ba7e061b2ebb330d9a3d63f1358f29 ]

This refactors and simplifies the registration/unregistration flow. Since
we now only perform registration when the client isn't opened anymore, the
logic for handling that can be removed, and the rest of the function
streamlined.

We also remove the previous assumption that we have a serial number to show
we're registered, replacing it with a single purpose boolean.

In a previous refactor the code for unregistering a battery if later
registration steps failed was accidentally left out. As a result, a
lingering power_supply object could get left over after the steam object
was torn down. This is also fixed here.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Omit steam_get_attributes() and coalesce_rumble_work cancellation
      as a0fbd9437d7d and 1d4549fd1115 are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 70 +++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index df176a722061b..06c2fcd134ce0 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -300,6 +300,7 @@ struct steam_device {
 	unsigned long quirks;
 	struct work_struct work_connect;
 	bool connected;
+	bool registered;
 	char serial_no[STEAM_SERIAL_LEN + 1];
 	struct power_supply_desc battery_desc;
 	struct power_supply __rcu *battery;
@@ -953,9 +954,6 @@ static void steam_battery_unregister(struct steam_device *steam)
 static int steam_register(struct steam_device *steam)
 {
 	int ret;
-	unsigned long client_opened;
-	unsigned long flags;
-	bool do_add;
 
 	/*
 	 * This function can be called several times in a row with the
@@ -963,60 +961,56 @@ static int steam_register(struct steam_device *steam)
 	 * another client send a get_connection_status command, for example.
 	 * The battery and serial number are set just once per device.
 	 */
-	if (!steam->serial_no[0]) {
-		/*
-		 * Unlikely, but getting the serial could fail, and it is not so
-		 * important, so make up a serial number and go on.
-		 */
-		if (steam_get_serial(steam) < 0)
-			strscpy(steam->serial_no, "XXXXXXXXXX",
-					sizeof(steam->serial_no));
+	if (steam->registered)
+		return 0;
 
-		hid_info(steam->hdev, "Steam Controller '%s' connected",
-				steam->serial_no);
+	/*
+	 * Unlikely, but getting the serial could fail, and it is not so
+	 * important, so make up a serial number and go on.
+	 */
+	if (steam_get_serial(steam) < 0 || !steam->serial_no[0])
+		strscpy(steam->serial_no, "XXXXXXXXXX",
+				sizeof(steam->serial_no));
 
-		/* ignore battery errors, we can live without it */
-		if (steam->quirks & STEAM_QUIRK_WIRELESS)
-			steam_battery_register(steam);
+	hid_info(steam->hdev, "Steam Controller '%s' connected",
+			steam->serial_no);
 
-		do_add = true;
-	}
+	/* ignore battery errors, we can live without it */
+	if (steam->quirks & STEAM_QUIRK_WIRELESS)
+		steam_battery_register(steam);
 
-	spin_lock_irqsave(&steam->lock, flags);
-	client_opened = steam->client_opened;
-	spin_unlock_irqrestore(&steam->lock, flags);
-
-	if (!client_opened) {
-		steam_set_lizard_mode(steam, lizard_mode);
-		ret = steam_input_register(steam);
-		if (ret != 0)
-			goto steam_register_input_fail;
-		ret = steam_sensors_register(steam);
-		if (ret != 0)
-			goto steam_register_sensors_fail;
-	}
+	steam_set_lizard_mode(steam, lizard_mode);
+	ret = steam_input_register(steam);
+	if (ret != 0)
+		goto steam_register_input_fail;
+	ret = steam_sensors_register(steam);
+	if (ret != 0)
+		goto steam_register_sensors_fail;
 
-	if (do_add) {
-		mutex_lock(&steam_devices_lock);
-		if (list_empty(&steam->list))
-			list_add(&steam->list, &steam_devices);
-		mutex_unlock(&steam_devices_lock);
-	}
+	steam->registered = true;
+	mutex_lock(&steam_devices_lock);
+	if (list_empty(&steam->list))
+		list_add(&steam->list, &steam_devices);
+	mutex_unlock(&steam_devices_lock);
 	return 0;
 
 steam_register_sensors_fail:
 	steam_input_unregister(steam);
 steam_register_input_fail:
+	steam_battery_unregister(steam);
+	cancel_work_sync(&steam->rumble_work);
+	cancel_delayed_work_sync(&steam->mode_switch);
 	return ret;
 }
 
 static void steam_unregister(struct steam_device *steam)
 {
-	if (!steam->serial_no[0])
+	if (!steam->registered)
 		return;
 
 	hid_info(steam->hdev, "Steam Controller '%s' disconnected",
 			steam->serial_no);
+	steam->registered = false;
 	steam_battery_unregister(steam);
 	steam_sensors_unregister(steam);
 	steam_input_unregister(steam);
-- 
2.53.0



