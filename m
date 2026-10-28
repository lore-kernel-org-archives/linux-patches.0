Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211192;
	b=R8rDgw4nIxcKHmozxqFrZdxhS2uKyd+ddAig7ifttSikvJ4YqgIIrOh9cx1k+Zzh2QJT
	 ueGvlJ1D5p8D46oYRJUGl0yYJEt9Z3QSSYSjaq6LztXB1RbxG39f+I24ePIt38LHPfafy
	 UiSl95BPEwTbIMTFp0jt7+5eScNKHJUw88chT8h9dHWzNQgcCBVz3DzxjB0x9mz1dKMJq
	 BRSNkGPkTknnm3J7a8Pic3dtC99rUQejZ9Z0FvivvJpkUpK3yxHd/kVyWoso5PNM27ouj
	 4Kz52ATtVkxNVk2o454et+exTz81t2v3wKk+mEZhRdLyrfcaMIO0KQHM7PL38zRRcvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SMzxg5AVbdhIdYvb8WS2XaykdCnfjyPGkEwhE6YokOM=;
	b=bbHatQYpCWMB+VBFlm8WnCXDDCrMfjfce52vuIHZ3JR0M8z35ua51IfX2dFysnRF+jGI
	 vaKZf5ih1WCxnRHiRFA2w/MuX1j0+u8hiDVx2bdxLbXzjTcWrItWfxDAKTTkl/4EfC8Wq
	 wGWqiEojHHLSelrkrS33zwHol7hh0CsbmUYFM33vQSuRebnH33KTb0fBtvGLM0MKUVPp0
	 3nsL2fMiGLfpJSI8UAhh5qtnZoV5JItB5nBuyq6Nk9+7VxHqDGcBl5GY1tcF86R8l7JXB
	 V3JzFkOhMtU6am5Io2HDooIJSbLaWxmQDNxI9ZeZssYeXU7DVxyDC22y8gWO5XoqrqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cx0EqGNS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA7460A6F62;
	Wed, 28 Oct 2026 18:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cx0EqGNS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ECD1F01829;
	Wed, 28 Oct 2026 18:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211191;
	bh=SMzxg5AVbdhIdYvb8WS2XaykdCnfjyPGkEwhE6YokOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cx0EqGNSQ13BLotsw4+5oClKKMM0xxzqNC8dMSsoLPJiuGMudJIIj9jYUiRbG/EuB
	 o3HJOfDqD874rRPUJmJSi/b8rBb7LujGo49J5aowNH+jp/wLfLUxDw/tuWP0+Ppvds
	 LL26Po56y2f0EV0K4Eg4EVh6OVY9YccxBaj1oCBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 291/571] tty: fix saved termios reset race
Date: Wed, 28 Oct 2026 17:57:18 +0100
Message-ID: <20261028170014.905327780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the new flag to hexadecimal macro definitions and Greybus’s existing post-allocation flags assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/uart.c  |  3 ++-
 drivers/tty/tty_io.c            | 18 ++++++++++--------
 drivers/usb/class/cdc-acm.c     |  2 +-
 drivers/usb/serial/usb-serial.c |  3 ++-
 include/linux/tty_driver.h      |  5 +++++
 5 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index dc4ed0ff1ae27..51fab4f3ea1ae 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -960,7 +960,8 @@ static int gb_tty_init(void)
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
index d63ab274ff4a2..6a0f8c3884977 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3294,14 +3294,16 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
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
index dc40b7ea40d4c..2d6817242d350 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -2084,7 +2084,7 @@ static int __init acm_init(void)
 {
 	int retval;
 	acm_tty_driver = tty_alloc_driver(ACM_TTY_MINORS, TTY_DRIVER_REAL_RAW |
-			TTY_DRIVER_DYNAMIC_DEV);
+			TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_RESET_SAVED_TERMIOS);
 	if (IS_ERR(acm_tty_driver))
 		return PTR_ERR(acm_tty_driver);
 	acm_tty_driver->driver_name = "acm",
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 1a94abe09433c..97a031033e946 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1325,7 +1325,8 @@ static int __init usb_serial_init(void)
 	int result;
 
 	usb_serial_tty_driver = tty_alloc_driver(USB_SERIAL_TTY_MINORS,
-			TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV);
+			TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV |
+			TTY_DRIVER_RESET_SAVED_TERMIOS);
 	if (IS_ERR(usb_serial_tty_driver))
 		return PTR_ERR(usb_serial_tty_driver);
 
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index c20431d8def8f..aa0564b34fd79 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -395,6 +395,10 @@ static inline void tty_set_operations(struct tty_driver *driver,
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
@@ -404,6 +408,7 @@ static inline void tty_set_operations(struct tty_driver *driver,
 #define TTY_DRIVER_HARDWARE_BREAK	0x0020
 #define TTY_DRIVER_DYNAMIC_ALLOC	0x0040
 #define TTY_DRIVER_UNNUMBERED_NODE	0x0080
+#define TTY_DRIVER_RESET_SAVED_TERMIOS	0x0200
 
 /* tty driver types */
 #define TTY_DRIVER_TYPE_SYSTEM		0x0001
-- 
2.53.0



