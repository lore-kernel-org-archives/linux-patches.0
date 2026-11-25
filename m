Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620560;
	b=ntAZk2lk8CVQmzJUn+4DzpXid0iRT6vTcSLu+dc0WxA3bP+4ChxdQB2+nRdF39jeeVSn
	 PZCK7JHeCKfkM47cKWeNfA90OFgsAn6UwjL+1mflfW2chgKcabsGOjnEZVnbxUro0ZGCv
	 W50lBG7XGJTq3JS4Qc4QkE4m/CFDuAj5XpeQL3J5avRZe1VV40zR3Y7QUoKxWXnIO8Dme
	 wi6/JUfUJJVcPzGvJDYqQvtXCn66/F7bew4DR7vyF6aDOA5N42ysBIUXU8KInoeba2fGv
	 byNz2nfG7ElvLVzVagONOUMIB6Qp8qPHNQVIVX+QEpo9O0cToZs2ympbCG5wBAQooWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QfqogHw9bHvXlziun7N30fpDa++m02pG/bFjZXZsiX8=;
	b=RC9szAP6hH6LoTkm+FtNC+ZWsIf6Noi9A/tuSpJqxleacK17UxZJFxRMCb7wSoZxxKM2
	 ziVNyYLpWv48RjRYi0Sc0KQyaHVGiLNJa6u9Ah8IPG1LuUVA9WYU0pIZOHYY+7FrhV0gR
	 4J9ejgFgrmrVE/1YMlXyN/se3pVHi+IvlkSuWGtIdlZ5uNEJavf7SmhYjjjs022R0eFpF
	 WEMGpk2Fxid4jTYGdrnj8bIelgk0bZdYd07b12yUwpY1TQ8z4F0sCwgFllCoMIUlKojqq
	 UATGy04sqEqSwNu/4hUibqah7ttL+uuuWoG+kBKX/Tr0WNP28EI6Bjn2q8bUmKaUv6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2o8l6ER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A70F606A31E;
	Wed, 25 Nov 2026 15:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2o8l6ER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6701F000C6;
	Wed, 25 Nov 2026 15:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620560;
	bh=QfqogHw9bHvXlziun7N30fpDa++m02pG/bFjZXZsiX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2o8l6ERvUOfMxaPKaflzzpV4VkLKCwUJVEx0Oi+Z0g4wmj4TZWDEoMhJIwSSC7LM
	 0ewVEqYN8PC9XTBb8npNGNSKs+RXuV4JMRndXioFfWpjNz1e9GFpuPQLlXqshVOccz
	 eyGt4+r+7iOtoFaPiaqe+Uo5U0ufUPiRzrX5YBqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0958/1005] USB: serial: io_edgeport: fix potential NULL-deref at open
Date: Wed, 25 Nov 2026 15:38:16 +0100
Message-ID: <20261125143844.114440206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


