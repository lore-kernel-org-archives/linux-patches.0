Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063375;
	b=EAevLm3bzawIvwI9a/Np+K1n4F9NDgsah214hKGfkl5pKp/jbPFQmzQnttXdtrY1TdCV
	 dSoGOGGm0ZFTVkKo4k+mBgAsaG97IAfi/DZf9NFdHacZgsxVGqt/cMXiRwgJoeBRm2RmH
	 VRrVfqcJpJvDYcCvEVCg8J8bIwFFpc+UXPuTixw/d5dpuhiOXs2JbICgRZ5nsJgNGJGS2
	 DQKmp2DI27vJTjRGQHYu9kLrxaBqlUiU9oyu9OsqtkKqR4WXdP0S+JYHmKC1AhDCosFDk
	 Y3EOLfOq3y/KZG+qCX1lT+5eH/P/AtY48pF0XIuKjNV1yPrZ0BXVlb359Fe6HyzOEgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P0AFccg1YjNNSuJnKlibo0k7CtguKK7cNoJ7Vl5CZo4=;
	b=r9cAfRtPugsxI8mcNuKNmxF9gTT6+6yNXSpR4qFO5aOHTkchi3d9B9XlNvf+ojBhjDmN
	 zqX7dm1MwCLGMSIZ5hQclkp9+DRh47Zo/JTsijmw8jQ84zF4uv/uIoEaH6+OknVciYAUk
	 OuJZiOhG3e24Qsx6IX1bq0a/K0LH4roWPmhKDpOV+nfvxwhgSVZ2gLMpJWEZAV1zwjfe8
	 xlFjaIVwk8/MqNF+JS6vaoJsm0qa8549r7mCeWTRrHhKOaZ6A6k24Z+nTAFIYp2L/avuz
	 Ff6ePoNW2o2YuiE/ZT3NSZeu99lXQdh2MSeVhKg7UOG2Slj5BNwgxpsUeTCod7+Gk5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vw3hqQAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD171606D801;
	Sat,  7 Nov 2026 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vw3hqQAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B891F008A1;
	Sat,  7 Nov 2026 14:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063374;
	bh=P0AFccg1YjNNSuJnKlibo0k7CtguKK7cNoJ7Vl5CZo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vw3hqQAjbk5Z6VwLoFsNnGGtz0QWy58k+jmh3XHKSZVEGJ8YtyasCND6IUiG8rYvo
	 Ou4DhR+iKu8fcddoo7l/MfnZkYfxb3DSuXehXcBplLD5eUGjqPS6fYd8N0M7hhXXSR
	 ltIo083HNweQeSTf6bQN8bvBid3ci7fv66xXqzO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 549/869] serial: amba-pl011: honour delay_rts_before_send for every write
Date: Sat,  7 Nov 2026 08:53:51 -0500
Message-ID: <20261107134911.988381300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 8a9750209596be35d109de5aa89623b049855c67 ]

While the driver waits out delay_rts_before_send, another write calls
pl011_start_tx() again. pl011_rs485_tx_start() then switches straight
to SEND, and the data goes out before the delay has passed.

Leave the start to the trigger_start_tx timer while it is pending.

Fixes: 2c1fd53af21b ("serial: amba-pl011: Fix RTS handling in RS485 mode")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20261011-fix-pl011-rs485-rts-delay-v1-1-5078e61bc408@tipi-net.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 4b213d0c61336..3e777e4d13f20 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1355,10 +1355,6 @@ static void pl011_rs485_tx_start(struct uart_amba_port *uap)
 	struct uart_port *port = &uap->port;
 	u32 cr;
 
-	if (uap->rs485_tx_state == WAIT_AFTER_RTS) {
-		uap->rs485_tx_state = SEND;
-		return;
-	}
 	if (uap->rs485_tx_state == WAIT_AFTER_SEND ||
 	    uap->rs485_tx_state == WAIT_AFTER_SEND_DELAY) {
 		hrtimer_try_to_cancel(&uap->trigger_stop_tx);
@@ -1397,6 +1393,10 @@ static void pl011_start_tx(struct uart_port *port)
 
 	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
 	    uap->rs485_tx_state != SEND) {
+		/* trigger_start_tx starts TX once delay_rts_before_send passed */
+		if (uap->rs485_tx_state == WAIT_AFTER_RTS)
+			return;
+
 		pl011_rs485_tx_start(uap);
 		if (uap->rs485_tx_state == WAIT_AFTER_RTS)
 			return;
@@ -1413,8 +1413,10 @@ static enum hrtimer_restart pl011_trigger_start_tx(struct hrtimer *t)
 	unsigned long flags;
 
 	uart_port_lock_irqsave(&uap->port, &flags);
-	if (uap->rs485_tx_state == WAIT_AFTER_RTS)
+	if (uap->rs485_tx_state == WAIT_AFTER_RTS) {
+		uap->rs485_tx_state = SEND;
 		pl011_start_tx(&uap->port);
+	}
 	uart_port_unlock_irqrestore(&uap->port, flags);
 
 	return HRTIMER_NORESTART;
-- 
2.53.0



