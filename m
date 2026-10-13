Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBE24FD262;
	Tue, 13 Oct 2026 12:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895266; cv=none; b=cVIiGt92yCUXfWwWmotsBhKryrUyXavfG/k8xyO0oypAgTNEfJEM7xmjNgN6ruGMLgEjQQWvhbLMF/IHRV5zz0Y/jzmOSC6uXsk/BQ8mVpluCQZ2+KDE/Jw9eee9eNXjWnH3DQcp/SDaxE/JqlPmi7Tq7HPR4V/IOoDVPnHNRxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895266; c=relaxed/simple;
	bh=cB5rOorGfaCpYqsjRnnv/RZYeQqIjdsjrqrNuHR/ICM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZMwPBXhJPv4vu+g+mkDCUX4oQcTyuLZRubV3gO7V8GhhPgsSrw0T3FrmjucvdGrqKOUiGSCp44od1w8yg4o1L8T+1VQY0xNSJbZ9dtCznhXMmlFXQAR3AfvOihQ0fF8cwYQDPyKMugh7Bg5zxtUGS3n5wzennYyIfUhR7cg+PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1qMylbJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1qMylbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0AA1F000FF;
	Tue, 13 Oct 2026 12:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895264;
	bh=poMvu9690TH//NQGPBCAIaog1Ainf89Gdx9F+8ptFzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1qMylbJzZTB7YTD1PvcgrH0nvTLS0QqZBN1jRode9h8qH4Jxr+FskGRHQHdFN22m
	 P85PVnZsBQL7ZYRPehfBCHhA44HidG9vO7p6LlXO0y6xjNaO3RpmJRkoV/6EfUu+Ca
	 zotLAVPX2cdfyCWglNv2r7SYSUSF14TnMBYi9f0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Pemberton <wfp5p@virginia.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 215/497] USB: serial: quatech2: fix baud rate overflow
Date: Tue, 13 Oct 2026 13:36:22 +0200
Message-ID: <20261013112912.997066104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -259,9 +260,9 @@ static void qt2_set_termios(struct tty_s
 	struct usb_device *dev = port->serial->dev;
 	struct qt2_port_private *port_priv;
 	struct ktermios *termios = &tty->termios;
-	u16 baud;
 	unsigned int cflag = termios->c_cflag;
 	u16 new_lcr = 0;
+	speed_t baud;
 	int status;
 
 	port_priv = usb_get_serial_port_data(port);
@@ -279,6 +280,18 @@ static void qt2_set_termios(struct tty_s
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
@@ -375,7 +388,7 @@ static int qt2_open(struct tty_struct *t
 	port_priv->device_port = (u8) device_port;
 
 	if (tty)
-		qt2_set_termios(tty, port, &tty->termios);
+		qt2_set_termios(tty, port, NULL);
 
 	return 0;
 


