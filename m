Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1704CCDC0;
	Fri,  9 Oct 2026 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556707; cv=none; b=RplRI6gZ33tENP56XiK/RUa5OT4G86c26vLvcDqJoi9ZkBCcuYj+dXrAxkKNrm65+q7ZxSxYfY1GnYGB7L0AVGsDp1yLLDnVhfm2byPeLL9xClArv+0qhd8esULN2TUoJrnn9DjmuLraR3rKKDvEHc0bymQKViRrReFLQgP85v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556707; c=relaxed/simple;
	bh=+NRwcFpIwDbicrff6iD7PT18xe9jqjRwE0Rjg626QOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3OGsr/NkDEwFlLfPKcrFTC2oZMKJFDYBwjpkgrqOuvxaa2vn/IG7o+HxF9wDS/tJ00uMRuhbU2Fw2egZSsDhHKOSqszexuy3p66RRaJlu70kepAPkhiYetDAggquQZJoiLbke3RHJ4jJQ93UjSbfCBnRqpTneb/sPA0E5EjKU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZmANrNB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZmANrNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D131F000FF;
	Fri,  9 Oct 2026 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556706;
	bh=WTQfSSR1VVeQEAvhPFGAc10N+haqNptHYXF91VYDrko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZmANrNBn7QcUtjchmqukXdVCicCKPzuVCxHqt/l+mLHHvdnh4xnvnrBPb30WroGF
	 wpk6JQYvCyD+DJEYgXhhhwOQSjA32yqd63rIvkusUSs5Jl6cxO0GZTSBO5e4i/5fkx
	 PlGuHPVKwGl8GvhG7zEhqm+pkNyeAE6nqgq/hIiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Pemberton <wfp5p@virginia.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 278/403] USB: serial: ssu100: fix baud rate overflow
Date: Fri,  9 Oct 2026 16:10:39 +0200
Message-ID: <20261009140958.690611289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit afc235a217360c6859068d2e37a4df305c4d1be2 upstream.

The requested baud rate is incorrectly truncated to 16 bits so that
line speeds above 65535 bps cannot be set.

Use 32 bits for the rate and remainder while rejecting rates outside of
[50,460800] to avoid having the divisor or remainder overflow.

This issue was flagged by an LLM.

Fixes: 52af95459939 ("USB: add USB serial ssu100 driver")
Cc: stable@vger.kernel.org	# 2.6.36
Cc: Bill Pemberton <wfp5p@virginia.edu>
Assisted-by: LLM
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ssu100.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -34,6 +34,7 @@
 
 #define  SERIAL_EVEN_PARITY         (UART_LCR_PARITY | UART_LCR_EPAR)
 
+#define  MIN_BAUD_RATE              50
 #define  MAX_BAUD_RATE              460800
 
 #define ATC_DISABLED                0x00
@@ -219,9 +220,10 @@ static void ssu100_set_termios(struct tt
 {
 	struct usb_device *dev = port->serial->dev;
 	struct ktermios *termios = &tty->termios;
-	u16 baud, divisor, remainder;
+	speed_t baud, remainder;
 	unsigned int cflag = termios->c_cflag;
 	u16 urb_value = 0; /* will hold the new flags */
+	u16 divisor;
 	int result;
 
 	if (cflag & PARENB) {
@@ -237,6 +239,18 @@ static void ssu100_set_termios(struct tt
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
 	dev_dbg(&port->dev, "%s - got baud = %d\n", __func__, baud);
 
 
@@ -312,7 +326,7 @@ static int ssu100_open(struct tty_struct
 		dev_dbg(&port->dev, "%s - set uart failed\n", __func__);
 
 	if (tty)
-		ssu100_set_termios(tty, port, &tty->termios);
+		ssu100_set_termios(tty, port, NULL);
 
 	return usb_serial_generic_open(tty, port);
 }


