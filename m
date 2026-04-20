Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1DE33E373;
	Mon, 20 Apr 2026 16:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701116; cv=none; b=fSvdGiA9lEpbul8QlfKLmL83gC9dOifKZnl+vPETP4SGC1tusHiEXRB24XMxv0e3JaXVS+2ZspD6Su4RO43fXILTdxpmO6ioOtoZNPpT+sQHAfHjVOlGYiRkv/v518GTu0a09pigbG1uBda4ZFt/wP0RZR7xuV2T9eLGKEuBUpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701116; c=relaxed/simple;
	bh=zQqftcedO08THD06Li0rp4WXAV22JG/GzpVUlyFLxc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6FzPhTSDhZ5wZG2deXKd2i0WZYJxE+0+J5THNFuH8sfWOd+STjdmZnidEo1e4/WBiE7+FXm+qfhraURr2/jnG6UxGeNONqy5bFunxZgXJ4r+767GBnrfZUtuLXYVu++uh3Xox6chQzI4AEJ0KmN15mfOqi5T4p7cnA0AJbLsW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUZ3Cpaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUZ3Cpaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDC6C19425;
	Mon, 20 Apr 2026 16:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701116;
	bh=zQqftcedO08THD06Li0rp4WXAV22JG/GzpVUlyFLxc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUZ3Cpaqtds50gUwhnqQGu3NzsMGtrR05wxfdfvS0/tkqSHXWRJ+u56Yi3Uw046Q3
	 W5DvrE6kCoYLyiLC7P7lSh284NAdVZj/xp1pTXn2xY9L9uhJqit05hM4SB+w/cV9yH
	 pi2IR/gc51uoquYsAJVUaOHHX+vitpoYgO9ySS9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 188/198] hwmon: (powerz) Fix use-after-free on USB disconnect
Date: Mon, 20 Apr 2026 17:42:47 +0200
Message-ID: <20260420153942.388463495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


