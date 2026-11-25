Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620474;
	b=vKZ2k+Nr2p++XSO022h2RBTfAeInUdTxkxzGF37dlHu0ewpUi7Os84CDoJrK8MZXHttH
	 1mkMVrqQ9t/MwimY2AafgeOJsRTDKfavmdZuRygaQkIWsFYPftSHYI55SLtukgXB3CPG7
	 4M3SQ2fHwJxJu6tC3jf8vuIIFLVS4IpNnLP9m1nQ1uYXpuKVdddiAkqvQuQOCguLzsYAo
	 9Am1Fr1tjhV/4FyvZcvlV0Qy3A9Ny0BF/1qahUSgTguQJxj76eNsE7NkTSk0eLLwaIimM
	 TanFgJjTwcnh6t2hI9HfyIh/PP6UanFof80Y+pgr2VhhAu1v+s5edbdwzSh8nBmgYPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k/YneSbEumJlmAq0UcHUoqgiwz8b9otwGTogKSUn3/4=;
	b=xMi04/gFxdopjyalkpHgK5jsHETFoZwXTsgzbfs95KnOOBDXX26T9lO5Wu3CTT4J1yCs
	 iV3YcPNj1JPu0yT0t5KoCQNmrFEKI+dDfWOGVzuYir/FXzNGGrwie0wNV5PfQ1173BSQG
	 EflQ946sYBp97pWWWjauRj4LcgP5ydQgdZSRODZeay/21+ikP8Zswk3Nfn3+wFhyahNss
	 rrSp/z8/XobUnHaK9YKvq4xCilLuNIsq5W5hwmvHzUeF2XYxAQXcMrPtMY1uKPp6AEWg7
	 LM57pQXQsGtt1ACbkF5BdBIoVYcReVTCppzd/oDY+OS2p37kKORDr8UvO/bxfWFhUmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=saOig2Wa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EF8606A326;
	Wed, 25 Nov 2026 15:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=saOig2Wa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12BC1F000C0;
	Wed, 25 Nov 2026 15:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620474;
	bh=k/YneSbEumJlmAq0UcHUoqgiwz8b9otwGTogKSUn3/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saOig2WaRbeOiydCaf39YBXFavuhMVj4Pl91Bqn1IGgK2kEDMbPRXDzDsRfYgpQfK
	 Rkw82xsP6HjF2m1r00W24NJ+ppV9EEZGEL8qwNR8JuXQX7l0Oqm/l4rj57VmsqeIIS
	 kCBelB4nlZv0h7ayxq7T9JC4Gth9pXaTH8h7mSFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 7.3 0928/1005] usb: gadget: f_midi: fix UAF race during IN request handling
Date: Wed, 25 Nov 2026 15:37:46 +0100
Message-ID: <20261125143843.425232042@linuxfoundation.org>
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


