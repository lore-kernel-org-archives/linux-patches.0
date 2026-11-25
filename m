Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622412;
	b=MLyuVXxRPw6f/bEos8WlBJbxXJfIRbzcU5KhmAIm3eu1Ng/Rnlviri8NG7JamkKvMcXu
	 Dr/kqOspcT73RBIypPrwbyHuGnIbdWyutUVSCeDzbgDszYpl7P3tpP1LWYll+ve1pzQmN
	 9+2a6islVvuc1LcHXxApuILfkHF7HsUv4KckQRvHZ+Zragw+D1ZO7SouV6yMsulD0PZR9
	 J+69GRZu6KoUwsntJNXdxrVR3Q44VMNZbh/IVTWp6dsPcihQmqfi/+RNy2GvIQMo4lFNG
	 qr8EVFq8EOMdryN4jgTQs98P818JPCHDromvyZzoum+hQ8ECWil8iw28nr5+CzjBohw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cpeA4tKkSKjJctEjHQN3uuDS5Mbd8j7fPlJxAvZG5vI=;
	b=O41IKkV3rodxsS4wRbfhTiID7eq6rhvOBB0ItR+YEcdbSGzv5JrX9ldbxgy0/O9Q0wwB
	 /8z/YEV0QAWtO1DRS0+UkudxYlPzzGpuhCMZZD+LIoCV5ciih0F4L/Ou5oVoquIZhSkAS
	 Wo/4yJguOaD2rIymvNYjeXZcNmp48madRLcsAMSQIcDAjBbc8iGDvU5bvUuBoQUYd3ngg
	 Kltfa3gmDlSx40yYV3bIIFML7IpexCZ/htQFO2jZK2K64zIyF9ItLqiVqcUJ4q6HgucSF
	 l7xvHZjwINM64wM9+bIw9+RTu1VgIOOZDrncUXqkG6kkh85r0ISSb5xuwGRIk51IMzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dh9/Ieq8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBFB606A33B;
	Wed, 25 Nov 2026 16:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dh9/Ieq8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB38F1F008B2;
	Wed, 25 Nov 2026 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622412;
	bh=cpeA4tKkSKjJctEjHQN3uuDS5Mbd8j7fPlJxAvZG5vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dh9/Ieq80awP/HDQfLMQUqy95ZB7WyonS2C75NsngxJKwz2UVij3tN+53qyC/bn5Y
	 jvjLgZlSaCVhxjL+Y6Ea6CfSW8oV3jQreh6anhJz5IHm85o79zT1YYvNzK78WK5T49
	 eT86cgkoaWIcpgkMnU/4my5tVUoLzuYqfyuMRkWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tate Whiteberg <whiteberg@arista.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 528/990] serial: 8250_mid: wait for LSR tx empty before setting termios
Date: Wed, 25 Nov 2026 15:31:35 +0100
Message-ID: <20261125143834.460117999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tate Whiteberg <whiteberg@arista.com>

[ Upstream commit 1c305d5f1daabd317a60b6a2e2ac6b1aff7e05df ]

If mid8250_set_termios is called while data is still in transmission,
the corresponding register updates will corrupt the transmission.

Fix this by locking the port and and waiting for the transmitter to
empty before performing updates. It is necessary to wait for both
UART_LSR_THRE and UART_LSR_TEMT to ensure the final character is sent.

Fixes: f549e94effa1 ("serial: 8250_pci: add Intel Penwell ports")
Signed-off-by: Tate Whiteberg <whiteberg@arista.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20260831165911.2029839-3-whiteberg@arista.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mid.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mid.c b/drivers/tty/serial/8250/8250_mid.c
index 82656645b8a64..c02ecb96e8b6f 100644
--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/rational.h>
@@ -209,6 +210,7 @@ static void mid8250_set_termios(struct uart_port *p, struct ktermios *termios,
 				const struct ktermios *old)
 {
 	unsigned int baud = tty_termios_baud_rate(termios);
+	struct uart_8250_port *up = up_to_u8250p(p);
 	struct mid8250 *mid = p->private_data;
 	unsigned short ps = 16;
 	unsigned long fuart = baud * ps;
@@ -231,11 +233,16 @@ static void mid8250_set_termios(struct uart_port *p, struct ktermios *termios,
 	}
 
 	rational_best_approximation(fuart, mid->board->freq, w, w, &mul, &div);
-	p->uartclk = fuart * 16 / ps;		/* core uses ps = 16 always */
 
-	writel(ps, p->membase + INTEL_MID_UART_PS);		/* set PS */
-	writel(mul, p->membase + INTEL_MID_UART_MUL);		/* set MUL */
-	writel(div, p->membase + INTEL_MID_UART_DIV);
+	scoped_guard(spinlock_irq, &p->lock) {
+		p->uartclk = fuart * 16 / ps;	/* core uses ps = 16 always */
+
+		serial8250_wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
+
+		writel(ps, p->membase + INTEL_MID_UART_PS);	/* set PS */
+		writel(mul, p->membase + INTEL_MID_UART_MUL);	/* set MUL */
+		writel(div, p->membase + INTEL_MID_UART_DIV);
+	}
 
 	serial8250_do_set_termios(p, termios, old);
 }
-- 
2.53.0



