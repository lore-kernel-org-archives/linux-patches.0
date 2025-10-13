Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A69230BBA3;
	Mon, 13 Oct 2025 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368715; cv=none; b=BnOS2Hns9gVZWh/QFAIO70Pv9wmgR2HxVXEaeScffI9D8fbJ4B4TxuEonUBzagaOowSdRhiOEntDWSsDXBIuTqepwdUVP0Eez6Cja8/ceDqrqM1Tzd8nUNOG6O/9oMPy3lc+UpzecSBLgQAChWWL+AO7YK5tNbktNrMSoPJWhws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368715; c=relaxed/simple;
	bh=x5rdQJqWvaw5kSkWsaJ8nuSHegAfZF8hmE1MgNpj21Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOwztItUQir5GVWctDGkQULPiO1NpC4E+eTCYs3KnYXWHwJHSljyNBx4W/NJYGdFR3ldjOmiWQVj1j7UdA21B6SGopUjLmK+8LHPqIN4X0ymoRsW4nTMppMJoPGJrLeNib2KMh06JKh6xxMiZZo5esJG/1HlwPAfChm1vdi+H68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/uvH8VT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/uvH8VT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85054C4CEE7;
	Mon, 13 Oct 2025 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368714;
	bh=x5rdQJqWvaw5kSkWsaJ8nuSHegAfZF8hmE1MgNpj21Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/uvH8VT+1lLqg1WGJ06xuHtDoPKJKn5a0LOVJObevdTJJi7IkyYYQBoZ79vfLo/V
	 MUUNGRpr3KUsrKiaxPrDnm17b0G9vyi66MqFLU3sTeOogh0t73InCW368/Uxf+c9z2
	 q4vCn5N/t40MAfaRkZ+ZXBfCKIX7nHJ+Sr3bJunE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.12 258/262] net/9p: Fix buffer overflow in USB transport layer
Date: Mon, 13 Oct 2025 16:46:40 +0200
Message-ID: <20251013144335.525446542@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


