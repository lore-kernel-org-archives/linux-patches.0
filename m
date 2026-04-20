Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36C53451C6;
	Mon, 20 Apr 2026 16:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701532; cv=none; b=st/h3Dj7gyTIpVH/kEh1qLISu1wY5eEbJOa4J0JIexjB68j8/isYtR8h1ou/jXqqzV/T6JYVkYHf3vyePOvgFzN/0naJKol8pbkzBzFxC1JD8HPUN7KXxsTBBPdStcN++jpgmmQg1ZJeAJOJx1Pa+gM97GImgABWVynpx7SbTZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701532; c=relaxed/simple;
	bh=uLzWXhK9C/IlPBJP5sMtIT5cek/H8jSq/Ji7gyBVALE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWZ1f5LamI67sTusnXurAoA+b6IANC3ipT9Uspu74tysySW/xRnYByrh/dOA38Jrt+CBVnfPwCqIHhVJDU6Y4Ch+hr74o9XHa96DZ203+C9g10ZrYh59gBTtB5loZ/+Y/ZfzC0gN/DcxJloOAC2GlNXORY1qM/PoRLGdBhwV6ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IV/HQXGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IV/HQXGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADA0C2BCB4;
	Mon, 20 Apr 2026 16:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701531;
	bh=uLzWXhK9C/IlPBJP5sMtIT5cek/H8jSq/Ji7gyBVALE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IV/HQXGJx1RdzeE/ahDk/dyuzjeGeFsRrhZV629cPinlRqT4cEaxDwyzSFkkuf46D
	 v8AAvasb/QreyjvJIl2eNaCJLSM+9QjqxHcGGT48RxpPl3/AuGRvbg+iSPsTEGIH3i
	 qRnVmimQ/pQ7vUG++KbxddrH9lWX3yC98NQVvHE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 149/162] hwmon: (powerz) Fix use-after-free on USB disconnect
Date: Mon, 20 Apr 2026 17:43:01 +0200
Message-ID: <20260420153932.446343046@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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
@@ -114,6 +114,9 @@ static int powerz_read_data(struct usb_d
 {
 	int ret;
 
+	if (!priv->urb)
+		return -ENODEV;
+
 	priv->status = -ETIMEDOUT;
 	reinit_completion(&priv->completion);
 
@@ -230,6 +233,8 @@ static int powerz_probe(struct usb_inter
 	mutex_init(&priv->mutex);
 	init_completion(&priv->completion);
 
+	usb_set_intfdata(intf, priv);
+
 	hwmon_dev =
 	    devm_hwmon_device_register_with_info(parent, DRIVER_NAME, priv,
 						 &powerz_chip_info, NULL);
@@ -238,8 +243,6 @@ static int powerz_probe(struct usb_inter
 		return PTR_ERR(hwmon_dev);
 	}
 
-	usb_set_intfdata(intf, priv);
-
 	return 0;
 }
 
@@ -250,6 +253,7 @@ static void powerz_disconnect(struct usb
 	mutex_lock(&priv->mutex);
 	usb_kill_urb(priv->urb);
 	usb_free_urb(priv->urb);
+	priv->urb = NULL;
 	mutex_unlock(&priv->mutex);
 }
 


