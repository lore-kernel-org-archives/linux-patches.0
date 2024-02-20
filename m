Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B4B151CCC;
	Tue, 20 Feb 2024 21:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465170; cv=none; b=NI45RgBkN1QjVfYs6qbSz3wzf+h1dKa/El+F3zOqPHnlsZ2wncMx53cEB3TvmGFaXPwXpuBIDeQCzd7s7om4FyWaj9GLUzZGdWx/mxRSzyIRDlviLXtoNDdlg68VAj6lCM4/yZW8N1u7FBDs5l3CLx+OJaTw4aW5II6o5S7BdFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465170; c=relaxed/simple;
	bh=z9qFDdv9UMAc8yLWkvLPdE/87VJahT8rGHjrBfMHqJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdtoXmBz2jnN5hs++egvc+aETRN1phN2ha1F2b5s5t8gacwKNoV1cCO6vHnsrAWIwrO5llphDfU7ooNApSAT1tni0PpdNkwP1QHg0xTEz0XTXaqvHPPsu08FiKpAdICJ7BQfVwetP2bv8hlOgtezW4bzaNSPIrCxWJKBiSSMadM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0qZvVR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0qZvVR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25145C433F1;
	Tue, 20 Feb 2024 21:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465170;
	bh=z9qFDdv9UMAc8yLWkvLPdE/87VJahT8rGHjrBfMHqJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0qZvVR0zLF+Ht9XST/5p5T2QYouKdVDoBCBjJRLY2Rlipr0IvJZhBN0ZKR0PxwnD
	 LxvZAb/KkFrwKc0nFrOcfhz10LHVcsxi3y26REiGt8aoiI2xJUhip0UKIpbkmzzTYZ
	 55Qbl5hpgIH1Fg0uUUyLHH9RObesoRApv2QKmpBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	stable <stable@kernel.org>,
	Emil Kronborg <emil.kronborg@protonmail.com>
Subject: [PATCH 6.7 229/309] serial: core: introduce uart_port_tx_flags()
Date: Tue, 20 Feb 2024 21:56:28 +0100
Message-ID: <20240220205640.319088651@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 3ee07964d407411fd578a3bc998de44fd64d266a upstream.

And an enum with a flag: UART_TX_NOSTOP. To NOT call
__port->ops->stop_tx() when the circular buffer is empty. mxs-uart needs
this (see the next patch).

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: stable <stable@kernel.org>
Tested-by: Emil Kronborg <emil.kronborg@protonmail.com>
Link: https://lore.kernel.org/r/20240201105557.28043-1-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/serial_core.h |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -748,8 +748,17 @@ struct uart_driver {
 
 void uart_write_wakeup(struct uart_port *port);
 
-#define __uart_port_tx(uport, ch, tx_ready, put_char, tx_done, for_test,      \
-		for_post)						      \
+/**
+ * enum UART_TX_FLAGS -- flags for uart_port_tx_flags()
+ *
+ * @UART_TX_NOSTOP: don't call port->ops->stop_tx() on empty buffer
+ */
+enum UART_TX_FLAGS {
+	UART_TX_NOSTOP = BIT(0),
+};
+
+#define __uart_port_tx(uport, ch, flags, tx_ready, put_char, tx_done,	      \
+		       for_test, for_post)				      \
 ({									      \
 	struct uart_port *__port = (uport);				      \
 	struct circ_buf *xmit = &__port->state->xmit;			      \
@@ -777,7 +786,7 @@ void uart_write_wakeup(struct uart_port
 	if (pending < WAKEUP_CHARS) {					      \
 		uart_write_wakeup(__port);				      \
 									      \
-		if (pending == 0)					      \
+		if (!((flags) & UART_TX_NOSTOP) && pending == 0)	      \
 			__port->ops->stop_tx(__port);			      \
 	}								      \
 									      \
@@ -812,7 +821,7 @@ void uart_write_wakeup(struct uart_port
  */
 #define uart_port_tx_limited(port, ch, count, tx_ready, put_char, tx_done) ({ \
 	unsigned int __count = (count);					      \
-	__uart_port_tx(port, ch, tx_ready, put_char, tx_done, __count,	      \
+	__uart_port_tx(port, ch, 0, tx_ready, put_char, tx_done, __count,     \
 			__count--);					      \
 })
 
@@ -826,8 +835,21 @@ void uart_write_wakeup(struct uart_port
  * See uart_port_tx_limited() for more details.
  */
 #define uart_port_tx(port, ch, tx_ready, put_char)			\
-	__uart_port_tx(port, ch, tx_ready, put_char, ({}), true, ({}))
+	__uart_port_tx(port, ch, 0, tx_ready, put_char, ({}), true, ({}))
 
+
+/**
+ * uart_port_tx_flags -- transmit helper for uart_port with flags
+ * @port: uart port
+ * @ch: variable to store a character to be written to the HW
+ * @flags: %UART_TX_NOSTOP or similar
+ * @tx_ready: can HW accept more data function
+ * @put_char: function to write a character
+ *
+ * See uart_port_tx_limited() for more details.
+ */
+#define uart_port_tx_flags(port, ch, flags, tx_ready, put_char)		\
+	__uart_port_tx(port, ch, flags, tx_ready, put_char, ({}), true, ({}))
 /*
  * Baud rate helpers.
  */


