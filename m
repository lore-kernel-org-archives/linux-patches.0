Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002F3612D7;
	Tue, 20 Feb 2024 21:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463894; cv=none; b=jQTb4Sa5Ix2f8ejyJ3CFbg2WsDUZrF3+VX2BgiedHSucXk1xK+jyBxRa5TjIZt3OaS6WrEtkMg+6KHtC2uHnLjFdECrxCovMOT0432+CdGffg98TSTJL6cEJ/y17XyXHaa3fJ+KYphdB10+YUci6+xM6r0r5DC+8CWz1zA6cdiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463894; c=relaxed/simple;
	bh=kn9Ib6DQWRVDgrPWbqecCJjCTi3FD8USrlr2BpakodU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abgzDEQuOHTiItHjdPKlqhI8PGVjTPFbpsq94wiqxPvAgpE0Jx/daD5ecuNAgp3vYCu1h7lyM8dzRs9Hd5qnmKlP+SZKSjx1Jp68lK5h/8iRqQHwL9AlL6F04AyX2ov7FnjhJJPmC2mJxjsQkXb5MzaHdwAEOd463Eumy97nOXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuTyxBgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuTyxBgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6487BC433C7;
	Tue, 20 Feb 2024 21:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463893;
	bh=kn9Ib6DQWRVDgrPWbqecCJjCTi3FD8USrlr2BpakodU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CuTyxBgRPaRS3lplRIHm5PqkowcRYxqTdCeV7irL+Usr8M2t+clHnwntBzXIptj18
	 2dWJ7y1mmoRGnM3aNIfUxK+9aQidxHlofvY3+YEi6Yzn4UCCD+06djJR2UGiooxFfJ
	 E5BswYrT0csiVVZgySS2Af0BpEvx5GILhx9mFw1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	stable <stable@kernel.org>,
	Emil Kronborg <emil.kronborg@protonmail.com>
Subject: [PATCH 6.6 187/331] serial: core: introduce uart_port_tx_flags()
Date: Tue, 20 Feb 2024 21:55:03 +0100
Message-ID: <20240220205643.432506096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


