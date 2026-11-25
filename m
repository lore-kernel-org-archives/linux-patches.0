Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626229;
	b=tYmxbfp3bGJYKO6pJ2NWVc/CijwSB/1zXsFOcS+XaE2cV3I7mGbaCMiSquzT9nDih6wZ
	 8lOpOfouTudeiO4AQJE407Q+hI/bbGqY8eorm4x1rq33vihrxX43IVL3qNoCZxSwMEVcj
	 RXIf/zsFQvE9qeNnmzSOUeNZSnqsMt8y3e6B+QbJylhnf4fBoj8u9UImasWM7OZNpKaju
	 v0RVI0kkey07fSVTfO0xFK30tJmdmVr9VfnrfCeipxzjS4Ax0j+3dVkaekroY9Kop88g5
	 m7SQ7wr+0+rZcVnm0L3L0I1xlwpLE0CmVbFmNJTC0btAtSx+GMrAMCONEq2MrlidhJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FdVRhkfCfe8AvoR80R2n+U52FI1vn6MSJ4rnwMXwWGI=;
	b=lCbHgj/s0EJV68hmvygTngxpLkAHZm9B28+pxZUeTy4gQif//QhQhLPg0xQbDBUWuCxy
	 zsXZ8BAhzTHzO6abO3ZjRyx8EtxW+OQ5CrxDX0hZT29GfFhX0PuCpxKjh7PfneAeHsHrW
	 xR8OGKNJ/JJHyXJ0IWACUWPwpuCSfuwgcvgmduHTL2A03dolFm7Nmur+aH3SjfKQjt5Br
	 aqeWZd2mwp3H5txczlQGtLoc6IUQE8EKFj8rNpLgi+YF4N+SbeQJwlwyRXSwyCnYB0H2y
	 nuGCisy4FoPqVlPUCeMsAGpdN7BzgOtUgRgxA0hN/dLpkM9AgZkZHLreTix/zWMOKbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwjCRG8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59386606A321;
	Wed, 25 Nov 2026 17:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwjCRG8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CF81F000CA;
	Wed, 25 Nov 2026 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626229;
	bh=FdVRhkfCfe8AvoR80R2n+U52FI1vn6MSJ4rnwMXwWGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwjCRG8o0/9YboIN27QOpb7cM6vvDZfZ1dlL9VbFrNmjTbZg6Uef8kKwmIrGjft/q
	 sigEsbiGMgR/qmCIB5jaZxOJqnZ9cqQRsTEa5fRPE5qDuXV5ylhyNOIup0E+VYva+l
	 IBLU04yVvZFpp0l3NLE18aANGFBnjEcWxiVQ7YoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 775/816] USB: serial: io_edgeport: fix potential NULL-deref at open
Date: Wed, 25 Nov 2026 15:38:43 +0100
Message-ID: <20261125143907.111585177@linuxfoundation.org>
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
@@ -885,9 +885,7 @@ static int edge_open(struct tty_struct *
 
 	/* send a open port command */
 	edge_port->openPending = true;
-	edge_port->open        = false;
 	response = send_iosp_ext_cmd(edge_port, IOSP_CMD_OPEN_PORT, 0);
-
 	if (response < 0) {
 		dev_err(dev, "%s - error sending open port command\n", __func__);
 		edge_port->openPending = false;
@@ -897,8 +895,7 @@ static int edge_open(struct tty_struct *
 	/* now wait for the port to be completely opened */
 	wait_event_timeout(edge_port->wait_open, !edge_port->openPending,
 								OPEN_TIMEOUT);
-
-	if (!edge_port->open) {
+	if (edge_port->openPending) {
 		/* open timed out */
 		dev_dbg(dev, "%s - open timeout\n", __func__);
 		edge_port->openPending = false;
@@ -926,6 +923,10 @@ static int edge_open(struct tty_struct *
 		return -ENOMEM;
 	}
 
+	spin_lock_irq(&edge_port->ep_lock);
+	edge_port->open = true;
+	spin_unlock_irq(&edge_port->ep_lock);
+
 	dev_dbg(dev, "%s - Initialize TX fifo to %d bytes\n",
 		__func__, edge_port->maxTxCredits);
 
@@ -1818,7 +1819,6 @@ static void process_rcvd_status(struct e
 
 		/* we have completed the open */
 		edge_port->openPending = false;
-		edge_port->open = true;
 		wake_up(&edge_port->wait_open);
 		return;
 	}


