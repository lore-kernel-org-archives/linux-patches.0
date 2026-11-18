Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049585;
	b=aiJW6zq/k4fKGtzswwB013iJ/K87K755nvn3Y9WvM1FbTskxVTmhpT80TZHeQFAN8odD
	 vIqSCu2dK9i5iMAPaoSYlQCc99j4uXBGR8LoooeG47jOvXw6pLKqUmcyxDPVXY98VtpZG
	 363T6lJTkcOdK5+wKUTe46Xc4fqM+7QFgnRAsMrI/3Q1A08Tu6xy1jY/5LofI965yHDaI
	 Rkts46DCaX68lVX1I+mHruE27l2AjcAzMg8rutCGMC7REf+PxhChWiGkPzfJ79CDErQTa
	 0DI+sAGvzw4wXdvyKDDZ/DdBtjwwmMxzy4gJXiF4lyF/y1XUDWQNjOzAXXBu6Le/yxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T/l1thwGeP0T060x+cQvWMgGnZoukv+MS3YoohCglGI=;
	b=DMEgfpKXJ9mPYabLGB/d8AebiFiNhieJHd7K1BQnqVX0XOKYXg+8XZPU7QWfNdUSL+XW
	 eQL5vg+xNBoOWLv1oxXu4TlebgrJDP05RcEcGlG9vqZA1RSRLvZ1SPpizBQWeZR6Mw6xh
	 5lv9ZuygM2iRI+WFAtswM+Agozy8lCKJoQO36HiaxZB+SwSNYYL5SeAwa1EgS8nlS6+cH
	 3O+WobQKf57sBCvqLGCSIM6rty/0o4inA+8LIqS/JG17mhNHWkLnLsgY81bJnqXVtgCXs
	 g5OEAdCpMxbI1MXNKFHV1GQch+DPDkJryqhL7UcV+plnshdYOZlMmpOs2he/qofa0YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QifnnUAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C70606A31C;
	Thu, 19 Nov 2026 00:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QifnnUAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3E21F000C4;
	Thu, 19 Nov 2026 00:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049585;
	bh=T/l1thwGeP0T060x+cQvWMgGnZoukv+MS3YoohCglGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QifnnUAYOi6qQicn39pviafnTa5eLcV95nGtCBlyNvOxb8q9fnmnwXy72lvVVDU5X
	 w0/9xTkimmjsgxkPGtUxr6ZOqhoWa0u3POlX5XoitA1D+DN1wMMZ+0UjvsSSYnQSD8
	 kTdEPErJ7bmxK98Q+BOzZhrotpiqwKNCk3PyVGpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2402/2857] serial: max310x: dont clobber the TX break bit in set_termios
Date: Wed, 18 Nov 2026 15:57:16 +0100
Message-ID: <20261118150328.011601371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit 3b2de448ec0332c1cb8c38b4c5ff0c8e860befbc ]

A TX break asserted with TIOCSBRK ends early, with no error reported,
as soon as any termios change lands on the port: a break is a state
that must hold until TIOCCBRK, but max310x_set_termios() overwrites
the whole LCR register, and LCR also carries the TX break bit that
break_ctl() drives. No concurrency is required - a baud or parity
change from the same process ends the break just as well, and
break-led protocols lose their break with nothing in the logs.

Update only the LCR bits that are derived from termios and leave the
TX break and RTS pin control bits untouched. Since nothing clears a
break when a port is closed with the break still asserted - the tty
core sends no break-off on release, and the unconditional write here
was the accidental recovery - clear TXBREAK in startup(), the same way
8250 does.

Fixes: f65444187a66 ("serial: New serial driver MAX310X")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20261008-max310x-rs485-sw-delay-v8-1-6ba881f81e1f@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 92c5ee79b4b11..cad593d7dbee8 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -154,6 +154,8 @@
 #define MAX310X_LCR_FORCEPARITY_BIT	(1 << 5) /* 9-bit multidrop parity */
 #define MAX310X_LCR_TXBREAK_BIT		(1 << 6) /* TX break enable */
 #define MAX310X_LCR_RTS_BIT		(1 << 7) /* RTS pin control */
+/* LCR bits owned by termios; TX break and RTS are driven elsewhere */
+#define MAX310X_LCR_TERMIOS_MASK	GENMASK(5, 0)
 
 /* IRDA register bits */
 #define MAX310X_IRDA_IRDAEN_BIT		(1 << 0) /* IRDA mode enable */
@@ -961,8 +963,12 @@ static void max310x_set_termios(struct uart_port *port,
 	if (termios->c_cflag & CSTOPB)
 		lcr |= MAX310X_LCR_STOPLEN_BIT; /* 2 stops */
 
-	/* Update LCR register */
-	max310x_port_write(port, MAX310X_LCR_REG, lcr);
+	/*
+	 * Update LCR register. Leave the TX break bit alone: it is driven by
+	 * break_ctl(), and a whole-register write here would end a break in
+	 * progress.
+	 */
+	max310x_port_update(port, MAX310X_LCR_REG, MAX310X_LCR_TERMIOS_MASK, lcr);
 
 	/* Set read status mask */
 	port->read_status_mask = MAX310X_LSR_RXOVR_BIT;
@@ -1079,6 +1085,13 @@ static int max310x_startup(struct uart_port *port)
 
 	s->devtype->power(port, 1);
 
+	/*
+	 * Clear a latched break: nothing clears TXBREAK when a port is
+	 * closed with a break still asserted, and set_termios() no longer
+	 * rewrites it.
+	 */
+	max310x_port_update(port, MAX310X_LCR_REG, MAX310X_LCR_TXBREAK_BIT, 0);
+
 	/* Configure MODE1 register */
 	max310x_port_update(port, MAX310X_MODE1_REG,
 			    MAX310X_MODE1_TRNSCVCTRL_BIT, 0);
-- 
2.53.0



