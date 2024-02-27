Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A347C13B78E;
	Tue, 27 Feb 2024 14:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042859; cv=none; b=bHk+UETgsWJfor2QHGmQGULXREdPMiouqkQu4W+BjcOucEMcoGvMmq3Lg1kcLAL5Eh5BQW1LrvKFJ9vQTewaBwj4jajFN7oZ7/AKp0Q11H8Q33quWNpmcc+yYvbOHq/UIdqCQFwjYlFVPPD9ZfyatxHE2vmW+et+KNeNTJO8GQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042859; c=relaxed/simple;
	bh=4jfhCN1eM/K9XkHc+3PICcsKJaRfXKOn1z69hDictu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E0wFLKjfyOBnlIJCcul1kOPb3QjUJb3s8QG44G29WOtBo7ZJ8UvSLfyZ7+Dgo325AIjrjTeAjI7g8uoTclWl8xBM/d7JiJQ0OCr7pBr6Ah06eEDgJCRLRzLYYKRCZJqpPORoUVaqs9IZ/L9EsmVTWhBomDFZSQU0y6nf7LCqcl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2eSGfo3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2eSGfo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2FDC433F1;
	Tue, 27 Feb 2024 14:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042859;
	bh=4jfhCN1eM/K9XkHc+3PICcsKJaRfXKOn1z69hDictu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2eSGfo39N8XEFxOfli641mR5bfIaBKCs1Py1RV96T6zRrNBLPJWVuprvYaiGB0Qk
	 sXfCkQ4M0Rxym55g7uf5u+5LZ9wovKD8d7feDWkGjHsHTwYv2CsbHi/1HARmCxvOsG
	 ZJB4x2KvPHgd1PFzjlJH/tqnSBvERQzJisnZ9+ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/245] serial: 8250: Remove serial_rs485 sanitization from em485
Date: Tue, 27 Feb 2024 14:25:34 +0100
Message-ID: <20240227131619.963214212@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 84f2faa7852e1f55d89bb0c99b3a672b87b11f87 ]

Serial core handles serial_rs485 sanitization.

When em485 init fails, there are two possible paths of entry:

  1) uart_rs485_config (init path) that fully clears port->rs485 on
     error.

  2) ioctl path with a pre-existing, valid port->rs485 unto which the
     kernel falls back on error and port->rs485 should therefore be
     kept untouched. The temporary rs485 struct is not returned to
     userspace in case of error so its flag don't matter.

...Thus SER_RS485_ENABLED clearing on error can/should be dropped.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220606100433.13793-37-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 45a8f76f562e7..4fce318bc83ca 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -670,13 +670,6 @@ int serial8250_em485_config(struct uart_port *port, struct serial_rs485 *rs485)
 		rs485->flags &= ~SER_RS485_RTS_AFTER_SEND;
 	}
 
-	/* clamp the delays to [0, 100ms] */
-	rs485->delay_rts_before_send = min(rs485->delay_rts_before_send, 100U);
-	rs485->delay_rts_after_send  = min(rs485->delay_rts_after_send, 100U);
-
-	memset(rs485->padding, 0, sizeof(rs485->padding));
-	port->rs485 = *rs485;
-
 	gpiod_set_value(port->rs485_term_gpio,
 			rs485->flags & SER_RS485_TERMINATE_BUS);
 
@@ -684,15 +677,8 @@ int serial8250_em485_config(struct uart_port *port, struct serial_rs485 *rs485)
 	 * Both serial8250_em485_init() and serial8250_em485_destroy()
 	 * are idempotent.
 	 */
-	if (rs485->flags & SER_RS485_ENABLED) {
-		int ret = serial8250_em485_init(up);
-
-		if (ret) {
-			rs485->flags &= ~SER_RS485_ENABLED;
-			port->rs485.flags &= ~SER_RS485_ENABLED;
-		}
-		return ret;
-	}
+	if (rs485->flags & SER_RS485_ENABLED)
+		return serial8250_em485_init(up);
 
 	serial8250_em485_destroy(up);
 	return 0;
-- 
2.43.0



