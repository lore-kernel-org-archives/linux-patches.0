Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208869;
	b=GTHsB6bo78oRfZOjU2VvOdhqYFNY2Mm3YpZCk2eZzK+RzgvOMXxWt91Ss2Bhl0sj+kWT
	 yl9CuS5q0Lmct0/8+W6rAz/kwV7bKkIZGYb9hYWoA5Y/OY4ygKSKJATEkb43knlEtLM1p
	 1sW6fMQpuKajfp/5078K3WoTtpkfVAyUpFdHYpFfThKsheOEsjiTbIF0LPYiUGU70YVvd
	 SmVd4VVBAdkqpU2brPG9Vx6GGE1HjTDu1Rs3f8WMQf9wZbYSY4mNi9/zTpr4M1sytVS2o
	 5ja1wFMMJqseb3I1vFJJYCpWFbngZGMkZJwcgx7IbAuKi11JMBzEraPTJXHUsl3y9Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GFbq5T5rk7EWNIa2Ibv/jU9hI09468GC4iYJtJ5vEkE=;
	b=xYh2+etgCSDYWNOM09nH/NnXLAHRUp43veCp2OdcjM3SPuORh0eemjNL3b3271Z5gGQq
	 10CxVJHHHlnHZFpvz2EF2MjtBT5zmFcfoiHLiuoSBZOPrpImpxxL6hYisu83jO2lQJcmG
	 k1g8Cihw2gYWTGLxbT30HSIPD5LJkDAMx/bZPUR9WFsQ0BluaBeaho+2ygDrTmcQpI0x/
	 8CpG+mJT4ww+mSKo77PdDpCcWi9DzQCbbxqV/xGc+dxAjS1UYkQ5jYjV5/eYucS993v3X
	 5OLkSO45szBjhbKr0j8OHq3lg8JfNUV0h5/Vh3/JPM6M98UbZlXWEZ1TpUWQDghk7DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6Y3JCml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6006D606A31D;
	Wed, 28 Oct 2026 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6Y3JCml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13451F01825;
	Wed, 28 Oct 2026 17:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208869;
	bh=GFbq5T5rk7EWNIa2Ibv/jU9hI09468GC4iYJtJ5vEkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6Y3JCml7tm3MC95emDVuh4ACDyUp7fRjKLf5FWarII9Ug10wKGbZy6D2pG57vsRG
	 JE+fA6A5MTTt8ep+UHGn0J6EHZSsoFnDOeFnteDfZps0GJAIvK41RIDUcH6JpVqoOS
	 qL1iDSFHcCGtIvChPa8fYase/YrijFjktYpoQuTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.10 270/516] tty: fix saved termios reset race
Date: Wed, 28 Oct 2026 17:57:02 +0100
Message-ID: <20261028170009.888735758@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 8df07fe93573e9e548d6645273e9bcb6eb74059e ]

Resetting saved termios state on device registration is needed where a
minor number can be reused for an entirely different device and where
the old settings may prevent the port from even being opened (e.g. when
CLOCAL is not set).

Not all TTY drivers guarantee that the minor number is no longer in use
when registering devices however, something which can lead to a
use-after-free when closing a TTY (and saving its termios) races with
re-registration.

Add a new TTY_DRIVER_RESET_SAVED_TERMIOS flag to request that any saved
termios state is reset on registration and only set it for drivers that
make sure that the minor number is no longer in use.

Fixes: 93857edd9829 ("tty: reset termios state on device registration")
Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Link: https://lore.kernel.org/20260926184154.3017929-1-nicoyip.dev@gmail.com
Cc: stable@kernel.org	# 4.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260930131845.1809256-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adapted the new flag to existing driver->flags assignments and hexadecimal #define conventions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/uart.c  |  3 ++-
 drivers/tty/tty_io.c            | 18 ++++++++++--------
 drivers/usb/class/cdc-acm.c     |  3 ++-
 drivers/usb/serial/usb-serial.c |  3 ++-
 include/linux/tty_driver.h      |  5 +++++
 5 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 5cdc5dff9f55b..2a88314058a86 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -974,7 +974,8 @@ static int gb_tty_init(void)
 	gb_tty_driver->minor_start = 0;
 	gb_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	gb_tty_driver->subtype = SERIAL_TYPE_NORMAL;
-	gb_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	gb_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV |
+			      TTY_DRIVER_RESET_SAVED_TERMIOS;
 	gb_tty_driver->init_termios = tty_std_termios;
 	gb_tty_driver->init_termios.c_cflag = B9600 | CS8 |
 		CREAD | HUPCL | CLOCAL;
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index f0d36f992616f..d6322a1493861 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3244,14 +3244,16 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
 		goto err_put;
 
 	if (!(driver->flags & TTY_DRIVER_DYNAMIC_ALLOC)) {
-		/*
-		 * Free any saved termios data so that the termios state is
-		 * reset when reusing a minor number.
-		 */
-		tp = driver->termios[index];
-		if (tp) {
-			driver->termios[index] = NULL;
-			kfree(tp);
+		if (driver->flags & TTY_DRIVER_RESET_SAVED_TERMIOS) {
+			/*
+			 * Free any saved termios data so that the termios
+			 * state is reset when reusing a minor number.
+			 */
+			tp = driver->termios[index];
+			if (tp) {
+				driver->termios[index] = NULL;
+				kfree(tp);
+			}
 		}
 
 		retval = tty_cdev_add(driver, devt, index, 1);
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 6b60b4dd508ca..b49b25d055a5a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -2094,7 +2094,8 @@ static int __init acm_init(void)
 	acm_tty_driver->minor_start = 0,
 	acm_tty_driver->type = TTY_DRIVER_TYPE_SERIAL,
 	acm_tty_driver->subtype = SERIAL_TYPE_NORMAL,
-	acm_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	acm_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV |
+			       TTY_DRIVER_RESET_SAVED_TERMIOS;
 	acm_tty_driver->init_termios = tty_std_termios;
 	acm_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD |
 								HUPCL | CLOCAL;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 98797c2b96ca2..38980e851667a 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1232,7 +1232,8 @@ static int __init usb_serial_init(void)
 	usb_serial_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	usb_serial_tty_driver->subtype = SERIAL_TYPE_NORMAL;
 	usb_serial_tty_driver->flags = TTY_DRIVER_REAL_RAW |
-						TTY_DRIVER_DYNAMIC_DEV;
+				      TTY_DRIVER_DYNAMIC_DEV |
+				      TTY_DRIVER_RESET_SAVED_TERMIOS;
 	usb_serial_tty_driver->init_termios = tty_std_termios;
 	usb_serial_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD
 							| HUPCL | CLOCAL;
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 2f719b471d524..dd76a4139fbcd 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -403,6 +403,10 @@ static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
  *	other words create /dev/ttyprintk and not /dev/ttyprintk0.
  *	Applicable only when a driver for a single tty device is
  *	being allocated.
+ *
+ * TTY_DRIVER_RESET_SAVED_TERMIOS -- reset any saved termios settings on
+ *	device registration when reusing a minor number. Must only be set by
+ *	drivers that guarantee that the minor number is no longer in use.
  */
 #define TTY_DRIVER_INSTALLED		0x0001
 #define TTY_DRIVER_RESET_TERMIOS	0x0002
@@ -412,6 +416,7 @@ static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
 #define TTY_DRIVER_HARDWARE_BREAK	0x0020
 #define TTY_DRIVER_DYNAMIC_ALLOC	0x0040
 #define TTY_DRIVER_UNNUMBERED_NODE	0x0080
+#define TTY_DRIVER_RESET_SAVED_TERMIOS	0x0200
 
 /* tty driver types */
 #define TTY_DRIVER_TYPE_SYSTEM		0x0001
-- 
2.53.0



