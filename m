Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D54B250C0C;
	Tue, 29 Apr 2025 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950554; cv=none; b=jHv91b67/Y+6iqefHrL7EQm3fqdY4bnhIXRygOCtqwhtQ/LaAl1vypxxUxZwifAo2/yMUM8WzA23pAfW3/K6aTET6SUEkwmuVYNqIFk7LyhDGVPe/zyue1MASnqxVitYPXnCdvpuJszb3Pi2x92fjjshJfUAstj/WLM+eMpjJxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950554; c=relaxed/simple;
	bh=JXX6wbN7ngsiT79mjRjC9H/1AYlWqxn8x73fIZqQddI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQAyh4lIRqenQkhv+WtpkzTVKtEz9njJDCeadTH+KbcL7a/8j84ua3h8VOcK4WbJPWinurklHvDUweqFDY/njQuzN7QKUkTJ/yv5lNAi+LmqS0Kpyt5JlZvY2ntZFX1AbSlKDLk6vfAwcyo77BypIUwmcGbhhql1z/m5+uPAK4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vknk478k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vknk478k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9625C4CEE3;
	Tue, 29 Apr 2025 18:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950554;
	bh=JXX6wbN7ngsiT79mjRjC9H/1AYlWqxn8x73fIZqQddI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vknk478kH9BZ7IzEmxn9MU76UmmUM36gEc602ShF2nKkC3zjcTUbajKRFXui7bXab
	 Aufeg0mpo6hLg7fZ26wQ5SzlxmoZwpKqiiN7tueAxDHhG0O5sNOnSUPzIOsp6nUZFO
	 GWBSwOTWjYpZbiG0WUsVDHA0AKaOqV6DTKATeOgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Kuangyi Chiang <ki.chiang65@gmail.com>
Subject: [PATCH 6.6 102/204] usb: xhci: Fix invalid pointer dereference in Etron workaround
Date: Tue, 29 Apr 2025 18:43:10 +0200
Message-ID: <20250429161103.604308110@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michal Pecio <michal.pecio@gmail.com>

commit 1ea050da5562af9b930d17cbbe9632d30f5df43a upstream.

This check is performed before prepare_transfer() and prepare_ring(), so
enqueue can already point at the final link TRB of a segment. And indeed
it will, some 0.4% of times this code is called.

Then enqueue + 1 is an invalid pointer. It will crash the kernel right
away or load some junk which may look like a link TRB and cause the real
link TRB to be replaced with a NOOP. This wouldn't end well.

Use a functionally equivalent test which doesn't dereference the pointer
and always gives correct result.

Something has crashed my machine twice in recent days while playing with
an Etron HC, and a control transfer stress test ran for confirmation has
just crashed it again. The same test passes with this patch applied.

Fixes: 5e1c67abc930 ("xhci: Fix control transfer error on Etron xHCI host")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Reviewed-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Link: https://lore.kernel.org/r/20250410151828.2868740-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3876,7 +3876,7 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *
 		 * enqueue a No Op TRB, this can prevent the Setup and Data Stage
 		 * TRB to be breaked by the Link TRB.
 		 */
-		if (trb_is_link(ep_ring->enqueue + 1)) {
+		if (last_trb_on_seg(ep_ring->enq_seg, ep_ring->enqueue + 1)) {
 			field = TRB_TYPE(TRB_TR_NOOP) | ep_ring->cycle_state;
 			queue_trb(xhci, ep_ring, false, 0, 0,
 					TRB_INTR_TARGET(0), field);


