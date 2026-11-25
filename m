Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626156;
	b=ewWZ8fb2r8VrRPa4X/sY2/ScgttZd+loC8g8TrtyGz9TVFC730zEIVmc1mdn0uaL8tsO
	 m5Ed/2MUn+xYaDl6na80gOzkXA7EejJ8IxdNxhausIymdXqFUNnmGEO8WXCl1g3Di9wCi
	 22E/XKOZNa3XEBvK3+rDWF7qBFNq2scRRgO5nvQ5G0jV1TPGa2y1II8IBk8VjtvSVJMrF
	 fGN9IvzQboIvcwsT9PaG3MgFqv1TfcgOuJTVzV+fXmS03dMUZ1hI05UgXDBc3+fekzozO
	 1XNeAo+XnX5axfCXKYMUmU2ae+V47QdgBYKOFJ0YBwPY0/X3LMynJilSy0Np7Jh8uyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bq9B4t7jADk4d1Q0FYCQRsiEuAbG+xJwz8Ws9hP5UfE=;
	b=oUK7dKNYgam+iPfvQD2IZtWuptg7nlLvD121DSjcHaJyEZkk+DtpiF/G19KcCXZIvCWu
	 lQgPx5uaxDgce9vAT59Glbv4Tlzvh843CEI8S610a+/P9UPkdsInCeiW0SI3/ky6xKB60
	 Xzpg2ZfghKrdU6QBd9MUTBB8HBjNhSha0ugNidburW94M1vs1aeB6hpX9hvNqS6OLaVKL
	 ofmcb4Z3mFEeeoWgbf5EE5xrsDVJYm6qZuEkNbN7scgRkPwbCWdyLfwVi+CkL0QOD5kTz
	 ecoPWqLVOB12ltTm8Ox/JSVJ4HOAyf5mjInhci9kuMr/tyXVusQoKqQsNV6d4e54HZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/RPV6RN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D32606A31E;
	Wed, 25 Nov 2026 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/RPV6RN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869CF1F000C0;
	Wed, 25 Nov 2026 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626156;
	bh=Bq9B4t7jADk4d1Q0FYCQRsiEuAbG+xJwz8Ws9hP5UfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/RPV6RN23u/7/wtvvwL/cMFvGfRn83//IGUCGW2WWM2tHxIVSfdIlv0tYtkADJ5p
	 K8E9ptxVuAZRzaPQxRFB4L7YpdYQiTh/NrlEcWEAaw6orbmUjmXT6qq+L/L2LC4Y4K
	 pYc+1J/TCDTTZMT54odaICHOujyUQyPHzglgVH9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 6.12 748/816] usb: gadget: f_midi: fix UAF race during IN request handling
Date: Wed, 25 Nov 2026 15:38:16 +0100
Message-ID: <20261125143906.488721587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


