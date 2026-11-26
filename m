Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704863;
	b=pOKR0sKLH1jy5hR6dUoWP48p629Plgj/tFVOkBZVjiCHSi8fmm8k78BW9R9N38sAD0Vb
	 J4/apzBHY53OxqbFMu/3GFXIr3bS63tJolfTYuwDRvXtv/6sG/Z7sW1KPDR/Gtz3k8R31
	 7tRwn4imOn0F7reaRM4+3LQzj5jwzvtZxVQ6MzsaSYi/8A7wiQOiql+Beo5pZhLxXHGlv
	 YCUCZZudVbKJSdhk2u2/t9QuEVWEHXkzEsXv1lqSjO7xoOU783SEOjwkbNDokBo/Jf8Nj
	 RUR1/8n36HZQPYZUgUAP+HxZbppJn82gl35pRgExsSqyUfymjtKzzd8Qyqpv+iBIlTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+NWogKwrxo1YqtaogdxRUQtVmEBmTvW8iEVqUH1+T1o=;
	b=yaNBgsFzuvT9eMTk16Wc7GqqImiytx7xTso5nkiT5jSWLmEMp+K4UZ6DGPAW3eobbKPS
	 ScFLxPRw28aFHmjtIXiqrnUvCCQVuo2hnZkWugNHMz1vncLzp3oNDCb8JuorAYte62xOq
	 CI5gB+frBdWDwsfm2vEh+4VqxZ0BqDuZB7EOWOHUFOK5eslAbi44djA3ZJXxLGa1tHDGf
	 eDqxWNefHoR0LBztsBp5PuoO2PxUGoleSmcYBvQTK+KSdPQIoH8g5IAHQR7AsMgLBci9K
	 GiCmuQK9tD2k9Bt2/lNn7isbPaF8RZU1vIYm0n5gLw0/LN2QFPN65+LJhrxGX6tOg6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLV5WYSv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C742606A31C;
	Thu, 26 Nov 2026 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLV5WYSv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2DB1F000C6;
	Thu, 26 Nov 2026 14:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704862;
	bh=+NWogKwrxo1YqtaogdxRUQtVmEBmTvW8iEVqUH1+T1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLV5WYSvE2wdHz4WbUhmDI0QRCqO+AqkcN0RKYe3XR6tU4NDMdkBQ0Ku2PDj9DgrA
	 WYE8VMcrLLbuy/VD3mBYzB9a4AyiPl3yXcN4ajW1ILkPW/ne98Mnmzz7RzM4izqRRY
	 JnbXUeMVwgWCqDi7J3QU2OZB6WAzJkDgopQ9tEaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 240/265] USB: serial: io_edgeport: fix potential fifo corruption
Date: Thu, 26 Nov 2026 15:39:30 +0100
Message-ID: <20261126143622.067531579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 270f76c3b88c9cc3d6ca58c5c0c0f34c2373b27c upstream.

The device buffer size is determined during open() and the driver
allocates a TX FIFO of corresponding size.

Add the missing sanity check to prevent memory corruption in case a
malicious device sends a second open response with a different buffer
size.

This issue was flagged by Sashiko when reviewing a related fix.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260714101316.823942-1-shpark061104%40gmail.com?part=1
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -954,13 +954,17 @@ static int edge_open(struct tty_struct *
 	}
 
 	/* initialize our port settings */
+	spin_lock_irq(&edge_port->ep_lock);
 	edge_port->txCredits = 0;	/* Can't send any data yet */
+	edge_port->maxTxCredits = 0;
+	edge_port->openPending = true;
+	spin_unlock_irq(&edge_port->ep_lock);
+
 	/* Must always set this bit to enable ints! */
 	edge_port->shadowMCR = MCR_MASTER_IE;
 	edge_port->chaseResponsePending = false;
 
 	/* send a open port command */
-	edge_port->openPending = true;
 	response = send_iosp_ext_cmd(edge_port, IOSP_CMD_OPEN_PORT, 0);
 	if (response < 0) {
 		dev_err(dev, "%s - error sending open port command\n", __func__);
@@ -1875,6 +1879,7 @@ static void process_rcvd_status(struct e
 	struct tty_struct *tty;
 	struct device *dev;
 	__u8 code = edge_serial->rxStatusCode;
+	unsigned long flags;
 
 	/* switch the port pointer to the one being currently talked about */
 	if (edge_serial->rxPort >= edge_serial->serial->num_ports)
@@ -1918,6 +1923,12 @@ static void process_rcvd_status(struct e
 	}
 
 	if (code == IOSP_STATUS_OPEN_RSP) {
+		spin_lock_irqsave(&edge_port->ep_lock, flags);
+		/* reject stray open responses to avoid FIFO corruption */
+		if (!edge_port->openPending) {
+			spin_unlock_irqrestore(&edge_port->ep_lock, flags);
+			return;
+		}
 		edge_port->txCredits = GET_TX_BUFFER_SIZE(byte3);
 		edge_port->maxTxCredits = edge_port->txCredits;
 		dev_dbg(dev, "%s - Port %u Open Response Initial MSR = %02x TxBufferSize = %d\n",
@@ -1935,6 +1946,8 @@ static void process_rcvd_status(struct e
 
 		/* we have completed the open */
 		edge_port->openPending = false;
+		spin_unlock_irqrestore(&edge_port->ep_lock, flags);
+
 		wake_up(&edge_port->wait_open);
 		return;
 	}


