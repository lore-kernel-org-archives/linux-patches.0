Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4052950839C;
	Mon, 31 Aug 2026 13:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183746; cv=none; b=OLVee+0tau3GHMWL8tAIYMeAaUvhutxZJs/LbfgZFp92IpkkUd6K64hxIjIZz9elQ5Puls6mW3MrpC2UhVRrb4qDD3UsB9Hco8kqrki4ZqG+AQBg/h1EDJApy9zOa+Vh0GoqeZ0oBN1QEUBkKgs14cinmzU8yAS0bzcwIjXXLY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183746; c=relaxed/simple;
	bh=mVJsatUbtXdaNFSdP4upbjVD571tWi+nBKXK+ubMsFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttahros2E+/enHa4NvIwcNQHVV0ZFXPjZa/iFCElmjuVmC2wrKQnSr9lhBp5+VfpYQBuZa2R9yDP87gHfnHOhGnmuRqI8CWS3liIIDhMeLWS+ETT9449usvhtClx6TCjkWtHRx5qTm26tGJZPIDo2x3qr8dlAbg3RNI7Pt3ehSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cv2r1mPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cv2r1mPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACFD1F00ACA;
	Mon, 31 Aug 2026 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183745;
	bh=CAPldyWKSwXip3n5l/1ygBIh2zNUDDdUmV6sqVxGnG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cv2r1mPMACwck/BMh5t8zszU1EJT2lcxPIcPcYPjUd5w9tRG4S3dO9otrcnDtNu20
	 Cn3z8qmbMEsvcuFB1qNfq1LKhe9qspQVyNLkRVBwDXIPOkXRa8cLChjMMHSqn4ad54
	 38bcmI9/UCeZHvuh4h0jg2cTg72hiHyl6CI6zrUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Nagel <bart@tremby.net>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Michal Pecio <michal.pecio@gmail.com>
Subject: [PATCH 7.1 20/76] usb: xhci: Handle bogus TRB pointers in Missed Service Error events
Date: Mon, 31 Aug 2026 15:33:52 +0200
Message-ID: <20260831133400.239037376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit 3d9eeb336131bc5a174367c384fa00c15c8744fd upstream.

xHCI 1.0 allowed these pointers to be zero. Some Intel chipsets from the
era usually set it to zero, but sometimes (apparently) to the next TRB
after the one referenced by the previous transfer event on the endpoint.

Usually that's indeed the missed TD, but it may also be the last TRB of
a two-TRB TD already completed with Short Packet on its first TRB. Then
the driver skips all pending TDs, failing to find a match.

When handling Missed Service Error, scan TD list twice and only really
skip TDs in the second pass if the first pass found a match. This won't
catch bogus pointers to wrong TDs, but such a bug would be practically
impossible to detect automatically and isn't known to exist.

Reported-by: Bart Nagel <bart@tremby.net>
Closes: https://lore.kernel.org/linux-usb/al_hchyOdPoPWKEo@spiral/
Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Fixes: d0b619599e52 ("usb: xhci: Expedite skipping missed isoch TDs on modern HCs")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260806142113.2436238-18-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2625,6 +2625,17 @@ static bool xhci_spurious_success_tx_eve
 	}
 }
 
+static struct xhci_td *find_td_by_dma(struct xhci_ring *ep_ring, dma_addr_t dma)
+{
+	struct xhci_td *td;
+
+	if (dma)
+		list_for_each_entry(td, &ep_ring->td_list, td_list)
+			if (trb_in_td(td, dma))
+				return td;
+	return NULL;
+}
+
 /*
  * If this function returns an error condition, it means it got a Transfer
  * event with a corrupted Slot ID, Endpoint ID, or TRB DMA address.
@@ -2819,8 +2830,11 @@ static int handle_tx_event(struct xhci_h
 		xhci_dequeue_td(xhci, td, ep_ring, td->status);
 	}
 
-	/* If the TRB pointer is NULL, missed TDs will be skipped on the next event */
-	if (trb_comp_code == COMP_MISSED_SERVICE_ERROR && !ep_trb_dma)
+	/*
+	 * We don't know how many TDs were missed when ep_trb_dma is zero (as permitted by
+	 * xHCI 1.0) or bogus. Bail out leaving ep->skip set, next event will sort it out.
+	 */
+	if (trb_comp_code == COMP_MISSED_SERVICE_ERROR && !find_td_by_dma(ep_ring, ep_trb_dma))
 		return 0;
 
 	if (list_empty(&ep_ring->td_list)) {


