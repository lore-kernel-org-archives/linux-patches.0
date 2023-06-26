Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF459134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD4FC433C0;
	Mon, 26 Jun 2023 18:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803942;
	bh=zE6ga+3xDpM3hUIUHTSrvkw52unKR/2Gl3CBRujDtEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBLiy7AebwdUhR1tsg8Y6R0ijshOrRcASYPd+gnQ8COBAY632vKMCL1AT2zyCiIXj
	 uW7h+c/dE7+xmsazItt2VAXGym3m+oWcrZomokJ0KnHOiwAcgRnH/2tNHg1LBPk+O6
	 8G+taThRZv0hrtaSH8Rnmylwi5YPrNj4OeNajBWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernhard Seibold <mail@bernhard-seibold.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/41] serial: lantiq: add missing interrupt ack
Date: Mon, 26 Jun 2023 20:11:27 +0200
Message-ID: <20230626180736.409671006@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180736.243379844@linuxfoundation.org>
References: <20230626180736.243379844@linuxfoundation.org>
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

[ Upstream commit 306320034e8fbe7ee1cc4f5269c55658b4612048 ]

Currently, the error interrupt is never acknowledged, so once active it
will stay active indefinitely, causing the handler to be called in an
infinite loop.

Fixes: 2f0fc4159a6a ("SERIAL: Lantiq: Add driver for MIPS Lantiq SOCs.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bernhard Seibold <mail@bernhard-seibold.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Message-ID: <20230602133029.546-1-mail@bernhard-seibold.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/lantiq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/lantiq.c b/drivers/tty/serial/lantiq.c
index de2d051cd7664..6cd168cb673fd 100644
--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -259,6 +259,7 @@ lqasc_err_int(int irq, void *_port)
 	unsigned long flags;
 	struct uart_port *port = (struct uart_port *)_port;
 	spin_lock_irqsave(&ltq_asc_lock, flags);
+	__raw_writel(ASC_IRNCR_EIR, port->membase + LTQ_ASC_IRNCR);
 	/* clear any pending interrupts */
 	asc_update_bits(0, ASCWHBSTATE_CLRPE | ASCWHBSTATE_CLRFE |
 		ASCWHBSTATE_CLRROE, port->membase + LTQ_ASC_WHBSTATE);
-- 
2.39.2



