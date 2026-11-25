Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626235;
	b=uDa9yS9y/UflhkpA1X4Q8yRDQCFDFAOmaBJ+3tvEDLsVdvtHsGKwM3UoZ2Ln0lAuzYQJ
	 WmxmWmWyIQdLIGNCICremicHNIbeWg2S+aumy0QDhUeEJXGsoVEHTTjr+2eNXZZsXwRqq
	 I5gGX+Ej752b6A1jFSe8/pOaqzwenxUcY3fdnHTThRJyVcTFivKv+B0bNDhUSWefOHiZj
	 tfBOb/RiHYHMn8JTMdczvM4YTQvNKzgQ83FrZcArcddqK92Keplw9WaUp6eMACCZLrmXq
	 dEOfKUnoteKlCF9gACMU8wqBuoyLMOtpSkdE6NilGrrDShAnRcibldO99LP2TpXF0HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e9EBlCdnnA4Glrd8mQDE2K25L87C67RnP+LrAp5Y4J0=;
	b=qQjrCy+0ZnJTWpMGWAM8kCZUYtWIq+LNTag3V+gSORgSkKG7sG/d69PurSo+fObn2DGr
	 aO1yl18rplhBfH1bA+cUI2dest/Dta/E11h2F9kzsqJjJC05a9SmAzN4n2YAkfLDeAwZ/
	 kelFt/aHcCUuszdM0qKGNenFT3g5heteRCKzyLSYzImnYnQHHejq14tdpU9QMnrG4eyfb
	 4Z6UIbnwKbajMEE8fsG2wG+cDuBY3vx2xkPqh/5TreBkXPdaowugq/hxfL8m3gpGx5OVC
	 MFeTPyJmrTk1DAlWhDhMQeSBN6KrXKMJcKpqoFBJaOZk2o0sCKRm/NxCy5qsmOUhziQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1vDVw9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A718606A339;
	Wed, 25 Nov 2026 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1vDVw9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855C01F0093C;
	Wed, 25 Nov 2026 17:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626235;
	bh=e9EBlCdnnA4Glrd8mQDE2K25L87C67RnP+LrAp5Y4J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1vDVw9HbG3mFIuAS1rOFm9/lImswI6Q+meW7ZZmjXQgfRHRRKhHWOMR+u2PHSs4M
	 3j6JG5G19Hw6cC6ahu1aEaOLPrMYNFytEsZbZg4w657199TqMrzCSYb2EAGONXXcHT
	 nbI35zG0FscDIaDZxTCO79IX5PO8Tp9wjrryXgd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 777/816] USB: serial: io_edgeport: fix potential fifo corruption
Date: Wed, 25 Nov 2026 15:38:45 +0100
Message-ID: <20261125143907.157075211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


