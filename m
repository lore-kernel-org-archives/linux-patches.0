Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704736;
	b=4ngSIWheKoocgJyA2S2VpYgf109b4GZpBL7pQuHXTNQWZsnwVHNZRuwT1gMyOO8AmkpP
	 1KixdeYEmPd+ebyRw5V5m238pMdCk5fU3MfWFvLcvJKlciZKSqDCoEoh9EiVYYGlp+cRn
	 fLbFXB9xP6g0Ie2LnT3mR+q/yBpA/Mik2R33CKXWQJh9O8eO/YOoR4omhcKoBMZMFmUjj
	 1MA9tzdv1t8pZ+ZWR0SQZCnRPnCP8u7vNXnakAsvudTLypofUHNcUMVLlt0au6fa66KmM
	 OMRBui2B/PmNJiZu2YYBinaqy45Gb7fdHETw5ot8WAoEEF1aBkVMuOP8IQY1fAZ3wag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xpW5gZ+TCqMY2/v8XQ71o6UWlw09hODsThLUrT2xf+4=;
	b=DbXLIOtbz7U1yTE1fR3pXKFHeEV/Q932d+u+mrxgWaNOc+fGFSZoe/ILzOF/uLazwegP
	 3xogeOLrMxO8VcGPZygFo1TmQrtMwPo9UP4O+PDUT3PFWfS00DDy/7Zmeq4VI+fRoo4DN
	 /H742Ydjuu0PcTVxsW6p3mSnw9u5pKal061vO5KwcnHI4SuvJJm+yKmFgrJBeA0LJkoIv
	 B/wLKmhw3bX7RbQN+jGF8XMYCAhfj5MTKqAkdE3NNd70ddZgXMIfUwxjtfA3o542VsbZN
	 MPL0s0SO6kmsYB3/5/vzzSoELtl1DTwWhjjxL+8WZDm4YkBgcAB2kAGLt3zdLaKh2TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLNiXc1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94921606A323;
	Thu, 26 Nov 2026 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLNiXc1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F7B1F000C6;
	Thu, 26 Nov 2026 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704736;
	bh=xpW5gZ+TCqMY2/v8XQ71o6UWlw09hODsThLUrT2xf+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLNiXc1B2yf/qZ+q0B4TKKqXUL7JKmV5ZdPQ1C+MPMDJQzrKpkdXUvFPHZ1rPvuaW
	 osSkFvWf67Qh8aHOpFD/6LyGBIze97frybl8xhr7oa/fK7cddZyKB8FutrZ7C5+mFI
	 yffkM3vw9qVfxJzafJUNbWfok2Zngja6qS1aBjac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 5.10 225/265] usb: gadget: f_midi: fix UAF race during IN request handling
Date: Thu, 26 Nov 2026 15:39:15 +0100
Message-ID: <20261126143620.991634531@linuxfoundation.org>
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

From: Sonali Pradhan <sonalipradhan@google.com>

commit 78a8d6537f1de34770e460edee360b556ef40427 upstream.

f_midi_disable() drains and frees pre-allocated IN requests from
in_req_fifo without holding midi->transmit_lock. If f_midi_transmit()
runs concurrently on the workqueue, f_midi_do_transmit() can peek a
request from in_req_fifo and write into its buffer while
f_midi_disable() frees it, leading to a use-after-free.

Additionally, when usb_ep_queue() fails in f_midi_do_transmit() (such
as with -ESHUTDOWN when the endpoint is disabled concurrently), it
resets req->length = 0 and returns active instead of the error code,
causing the do-while loop in f_midi_transmit() to keep spinning under
midi->transmit_lock until the substream is drained.

Fix this by acquiring midi->transmit_lock in f_midi_disable() while
releasing IN requests from in_req_fifo, and returning the error code
from f_midi_do_transmit() when usb_ep_queue() fails so f_midi_transmit()
aborts immediately and drops active substreams.

Fixes: e1e3d7ec5da3 ("usb: gadget: f_midi: pre-allocate IN requests")
Cc: stable <stable@kernel.org>
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20261028074821.579450-1-sonalipradhan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -419,6 +419,7 @@ static void f_midi_disable(struct usb_fu
 	struct f_midi *midi = func_to_midi(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 	struct usb_request *req = NULL;
+	unsigned long flags;
 
 	DBG(cdev, "disable\n");
 
@@ -430,8 +431,10 @@ static void f_midi_disable(struct usb_fu
 	usb_ep_disable(midi->out_ep);
 
 	/* release IN requests */
+	spin_lock_irqsave(&midi->transmit_lock, flags);
 	while (kfifo_get(&midi->in_req_fifo, &req))
 		free_ep_req(midi->in_ep, req);
+	spin_unlock_irqrestore(&midi->transmit_lock, flags);
 
 	f_midi_drop_out_substreams(midi);
 }
@@ -660,6 +663,7 @@ static int f_midi_do_transmit(struct f_m
 		ERROR(midi, "%s failed to queue req: %d\n",
 		      midi->in_ep->name, err);
 		req->length = 0; /* Re-use request next time. */
+		return err;
 	} else {
 		/* Upon success, put request at the back of the queue. */
 		kfifo_skip(&midi->in_req_fifo);


