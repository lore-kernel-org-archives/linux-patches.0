Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828852;
	b=HtmANxW0LlMmFUzIBfPviY20HJfdbhNHpShfRlMjhm7jfFEn/ntrSFazfny6ZSK6WO0Q
	 faysoX6sMeFOJBOxLpLxvziffJIgNX+wDMGQqHSiJObBne3N9Rap0cgl1ixRZ7JkZIRcV
	 Df0te8OkdTPBenKM3wwcuo20LE8ZC0kv2cGtqJakn3Jsi9qw7WUIE/22sDvxVSLStrqYv
	 QLwokUQOdPyLQzEa0jXuxO56WkNWuu6lWydG3ETa2jtXJAhRJR5p6dT5pTMiF/alB0VcD
	 xQTcZDRsCuRf98KdXtunUVOTkVxfGCxI9FmNIgNCGArg/29JdMNl3qVqsvwOn1pqHBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K6rl0+8Tx5GcaqoEuxXMAcaZLgp5RkgENrHn4pIUXag=;
	b=bAsVD5zTbRG2xlVjmZP4TBvwEJmn+WdKuOxHqyREheN7ttGKl5R9z2K37+VCGixcWskE
	 5Jg7dJP8SsIvniez6M30Xc4H+37Bc99gQ1z6SobYvWs97rKarlNyLmxyNcmnxsxfaqdbt
	 yme1VjsUnFddDmXhWJXmvc35CjAMSuJDsr5seVG2BBOtbTN6E8m24eJM4wacKZpmq+puv
	 8AIw9U1+DcH2reeG016MgpUBXOSfe6ZVxvNIcHHiock4TJLgeanFoCwjt2ZGN19+OvnrN
	 lJIiyL2sWGlAKA1zBAR/6eNQYIuZvR3Z4nRtOg3SeoPMAyQK1OIXoFQ0wjq0D4qHVRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPLNqvcy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD879606A32D;
	Wed,  4 Nov 2026 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPLNqvcy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DAC1F000C1;
	Wed,  4 Nov 2026 21:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828851;
	bh=K6rl0+8Tx5GcaqoEuxXMAcaZLgp5RkgENrHn4pIUXag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPLNqvcyBxSTLgelsB7DpgFNyl7VSXS+KRWJwG+lQ+IS071xzWWO2RwrYdQo0DZ0e
	 c1yEUh/I1k5ljMrH4NAKuuKf/GQVKwq7M1j1F2+dJGVphr3FSEZdRde0Ite9yRfjDd
	 qYJnpUZMqj6ysFhYoRDB1gI/e6KjKiX22rHReaCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 263/547] media: rc: Ensure registered is cleared in error path
Date: Wed,  4 Nov 2026 16:07:27 -0500
Message-ID: <20261104211045.664031124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 37efd09ba2c62e46e3a3a793025c186f8cd1a417 upstream.

If rc_register_device() fails, ensure that registered is not set to true.
If lirc_register() succeeded, then userspace could have an open file
descriptor open. This leads to a use-after-free.

lirc_unregister() must be called with registered = false, else there is a
possibility that an fd is open and polling, which would never return
POLLERR unless registered is false.

Note that registered must be changed under dev->lock, many functions
read registered under lock (e.g. lirc_ioctl).

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1929,7 +1929,8 @@ int rc_register_device(struct rc_dev *de
 			goto out_raw;
 	}
 
-	dev->registered = true;
+	scoped_guard(mutex, &dev->lock)
+		dev->registered = true;
 
 	rc = device_add(&dev->dev);
 	if (rc)
@@ -1949,7 +1950,7 @@ int rc_register_device(struct rc_dev *de
 	if (dev->allowed_protocols != RC_PROTO_BIT_CEC) {
 		rc = lirc_register(dev);
 		if (rc < 0)
-			goto out_dev;
+			goto out_lirc;
 	}
 
 	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
@@ -1972,11 +1973,18 @@ int rc_register_device(struct rc_dev *de
 out_rx:
 	rc_free_rx_device(dev);
 out_lirc:
-	if (dev->allowed_protocols != RC_PROTO_BIT_CEC)
+	scoped_guard(mutex, &dev->lock)
+		dev->registered = false;
+
+	if (device_is_registered(&dev->lirc_dev))
 		lirc_unregister(dev);
-out_dev:
 	device_del(&dev->dev);
+	/* registered already cleared above */
+	goto out_free_table;
 out_rx_free:
+	scoped_guard(mutex, &dev->lock)
+		dev->registered = false;
+out_free_table:
 	ir_free_table(&dev->rc_map);
 out_raw:
 	ir_raw_event_free(dev);


