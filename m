Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623601;
	b=443OfTyqzpT4uJbrjNfVApZBLOo+tl3oPOx/Yx0+h2lvZP5z1sMLnyIGkDRoEFH3QrH3
	 9KSq8CvEk4FEUzMbtjRLYmvw2Z8BTYPbV0LLwJidf/6LlSt/VJfswYEynucJmkycysvME
	 d85QcujuAPOgrpkOoffyuTB6Kn6mWs3LA9dqo1nR3uBmlKm8GUWWg7yksDRw2Q0imo7P1
	 UN3TYid/du55d9neDQ27i30faOT9hBobyH/dmSRFvtnYWK1oE8oOvDrVIjlkAdBz24oy0
	 Zor93ueXkUmMADkL/nH90L0iKyxkw28YrVdV8yXb4br5rkvE0/XnzJweLbS6luy/gIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Njo+NRo3BrQBw3LFhcaLqsgsHs0OFoeljzk3GHSRgL4=;
	b=QpWahg3cq4N9gYhU0CwFuYQ4hEPHo0dYBdw7VHXfNLwnbPYtZMwIm5xoiZ9I+nY32keB
	 bCAURAk04cIhrYanKFT3VSk9TaVF0zE3ur1vGFS3Y2j2pFpCsA1PWd6CSxaXwBR/s7miE
	 OD17igrsdt8wQYiZFfHiGJbmcwAguqfnGjcYSELxbZKwbb6VtH6eDdOgoQxrqfBhhH3IE
	 GScFwzUQm5h5MCv/X/oG2HPoouScDZHsOVGiXHI+8MQAGiwdnKc1k0H+7VbI4nQGXAdvr
	 D9M/VN9oz5TjbYjC/gZellr+jGKHwCMogbqdx15akRGk4PenKv1cpDiM+eSI1okQB+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yDXHlLah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B74F606A333;
	Wed, 25 Nov 2026 16:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yDXHlLah
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB801F000C6;
	Wed, 25 Nov 2026 16:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623600;
	bh=Njo+NRo3BrQBw3LFhcaLqsgsHs0OFoeljzk3GHSRgL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDXHlLahkpBlGJzOdGvqYX05Spd+i2T+LfABbAI1SyPW9xlhLko14FBvXrglgOVPJ
	 XVm12g+KosyjoVfcDrZUwZb/yeSlOStmGHa7ees3yTQBPXWHsInbsocPeaZnU6fvxm
	 wffCw2KT920RJqfty9pzw7YOM8pcMfqvo2UnTeQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 6.18 911/990] usb: gadget: f_midi: fix UAF race during IN request handling
Date: Wed, 25 Nov 2026 15:37:58 +0100
Message-ID: <20261125143843.345021247@linuxfoundation.org>
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
@@ -420,6 +420,7 @@ static void f_midi_disable(struct usb_fu
 	struct f_midi *midi = func_to_midi(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 	struct usb_request *req = NULL;
+	unsigned long flags;
 
 	DBG(cdev, "disable\n");
 
@@ -431,8 +432,10 @@ static void f_midi_disable(struct usb_fu
 	usb_ep_disable(midi->out_ep);
 
 	/* release IN requests */
+	spin_lock_irqsave(&midi->transmit_lock, flags);
 	while (kfifo_get(&midi->in_req_fifo, &req))
 		free_ep_req(midi->in_ep, req);
+	spin_unlock_irqrestore(&midi->transmit_lock, flags);
 
 	f_midi_drop_out_substreams(midi);
 }
@@ -661,6 +664,7 @@ static int f_midi_do_transmit(struct f_m
 		ERROR(midi, "%s failed to queue req: %d\n",
 		      midi->in_ep->name, err);
 		req->length = 0; /* Re-use request next time. */
+		return err;
 	} else {
 		/* Upon success, put request at the back of the queue. */
 		kfifo_skip(&midi->in_req_fifo);


