Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE2A179A3;
	Fri, 24 Apr 2026 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037816; cv=none; b=cC0PJZg0zqd9FwT1cCgY1im8bXrkGVF5ib437qIKkWw/WhhP2kg1u4jg6q7SWqK5Ofo/JIu9wxu8X3yny7oCbvAbXfgRxGs/m3c6JWMI4xnFNi7v+HCDrJo8vXixmq0pvAHBXvOSFt9hQ6TiI0bEoNouKPB4l/XVydcXjv3wgvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037816; c=relaxed/simple;
	bh=zACIHG6S04H8zzpEnY7dysic2W6qY1vq88oqlbHpobc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7hF0SAL/y0NrgCoI+Yv1ir/OWgqGESK3MX/mAIrbs+AuUKWwVYd4FoP8Yz8Nc9dHIHqdViuZ25GrrBkuUFuPZNg5u0C/1z28gqeHpEAUrvjbGGR5de8Osig+knWEz1QCZ0J9MShfKVRTx4vcHcs6W0IuXsRNM/qaXaejtD0yMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXx0J4dU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXx0J4dU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FC0C19425;
	Fri, 24 Apr 2026 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037816;
	bh=zACIHG6S04H8zzpEnY7dysic2W6qY1vq88oqlbHpobc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXx0J4dUXISlJHGYyHDhanBdgqOIBJ5IgBz+Ti5Gk4KCuNw3xNzK9raoeC6uvZ5lB
	 E7beq40KHGuakfbm/qk0Ym9HA0Lo6HIGQNoVd/hmNsR5xNpTR0U5ym2wPpMuz5iBKK
	 tA5tNL61EiYIAT8HtchAdx6sfONiHVI3W9uZ9/zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 079/166] usb: gadget: f_phonet: fix skb frags[] overflow in pn_rx_complete()
Date: Fri, 24 Apr 2026 15:29:53 +0200
Message-ID: <20260424132549.349418444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c088d5dd2fffb4de1fb8e7f57751c8b82942180a upstream.

A broken/bored/mean USB host can overflow the skb_shared_info->frags[]
array on a Linux gadget exposing a Phonet function by sending an
unbounded sequence of full-page OUT transfers.

pn_rx_complete() finalizes the skb only when req->actual < req->length,
where req->length is set to PAGE_SIZE by the gadget.  If the host always
sends exactly PAGE_SIZE bytes per transfer, fp->rx.skb will never be
reset and each completion will add another fragment via
skb_add_rx_frag().  Once nr_frags exceeds MAX_SKB_FRAGS (default 17),
subsequent frag stores overwrite memory adjacent to the shinfo on the
heap.

Drop the skb and account a length error when the frag limit is reached,
matching the fix applied in t7xx by commit f0813bcd2d9d ("net: wwan:
t7xx: fix potential skb->frags overflow in RX path").

Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Link: https://patch.msgid.link/2026040705-fruit-unloved-0701@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_phonet.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/gadget/function/f_phonet.c
+++ b/drivers/usb/gadget/function/f_phonet.c
@@ -333,6 +333,15 @@ static void pn_rx_complete(struct usb_ep
 		if (unlikely(!skb))
 			break;
 
+		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
+			/* Frame count from host exceeds frags[] capacity */
+			dev_kfree_skb_any(skb);
+			if (fp->rx.skb == skb)
+				fp->rx.skb = NULL;
+			dev->stats.rx_length_errors++;
+			break;
+		}
+
 		if (skb->len == 0) { /* First fragment */
 			skb->protocol = htons(ETH_P_PHONET);
 			skb_reset_mac_header(skb);


