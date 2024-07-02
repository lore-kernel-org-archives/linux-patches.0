Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA77715218A;
	Tue,  2 Jul 2024 17:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941065; cv=none; b=hRSOn4XMGE6HTER5si50UK8grQIHea2pOEyDJ/8CnfBx+CILC9wP6uZHx32cgqrlIzps7g2uOHA5pGE8ft5xycJIMbpPuQHQijS3vUneYTXNdYDXEKuXdHDW2SUyGWXMcN4hWxyHIzIUmRE4hHYiK5fcYWZMvUcPcBxVKLVO8VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941065; c=relaxed/simple;
	bh=A9NGJ6GcVIRK2ivYGjxYOAKrk+KBjByfQSiJq2R1e3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNkGIpX4/pINMg+Fht8jzH3VxE51PLPkE/CJXbr122sg4Zl8Kg+Ds0nntxg3qnRNdqOGzXOIG0ALpbBQwFXJtfMxaHlkMFUWmAUUcJNU7YBWl30SEl6dsDpmxNAalJ+3CLl73id2fBQ2uyJXD/8qvF7sR27Sam4yvj+opXdKF50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdGfYvpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdGfYvpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2FBC116B1;
	Tue,  2 Jul 2024 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941064;
	bh=A9NGJ6GcVIRK2ivYGjxYOAKrk+KBjByfQSiJq2R1e3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdGfYvpPDqe0HRrGGuKL7caBcQ3XEnGlTzot6MnAYWWJO2pXwC8iIDn6MQ1Qi0TUt
	 56tsVNRzhje/c+u+FzbF1/UyEL2WVJxkt5LQpGpycnEvi8nKdy5p68DJMHgWGvsTKd
	 neFdbQSSMDZY57tTvRF7rZawx1HMzZTJZSeSIPkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Doug Brown <doug@schmorgal.com>
Subject: [PATCH 6.6 118/163] serial: core: introduce uart_port_tx_limited_flags()
Date: Tue,  2 Jul 2024 19:03:52 +0200
Message-ID: <20240702170237.521750535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

commit 9bb43b9e8d9a288a214e9b17acc9e46fda3977cf upstream.

Analogue to uart_port_tx_flags() introduced in commit 3ee07964d407
("serial: core: introduce uart_port_tx_flags()"), add a _flags variant
for uart_port_tx_limited().

Fixes: d11cc8c3c4b6 ("tty: serial: use uart_port_tx_limited()")
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20240606195632.173255-3-doug@schmorgal.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/serial_core.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -827,6 +827,24 @@ enum UART_TX_FLAGS {
 })
 
 /**
+ * uart_port_tx_limited_flags -- transmit helper for uart_port with count limiting with flags
+ * @port: uart port
+ * @ch: variable to store a character to be written to the HW
+ * @flags: %UART_TX_NOSTOP or similar
+ * @count: a limit of characters to send
+ * @tx_ready: can HW accept more data function
+ * @put_char: function to write a character
+ * @tx_done: function to call after the loop is done
+ *
+ * See uart_port_tx_limited() for more details.
+ */
+#define uart_port_tx_limited_flags(port, ch, flags, count, tx_ready, put_char, tx_done) ({ \
+	unsigned int __count = (count);							   \
+	__uart_port_tx(port, ch, flags, tx_ready, put_char, tx_done, __count,		   \
+			__count--);							   \
+})
+
+/**
  * uart_port_tx -- transmit helper for uart_port
  * @port: uart port
  * @ch: variable to store a character to be written to the HW


