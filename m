Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CF523C8D6;
	Tue, 29 Apr 2025 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946568; cv=none; b=ftwuNpY8IooxIEie5bsZ5kk74l4cyc+BpXxpr68+cgQQicoPEKj15FPKgo9InIRUoFpDr2/ecSkE1BnlwXbcr/jli6BGWJe69H4eKhxEusHSKei41GIn9H3Gypk2/Ay4+eY/4m42SFAtmbYlNAuxY+0yIiWb+EpzsSAszkoHxaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946568; c=relaxed/simple;
	bh=W9/XQJJMS6Bsiai2ye+4wtHJuk4I5qiH1YZj0sOFDGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaznPB6FKICuMMvSIuwGwprEDeOfiMoGK/raJl1ZlZKNEYfz58P6+ZmvBRq6SVzkehgdW0LD7nG3LqIus9y9JLWSPY+JIk5S8pnQInnJT9lc7N3/fTQ5MuplgYitp2tOD7jH2f9k6G7yMAQ3FF0xBzp5qF4f9DHjBVgwxOtzxhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVBUj+UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVBUj+UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795AEC4CEEA;
	Tue, 29 Apr 2025 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946567;
	bh=W9/XQJJMS6Bsiai2ye+4wtHJuk4I5qiH1YZj0sOFDGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVBUj+UHBAgCDT/Qob5kq05CxHLquoEZ7h5aJ165kuj6KyzfiGyms8oJePlux4JqD
	 DkgQ8yWDDxDh+KYTZjFTxwEd28ZTi/+V40V/rxDuifNftXK+Sd345NVukllwsdYyRb
	 UCqZCwFzRCtQvZuRDoQQ8wdd9ehGFpzgMJRjt/xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.14 308/311] usb: xhci: Fix Short Packet handling rework ignoring errors
Date: Tue, 29 Apr 2025 18:42:25 +0200
Message-ID: <20250429161133.611553012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit 9e3a28793d2fde7a709e814d2504652eaba6ae98 upstream.

A Short Packet event before the last TRB of a TD is followed by another
event on the final TRB on spec-compliant HCs, which is most of them.

A 'last_td_was_short' flag was added to know if a TD has just completed
as Short Packet and another event is to come. The flag was cleared after
seeing the event (unless no TDs are pending, but that's a separate bug)
or seeing a new TD complete as something other than Short Packet.

A rework replaced the flag with an 'old_trb_comp_code' variable. When
an event doesn't match the pending TD and the previous event was Short
Packet, the new event is silently ignored.

To preserve old behavior, 'old_trb_comp_code' should be cleared at this
point, but instead it is being set to current comp code, which is often
Short Packet again. This can cause more events to be silently ignored,
even though they are no longer connected with the old TD that completed
short and indicate a serious problem with the driver or the xHC.

Common device classes like UAC in async mode, UVC, serial or the UAS
status pipe complete as Short Packet routinely and could be affected.

Clear 'old_trb_comp_code' to zero, which is an invalid completion code
and the same value the variable starts with. This restores original
behavior on Short Packet and also works for illegal Etron events, which
the code has been extended to cover too.

Fixes: b331a3d8097f ("xhci: Handle spurious events on Etron host isoc enpoints")
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250410151828.2868740-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2926,7 +2926,7 @@ static int handle_tx_event(struct xhci_h
 			if (xhci_spurious_success_tx_event(xhci, ep_ring)) {
 				xhci_dbg(xhci, "Spurious event dma %pad, comp_code %u after %u\n",
 					 &ep_trb_dma, trb_comp_code, ep_ring->old_trb_comp_code);
-				ep_ring->old_trb_comp_code = trb_comp_code;
+				ep_ring->old_trb_comp_code = 0;
 				return 0;
 			}
 


