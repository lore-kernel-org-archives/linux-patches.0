Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623688;
	b=CKJgkPLR53h298D7N9xti2T0ZpY8YEDLLOpPFtu+tPnJa0m04Yvu0aXzX1FaUjDC1zFE
	 k/wcWmLzMlrvCQ5fMTHgyH8iDClv+7ja3kADLfzk+m9dNMEppZRfnuXyvOb3KiFR3h6P2
	 PL2lUfgWC0AY3+65Y+MW4rkB+S8QFq1JCWNpMjkiJ1wivuLGepZ80XDSpS/1hNdtQQjym
	 YeFiGGnECl9U0stMDGgxc210AeZO5Wjl5t3u0zphLmUPIbbItybZoX4PJBmFDXfX/zVV5
	 SGW/77oT5c/NObU4h3GDpksQvt5ztzkyVqSrHS2ML8rHn8/pfJrrT4cpbvRHtdahfSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Al9h9DXG2fCWLDrwqs1DSJnVrMqWY7UUymshHj3+Zw=;
	b=AV+6M3JZ2azjHq2xTeJ2mEJhhbgvcmyTWO1Wftj2wPSB/mJztMUv1oGu3UYFGVqaZ3iB
	 y/fKvA0kd9qRQYTpf/5UKEZv4dvwss2ROMJ6z1iBMCjMTzg+x/VhLKIkLyNpgLZ7CN5ME
	 5qMRvpbtCoy+6SBDUfxaPTqib3mW/RcJo4yMJmMvklUPq/OUttMdYdiRCe/xt7FqmdNfx
	 hNngwtiEXQ9wm6cIXfeCMkgAywqQ8d/opDMBPdmssk09EoFECtYj4aH2ilqIoKGn5fkBh
	 5ZNlZnve0ZwaZm0BByoRarmcd6NV8R/RuCDjIaDfyxVGu/ffpAQUFqjmBe523L6S03Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkzZjtac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3E606A684;
	Wed, 25 Nov 2026 16:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkzZjtac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C5D1F000CF;
	Wed, 25 Nov 2026 16:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623688;
	bh=1Al9h9DXG2fCWLDrwqs1DSJnVrMqWY7UUymshHj3+Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkzZjtacCKw31umJ9E6L0o5Gc2+k659hsFB1gfeMknT++BFzev3SGQPX8kXgcQhh/
	 mSq2HtBNao+tSvYNmTRQFHgqRyu87Jwuz/MeGK6qzN4Qx26R4/xVVp381L8kQXOIxJ
	 YXXRCwgqM2LIhSJ0hwUt8+LZ/kNJHn6Du7A81SW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 940/990] USB: serial: io_edgeport: fix potential fifo corruption
Date: Wed, 25 Nov 2026 15:38:27 +0100
Message-ID: <20261125143844.010089343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -877,13 +877,17 @@ static int edge_open(struct tty_struct *
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
@@ -1736,6 +1740,7 @@ static void process_rcvd_status(struct e
 	struct edgeport_port *edge_port;
 	struct device *dev;
 	__u8 code = edge_serial->rxStatusCode;
+	unsigned long flags;
 
 	/* switch the port pointer to the one being currently talked about */
 	if (edge_serial->rxPort >= edge_serial->serial->num_ports)
@@ -1779,6 +1784,12 @@ static void process_rcvd_status(struct e
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
@@ -1787,6 +1798,8 @@ static void process_rcvd_status(struct e
 
 		/* we have completed the open */
 		edge_port->openPending = false;
+		spin_unlock_irqrestore(&edge_port->ep_lock, flags);
+
 		wake_up(&edge_port->wait_open);
 		return;
 	}


