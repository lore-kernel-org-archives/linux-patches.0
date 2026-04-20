Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF03A33262B;
	Mon, 20 Apr 2026 15:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699991; cv=none; b=oEkThrRqw7d9qZ5lZSw2fO9vluMswPBoz4fzZtkj7pisaMs6SkfaFn/Meh3JaXzfaQTNvEKPb1cG+BCGEjZ5w3iS8SwtM2ZulAkHTQv1bPtGV4rwFI0BP2GGqCf8TGM9EUQfw7shnzVZM1qhhFksdnqxEhQky2Q7PeygpzsTHws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699991; c=relaxed/simple;
	bh=CA7tYamiV1kwsUSS+Q/+6ctSM+428q5MEPGKxJFlfKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnCMBHbFRpp44VgB3pqy1+EHq4951ajVP/X3GuqTGa7ChBOvENGMgOy8HN1vGolEnRnVOCPP+mvDMkV5CXQk9Q4JJP06qIY+mAPC6uQDUmu0ISE5VPePe/tWn1m+KIFgGGVgnBuLqXJ8T6dWs0ehO/rLstxXrDydAfDfVGYbc7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tU1QOjMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tU1QOjMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BCDC19425;
	Mon, 20 Apr 2026 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699990;
	bh=CA7tYamiV1kwsUSS+Q/+6ctSM+428q5MEPGKxJFlfKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tU1QOjMKkvqXuY5fZS58o9t7W1IJN3L8kqXKMJsPlXBY3qXNnOk1mzzG5+XfEvOmF
	 Gt1VuqY6Nz3wfrKnhFcC99NKfW7RsiW2qQhjemr7AS5w+rfSAehf/OlupcoFmy1Mob
	 NeKgL8Iyd0Ti70MnLEvEx5H0mNvCqIle+9c7gUMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.0 68/76] hwmon: (powerz) Fix use-after-free on USB disconnect
Date: Mon, 20 Apr 2026 17:42:19 +0200
Message-ID: <20260420153913.294805555@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit 08e57f5e1a9067d5fbf33993aa7f51d60b3d13a4 upstream.

After powerz_disconnect() frees the URB and releases the mutex, a
subsequent powerz_read() call can acquire the mutex and call
powerz_read_data(), which dereferences the freed URB pointer.

Fix by:
 - Setting priv->urb to NULL in powerz_disconnect() so that
   powerz_read_data() can detect the disconnected state.
 - Adding a !priv->urb check at the start of powerz_read_data()
   to return -ENODEV on a disconnected device.
 - Moving usb_set_intfdata() before hwmon registration so the
   disconnect handler can always find the priv pointer.

Fixes: 4381a36abdf1c ("hwmon: add POWER-Z driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260410002521.422645-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/powerz.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/powerz.c
+++ b/drivers/hwmon/powerz.c
@@ -108,6 +108,9 @@ static int powerz_read_data(struct usb_d
 {
 	int ret;
 
+	if (!priv->urb)
+		return -ENODEV;
+
 	priv->status = -ETIMEDOUT;
 	reinit_completion(&priv->completion);
 
@@ -224,6 +227,8 @@ static int powerz_probe(struct usb_inter
 	mutex_init(&priv->mutex);
 	init_completion(&priv->completion);
 
+	usb_set_intfdata(intf, priv);
+
 	hwmon_dev =
 	    devm_hwmon_device_register_with_info(parent, DRIVER_NAME, priv,
 						 &powerz_chip_info, NULL);
@@ -232,8 +237,6 @@ static int powerz_probe(struct usb_inter
 		return PTR_ERR(hwmon_dev);
 	}
 
-	usb_set_intfdata(intf, priv);
-
 	return 0;
 }
 
@@ -244,6 +247,7 @@ static void powerz_disconnect(struct usb
 	mutex_lock(&priv->mutex);
 	usb_kill_urb(priv->urb);
 	usb_free_urb(priv->urb);
+	priv->urb = NULL;
 	mutex_unlock(&priv->mutex);
 }
 


