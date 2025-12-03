Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FBF31619D;
	Wed,  3 Dec 2025 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780843; cv=none; b=tD5jXufYawdk6Wdoj8L7MbamB1SyyhCKFd7aqjj3tWTteYkS/JnaQq9kXURjhmbZvdhSntkwl9kdm5vUBWHZT85ev79awjXpHF3714gDI4pQQI+zNotwTyLt0em8lxhH7rMxw+DSdSvN0jY294uKpEeUOzLEgF5vq8KGgsrfpWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780843; c=relaxed/simple;
	bh=1U9nTeqC1oBjUe6YhOMCmzYzMKGvsoD60V6fOLCQzQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zy5T6G/ENpj5SwS1wYpBhvDEQ9gV4hCpxJms8fyYxkh6QP/hvL8j5hbnexkcM8/nIgLfWp5NnUgOlq2SCyFSMfwa56kd6L+kQQBp3Tf/muMvKHGHuAuxfVuOPtIzXrP4QLp7uan02lrobDOHZLMovSFUQQtt04nUkMYDqBtqAdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9NjjIrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9NjjIrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C87C4CEF5;
	Wed,  3 Dec 2025 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780842;
	bh=1U9nTeqC1oBjUe6YhOMCmzYzMKGvsoD60V6fOLCQzQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9NjjIrGfdhMonsU07soJk/ytuiURPk06fMUOG5D3hV0kzKnsFpncd96dPxxsGc+P
	 uYAlUreEI8qZ5QBHghSguER7EAm3KVSXh4gkWgF0PCNmTKjsd5UC5IHxkxMI//YrJl
	 zyi3tQkEVfqNwkSNlRaoemC/cbx25jyJz8mJAcgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 099/132] xhci: dbgtty: Fix data corruption when transmitting data form DbC to host
Date: Wed,  3 Dec 2025 16:29:38 +0100
Message-ID: <20251203152346.954643306@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -114,6 +114,7 @@ struct dbc_port {
 	unsigned int			tx_boundary;
 
 	bool				registered;
+	bool				tx_running;
 };
 
 struct dbc_driver {
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -47,7 +47,7 @@ dbc_kfifo_to_req(struct dbc_port *port,
 	return len;
 }
 
-static int dbc_start_tx(struct dbc_port *port)
+static int dbc_do_start_tx(struct dbc_port *port)
 	__releases(&port->port_lock)
 	__acquires(&port->port_lock)
 {
@@ -57,6 +57,8 @@ static int dbc_start_tx(struct dbc_port
 	bool			do_tty_wake = false;
 	struct list_head	*pool = &port->write_pool;
 
+	port->tx_running = true;
+
 	while (!list_empty(pool)) {
 		req = list_entry(pool->next, struct dbc_request, list_pool);
 		len = dbc_kfifo_to_req(port, req->buf);
@@ -77,12 +79,25 @@ static int dbc_start_tx(struct dbc_port
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


