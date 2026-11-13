Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585439;
	b=Fw2KqJC4KSYSk4PFC0HQpRjaQqHtD8QvzQw+Q8+3plrAsIq9zdibRle07IE5nX/xREXx
	 hCTkaXkjzbtS5IXEQV1wBw1CmIkA787WJJFakCTohhnromPOW3PiKcrrRAM9sEof65pyv
	 r9K08a72DzTYer6aCjt7pjQnj9PWnt9cdtgpQ44VOixnZJ8CBnI3oyqnGJ1/FQZ1L/2pR
	 AxaRDMvNe4Cd1jlaTCgsjcdrrRpQbi2xUPl76WrfyKLejc1m3/jgXBkgL0bhRS5V/e/U6
	 zKPi0RhSzB0XPy3Ue/520rHvPGqSyDmEkrM66mVLLWrEPoUyEpSuCyFY3KtKix3kzgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iXHyIxt43W1YbCTIcz1kBIqeBnbRyxKupmdPDBEMs7I=;
	b=qtZqIsJ4GJiZCoHbeS4FDUTx99w1kaHVK75yutqsWy/hFRr+d1wnMcYaiDNwP6unEcVV
	 RIjMacqeqvcbI5InDbJR2zqXktcnzSV4OMbiD36+41i2fZRhfaNoRYaQ81XGUE87zDTPu
	 VPgqgSe+TsJcYYfeOUlQAey4C4nwzeloC1whQvBrrkEuUt4Eoeb9UPtoqOO23Y4zpsjBz
	 PAgYFI9PbVC5KcOSPidZYCkxdviAz0GABAldtTfOaac5qI1mYTdKDP4LmgeURIgbhKQIv
	 BspYfzz7WdWKTl7xNaEhl05H8sjMUTCfXp7ONKouq0KH9EsiTzIeyrUuvTreti7J2Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mvyyRtey;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689F3606A8B2;
	Fri, 13 Nov 2026 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mvyyRtey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149C71F000C4;
	Fri, 13 Nov 2026 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585439;
	bh=iXHyIxt43W1YbCTIcz1kBIqeBnbRyxKupmdPDBEMs7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvyyRteyl8mqTkvQE8OJb+5UYVSpBvWYoOZHjQbsDaWAc1Ml8ghd4dgxVldV4a9wU
	 Rw7P5FZ7mCiEXZbfB69Kt0pR0QDdnqH1Mfllkhw6yRtjBuJEpsxdr0iaZn+Ybk61wX
	 R5OXDZu4FA/xQeDSPms9Ty/LEhK1NC57D4T/Pcm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 057/507] net/9p/usbg: clear stale client pointer on close
Date: Fri, 13 Nov 2026 10:46:01 -0500
Message-ID: <20261113153755.496358233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 2be5abae03aea..7d600e1288a30 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -149,7 +149,8 @@ static void usb9pfs_tx_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct f_usb9pfs *usb9pfs = ep->driver_data;
 	struct usb_composite_dev *cdev = usb9pfs->function.config->cdev;
-	struct p9_req_t *p9_tx_req = req->context;
+	struct p9_client *client;
+	struct p9_req_t *p9_tx_req;
 	unsigned long flags;
 
 	/* reset zero packages */
@@ -165,18 +166,25 @@ static void usb9pfs_tx_complete(struct usb_ep *ep, struct usb_request *req)
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
@@ -202,7 +210,7 @@ static struct p9_req_t *usb9pfs_rx_header(struct f_usb9pfs *usb9pfs, void *buf)
 		 "mux %p pkt: size: %d bytes tag: %d\n",
 		 usb9pfs, rc.size, rc.tag);
 
-	p9_rx_req = p9_tag_lookup(usb9pfs->client, rc.tag);
+	p9_rx_req = p9_tag_lookup(client, rc.tag);
 	if (!p9_rx_req || p9_rx_req->status != REQ_STATUS_SENT) {
 		p9_debug(P9_DEBUG_ERROR, "Unexpected packet tag %d\n", rc.tag);
 		return NULL;
@@ -212,7 +220,7 @@ static struct p9_req_t *usb9pfs_rx_header(struct f_usb9pfs *usb9pfs, void *buf)
 		p9_debug(P9_DEBUG_ERROR,
 			 "requested packet size too big: %d for tag %d with capacity %zd\n",
 			 rc.size, rc.tag, p9_rx_req->rc.capacity);
-		p9_req_put(usb9pfs->client, p9_rx_req);
+		p9_req_put(client, p9_rx_req);
 		return NULL;
 	}
 
@@ -220,7 +228,7 @@ static struct p9_req_t *usb9pfs_rx_header(struct f_usb9pfs *usb9pfs, void *buf)
 		p9_debug(P9_DEBUG_ERROR,
 			 "No recv fcall for tag %d (req %p), disconnecting!\n",
 			 rc.tag, p9_rx_req);
-		p9_req_put(usb9pfs->client, p9_rx_req);
+		p9_req_put(client, p9_rx_req);
 		return NULL;
 	}
 
@@ -231,8 +239,10 @@ static void usb9pfs_rx_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct f_usb9pfs *usb9pfs = ep->driver_data;
 	struct usb_composite_dev *cdev = usb9pfs->function.config->cdev;
+	struct p9_client *client;
 	struct p9_req_t *p9_rx_req;
 	unsigned int req_size = req->actual;
+	unsigned long flags;
 	int status = REQ_STATUS_RCVD;
 
 	if (req->status) {
@@ -241,9 +251,16 @@ static void usb9pfs_rx_complete(struct usb_ep *ep, struct usb_request *req)
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
@@ -257,8 +274,11 @@ static void usb9pfs_rx_complete(struct usb_ep *ep, struct usb_request *req)
 
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
@@ -412,7 +432,9 @@ static int p9_usbg_create(struct p9_client *client, struct fs_context *fc)
 		client->status = Disconnected;
 	else
 		client->status = Connected;
+	spin_lock_irq(&usb9pfs->lock);
 	usb9pfs->client = client;
+	spin_unlock_irq(&usb9pfs->lock);
 
 	client->trans_mod->maxsize = usb9pfs->buflen;
 
@@ -423,18 +445,25 @@ static int p9_usbg_create(struct p9_client *client, struct fs_context *fc)
 
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



