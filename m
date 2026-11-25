Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623682;
	b=cX8eEbDPk693WV08MIN9EMmenLPnl9Z5+lZm7HtDC3j9Jm5jzb1N59ALGjCG8qSoNPI0
	 5fHbFM4dmiu+eBl2ykue5+9lk9tDIPQlEMzpxzq/rd968AhsCZOvwXpfJKrmkWRMh3w+h
	 PYnFmAONswcA79nkUcK1dtkU63GErwjgTzdB+8EI9UM7Wc93mD9CPVhs8bYlSXpoaCr8Z
	 4Yu4fqVBzrDBfz8RbDmBwbWXRan9N9gvmrK4cGAv9xrfKz+/gfYhpBjoE2sUgXBi4+Tdm
	 7Udrlf0VNMUNY1cQn1JIQAFzbLUkfDZKaI6uiyKSOge5C+oZNKwA74qiE/f7Nvq6srg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=673k1/OsoKZnIByP1RKa9BjgAZu5ZKnuXMR5lCrjljY=;
	b=cLXBmcAbrGiXa51/LQq5mlxLiQ4j3yjDfAw8Ok+/fd/X0zjHRuedNVcJ01K3ZZefwfon
	 HS7XpD5ivjrIIaMQ8qG/COuy9VCcAa3ZAtafcekgk1a+5UQPZgLgV5VRnhlrZleh5g2yt
	 E1FV+ff1rbC6xv4xt7oNrjL9dedWw8zsWoH6+tfGY3jGOmeiTgKP+lVEY2y6hctHfL63V
	 aW9gMrz7ZBnjeb9bNLxVSIMjoyj0lHeVPUmMIWFEkh6w3hW6FHPZbFVMWMo1UM04K+m3+
	 mjb3598IRfUWcRqB1inE3Oy6Usi2oAQu3ZSBolXtMg9n9R4uMArvV/l8y/SphJiaWug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eg8arwr7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742C3606A339;
	Wed, 25 Nov 2026 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eg8arwr7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161121F000CA;
	Wed, 25 Nov 2026 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623681;
	bh=673k1/OsoKZnIByP1RKa9BjgAZu5ZKnuXMR5lCrjljY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eg8arwr7dznxRutEAqk/pkPnzr6VLoQYBL8OTwgaqvFyr+8kuyUNpHxqwKGaIUgx8
	 cy8Zqk1WPQHIOCYBP3k7SFCYpR82wy1OdIy5SuHxMwWUcNAJV/q0ianQli+807W1xf
	 H90CrcftrephUo4CqnHvPu4JJdhSX3TTZdCN8AGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 938/990] USB: serial: io_edgeport: fix potential NULL-deref at open
Date: Wed, 25 Nov 2026 15:38:25 +0100
Message-ID: <20261125143843.963913720@linuxfoundation.org>
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


