Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563111C3BEB;
	Tue, 11 Mar 2025 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705649; cv=none; b=uHOKzV3GpJ/t0YoPiJmvxkFWaXXkNr/+MrUSOeB8nNRaEcFFjHdHY/ICDSl3ctw3zcsKdM8tHRsJszMg86uf7f169E2zvsnkjOQyb4Rxmz1rQvUBKzxrjzUDdClyIBYvcugbr3gSUnPGpVDeWBLRFySMn/q9EGkM64JLjbLcvqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705649; c=relaxed/simple;
	bh=XXhfCqAVU18O4ujo9t6h62/HTUGZ+KpZaMwfKm5qDo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgNJ4qzooeXioqeMze5eHrV3+wv2vzxRlu1z8QFSuQEyuj8KTkfC3yZugyBRc9RYTRwMSRBpoRIqA9ENBgDyvn/s/FEAP573JIwUjMacSXYKpqSvDlgad0Vr377VyQQGXSf483OAmvsGEuJz83WC3+jTj6LrOn8PfRrojGDdJUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spuDQ/ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spuDQ/ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3C8C4CEEA;
	Tue, 11 Mar 2025 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705649;
	bh=XXhfCqAVU18O4ujo9t6h62/HTUGZ+KpZaMwfKm5qDo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spuDQ/mar0LvF6UQcXTLQzPIMQvygyaXL3+n9ql+GXpIpmeuhkzWNYr2LPS9Hq7Ec
	 YGsKOgL1R7lAu1DYV15RbdRml88Rc7RoyZaGJz04XhGxeMChlf6FhFYWQXko934fwT
	 ufcCe9GB1ap0bNLZlTTzOPhoC7LFQB8yUKEdXLYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/328] usb: xhci: Fix NULL pointer dereference on certain command aborts
Date: Tue, 11 Mar 2025 15:57:58 +0100
Message-ID: <20250311145719.190607658@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit 1e0a19912adb68a4b2b74fd77001c96cd83eb073 ]

If a command is queued to the final usable TRB of a ring segment, the
enqueue pointer is advanced to the subsequent link TRB and no further.
If the command is later aborted, when the abort completion is handled
the dequeue pointer is advanced to the first TRB of the next segment.

If no further commands are queued, xhci_handle_stopped_cmd_ring() sees
the ring pointers unequal and assumes that there is a pending command,
so it calls xhci_mod_cmd_timer() which crashes if cur_cmd was NULL.

Don't attempt timer setup if cur_cmd is NULL. The subsequent doorbell
ring likely is unnecessary too, but it's harmless. Leave it alone.

This is probably Bug 219532, but no confirmation has been received.

The issue has been independently reproduced and confirmed fixed using
a USB MCU programmed to NAK the Status stage of SET_ADDRESS forever.
Everything continued working normally after several prevented crashes.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219532
Fixes: c311e391a7ef ("xhci: rework command timeout and cancellation,")
CC: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241227120142.1035206-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index a37b55b2e31f4..08b016864fc08 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -332,7 +332,8 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
 	if ((xhci->cmd_ring->dequeue != xhci->cmd_ring->enqueue) &&
 	    !(xhci->xhc_state & XHCI_STATE_DYING)) {
 		xhci->current_cmd = cur_cmd;
-		xhci_mod_cmd_timer(xhci);
+		if (cur_cmd)
+			xhci_mod_cmd_timer(xhci);
 		xhci_ring_cmd_db(xhci);
 	}
 }
-- 
2.39.5



