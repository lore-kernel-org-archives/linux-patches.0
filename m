Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212911;
	b=oT0NQBryYji5Sj+l2ocjEJeVPX/0lbjLqkVkFmqTeaKXur5leaqjhkLrvRJl8T3triQv
	 oQgicsJ9poJyZ77MKFLI6S+TCDhFlRIpZ8/5brqaELZVGwPOBYIXroWuDa7YC6NL537sk
	 9pHHK1C18JMD2bzW68iJSXz8wtdksi3fc4dJsH3erDk3fPZntTQsWzx4bi03PWTjXbDOE
	 goVc7jR/A0vNDvzyrpo30lCJQKZejbI2gdnd520s3jLlUS/fRu7haqD4ln+eG/oO1/iSK
	 htTSuEUwLXCtEzvLG9Iwrah58o05I85RpaAKGAr8zIA8EWUa+KnUl17mnke4ZyhYA6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z6LSc6xmNOo/J10OGrfD0NuuREudgkxrv6qhnn75OeU=;
	b=HdXGajy2fR6qeKR4vM2ggGr1ma+c21L1hnV1tI2Coa43WPqVXPDtcqpNxLH5VZUvE9DR
	 eUrlQII2ecQSzRCzufK6hE1M9kCBqbSFYtcyqu5EMjzmLHHiJhn3n4hI1RneVn4eWVHAJ
	 xI3iVqVSCZjhEU+ylFx4rSRMRf+spKgQOG684hOhQ5Sq6Y79q8orwIIKeHfNA27uoH+PH
	 I0wHL8mZnX/rtb4VPxlhVGTD/b8iowCBzSbDLo4iwMagSH4l1LOLsoofxdBWEdeV4U9kU
	 lOdRgXyV4TleB7c1XZtqD5NwYELVLkb9pAVKIrfOt/7pmmcRM5rnJwCqAsQd3zEkm8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msauKHpw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E5260A2600;
	Wed, 28 Oct 2026 18:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msauKHpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4701F01825;
	Wed, 28 Oct 2026 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212910;
	bh=z6LSc6xmNOo/J10OGrfD0NuuREudgkxrv6qhnn75OeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msauKHpwyQ4omOPshOigWMZLDgBdCfP/unyCFVl7Tsymkcl2DuAFqcOLcLdvV1LEQ
	 MKx6PyQQr+tqKJI6Xz/kXL5AQxiXClvbh1OhSfBsZQodI+uv9R4vB2Wi7K10ZRfhjx
	 x1hS9F+NJh2uab1uVbaacWX9C6BK8GfIeGFxyyW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Pemberton <wfp5p@virginia.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0320/1887] USB: serial: quatech2: fix baud rate overflow
Date: Wed, 28 Oct 2026 17:40:16 +0100
Message-ID: <20261028170506.510058309@linuxfoundation.org>
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

commit ec06546b43b612cefc851558981b4955c0ef9e46 upstream.

The requested baud rate is incorrectly truncated to 16 bits so that
line speeds above 65535 bps cannot be set.

Use 32 bits for the rate while rejecting rates outside of
[50,921600] to avoid having the 16-bit divisor overflow.

Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Cc: stable@vger.kernel.org	# 3.5
Cc: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/quatech2.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -54,6 +54,7 @@
 #define QT2_XMIT_FLUSH      0x05  /* no following info */
 #define QT2_CONTROL_ESCAPE  0xff  /* pass through previous 2 control bytes */
 
+#define  MIN_BAUD_RATE              50
 #define  MAX_BAUD_RATE              921600
 #define  DEFAULT_BAUD_RATE          9600
 
@@ -158,7 +159,7 @@ static inline int calc_baud_divisor(int
 
 static inline int qt2_set_port_config(struct usb_device *dev,
 				      unsigned char port_number,
-				      u16 baudrate, u16 lcr)
+				      speed_t baudrate, u16 lcr)
 {
 	int divisor = calc_baud_divisor(baudrate);
 	u16 index = ((u16) (lcr << 8) | (u16) (port_number));
@@ -267,9 +268,9 @@ static void qt2_set_termios(struct tty_s
 	struct usb_device *dev = port->serial->dev;
 	struct qt2_port_private *port_priv;
 	struct ktermios *termios = &tty->termios;
-	u16 baud;
 	unsigned int cflag = termios->c_cflag;
 	u16 new_lcr = 0;
+	speed_t baud;
 	int status;
 
 	port_priv = usb_get_serial_port_data(port);
@@ -287,6 +288,18 @@ static void qt2_set_termios(struct tty_s
 	if (!baud)
 		baud = 9600;
 
+	if (baud < MIN_BAUD_RATE || baud > MAX_BAUD_RATE) {
+		if (old_termios)
+			baud = tty_termios_baud_rate(old_termios);
+		else
+			baud = clamp(baud, MIN_BAUD_RATE, MAX_BAUD_RATE);
+
+		tty_encode_baud_rate(tty, baud, baud);
+
+		if (!baud)
+			baud = 9600;
+	}
+
 	status = qt2_set_port_config(dev, port_priv->device_port, baud,
 				     new_lcr);
 	if (status < 0)
@@ -383,7 +396,7 @@ static int qt2_open(struct tty_struct *t
 	port_priv->device_port = (u8) device_port;
 
 	if (tty)
-		qt2_set_termios(tty, port, &tty->termios);
+		qt2_set_termios(tty, port, NULL);
 
 	return 0;
 


