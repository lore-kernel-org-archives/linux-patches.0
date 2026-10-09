Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311D545A2BC;
	Fri,  9 Oct 2026 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556816; cv=none; b=NuTVEwsQJecigEOWfkci/HZ5dvOzBLHLMs3MNwlsE4u/swCtvrqx8J7rLsiW9QoYLvgkEoC3uU/7gKIFg5C2W967IvYi5KKgHxTqB81xY0l85veIAhQU6CBW7kGwOLmbSta7o4SNMkxC64kD5H9qI+FmfuWULCXkXdgnaahvUG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556816; c=relaxed/simple;
	bh=uD8pKNp4lPekT6qocj2Hh9+IvM6IobqV6T+cH1NpApY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSWAQ9g+8v9tuKR9dBfR1U4GS3Hjpw+BHD5bxU+YqxjAeEzVt/FIoF0Z1TG+IUyQoz550i4CZJX/f8ic2SVc4j92NMO2MNYAhHTO1ZlHOET33DSdYUs1NmegvqAHrB12ucYSuVnjJmN5wxa4jlUOimm0obbn5pH2dSgWDJzLP2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZQZKw3g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZQZKw3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DDD1F00893;
	Fri,  9 Oct 2026 14:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556815;
	bh=jIoUdTphj9nRyimTYtiEH/TB5L4sQyZyFKGOD0DcMK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZQZKw3g6dlKKlTTpTR6/SVCdjulRzdU+Q+QPkFoRaH0ZivBdKViP/4gPNE6oI/K5
	 fgAJus8jdVHVS20AVJ5D/tsAyQNTb8o/Pl8lkAdrqwPQe1FImXTb4KLUnc3qATcbDK
	 1r06TREyIuJ6KHRal9tljZNLgeshOzG2TJIhpgQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	stable@kernel.org
Subject: [PATCH 7.2 246/428] tty: fix saved termios reset race
Date: Fri,  9 Oct 2026 16:09:43 +0200
Message-ID: <20261009140951.511080964@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 8df07fe93573e9e548d6645273e9bcb6eb74059e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/uart.c  |    3 ++-
 drivers/tty/tty_io.c            |   18 ++++++++++--------
 drivers/usb/class/cdc-acm.c     |    2 +-
 drivers/usb/serial/usb-serial.c |    3 ++-
 include/linux/tty_driver.h      |    6 ++++++
 5 files changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -948,7 +948,8 @@ static int gb_tty_init(void)
 	int retval = 0;
 
 	gb_tty_driver = tty_alloc_driver(GB_NUM_MINORS, TTY_DRIVER_REAL_RAW |
-					 TTY_DRIVER_DYNAMIC_DEV);
+					 TTY_DRIVER_DYNAMIC_DEV |
+					 TTY_DRIVER_RESET_SAVED_TERMIOS);
 	if (IS_ERR(gb_tty_driver)) {
 		pr_err("Can not allocate tty driver\n");
 		retval = -ENOMEM;
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3283,14 +3283,16 @@ struct device *tty_register_device_attr(
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
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -2145,7 +2145,7 @@ static int __init acm_init(void)
 {
 	int retval;
 	acm_tty_driver = tty_alloc_driver(ACM_TTY_MINORS, TTY_DRIVER_REAL_RAW |
-			TTY_DRIVER_DYNAMIC_DEV);
+			TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_RESET_SAVED_TERMIOS);
 	if (IS_ERR(acm_tty_driver))
 		return PTR_ERR(acm_tty_driver);
 	acm_tty_driver->driver_name = "acm",
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1318,7 +1318,8 @@ static int __init usb_serial_init(void)
 	int result;
 
 	usb_serial_tty_driver = tty_alloc_driver(USB_SERIAL_TTY_MINORS,
-			TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV);
+			TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV |
+			TTY_DRIVER_RESET_SAVED_TERMIOS);
 	if (IS_ERR(usb_serial_tty_driver))
 		return PTR_ERR(usb_serial_tty_driver);
 
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -73,6 +73,11 @@ struct serial_struct;
  * @TTY_DRIVER_NO_WORKQUEUE:
  *	Do not create workqueue when tty_register_driver(). Whenever set, flip
  *	buffer workqueue can be set by tty_port_link_wq() for every port.
+ *
+ * @TTY_DRIVER_RESET_SAVED_TERMIOS
+ *	Reset any saved termios settings on device registration when reusing a
+ *	minor number. Must only be set by drivers that guarantee that the minor
+ *	number is no longer in use.
  */
 enum tty_driver_flag {
 	TTY_DRIVER_INSTALLED		= BIT(0),
@@ -84,6 +89,7 @@ enum tty_driver_flag {
 	TTY_DRIVER_DYNAMIC_ALLOC	= BIT(6),
 	TTY_DRIVER_UNNUMBERED_NODE	= BIT(7),
 	TTY_DRIVER_NO_WORKQUEUE		= BIT(8),
+	TTY_DRIVER_RESET_SAVED_TERMIOS	= BIT(9),
 };
 
 enum tty_driver_type {


