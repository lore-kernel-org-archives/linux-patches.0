Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704860;
	b=RC0G3jrgIkEDKSAfAc3TrdlXykG7UZ3909AH6XE6Hd+MWPT/Z1QpvfmROp+wemZjVHXt
	 w2DKPxkzSnWOp+KcIwbWkcyvPuY0kgrXaplonel2hBcySI2PweSGZdh0XiA/Sk2CqRQ8O
	 C4J8VDvZNdYw7D+0LPSHlRSQ2Ru9NIxOahViiURqO488nA9MHJvZYpyIZbsCfyYEgm58A
	 S3vlBHnAKTL9PT9Oh0Lhfd/UELpKL6o4pf10L0a1lR/Cd5N4G3ChA3TTRq65OMJss1Xt7
	 sFqSIbzWG/b104gBOodIas+/X3v/Rp3NWMHKHGPpW2g2Zq41+TpzbtkxzIVJvVq2geQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DPUXsQB0SGscO2Ebf8nCNZlztWQ/RDNKbjLp+zDfucE=;
	b=HPfQbRLRYiz7DFnuoL815kCRXMLcPA/s7yLq748BpZ7WzSEjAVSPPd+ksX9eKHlhoKb2
	 nA3L/Zd998KN+sXjEFt7eyUgbSbXgLjlltbTMwbgr0E8+qAPKCeYNWPADy3vizcofi1nk
	 bAMj4OCbSpY/8lmNuLMe0oY8DqT4fswrsD5Nz41xsccpgFpyl0co1P68Ajjz6Dzlc0HG8
	 QmSzPk4ZDasnAudaPugI83/S66gamulCmcAbwq6MmCkoYV/8w0phYeKAJiBlbYCbxOCOf
	 aBEZ/uF+F9GWojoKP8E4C5GMc9mzqNcpGrj/xlRT8ruxMZ8lRiRYyYupMWYLo7yl4Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+KTSHwr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E2A606A31C;
	Thu, 26 Nov 2026 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+KTSHwr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CA61F000D0;
	Thu, 26 Nov 2026 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704859;
	bh=DPUXsQB0SGscO2Ebf8nCNZlztWQ/RDNKbjLp+zDfucE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+KTSHwrZ345GBwRe6FdW+P7Supsqk2Ij9f13JkkriFxX4VSlIQmWox8MTlNY/uaD
	 vVT1rB5tl3t6SBHrLOldkZM4x9hjm5NB2TfmH767fW43Q3UCQORKLYmXnCTWBQIU4P
	 pbVmzAB1ANGzUsMU3RGQZXM0NMTxlzyI+volZ+6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 239/265] USB: serial: io_edgeport: fix potential NULL-deref at open
Date: Thu, 26 Nov 2026 15:39:29 +0100
Message-ID: <20261126143621.982228877@linuxfoundation.org>
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

commit a0403880a0a638f189e5187068244d9fd5bc8d4d upstream.

Do not mark the port as open until after the write FIFO has been
allocated and initialised to prevent a racing interrupt completion from
attempting to send stale data and dereference the FIFO buffer pointer.

Note that the open flag defaults to false and is cleared on close() so
there is no need to reinitialise it on every open().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -961,9 +961,7 @@ static int edge_open(struct tty_struct *
 
 	/* send a open port command */
 	edge_port->openPending = true;
-	edge_port->open        = false;
 	response = send_iosp_ext_cmd(edge_port, IOSP_CMD_OPEN_PORT, 0);
-
 	if (response < 0) {
 		dev_err(dev, "%s - error sending open port command\n", __func__);
 		edge_port->openPending = false;
@@ -973,8 +971,7 @@ static int edge_open(struct tty_struct *
 	/* now wait for the port to be completely opened */
 	wait_event_timeout(edge_port->wait_open, !edge_port->openPending,
 								OPEN_TIMEOUT);
-
-	if (!edge_port->open) {
+	if (edge_port->openPending) {
 		/* open timed out */
 		dev_dbg(dev, "%s - open timedout\n", __func__);
 		edge_port->openPending = false;
@@ -1002,6 +999,10 @@ static int edge_open(struct tty_struct *
 		return -ENOMEM;
 	}
 
+	spin_lock_irq(&edge_port->ep_lock);
+	edge_port->open = true;
+	spin_unlock_irq(&edge_port->ep_lock);
+
 	dev_dbg(dev, "%s - Initialize TX fifo to %d bytes\n",
 		__func__, edge_port->maxTxCredits);
 
@@ -1934,7 +1935,6 @@ static void process_rcvd_status(struct e
 
 		/* we have completed the open */
 		edge_port->openPending = false;
-		edge_port->open = true;
 		wake_up(&edge_port->wait_open);
 		return;
 	}


