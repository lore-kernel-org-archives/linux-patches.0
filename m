Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D217730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E366BC433D2;
	Mon, 15 May 2023 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684174045;
	bh=3RDzR2M24iuajjTUPCCSKWYArwSnVgoVdBcrM8iFaL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcubOBwwgf6HHsOnc89PQ6kHvnkbUejxn/DYe3XcZ54+JkNVm+j/MRx6capuVBdfh
	 kv2WilM54HFHXAGHuL2ogc2g7/rTli6P+hH4v3fa92wT5hdW8Olzs1pah55K1oyZPb
	 YYDQ78DJ+EZyqDAhmwp8RoyOXfsTZmWN+j0GQW1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.4 269/282] serial: 8250: Fix serial8250_tx_empty() race with DMA Tx
Date: Mon, 15 May 2023 18:30:47 +0200
Message-Id: <20230515161730.379893816@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Ilpo J�rvinen" <ilpo.jarvinen@linux.intel.com>

There's a potential race before THRE/TEMT deasserts when DMA Tx is
starting up (or the next batch of continuous Tx is being submitted).
This can lead to misdetecting Tx empty condition.

It is entirely normal for THRE/TEMT to be set for some time after the
DMA Tx had been setup in serial8250_tx_dma(). As Tx side is definitely
not empty at that point, it seems incorrect for serial8250_tx_empty()
claim Tx is empty.

Fix the race by also checking in serial8250_tx_empty() whether there's
DMA Tx active.

Note: This fix only addresses in-kernel race mainly to make using
TCSADRAIN/FLUSH robust. Userspace can still cause other races but they
seem userspace concurrency control problems.

Fixes: 9ee4b83e51f74 ("serial: 8250: Add support for dmaengine")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230317113318.31327-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 146a37e05d620cef4ad430e5d1c9c077fe6fa76f)
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250.h      |   12 ++++++++++++
 drivers/tty/serial/8250/8250_port.c |   12 +++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -305,6 +305,13 @@ extern int serial8250_rx_dma(struct uart
 extern void serial8250_rx_dma_flush(struct uart_8250_port *);
 extern int serial8250_request_dma(struct uart_8250_port *);
 extern void serial8250_release_dma(struct uart_8250_port *);
+
+static inline bool serial8250_tx_dma_running(struct uart_8250_port *p)
+{
+	struct uart_8250_dma *dma = p->dma;
+
+	return dma && dma->tx_running;
+}
 #else
 static inline int serial8250_tx_dma(struct uart_8250_port *p)
 {
@@ -320,6 +327,11 @@ static inline int serial8250_request_dma
 	return -1;
 }
 static inline void serial8250_release_dma(struct uart_8250_port *p) { }
+
+static inline bool serial8250_tx_dma_running(struct uart_8250_port *p)
+{
+	return false;
+}
 #endif
 
 static inline int ns16550a_goto_highspeed(struct uart_8250_port *up)
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1922,19 +1922,25 @@ static int serial8250_tx_threshold_handl
 static unsigned int serial8250_tx_empty(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
+	unsigned int result = 0;
 	unsigned long flags;
 	unsigned int lsr;
 
 	serial8250_rpm_get(up);
 
 	spin_lock_irqsave(&port->lock, flags);
-	lsr = serial_port_in(port, UART_LSR);
-	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+	if (!serial8250_tx_dma_running(up)) {
+		lsr = serial_port_in(port, UART_LSR);
+		up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+
+		if ((lsr & BOTH_EMPTY) == BOTH_EMPTY)
+			result = TIOCSER_TEMT;
+	}
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	serial8250_rpm_put(up);
 
-	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
+	return result;
 }
 
 unsigned int serial8250_do_get_mctrl(struct uart_port *port)


