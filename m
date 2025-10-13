Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB89C12DDA1;
	Mon, 13 Oct 2025 15:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370347; cv=none; b=UW1HERuIfIQY2kiCI3fEOO80ngyVq1NLmjLzm5aXRvPzhsmYsqa9LukAuFhLt/75zoJqiMuD4Wfox4lBpR9KgUDu/4Uwpxpzr3cNvbn/YFsB8BWmRpFU1ThfLwonsKk0pD4tUPvJfYOWnFjnVxqnIAJ7PRQlz+NGK05HgwbmRck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370347; c=relaxed/simple;
	bh=dCFV6INbMVKpq/jOc/gimzOj2HOlcFXzyvMi/YsdvPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+FurHFPA7K512deCfL1wKCRtfQQQBaFZ+ZMr4fOYL1gnxo4d+8xTmJqMjsuKR9jGWHafQ29CO7N0s2vHeFr/t266DeSo0tH5QK4sGHgeaBshOLHwsW4tjbHeYzMckKu8ZtGRlmwRJGxCftiHbDIdwJJOMiy0f4Eec4g6mc16wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyQtYVdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyQtYVdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6820BC4CEE7;
	Mon, 13 Oct 2025 15:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370346;
	bh=dCFV6INbMVKpq/jOc/gimzOj2HOlcFXzyvMi/YsdvPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyQtYVdL+VhIMN+/qUfkWdhWT2l5YEkW2Ap/tjnefwJhYiX+IDx6AC8HDhlMuTF61
	 0WIFablQiBsduXkDNrNrGm1xLP98WbTZDw9fXqtAeY5iY9rnFsaDpMxvoSgnw0aIfk
	 419Ffy5Yt4lJ+i843wm5/tktoEZF6g28ZDfBdx+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.17 557/563] net/9p: Fix buffer overflow in USB transport layer
Date: Mon, 13 Oct 2025 16:46:58 +0200
Message-ID: <20251013144431.481396891@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

commit c04db81cd0288dfc68b7a0f7d09bd49b40bba451 upstream.

A buffer overflow vulnerability exists in the USB 9pfs transport layer
where inconsistent size validation between packet header parsing and
actual data copying allows a malicious USB host to overflow heap buffers.

The issue occurs because:
- usb9pfs_rx_header() validates only the declared size in packet header
- usb9pfs_rx_complete() uses req->actual (actual received bytes) for
memcpy

This allows an attacker to craft packets with small declared size
(bypassing validation) but large actual payload (triggering overflow
in memcpy).

Add validation in usb9pfs_rx_complete() to ensure req->actual does not
exceed the buffer capacity before copying data.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Closes: https://lkml.kernel.org/r/20250616132539.63434-1-danisjiang@gmail.com
Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Message-ID: <20250622-9p-usb_overflow-v3-1-ab172691b946@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/trans_usbg.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -231,6 +231,8 @@ static void usb9pfs_rx_complete(struct u
 	struct f_usb9pfs *usb9pfs = ep->driver_data;
 	struct usb_composite_dev *cdev = usb9pfs->function.config->cdev;
 	struct p9_req_t *p9_rx_req;
+	unsigned int req_size = req->actual;
+	int status = REQ_STATUS_RCVD;
 
 	if (req->status) {
 		dev_err(&cdev->gadget->dev, "%s usb9pfs complete --> %d, %d/%d\n",
@@ -242,11 +244,19 @@ static void usb9pfs_rx_complete(struct u
 	if (!p9_rx_req)
 		return;
 
-	memcpy(p9_rx_req->rc.sdata, req->buf, req->actual);
+	if (req_size > p9_rx_req->rc.capacity) {
+		dev_err(&cdev->gadget->dev,
+			"%s received data size %u exceeds buffer capacity %zu\n",
+			ep->name, req_size, p9_rx_req->rc.capacity);
+		req_size = 0;
+		status = REQ_STATUS_ERROR;
+	}
+
+	memcpy(p9_rx_req->rc.sdata, req->buf, req_size);
 
-	p9_rx_req->rc.size = req->actual;
+	p9_rx_req->rc.size = req_size;
 
-	p9_client_cb(usb9pfs->client, p9_rx_req, REQ_STATUS_RCVD);
+	p9_client_cb(usb9pfs->client, p9_rx_req, status);
 	p9_req_put(usb9pfs->client, p9_rx_req);
 
 	complete(&usb9pfs->received);


