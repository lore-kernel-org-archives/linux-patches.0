Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214964;
	b=ePER+vUwhXLiOhQZ6bqD+ALaFvq1ywP4XeqnnOlNmdR9Yfq210cm0DNLAYGkAY/oBlA7
	 XvMWq2bD4J34DhtzKDDMixXLu5XW6Gv+GuF+/OeEa1DLTAMdcfYh0KMdbo8UUa0E1MBst
	 UxzxmQYIiY9DUD9V/fst0n5me31Dsudmg/upBkglIaQpdDoIry0dAKxw/N2sPgGetXcsr
	 +dBg4+iXo1iGBoZUUjhjsitTMMXxzpMEjfZNWZkrSP2qFzQKOcUxwxpZDSsw9Wn+w7rGn
	 n1jh/IBY2cOR2z6xsfzLUDnk2F46IyHQ9MkkXXxZwiokyTf9UB1uVrnVy3kR4ZZ1GsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vd83N9p6kM+Dn/CjgTRHvdJyFsdEAtqvbJHqppqWn4M=;
	b=CF7hSOS/hb/5P4sa9R3q1ZtN2PGqjdLOt0kA3He0QXQGMdYMG6crUy62LrcBdYiU5Ikg
	 fqUo+u7ppzgyqe62keCwOLqETxVFvt/fj+TIg4UZUPUr/ZheZSabLXsUD3CsWFcuO2oDa
	 dqhHoLF4UBIEVRMsNDq/lH/2x37SQkzqvUCblpXueIPNg1MA8HJzT0Kt8D6iPomMKzYrL
	 LXhpgfVdfeS2tmnXpajOWRt9QsCH95d74LRFkrWANmVCzWYG3aGA+CSiiOK7Gr4jGQuhX
	 BV6d0fXRkWlVhPNKQyr2apo8gGZgNNMoFzkY3EX37tZpnL2F6bflEzJXDg7ipKrLqGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ox0tQs00;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBA2606A31A;
	Wed, 28 Oct 2026 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ox0tQs00
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6DA1F01825;
	Wed, 28 Oct 2026 19:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214963;
	bh=vd83N9p6kM+Dn/CjgTRHvdJyFsdEAtqvbJHqppqWn4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ox0tQs00e2sz+cMQArR1FQqQl8+m9if+RCvqnBLpz6eUPS6egPKdWsGbTeU8pl9ae
	 AXhWiBLznJPpOgaFkzgeS6M/E12ddbQ2lhTAFwogGwIjudxm4nkM/jho3CYqsyT6Gq
	 zFT0CpuwN8RFwjoavMdhSxqcAgXtLfcLpBgJqe2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Peter <mario.peter@leica-geosystems.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1001/1887] usb: chipidea: udc: fix DMA and SG cleanup in _ep_nuke()
Date: Wed, 28 Oct 2026 17:51:37 +0100
Message-ID: <20261028170522.191104223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Peter <mario.peter@leica-geosystems.com>

[ Upstream commit cea2a1257a3b5ea3e769a445b34af13e6aa5a123 ]

The ChipIdea UDC driver can encounter "not page aligned sg buffer"
errors when a USB device is reconnected after being disconnected
during an active transfer. This occurs because _ep_nuke() returns
requests to the gadget layer without properly unmapping DMA buffers
or cleaning up scatter-gather bounce buffers.

Root cause:
When a disconnect happens during a multi-segment DMA transfer, the
request's num_mapped_sgs field and sgt.sgl pointer remain set with
stale values. The request is returned to the gadget driver with status
-ESHUTDOWN but still has active DMA state. If the gadget driver reuses
this request on reconnect without reinitializing it, the stale DMA
state causes _hardware_enqueue() to skip DMA mapping (seeing non-zero
num_mapped_sgs) and attempt to use freed/invalid DMA addresses,
leading to alignment errors and potential memory corruption.

The normal completion path via _hardware_dequeue() properly calls
usb_gadget_unmap_request_by_dev() and sglist_do_debounce() before
returning the request. The _ep_nuke() path must do the same cleanup
to ensure requests are returned in a clean, reusable state.

Fix:
Add DMA unmapping and bounce buffer cleanup to _ep_nuke() to mirror
the cleanup sequence in _hardware_dequeue():
- Call usb_gadget_unmap_request_by_dev() if num_mapped_sgs is set
- Call sglist_do_debounce() with copy=false if bounce buffer exists

This ensures that when requests are returned due to endpoint shutdown,
they don't retain stale DMA mappings. The 'false' parameter to
sglist_do_debounce() prevents copying data back (appropriate for
shutdown path where transfer was aborted).

Signed-off-by: Mario Peter <mario.peter@leica-geosystems.com>
Reviewed-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260108165902.795354-1-mario.peter@leica-geosystems.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/udc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index e7a02d9e1c079..b1b5f8a135596 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -773,6 +773,10 @@ __acquires(hwep->lock)
 		list_del_init(&hwreq->queue);
 		hwreq->req.status = -ESHUTDOWN;
 
+		/* Unmap DMA before giving back */
+		usb_gadget_unmap_request_by_dev(hwep->ci->dev->parent,
+					&hwreq->req, hwep->dir);
+
 		if (hwreq->req.complete != NULL) {
 			spin_unlock(hwep->lock);
 			usb_gadget_giveback_request(&hwep->ep, &hwreq->req);
-- 
2.53.0



