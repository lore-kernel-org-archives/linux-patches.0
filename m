Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705719;
	b=ekL/I6iYa600vAaPGLcPLvoShun5PPB7V+HLxq4IZbXJr3CLXTYH0dakPrbRJm1DFh8j
	 4l7R4veE4/la3ndJDo1jpSwZVEXUDJA/FSsS5aTLO2jqKFA2IQanaC+E9YOfWeOC9KQ7C
	 f+4onYHPWqVV/okSrb171Vd9kb4aAn8NsHB3mx6K5YMGLLCLT28zJgMaSnQzGcYD/HPX8
	 9er9jjrdvzALr8n5EUW1nblysfHgONpVD9k2a2uUnWIBIwxywjqXAtSKUcaAItEx8Iimm
	 IVfiK9RPZ/LMxT+u3uPfeuRxO0YByT0azD/B3UE6AilJ+FCR28GcRKHptTMyOVy0hpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sS0GIiaAGe7TtRIK5ErIZybh39yICVQXHc404Ssql0k=;
	b=VUF9JXmfs1xMKUph7IF/VSkwvnsWVF6NbLzAwtMrNqNCejNdryzoSw0wdvtzdrjpBz3f
	 5n6ZU8vAdAfC4y0oCaCbnSGXBsnyvvnzyFLs+rAIWLiylzl+CwWujqrOq7EiPA3Yln4Yp
	 /CDYv2fpds72vd9z6FwOQhzFYDQ/nVmfotBOX5JB6fjHRNWKl+9lcc23LYn4/EY36+J6D
	 y9r7rIpzAHKIL57hcmJQV5bksl+JTt8Oo875YRbRE8lV75kV9HGfW72h3sTXw3a0pjr8z
	 KlWP9pNjsvqDFzchG+D0Fi1x2m8mNgiXq9ZDWWdN6ua+X1qipZ/4j0DAtdur5vt5Mxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmHcjU+P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BBD606A331;
	Thu, 26 Nov 2026 15:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmHcjU+P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97921F000EE;
	Thu, 26 Nov 2026 15:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705719;
	bh=sS0GIiaAGe7TtRIK5ErIZybh39yICVQXHc404Ssql0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmHcjU+Pwqpr1KPGhrUQWdjJ1p/lubJdRV6IGnfah+SgGQCYhdfRTI2Z7ZYuz83mq
	 drQlVs57BcpLn93XSNzCU9A9Gx30J6k+fPkjyLtpJFM4lP9vtUbvpbOvTI6TV9NzSK
	 bzcsaJ3+0i7W70hfN/TvOpNdbe1Qaset3EtUK+5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 292/319] USB: serial: io_edgeport: fix potential NULL-deref at open
Date: Thu, 26 Nov 2026 15:41:00 +0100
Message-ID: <20261126144013.349884796@linuxfoundation.org>
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
 		dev_dbg(dev, "%s - open timedout\n", __func__);
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
 
@@ -1815,7 +1816,6 @@ static void process_rcvd_status(struct e
 
 		/* we have completed the open */
 		edge_port->openPending = false;
-		edge_port->open = true;
 		wake_up(&edge_port->wait_open);
 		return;
 	}


