Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19682505D2;
	Thu,  3 Apr 2025 15:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693849; cv=none; b=HwQyP+zNiQzOy6weAtb/7Jgo5cl2umAKD9LPGityumOanhgAH7xus7UIg3+ba1qM8VDROHEDZzma5YrHG7AhiH0Juo2x5nnzV8rDLbARHnJc6frUisXllOVLsBx6t8HDFXv47d0CrRXElCCMNgv7Z2UOklzcmChY+2ob5H4AEUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693849; c=relaxed/simple;
	bh=WDDVK3TmKoOYpNcTjLPvMAvNmc0aas5QURETba9VtMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6ZP6axwhspz+xqO00ehw3QDS+SSdrW9gPIIDEOdy1q7Zum9V8of7LHek3AKAY6OywqbBSA0btPvXUTpvlortClzGjTVokDEPZ55sItpGFcvrxnGzyE87LMqSsWrbFn6uMYwU4EEYHgkqpw5DAluZUkj2dbYfSTxvQAhPPPXLTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8p0fepv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8p0fepv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8137BC4CEE3;
	Thu,  3 Apr 2025 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693848;
	bh=WDDVK3TmKoOYpNcTjLPvMAvNmc0aas5QURETba9VtMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8p0fepvQJ553hhhuxJEeuuR/gC7LdlgWyUg/oFqwHHke9B1iq7qH8H+9rBsa3mym
	 x5ar7knB6G58mEmFrOQPk1SkzzLzDfnWScAQP8D2tl7z6Y8YOM/UmZZHTh0uqbBGF6
	 FxJfZ+GF7QhM5920c94Xx+GWnkmVJDObBGbf59Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cheick Traore <cheick.traore@foss.st.com>
Subject: [PATCH 6.14 20/21] serial: stm32: do not deassert RS485 RTS GPIO prematurely
Date: Thu,  3 Apr 2025 16:20:24 +0100
Message-ID: <20250403151621.699884385@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
References: <20250403151621.130541515@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheick Traore <cheick.traore@foss.st.com>

commit 2790ce23951f0c497810c44ad60a126a59c8d84c upstream.

If stm32_usart_start_tx is called with an empty xmit buffer, RTS GPIO
could be deasserted prematurely, as bytes in TX FIFO are still
transmitting.
So this patch remove rts disable when xmit buffer is empty.

Fixes: d7c76716169d ("serial: stm32: Use TC interrupt to deassert GPIO RTS in RS485 mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Cheick Traore <cheick.traore@foss.st.com>
Link: https://lore.kernel.org/r/20250320152540.709091-1-cheick.traore@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -965,10 +965,8 @@ static void stm32_usart_start_tx(struct
 {
 	struct tty_port *tport = &port->state->port;
 
-	if (kfifo_is_empty(&tport->xmit_fifo) && !port->x_char) {
-		stm32_usart_rs485_rts_disable(port);
+	if (kfifo_is_empty(&tport->xmit_fifo) && !port->x_char)
 		return;
-	}
 
 	stm32_usart_rs485_rts_enable(port);
 


