Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213067;
	b=ZVpwinCwcx60eUGl8riqX4C4ZeiTi8dBBI7ItOYXnqfx6RLbaCtvcjBurqhGxHr++rJa
	 KQrd+GCYtfLH6EMRrZVDMnqYeZF7bscd7OWarQSvJjNaegx83upo6b6B0sMCQKQWLVRAJ
	 3d6Sf1Wbw0aKf7szNEKgfwN78Ehu5HaToG3q9JlLSp7ie0EiMQLytCmMh9GMV7XouIy49
	 bCE/stqhI0kYWBaSY+ggkHDB+GRxiLiZblsBxOKt2s/OURd0DqGb+MV8mtr7As+7VFjMG
	 PYfHAKB46lnKhpTNXSBuFDuzbrOZsLnVVDdznFgSnWLBZZQhXFdEx23dzPtKQ0Q6n+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PzphCA+gxVZIdOiCHUllnQIQd2njzBoK+zUMi5K+39w=;
	b=II0dHGjftBpdtLihhzUdI0VSEWPx1ZqHEZ3uzA5AV57ESxlNbiU7bO3lU64Hp2T5Zg60
	 kN9Ur29PPgN1dqtR6v6JThHDioYljGq7nzDGO1tlKLUR8SDHPDxbiQ76RW4nC3M+L/riS
	 r6dPEJDi2mMhVEvl7E3W2Fu4tOHJ4FTKU0/whK8GP6GC405lehiygUt84HOHr3gIfBI6f
	 IJx1fhp9MOh7m0/NgqfW+y2F3VUxS+dALMOR3iH+uCu9Yg0t6jI7SVyAuxzBmOvBvHTvt
	 LG/jR0fCYMi8g6IMlBvQy3w055nRsZ9zXVlFJ0nrE698yBBRlIVr9CGsOl0RPHr1dYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLpguTfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB5C606A31A;
	Wed, 28 Oct 2026 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLpguTfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7C21F01825;
	Wed, 28 Oct 2026 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213067;
	bh=PzphCA+gxVZIdOiCHUllnQIQd2njzBoK+zUMi5K+39w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLpguTfNwSIxmtY0GBlNM5u3QXBFFtWLn2TCez5ioKM6WFga186666V6sv09TBs6e
	 SjX3xXlDQI6rLQS3eFaEjjDHAraeOtl9mRzTGvKzznk9Ev+W1f/LQhSOBUEjHUdJcK
	 Ed5LyZZkK37i+gsNs+q85Yx91ZDgV7ADg4q5xTvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.1 0374/1887] tty: fix saved termios reset race
Date: Wed, 28 Oct 2026 17:41:10 +0100
Message-ID: <20261028170507.742785870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted flag handling to use a hexadecimal macro assigned through gb_tty_driver->flags. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/uart.c  |  3 ++-
 drivers/tty/tty_io.c            | 18 ++++++++++--------
 drivers/usb/class/cdc-acm.c     |  2 +-
 drivers/usb/serial/usb-serial.c |  3 ++-
 include/linux/tty_driver.h      |  6 ++++++
 5 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 074c02f123e20..0bdef38a15d72 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -954,7 +954,8 @@ static int gb_tty_init(void)
 	gb_tty_driver->minor_start = 0;
 	gb_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	gb_tty_driver->subtype = SERIAL_TYPE_NORMAL;
-	gb_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	gb_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV |
+			       TTY_DRIVER_RESET_SAVED_TERMIOS;
 	gb_tty_driver->init_termios = tty_std_termios;
 	gb_tty_driver->init_termios.c_cflag = B9600 | CS8 |
 		CREAD | HUPCL | CLOCAL;
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index dd5e8a850f6ec..4124603a0b44f 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3272,14 +3272,16 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
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
index bbb31a074c35e..80e86fa38eabe 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -2119,7 +2119,7 @@ static int __init acm_init(void)
 {
 	int retval;
 	acm_tty_driver = tty_alloc_driver(ACM_TTY_MINORS, TTY_DRIVER_REAL_RAW |
-			TTY_DRIVER_DYNAMIC_DEV);
+			TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_RESET_SAVED_TERMIOS);
 	if (IS_ERR(acm_tty_driver))
 		return PTR_ERR(acm_tty_driver);
 	acm_tty_driver->driver_name = "acm",
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 2b3b7b10f7382..eb3c9f626e5d6 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1321,7 +1321,8 @@ static int __init usb_serial_init(void)
 	int result;
 
 	usb_serial_tty_driver = tty_alloc_driver(USB_SERIAL_TTY_MINORS,
-			TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV);
+			TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV |
+			TTY_DRIVER_RESET_SAVED_TERMIOS);
 	if (IS_ERR(usb_serial_tty_driver))
 		return PTR_ERR(usb_serial_tty_driver);
 
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index ff5791373cf96..1e5241b823856 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -542,6 +542,11 @@ static inline void tty_set_operations(struct tty_driver *driver,
  *	Do not create numbered ``/dev`` nodes. For example, create
  *	``/dev/ttyprintk`` and not ``/dev/ttyprintk0``. Applicable only when a
  *	driver for a single tty device is being allocated.
+ *
+ * TTY_DRIVER_RESET_SAVED_TERMIOS
+ *	Reset any saved termios settings on device registration when reusing a
+ *	minor number. Must only be set by drivers that guarantee that the minor
+ *	number is no longer in use.
  */
 #define TTY_DRIVER_INSTALLED		0x0001
 #define TTY_DRIVER_RESET_TERMIOS	0x0002
@@ -551,6 +556,7 @@ static inline void tty_set_operations(struct tty_driver *driver,
 #define TTY_DRIVER_HARDWARE_BREAK	0x0020
 #define TTY_DRIVER_DYNAMIC_ALLOC	0x0040
 #define TTY_DRIVER_UNNUMBERED_NODE	0x0080
+#define TTY_DRIVER_RESET_SAVED_TERMIOS	0x0200
 
 /* tty driver types */
 #define TTY_DRIVER_TYPE_SYSTEM		0x0001
-- 
2.53.0



