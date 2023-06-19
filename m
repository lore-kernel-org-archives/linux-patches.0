Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C235FBE56
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4835EC433C8;
	Mon, 19 Jun 2023 10:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172117;
	bh=g0CC2XjnWHN7o46Alid9OcWQuVHVkrpIHUcsONZdWno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkkbiqkibNswbBKRRfCBlVp3VikCOFEGMCCTKtUAYsUr+Z1GEBoeKCs2if3W566NC
	 KE7iUxRAV400MYPEnrlB+hp0+pRV6lRhodfyI++WrzP6RsAwXClJSuirmT+Y3CN/I4
	 AAn7mv+DZQIC4i+wq4pHxjGPR4vWD6AprBwO8HSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernhard Seibold <mail@bernhard-seibold.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.10 43/89] serial: lantiq: add missing interrupt ack
Date: Mon, 19 Jun 2023 12:30:31 +0200
Message-ID: <20230619102140.253398555@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bernhard Seibold <mail@bernhard-seibold.de>

commit 306320034e8fbe7ee1cc4f5269c55658b4612048 upstream.

Currently, the error interrupt is never acknowledged, so once active it
will stay active indefinitely, causing the handler to be called in an
infinite loop.

Fixes: 2f0fc4159a6a ("SERIAL: Lantiq: Add driver for MIPS Lantiq SOCs.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bernhard Seibold <mail@bernhard-seibold.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Message-ID: <20230602133029.546-1-mail@bernhard-seibold.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/lantiq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -274,6 +274,7 @@ lqasc_err_int(int irq, void *_port)
 	struct ltq_uart_port *ltq_port = to_ltq_uart_port(port);
 
 	spin_lock_irqsave(&ltq_port->lock, flags);
+	__raw_writel(ASC_IRNCR_EIR, port->membase + LTQ_ASC_IRNCR);
 	/* clear any pending interrupts */
 	asc_update_bits(0, ASCWHBSTATE_CLRPE | ASCWHBSTATE_CLRFE |
 		ASCWHBSTATE_CLRROE, port->membase + LTQ_ASC_WHBSTATE);


