Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEE8143898;
	Tue, 23 Apr 2024 21:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908518; cv=none; b=ZaoH1x9l6M+EC/z0iPULLC6BEycxIabsgVpKNoleRTaW+HEo3MczjMcHRBLLQ+0K2dt7jm1fdD9tab0/P7x/To613kPh3lFPno6CLGxjvLFRA8RzFiU8+O0mhtwpCKs2e+g+nmQtFkdK9k0D2M4+6N4We2lK6Qeg0XyEvRlCEXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908518; c=relaxed/simple;
	bh=qGnc8NeZ3rTCbDsDRNSA+k+zsB1/K5UHVcsKIJi3vIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eKq/7f1EB0+AkQQmq/UeR9jLwuEy8AIri0R40FDFP46g0fiKHfAiyzocuTs18CKIRIGcxDS5HIPA4YK1O/B4JUI6yhSi+ZmiwkF0i9WQbCbglxuA1vrCqW2GwSByxoPFqRbCtvvs67+PwXvW+vseU4VzFBAZVOKuXZCfdILKloE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORJij1mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORJij1mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2128FC32783;
	Tue, 23 Apr 2024 21:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908518;
	bh=qGnc8NeZ3rTCbDsDRNSA+k+zsB1/K5UHVcsKIJi3vIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORJij1mhOepcGjGio4j6+mS2yuuwZMgNaI04IPJSbQOcPxh6RFIS9G5Av2xANH/fW
	 4CKp53uhMZJw5atK6j/dWLCehaNYWuyXbGCqZINSiHz3q8fWxOloci/VNYwNtwIwrO
	 WP61vRVAzNFHDKQBw5Hzn1Kh5KuLJIDgwJyE9VeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 6.8 105/158] serial: stm32: Reset .throttled state in .startup()
Date: Tue, 23 Apr 2024 14:38:47 -0700
Message-ID: <20240423213859.354428901@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit ea2624b5b829b8f93c0dce25721d835969b34faf upstream.

When an UART is opened that still has .throttled set from a previous
open, the RX interrupt is enabled but the irq handler doesn't consider
it. This easily results in a stuck irq with the effect to occupy the CPU
in a tight loop.

So reset the throttle state in .startup() to ensure that RX irqs are
handled.

Fixes: d1ec8a2eabe9 ("serial: stm32: update throttle and unthrottle ops for dma mode")
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/a784f80d3414f7db723b2ec66efc56e1ad666cbf.1713344161.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -1088,6 +1088,7 @@ static int stm32_usart_startup(struct ua
 		val |= USART_CR2_SWAP;
 		writel_relaxed(val, port->membase + ofs->cr2);
 	}
+	stm32_port->throttled = false;
 
 	/* RX FIFO Flush */
 	if (ofs->rqr != UNDEF_REG)


