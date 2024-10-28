Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1241015B10D;
	Mon, 28 Oct 2024 06:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097282; cv=none; b=Orym06Oh/oPBKkc6BQFHz4ZigvYQtXJkrVseZJhHUexK0nYaVpVqYNeiPzT4KcRooZX7zBAnxvWDifEBzjJ1OOLyZEHUAI9vnpOUkACQPEbiL7XdBzhxnkvKmSteGUGq3iNKZsuGjnRVaisE9FpQZ6a60zO/Ubw85q6alTJ6b3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097282; c=relaxed/simple;
	bh=YrZpVut7wzslC8mZ1V9t02cI+jFLHD/1r6UdNqFLXC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2a3rZIYbQaKHgePzXOC92vvcYJmE5MiMuqcyhxEKWk4JUmmARvrsDvxFBU8O/OqESakAhKUaAQUUquZIY6SjKnmiaVNpMeLjVyJ4ipbSKl9oRpfFSVb5gK5CkXi0DgbCg/VaEg7/4o9O5XvK/5QtHbNXc6DysfodKv3RziudbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKSJxjnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKSJxjnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3132C4CEC3;
	Mon, 28 Oct 2024 06:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097281;
	bh=YrZpVut7wzslC8mZ1V9t02cI+jFLHD/1r6UdNqFLXC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKSJxjnT5TxgUZP/zFAgZAZ6LFE4Mah/vXPZEO4HtWYTIfCu08WIhkiCSH73eLsaj
	 rEsXzfoZsnkyxgqnR1ssZamWzLoH2jMPat+h1jfXhvNDbVOSqxdevfttSTzhc2AUYd
	 eayPHN8QrJDyqGI3+0K+gjp6ddXXonGzo7V7kFio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday M Bhat <uday.m.bhat@intel.com>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/137] xhci: dbc: honor usb transfer size boundaries.
Date: Mon, 28 Oct 2024 07:24:58 +0100
Message-ID: <20241028062300.443161778@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 30c9ae5ece8ecd69d36e6912c2c0896418f2468c ]

Treat each completed full size write to /dev/ttyDBC0 as a separate usb
transfer. Make sure the size of the TRBs matches the size of the tty
write by first queuing as many max packet size TRBs as possible up to
the last TRB which will be cut short to match the size of the tty write.

This solves an issue where userspace writes several transfers back to
back via /dev/ttyDBC0 into a kfifo before dbgtty can find available
request to turn that kfifo data into TRBs on the transfer ring.

The boundary between transfer was lost as xhci-dbgtty then turned
everyting in the kfifo into as many 'max packet size' TRBs as possible.

DbC would then send more data to the host than intended for that
transfer, causing host to issue a babble error.

Refuse to write more data to kfifo until previous tty write data is
turned into properly sized TRBs with data size boundaries matching tty
write size

Tested-by: Uday M Bhat <uday.m.bhat@intel.com>
Tested-by: Łukasz Bartosik <ukaszb@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241016140000.783905-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgcap.h |  1 +
 drivers/usb/host/xhci-dbgtty.c | 55 ++++++++++++++++++++++++++++++----
 2 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgcap.h b/drivers/usb/host/xhci-dbgcap.h
index 0d4d60758af97..caeadfb8760b6 100644
--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -108,6 +108,7 @@ struct dbc_port {
 	struct tasklet_struct		push;
 
 	struct list_head		write_pool;
+	unsigned int			tx_boundary;
 
 	bool				registered;
 };
diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index f6e25a1cec115..6dd7e8c8eed08 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -24,6 +24,29 @@ static inline struct dbc_port *dbc_to_port(struct xhci_dbc *dbc)
 	return dbc->priv;
 }
 
+static unsigned int
+dbc_kfifo_to_req(struct dbc_port *port, char *packet)
+{
+	unsigned int	len;
+
+	len = kfifo_len(&port->port.xmit_fifo);
+
+	if (len == 0)
+		return 0;
+
+	len = min(len, DBC_MAX_PACKET);
+
+	if (port->tx_boundary)
+		len = min(port->tx_boundary, len);
+
+	len = kfifo_out(&port->port.xmit_fifo, packet, len);
+
+	if (port->tx_boundary)
+		port->tx_boundary -= len;
+
+	return len;
+}
+
 static int dbc_start_tx(struct dbc_port *port)
 	__releases(&port->port_lock)
 	__acquires(&port->port_lock)
@@ -36,7 +59,7 @@ static int dbc_start_tx(struct dbc_port *port)
 
 	while (!list_empty(pool)) {
 		req = list_entry(pool->next, struct dbc_request, list_pool);
-		len = kfifo_out(&port->port.xmit_fifo, req->buf, DBC_MAX_PACKET);
+		len = dbc_kfifo_to_req(port, req->buf);
 		if (len == 0)
 			break;
 		do_tty_wake = true;
@@ -201,14 +224,32 @@ static int dbc_tty_write(struct tty_struct *tty,
 {
 	struct dbc_port		*port = tty->driver_data;
 	unsigned long		flags;
+	unsigned int		written = 0;
 
 	spin_lock_irqsave(&port->port_lock, flags);
-	if (count)
-		count = kfifo_in(&port->port.xmit_fifo, buf, count);
-	dbc_start_tx(port);
+
+	/*
+	 * Treat tty write as one usb transfer. Make sure the writes are turned
+	 * into TRB request having the same size boundaries as the tty writes.
+	 * Don't add data to kfifo before previous write is turned into TRBs
+	 */
+	if (port->tx_boundary) {
+		spin_unlock_irqrestore(&port->port_lock, flags);
+		return 0;
+	}
+
+	if (count) {
+		written = kfifo_in(&port->port.xmit_fifo, buf, count);
+
+		if (written == count)
+			port->tx_boundary = kfifo_len(&port->port.xmit_fifo);
+
+		dbc_start_tx(port);
+	}
+
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
-	return count;
+	return written;
 }
 
 static int dbc_tty_put_char(struct tty_struct *tty, unsigned char ch)
@@ -242,6 +283,10 @@ static unsigned int dbc_tty_write_room(struct tty_struct *tty)
 
 	spin_lock_irqsave(&port->port_lock, flags);
 	room = kfifo_avail(&port->port.xmit_fifo);
+
+	if (port->tx_boundary)
+		room = 0;
+
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
 	return room;
-- 
2.43.0



