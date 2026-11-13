Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590235;
	b=cS14aEIYcP/3XP8UrmXztLMK6rxTRxFu1KsCM9FvwZxgIiUSo0yqLAMh6X0i37h1TAHr
	 TE3MXH9W6NwlYDxNd6KrYFHRzPPOEAFeXQ9o9gojpWXGzTg6PBJClCWBwlzqkeZZ+Kjfk
	 IPjki0R1+lDsF+hEwdqjHogicmISAgbLeDukAeMA3XIshzdx9H1e3I9q+xn5K2fVsVEws
	 /3oCGs2+4pgUeto4SjDIpHrC4plJA27YusTu12gfkrJlh0Ld41ZfUvMQ+HxLnbkfQLjeU
	 98q3B7VfwsHPAhRTelOEv/vpdezdbQE8C0RhCcS+kXnufQ1RvAlcSC3qtT37PR7UgEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cIc8mGcO00u/3nja+Ou8wQXRJUoflazEN4DmvWWyw3A=;
	b=1QC/1JgICQVEnrFTQTtmVe2nC/I98yPIMWPe9U8nWZNrpiPnEEyYFdtu0BHssfottii1
	 VViKsdKoKgn3Vn4zTYhjtJ43Fbmfmlugx7ULxXxvsCrX8YjRaXfapEXw2ivmgbvyolGLY
	 ICp9HOopXt6PWKfy5tguZFVPmWT1yuaV6zItAKxitrXa+SxbYwxAitYO8mzLJECZrUP+h
	 byANRMf0s8JjAhu+npkjgieug6bU477n0w6bns8VM76f4JAGP5SentGYQY4rFvcJps6u3
	 XXG7vL00OXcmFyXogKMv9txPJhdunYdskSAg2CFtwMS04LQfoJf6z2KYsQDikd94HVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZyNdFYCO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9776075E1D;
	Fri, 13 Nov 2026 17:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZyNdFYCO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DA01F000C5;
	Fri, 13 Nov 2026 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590235;
	bh=cIc8mGcO00u/3nja+Ou8wQXRJUoflazEN4DmvWWyw3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZyNdFYCOLsynslNCaq7E/XQkBRhqXVDL9OVa8RuGYfVMsP7GTYvaqNQhyOK3kQblv
	 7A+pwtwygyccszN5sqqNJcGsTO4eSQ2vlWjRmHOGmpltNTS8W9wrrc4miwTnJe3TWE
	 5lGqS1rU+mvIe3gRtAswLKwbLn8rCs5bGsZIB7L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 192/686] net/9p/usbg: clear stale client pointer on close
Date: Fri, 13 Nov 2026 10:45:25 -0500
Message-ID: <20261113153827.556056853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Hyungjung Joo <jhj140711@gmail.com>

[ Upstream commit a478958f4c1181ff3362f8857b489c2d069f9c7d ]

p9_usbg_close() tears down the client transport, but usb9pfs keeps
using usb9pfs->client from asynchronous TX and RX completion handlers.
A late completion can therefore dereference a client that has already
been freed during mount teardown.

Clear usb9pfs->client under usb9pfs->lock when closing the transport,
detach any pending TX request from in_req->context, and make the TX/RX
completion handlers bail out once the transport has been detached. This
keeps late completions from touching a freed or rebound p9_client.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Signed-off-by: Hyungjung Joo <jhj140711@gmail.com>
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-7-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 61 +++++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 16 deletions(-)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index ed8f01ead839a..938e3130ab81a 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -148,7 +148,8 @@ static void usb9pfs_tx_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct f_usb9pfs *usb9pfs = ep->driver_data;
 	struct usb_composite_dev *cdev = usb9pfs->function.config->cdev;
-	struct p9_req_t *p9_tx_req = req->context;
+	struct p9_client *client;
+	struct p9_req_t *p9_tx_req;
 	unsigned long flags;
 
 	/* reset zero packages */
@@ -164,18 +165,25 @@ static void usb9pfs_tx_complete(struct usb_ep *ep, struct usb_request *req)
 		ep->name, req->status, req->actual, req->length);
 
 	spin_lock_irqsave(&usb9pfs->lock, flags);
-	WRITE_ONCE(p9_tx_req->status, REQ_STATUS_SENT);
+	client = usb9pfs->client;
+	p9_tx_req = req->context;
+	req->context = NULL;
 
-	p9_req_put(usb9pfs->client, p9_tx_req);
+	if (!client || !p9_tx_req)
+		goto unlock_complete;
 
-	req->context = NULL;
+	WRITE_ONCE(p9_tx_req->status, REQ_STATUS_SENT);
 
+	p9_req_put(client, p9_tx_req);
+
+unlock_complete:
 	spin_unlock_irqrestore(&usb9pfs->lock, flags);
 
 	complete(&usb9pfs->send);
 }
 
-static struct p9_req_t *usb9pfs_rx_header(struct f_usb9pfs *usb9pfs, void *buf)
+static struct p9_req_t *usb9pfs_rx_header(struct f_usb9pfs *usb9pfs,
+					  struct p9_client *client, void *buf)
 {
 	struct p9_req_t *p9_rx_req;
 	struct p9_fcall	rc;
@@ -201,7 +209,7 @@ static struct p9_req_t *usb9pfs_rx_header(struct f_usb9pfs *usb9pfs, void *buf)
 		 "mux %p pkt: size: %d bytes tag: %d\n",
 		 usb9pfs, rc.size, rc.tag);
 
-	p9_rx_req = p9_tag_lookup(usb9pfs->client, rc.tag);
+	p9_rx_req = p9_tag_lookup(client, rc.tag);
 	if (!p9_rx_req || p9_rx_req->status != REQ_STATUS_SENT) {
 		p9_debug(P9_DEBUG_ERROR, "Unexpected packet tag %d\n", rc.tag);
 		return NULL;
@@ -211,7 +219,7 @@ static struct p9_req_t *usb9pfs_rx_header(struct f_usb9pfs *usb9pfs, void *buf)
 		p9_debug(P9_DEBUG_ERROR,
 			 "requested packet size too big: %d for tag %d with capacity %zd\n",
 			 rc.size, rc.tag, p9_rx_req->rc.capacity);
-		p9_req_put(usb9pfs->client, p9_rx_req);
+		p9_req_put(client, p9_rx_req);
 		return NULL;
 	}
 
@@ -219,7 +227,7 @@ static struct p9_req_t *usb9pfs_rx_header(struct f_usb9pfs *usb9pfs, void *buf)
 		p9_debug(P9_DEBUG_ERROR,
 			 "No recv fcall for tag %d (req %p), disconnecting!\n",
 			 rc.tag, p9_rx_req);
-		p9_req_put(usb9pfs->client, p9_rx_req);
+		p9_req_put(client, p9_rx_req);
 		return NULL;
 	}
 
@@ -230,8 +238,10 @@ static void usb9pfs_rx_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct f_usb9pfs *usb9pfs = ep->driver_data;
 	struct usb_composite_dev *cdev = usb9pfs->function.config->cdev;
+	struct p9_client *client;
 	struct p9_req_t *p9_rx_req;
 	unsigned int req_size = req->actual;
+	unsigned long flags;
 	int status = REQ_STATUS_RCVD;
 
 	if (req->status) {
@@ -240,9 +250,16 @@ static void usb9pfs_rx_complete(struct usb_ep *ep, struct usb_request *req)
 		return;
 	}
 
-	p9_rx_req = usb9pfs_rx_header(usb9pfs, req->buf);
-	if (!p9_rx_req)
+	spin_lock_irqsave(&usb9pfs->lock, flags);
+	client = usb9pfs->client;
+	if (!client) {
+		spin_unlock_irqrestore(&usb9pfs->lock, flags);
 		return;
+	}
+
+	p9_rx_req = usb9pfs_rx_header(usb9pfs, client, req->buf);
+	if (!p9_rx_req)
+		goto out_unlock;
 
 	if (req_size > p9_rx_req->rc.capacity) {
 		dev_err(&cdev->gadget->dev,
@@ -256,8 +273,11 @@ static void usb9pfs_rx_complete(struct usb_ep *ep, struct usb_request *req)
 
 	p9_rx_req->rc.size = req_size;
 
-	p9_client_cb(usb9pfs->client, p9_rx_req, status);
-	p9_req_put(usb9pfs->client, p9_rx_req);
+	p9_client_cb(client, p9_rx_req, status);
+	p9_req_put(client, p9_rx_req);
+
+out_unlock:
+	spin_unlock_irqrestore(&usb9pfs->lock, flags);
 
 	complete(&usb9pfs->received);
 }
@@ -410,7 +430,9 @@ static int p9_usbg_create(struct p9_client *client, const char *devname, char *a
 		client->status = Disconnected;
 	else
 		client->status = Connected;
+	spin_lock_irq(&usb9pfs->lock);
 	usb9pfs->client = client;
+	spin_unlock_irq(&usb9pfs->lock);
 
 	client->trans_mod->maxsize = usb9pfs->buflen;
 
@@ -421,18 +443,25 @@ static int p9_usbg_create(struct p9_client *client, const char *devname, char *a
 
 static void usb9pfs_clear_tx(struct f_usb9pfs *usb9pfs)
 {
+	struct p9_client *client;
 	struct p9_req_t *req;
+	unsigned long flags;
 
-	guard(spinlock_irqsave)(&usb9pfs->lock);
+	spin_lock_irqsave(&usb9pfs->lock, flags);
+	client = usb9pfs->client;
+	usb9pfs->client = NULL;
+	req = usb9pfs->in_req ? usb9pfs->in_req->context : NULL;
+	if (usb9pfs->in_req)
+		usb9pfs->in_req->context = NULL;
+	spin_unlock_irqrestore(&usb9pfs->lock, flags);
 
-	req = usb9pfs->in_req->context;
-	if (!req)
+	if (!req || !client)
 		return;
 
 	if (!req->t_err)
 		req->t_err = -ECONNRESET;
 
-	p9_client_cb(usb9pfs->client, req, REQ_STATUS_ERROR);
+	p9_client_cb(client, req, REQ_STATUS_ERROR);
 	usb9pfs->in_req->context = NULL;
 }
 
-- 
2.53.0



