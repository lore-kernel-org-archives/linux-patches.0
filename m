Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDFF3911B8;
	Sat, 17 Oct 2026 16:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255394; cv=none; b=LpB4vJFlx2jtmjL6hmx8w1nsUmU6UA4Apd/yOfIrM5mpgPiHpqoL5I/PNA/jHH5MxXNT+RRdnDKMLULM7YE7IhcGj4qO8jMsGNoe/Ka2NpGDoOtOGWaqFrFDpQ4Q04UhH5CJf4yVJylawa6C1IEaPzheEi3ygsNyfGhDBzRvk+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255394; c=relaxed/simple;
	bh=rSRsciPkBO6FL4DyNWmiwX+S7jr59SJjVKeNUA4qaBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1XDSxG4qMmIqmxqhh57UHMKhvJ/bCmVxo22o7tPPsxtrsFbI/MUUnrK+/U7g4m+Ym52T+Tp03dgpzCzrztmy7TZ3QW6txqso0YWaVmeKURmL8Q07TrjoNTf4XFIWHBpsvKgYIQ3w3kyRoFkjNUjAF856Ingfr/AwFjIq9leDag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipH4va9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipH4va9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BEC1F000C4;
	Sat, 17 Oct 2026 16:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255393;
	bh=68lX8RtQDXHIHixDinFIilMpjAoDwnZG7z5VzTuat20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipH4va9vr6nfxVYNFdNRYbA+eUaSjttpeun7+XTEZl40rR/1yJOji0OW7PpZQTlGY
	 FPiuxaqeUwjNog9yfeu02C7nI6JeNu7Oz5QEFjhwjp9uvzQrqhyMkqAqSzgW7rKOX8
	 rEn0xXeXVo4Dzt2eR8UP8E3/zPNBOBB9Ed5NZX7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 762/869] hwmon: (asus_rog_ryujin) Rely on subsystem locking
Date: Sat, 17 Oct 2026 18:00:03 +0200
Message-ID: <20261017160056.463497776@linuxfoundation.org>
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

[ Upstream commit b4306c0c8e24f9e031185fb87de45391bc8c7fe9 ]

Attribute access is now serialized in the hardware monitoring core,
so locking in the driver code is no longer necessary. Drop it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 8042312e73c5 ("hwmon: (asus_rog_ryujin) Validate HID report lengths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus_rog_ryujin.c | 48 +++++++--------------------------
 1 file changed, 9 insertions(+), 39 deletions(-)

diff --git a/drivers/hwmon/asus_rog_ryujin.c b/drivers/hwmon/asus_rog_ryujin.c
index e5e93a20723c4..10a1f5aca988d 100644
--- a/drivers/hwmon/asus_rog_ryujin.c
+++ b/drivers/hwmon/asus_rog_ryujin.c
@@ -81,10 +81,6 @@ static const char *const rog_ryujin_speed_label[] = {
 struct rog_ryujin_data {
 	struct hid_device *hdev;
 	struct device *hwmon_dev;
-	/* For locking access to buffer */
-	struct mutex buffer_lock;
-	/* For queueing multiple readers */
-	struct mutex status_report_request_mutex;
 	/* For reinitializing the completions below */
 	spinlock_t status_report_request_lock;
 	struct completion cooler_status_received;
@@ -153,18 +149,10 @@ static umode_t rog_ryujin_is_visible(const void *data,
 /* Writes the command to the device with the rest of the report filled with zeroes */
 static int rog_ryujin_write_expanded(struct rog_ryujin_data *priv, const u8 *cmd, int cmd_length)
 {
-	int ret;
-
-	mutex_lock(&priv->buffer_lock);
-
 	memcpy_and_pad(priv->buffer, MAX_REPORT_LENGTH, cmd, cmd_length, 0x00);
-	ret = hid_hw_output_report(priv->hdev, priv->buffer, MAX_REPORT_LENGTH);
-
-	mutex_unlock(&priv->buffer_lock);
-	return ret;
+	return hid_hw_output_report(priv->hdev, priv->buffer, MAX_REPORT_LENGTH);
 }
 
-/* Assumes priv->status_report_request_mutex is locked */
 static int rog_ryujin_execute_cmd(struct rog_ryujin_data *priv, const u8 *cmd, int cmd_length,
 				  struct completion *status_completion)
 {
@@ -196,14 +184,11 @@ static int rog_ryujin_execute_cmd(struct rog_ryujin_data *priv, const u8 *cmd, i
 
 static int rog_ryujin_get_status(struct rog_ryujin_data *priv)
 {
-	int ret = mutex_lock_interruptible(&priv->status_report_request_mutex);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	if (!time_after(jiffies, priv->updated + msecs_to_jiffies(STATUS_VALIDITY))) {
 		/* Data is up to date */
-		goto unlock_and_return;
+		return 0;
 	}
 
 	/* Retrieve cooler status */
@@ -211,36 +196,30 @@ static int rog_ryujin_get_status(struct rog_ryujin_data *priv)
 	    rog_ryujin_execute_cmd(priv, get_cooler_status_cmd, GET_CMD_LENGTH,
 				   &priv->cooler_status_received);
 	if (ret < 0)
-		goto unlock_and_return;
+		return ret;
 
 	/* Retrieve controller status (speeds) */
 	ret =
 	    rog_ryujin_execute_cmd(priv, get_controller_speed_cmd, GET_CMD_LENGTH,
 				   &priv->controller_status_received);
 	if (ret < 0)
-		goto unlock_and_return;
+		return ret;
 
 	/* Retrieve cooler duty */
 	ret =
 	    rog_ryujin_execute_cmd(priv, get_cooler_duty_cmd, GET_CMD_LENGTH,
 				   &priv->cooler_duty_received);
 	if (ret < 0)
-		goto unlock_and_return;
+		return ret;
 
 	/* Retrieve controller duty */
 	ret =
 	    rog_ryujin_execute_cmd(priv, get_controller_duty_cmd, GET_CMD_LENGTH,
 				   &priv->controller_duty_received);
-	if (ret < 0)
-		goto unlock_and_return;
-
-	priv->updated = jiffies;
-
-unlock_and_return:
-	mutex_unlock(&priv->status_report_request_mutex);
 	if (ret < 0)
 		return ret;
 
+	priv->updated = jiffies;
 	return 0;
 }
 
@@ -303,14 +282,11 @@ static int rog_ryujin_write_fixed_duty(struct rog_ryujin_data *priv, int channel
 		 * Retrieve cooler duty since both pump and internal fan are set
 		 * together, then write back with one of them modified.
 		 */
-		ret = mutex_lock_interruptible(&priv->status_report_request_mutex);
-		if (ret < 0)
-			return ret;
 		ret =
 		    rog_ryujin_execute_cmd(priv, get_cooler_duty_cmd, GET_CMD_LENGTH,
 					   &priv->cooler_duty_received);
 		if (ret < 0)
-			goto unlock_and_return;
+			return ret;
 
 		memcpy(set_cmd, set_cooler_duty_cmd, SET_CMD_LENGTH);
 
@@ -329,11 +305,7 @@ static int rog_ryujin_write_fixed_duty(struct rog_ryujin_data *priv, int channel
 			set_cmd[RYUJIN_SET_COOLER_FAN_DUTY_OFFSET] = val;
 		}
 
-		ret = rog_ryujin_execute_cmd(priv, set_cmd, SET_CMD_LENGTH, &priv->cooler_duty_set);
-unlock_and_return:
-		mutex_unlock(&priv->status_report_request_mutex);
-		if (ret < 0)
-			return ret;
+		return rog_ryujin_execute_cmd(priv, set_cmd, SET_CMD_LENGTH, &priv->cooler_duty_set);
 	} else {
 		/*
 		 * Controller fan duty (channel == 2). No need to retrieve current
@@ -538,8 +510,6 @@ static int rog_ryujin_probe(struct hid_device *hdev, const struct hid_device_id
 		goto fail_and_close;
 	}
 
-	mutex_init(&priv->status_report_request_mutex);
-	mutex_init(&priv->buffer_lock);
 	spin_lock_init(&priv->status_report_request_lock);
 	init_completion(&priv->cooler_status_received);
 	init_completion(&priv->controller_status_received);
-- 
2.53.0



