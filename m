Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AD914A611;
	Tue, 23 Apr 2024 21:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908757; cv=none; b=Fp/jfDBV4kfYK1XjatXRaqkNbocUGxH2Vk1Rt9wKG26Ljfulb0wBjpZfSZNJtK4fenMSecvJNG7R5xU0v1LbZlf/IE+RsIji9wCiJryEW0DAdaY0rwtcQorSHydTtZHLzlOJSln9O0bP3YK8+1NfOj6OORcPUzLngYr4CNqY/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908757; c=relaxed/simple;
	bh=hmvFB+QjwpaSQnc1MvcAQazA/GcynFSnE8UacCe/dNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lO93B1QQ96hjUzPVorvCgVvDxY5KTTt2D+2gm+66odRygJ3SVVZ06i/nGUdOqjcMNt3WQMnlxPmK1XFTiarKuzhi1IeTkm7oJujNPmWgMHoSbjV631c8ZjQh/GM/ImRcz+wrmqrqCBcSq2RcG8/f/yavcVKBUkde2zAM5Nk/sF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGHSFDHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGHSFDHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA10C32782;
	Tue, 23 Apr 2024 21:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908756;
	bh=hmvFB+QjwpaSQnc1MvcAQazA/GcynFSnE8UacCe/dNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGHSFDHHQEsJ4UIRk4OO6lx0Gzi+qBgLtlxirbsF7ld7y/tTRDZ1qeGbeVlTljxEb
	 AEgc2gp7QDGJML14SpycgWck8pWoWT3mEflddqMHxwg4SW4oX5q/fH2TGWIhiApd6p
	 CMOjT1TGIBn6oRp1fjHxtB/8NX9s/mJS/c1f76jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 6.1 107/141] serial: stm32: Reset .throttled state in .startup()
Date: Tue, 23 Apr 2024 14:39:35 -0700
Message-ID: <20240423213856.660806575@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1021,6 +1021,7 @@ static int stm32_usart_startup(struct ua
 		val |= USART_CR2_SWAP;
 		writel_relaxed(val, port->membase + ofs->cr2);
 	}
+	stm32_port->throttled = false;
 
 	/* RX FIFO Flush */
 	if (ofs->rqr != UNDEF_REG)


