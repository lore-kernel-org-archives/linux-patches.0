Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772F3313E00;
	Wed,  3 Dec 2025 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776774; cv=none; b=L3ZWMiL2kt7uWwCMXvj3w9PubNf2SAenC0MLcN8WpTAHjn9uROfJPxj79/27FWoPV0Dht5P25x9likVPN8nMxcGQooduHbev9xGw/RqD8KoDX+ZBs8WB5CLNTJiWq1BGn3JpZX7YV48cXTGlXOL3vzsC+tRQygeIYSWcQjQmH4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776774; c=relaxed/simple;
	bh=pSGhcBfJhahy2gBzPJKAdbyI1+fPWhZ7S52p42w8Ecc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZIULfEt4CEfewzlB8fvrupz04ZTOtZufvUCotzeDmc8bfw+7eoCUx9bOjZntHLSTk5N2/HFYzHaL1RRNdkFL7pMi4XO0aGqXYqJRamQi6NHmcbHU0gyhwqH44kn2yufDDVPKlZN4X5zwgJrKIQsVLdr2WxWUP032pLBYrVlEHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlaxKgf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlaxKgf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF731C4CEF5;
	Wed,  3 Dec 2025 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776774;
	bh=pSGhcBfJhahy2gBzPJKAdbyI1+fPWhZ7S52p42w8Ecc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlaxKgf831oqp75SMmZZUk+Y/VfKZqmw5Jb5dxmRqjwBYwMNHprnx9gp/xio7zl/J
	 Mc76IM1JbwzqORFUbsO/iccrYdG/pO9XbGGBfbC7mcB21I43zl+ijwvWFiv1P1B7+8
	 w9g41cydnZ6F8+abQ8/lcGUP1vptSZjzxlU7sNcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 284/300] xhci: dbgtty: Fix data corruption when transmitting data form DbC to host
Date: Wed,  3 Dec 2025 16:28:08 +0100
Message-ID: <20251203152411.145565022@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit f6bb3b67be9af0cfb90075c60850b6af5338a508 upstream.

Data read from a DbC device may be corrupted due to a race between
ongoing write and write request completion handler both queuing new
transfer blocks (TRBs) if there are remining data in the kfifo.

TRBs may be in incorrct order compared to the data in the kfifo.

Driver fails to keep lock between reading data from kfifo into a
dbc request buffer, and queuing the request to the transfer ring.

This allows completed request to re-queue itself in the middle of
an ongoing transfer loop, forcing itself between a kfifo read and
request TRB write of another request

cpu0					cpu1 (re-queue completed req2)

lock(port_lock)
dbc_start_tx()
kfifo_out(fifo, req1->buffer)
unlock(port_lock)
					lock(port_lock)
					dbc_write_complete(req2)
					dbc_start_tx()
      					kfifo_out(fifo, req2->buffer)
					unlock(port_lock)
					lock(port_lock)
					req2->trb = ring->enqueue;
					ring->enqueue++
					unlock(port_lock)
lock(port_lock)
req1->trb = ring->enqueue;
ring->enqueue++
unlock(port_lock)

In the above scenario a kfifo containing "12345678" would read "1234" to
req1 and "5678" to req2, but req2 is queued before req1 leading to
data being transmitted as "56781234"

Solve this by adding a flag that prevents starting a new tx if we
are already mid dbc_start_tx() during the unlocked part.

The already running dbc_do_start_tx() will make sure the newly completed
request gets re-queued as it is added to the request write_pool while
holding the lock.

Cc: stable@vger.kernel.org
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Tested-by: Łukasz Bartosik <ukaszb@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251107162819.1362579-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.h |    1 +
 drivers/usb/host/xhci-dbgtty.c |   17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -110,6 +110,7 @@ struct dbc_port {
 	struct kfifo			write_fifo;
 
 	bool				registered;
+	bool				tx_running;
 };
 
 struct dbc_driver {
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -37,7 +37,7 @@ dbc_send_packet(struct dbc_port *port, c
 	return size;
 }
 
-static int dbc_start_tx(struct dbc_port *port)
+static int dbc_do_start_tx(struct dbc_port *port)
 	__releases(&port->port_lock)
 	__acquires(&port->port_lock)
 {
@@ -47,6 +47,8 @@ static int dbc_start_tx(struct dbc_port
 	bool			do_tty_wake = false;
 	struct list_head	*pool = &port->write_pool;
 
+	port->tx_running = true;
+
 	while (!list_empty(pool)) {
 		req = list_entry(pool->next, struct dbc_request, list_pool);
 		len = dbc_send_packet(port, req->buf, DBC_MAX_PACKET);
@@ -67,12 +69,25 @@ static int dbc_start_tx(struct dbc_port
 		}
 	}
 
+	port->tx_running = false;
+
 	if (do_tty_wake && port->port.tty)
 		tty_wakeup(port->port.tty);
 
 	return status;
 }
 
+/* must be called with port->port_lock held */
+static int dbc_start_tx(struct dbc_port *port)
+{
+	lockdep_assert_held(&port->port_lock);
+
+	if (port->tx_running)
+		return -EBUSY;
+
+	return dbc_do_start_tx(port);
+}
+
 static void dbc_start_rx(struct dbc_port *port)
 	__releases(&port->port_lock)
 	__acquires(&port->port_lock)


