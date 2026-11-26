Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705722;
	b=cdcNgyOW0afSHBDTsLi9Sxe/a74eZ0zQry8JvjlG076RjHdWjCC/gqa04v/ON9Ngr8rc
	 EWv1pBuN7PPps/ScVqPq6y+x8RNHvgYKRXM06dOzpz80xhzyUlN+nxm8Neqi9gLaCRtlX
	 n4UgMniL3pJehzBpRLepQ1kFw1Ndf97zs0Xsx7U/sXoflnedtLgKqPsu3Shl8yvDMLCjl
	 uB1xjgFmX927hZQAUGyLQJv109mLPPuyUs10rPbUJu7iMW3Rgs2eiCcv6M6dKjLvGBzQT
	 IkjIhHw2agLd3roIBei1JAJDIezNkLfN1jo5PYlsVNsHPvcxYVHoQOHSuijPefBZZvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GcTv826ikbqd6i3ZP/4Ee6ZmvbVs9ORyys77VAx0gWA=;
	b=QmfVwkfn5Bl8UjUtYR8vGAJBRtiE8YTforiW3OP5HqtRn7AC3t9cik4bsLtc+Djq99iI
	 P+S3+mBEPwXrjnFyxmSiLjSIh75cEkCnTtiMJGH0uy+wlgWE6ft+EvbIQtsoljJvKMU+S
	 mvLUYIvyoRsuBLlbFQDHc8JNpo97Wf0Sdj13+HEy/KCTHhDCvLaul+IUZLKaB255FP+Nj
	 BhHNLHaLWETCaI2LhKMqkCTDtG/CZAwec03DR+aoepE1yKPBl5VOWUYP1QGIq7ytQkWSa
	 f3IYN9+F5qxuuUiM5zt9xm8pq9ALO31h6TahEM3F+ibj6n5YlDKAieADBSnGpg0StIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7b7G6n7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89081606A326;
	Thu, 26 Nov 2026 15:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7b7G6n7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30D81F000C4;
	Thu, 26 Nov 2026 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705722;
	bh=GcTv826ikbqd6i3ZP/4Ee6ZmvbVs9ORyys77VAx0gWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7b7G6n7fru+IaKOQpWlwe4Gi5rCZCmYVexq6x83LNhnQ9sZENFtxwOiPuKWUdbai
	 tLozF9XeGaQWTJmH4MM1Xq7Yx9RFbsyUtrr02lCjwOag2/A9yisyMEFyygZ4czSJdH
	 IEIqPKXnHWncom50jo5u7/JtNfHiZtSGSY43QkBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 293/319] USB: serial: io_edgeport: fix potential fifo corruption
Date: Thu, 26 Nov 2026 15:41:01 +0100
Message-ID: <20261126144013.372234590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -878,13 +878,17 @@ static int edge_open(struct tty_struct *
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
@@ -1756,6 +1760,7 @@ static void process_rcvd_status(struct e
 	struct tty_struct *tty;
 	struct device *dev;
 	__u8 code = edge_serial->rxStatusCode;
+	unsigned long flags;
 
 	/* switch the port pointer to the one being currently talked about */
 	if (edge_serial->rxPort >= edge_serial->serial->num_ports)
@@ -1799,6 +1804,12 @@ static void process_rcvd_status(struct e
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
@@ -1816,6 +1827,8 @@ static void process_rcvd_status(struct e
 
 		/* we have completed the open */
 		edge_port->openPending = false;
+		spin_unlock_irqrestore(&edge_port->ep_lock, flags);
+
 		wake_up(&edge_port->wait_open);
 		return;
 	}


