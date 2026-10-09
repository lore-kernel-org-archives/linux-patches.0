Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B1F3D1AA6;
	Fri,  9 Oct 2026 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557342; cv=none; b=u+W7v+CQJ95KdHyLFl5/kU0fVB2S1sePdLaj0579nJ3ralvJ030C42XvMFVtc9RmKctuqgDXABGsJI2Kh+IZ76kRoKUxNalSc1pvJKmG0wlq982ihU25HVQmb0WqqN1My0IOTx58UsGSslSbnmEFmF++B2A3BeDt7uZewxFYHPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557342; c=relaxed/simple;
	bh=9W/3T3bqmwM/NO6BDYNwnN4Nl+EMbKSAtyMjn6+29SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTFBIVAH/LJsCVPkBgngcHaPc9yrBCvRQ7H+QoAOwqBbFTP3t4lOv3J8DhKF4kdPD8oPFzrFNTE+ZZkqOP/CXw7SJRZODXwb1Z2XpiBmJ/nw6Bs+2hPyXnf/j/8ltD1KDNhf6Lz7tJrUOdM1NuEUZPnU9eBqqvQIe8NZ1qTBENw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibPt9RFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibPt9RFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC351F000FF;
	Fri,  9 Oct 2026 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557340;
	bh=GAaokJJHxnAvZCAW6fJLe0fVKMDlVny55ID3nTcKl9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibPt9RFkP/zHcZsJdFz83dkpDchW2+NHOxmhl7lX/XDfe4ZSlIbZq24VM6MzliDik
	 tzlxqKQ+kYcWvuRSQJRXyx0D93TG0KG/pQXnscStmj8U/khhep6t6/ycHCa/GHYhJV
	 /swGr0VUW9qBbwnh3gkl2aHPMCJzPwCTdbwAI8rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Pemberton <wfp5p@virginia.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 340/428] USB: serial: quatech2: fix baud rate overflow
Date: Fri,  9 Oct 2026 16:11:17 +0200
Message-ID: <20261009140953.617754119@linuxfoundation.org>
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
@@ -52,6 +52,7 @@
 #define QT2_XMIT_FLUSH      0x05  /* no following info */
 #define QT2_CONTROL_ESCAPE  0xff  /* pass through previous 2 control bytes */
 
+#define  MIN_BAUD_RATE              50
 #define  MAX_BAUD_RATE              921600
 #define  DEFAULT_BAUD_RATE          9600
 
@@ -156,7 +157,7 @@ static inline int calc_baud_divisor(int
 
 static inline int qt2_set_port_config(struct usb_device *dev,
 				      unsigned char port_number,
-				      u16 baudrate, u16 lcr)
+				      speed_t baudrate, u16 lcr)
 {
 	int divisor = calc_baud_divisor(baudrate);
 	u16 index = ((u16) (lcr << 8) | (u16) (port_number));
@@ -257,9 +258,9 @@ static void qt2_set_termios(struct tty_s
 	struct usb_device *dev = port->serial->dev;
 	struct qt2_port_private *port_priv;
 	struct ktermios *termios = &tty->termios;
-	u16 baud;
 	unsigned int cflag = termios->c_cflag;
 	u16 new_lcr = 0;
+	speed_t baud;
 	int status;
 
 	port_priv = usb_get_serial_port_data(port);
@@ -277,6 +278,18 @@ static void qt2_set_termios(struct tty_s
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
@@ -373,7 +386,7 @@ static int qt2_open(struct tty_struct *t
 	port_priv->device_port = (u8) device_port;
 
 	if (tty)
-		qt2_set_termios(tty, port, &tty->termios);
+		qt2_set_termios(tty, port, NULL);
 
 	return 0;
 


