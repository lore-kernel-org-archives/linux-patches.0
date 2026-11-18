Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031592;
	b=0q5tCBHxwSbsLS9oRmxdPIiV1L3Vtp7Mnaq6kftW0U5Y6mu0ZiK8b6wWCs4Ya6vDqCMk
	 4szlyHmMzcL2US7mK7JVHZp3QNlLbfyl7y215fl+RPDvY7/G4uJPInqnuvjerbyZ9vcFH
	 BX/vFH9fXrmDVdEd70vrPtQjv+Yevc56ldgPRHEICSP6qNdZ1wVZFopR/+yS75cVwKChz
	 wwATKhX6Ifm6Zt0nxddlb/T4k0nrKpeVeC2xMtCdPZsBOjinC1/dNsaipKtZVHEXmkGuR
	 rSlp/7OsC1KGVLqFTtSV1HhJM+rronc0i/F0RFWzG0f7Z7Zw47/s6opulUeU0spYVxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dXQb4QbC+Ra2eUOANW54IOVqON/5fAvoOjB6TjOfBqk=;
	b=aDU8mezgFsWqd7dZBHuOoAIZkPE+vZtQ4xIBxLa+0Y941W5GlIaxb/zjuV3jzia0Q1xk
	 TMBb5rFOeLP3LSQD2FRqzWjXyA47rdH5dYU1J0YX1uuMlu3YDf2vQAuwD3BjgYW7NHXJe
	 nO7axmP42ICErpdM7+x4/C+veXGZP5O8HL+9tUBT4hV8Sg5+71WO6Nr7Aigxm31ygCjvr
	 P8mMwM7KiHh9samEmOvX3DPfQtXnWlDvQhUWxFVAnrX9qWPnGW/qtWGgJ/C7fwt2CW+hp
	 UbyTaEnee0St97iH5gC4yiVMk/EIQc0Bzkpe4aghh+EhfVPsNCMr91s1iPFCBYolB3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rWC5Csjw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC63606A320;
	Wed, 18 Nov 2026 19:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rWC5Csjw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF7B1F000C4;
	Wed, 18 Nov 2026 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031592;
	bh=dXQb4QbC+Ra2eUOANW54IOVqON/5fAvoOjB6TjOfBqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWC5CsjwmFZKXZZ2+wAgRGHpV7z3JrZb4fU+CSktVf9WwTkIswVLO7LudDFNnTY5w
	 EvW4jv6DFOTQON2D/Mx6eTquX59DjGQflphMtthrC4gQ02XAG+daNAGJ8InJk1txDP
	 gtAnu02246pAoYZ5cTob2hmwXJG7bGvYQZxMJSGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1113/1756] serial: max310x: dont clobber the TX break bit in set_termios
Date: Wed, 18 Nov 2026 15:54:00 +0100
Message-ID: <20261118150054.450652315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 163088b4b543b..ea09a77e89c03 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -156,6 +156,8 @@
 #define MAX310X_LCR_FORCEPARITY_BIT	(1 << 5) /* 9-bit multidrop parity */
 #define MAX310X_LCR_TXBREAK_BIT		(1 << 6) /* TX break enable */
 #define MAX310X_LCR_RTS_BIT		(1 << 7) /* RTS pin control */
+/* LCR bits owned by termios; TX break and RTS are driven elsewhere */
+#define MAX310X_LCR_TERMIOS_MASK	GENMASK(5, 0)
 
 /* IRDA register bits */
 #define MAX310X_IRDA_IRDAEN_BIT		(1 << 0) /* IRDA mode enable */
@@ -926,8 +928,12 @@ static void max310x_set_termios(struct uart_port *port,
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
@@ -1045,6 +1051,13 @@ static int max310x_startup(struct uart_port *port)
 
 	max310x_power(port, 1);
 
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



