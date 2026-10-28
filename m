Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211056;
	b=SYqtTSFPwTGME7PROVx9GelX2HvkmGSm7tysY/hjbwGPbqzctrhvfnBGpevPAtV4VkxY
	 zMICljADgldR1Mi/NTvRfj7D5whcpgPkR0p241Vg98hOR3cSBGwm+p2o5YbBJvE69d4/p
	 ASYi77j67GURd/LB20CLSyivkAEq5H1bnBVIMhaDF7jb8kN0Rk19nbGg55/BmBOv2e887
	 PwtzTHmmgQVyT1S81hvep1PmCCmofR19sJbLlqhiSGv32CO2h030Z4J44OFLDFytEeBPT
	 Jzu1NTFz8jqn5jLqbevONu2/taNYh+NTKgoexZvY55za761YL9DrtzN7jCIE3/LfhOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ahF4VIiyt3jkf0HTLMEykgaeBuVkXH9VM4vdghLtmdg=;
	b=ByTXyuCzRdxwAzo6QAJyEPOy3dM2OUgPybg8Aujw4jizzPtKfNd8EkGpgUeQoU1+L+9d
	 rxqxDRKfpvlA8l9bnyByYKR2CeYcKIGGOepnQp4tmtunzZ3z3R2tuEM3Z+aq/K/oTwOr0
	 fj5opTgELvxQW1TNoHuz+ZLbbP65wabHaiJngRbJQTuqhBbHEYOFKtQAx4+Xj1ZQkzVIl
	 EOCS3LS/6iTXacWR0Nf9zcq37KPs0GiU+dEr6dX+JBygADHtdvpTTs+RdYIu95fUc8ZHD
	 1yvoxbF9X9UBETOdyK1cy4xeOwpizyoaUPi3vKzIBph+RvZJZskCpI7ieOcEXPVoTew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qomNeZrN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A401C606A969;
	Wed, 28 Oct 2026 18:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qomNeZrN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E871F01829;
	Wed, 28 Oct 2026 18:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211055;
	bh=ahF4VIiyt3jkf0HTLMEykgaeBuVkXH9VM4vdghLtmdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qomNeZrNAk5Jtt7TwsWx4jrJPRlVcRH74UOuhl5nfoZNVke8IwpQh4shAlBvi9fyj
	 o/A9XzPLuhbeYXv5rGnjqqJyPVcB13REMp56BwKWpGtjVTmDBlHgJUSANPxbkDtwvi
	 Wr4TKWFxlmfvqVuWjlEQBhzWKBL00u0CsNu+bkOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Pemberton <wfp5p@virginia.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 243/571] USB: serial: ssu100: fix baud rate overflow
Date: Wed, 28 Oct 2026 17:56:30 +0100
Message-ID: <20261028170013.772097965@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -251,6 +253,18 @@ static void ssu100_set_termios(struct tt
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
 
 
@@ -326,7 +340,7 @@ static int ssu100_open(struct tty_struct
 		dev_dbg(&port->dev, "%s - set uart failed\n", __func__);
 
 	if (tty)
-		ssu100_set_termios(tty, port, &tty->termios);
+		ssu100_set_termios(tty, port, NULL);
 
 	return usb_serial_generic_open(tty, port);
 }


