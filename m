Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705803;
	b=Y46x2nw1A1OyOVAB1czkd/k0GJIJ6DndrL3ZpzFWNSt3Hoe6+M99Llo3+XMb1hI5q3GQ
	 pVtzx0+eXNXnLh2uAAk8JVMsmaylzUFmq8Hm/HPptjeVrsDMtSsIBWsLSR//ywnH5lB5H
	 QWK+qF2SPYMOYunuwAT1WGuTi3WKIXd2WESev7o/zWkazQKOUc1FJhG00w2qV3ifEo1fw
	 dGOVlYTEL7yo3++UUcxWdvs7VF4zSyDcMVDIayrpHJxavO3OmOUawYkZVTrbc5awqAn5M
	 g2DUYjjtQfPA1PCApH2p3mTOXrlsy4Reaw4dTvmEkcYopQeyOmUmDytAuSKqTS93ipg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Ml74lhORHD4WjtxlOCYV4a+Z2F/MHYGwgxlAI9VI4w=;
	b=vIAwdOnOr1tW9VyJXcwBNLlnZwvgA3YUsByTgiBO9TSWb7RAVtDstV/kKDSrnRoqhf51
	 34WjdjDF+Tz00Af/m2JaEqXpcHDHw9NEK1ug0ZeQpMIvCfxULo48Egm53bTclqjwHVgSI
	 4Lmr1GUDIYW/B/JoNHHOx2lyQSt0PcvFpzJ2p0gqhmzNFRhnmgphzaYKbFxF1BE3kZ6S+
	 FiQNwXSt3CYKgmOTV9bBbu2epzJyb5xpElqoWePx+z2m9AGfxkoR1jnKm3IxbsOiQDFnJ
	 b1VIlRuaNMLIJusBh+mv8z5a27BBWrvoY8sI59Q7kWYpw76E0P4bAzYGjtN/NV7keqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdrbWl6h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2BC606A31C;
	Thu, 26 Nov 2026 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdrbWl6h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049311F000CA;
	Thu, 26 Nov 2026 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705802;
	bh=6Ml74lhORHD4WjtxlOCYV4a+Z2F/MHYGwgxlAI9VI4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdrbWl6hhEwjgHS8fwegiN0f85VIp3uHZsXiAscpBo0176PZx2qyLSktKAz+d10ho
	 Zjsp755AhJmDlfdEhP8nvPgysKd6Kvme2vZ+BG+gwKqEvw2FUu2BqNFukNSZ8bxDys
	 8Aj/HAfbN8iXlLmn6HhqbHerq7NOZ6eUVN50m118=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 5.15 275/319] usb: gadget: f_midi: fix UAF race during IN request handling
Date: Thu, 26 Nov 2026 15:40:43 +0100
Message-ID: <20261126144012.960633329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


