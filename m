Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3FB1C6B4;
	Tue, 29 Apr 2025 17:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948161; cv=none; b=on6QhNm3w6+hJM6Ps/X5X2B0Zp7d0QLWUE4Hd1335L4pLiCYy3thAK1yM9EuyUErW/V+A+iz41gt2w7qZTwM13LLRq3Hkn7/m29euU/f006DnMktIpvOrz/7DGdvtdjU1dAqmjiGZxtVfwV5Ygak8HMeIY42bwqFzJ8jC1ql004=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948161; c=relaxed/simple;
	bh=UVZ39jJjHYpwi9TGahg2ysCOnt3L3vG3m53CSi1Pr7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxOCLdMuUAo8pu3g75A75yYGlrQIjyt9bfRULreBLk7/rSLGUfFdDwZ0EcctBYfjM8OamxOF80vrAZHd3pr0Mx2kuAL+Fm3U5NDRKFOZKDOARh52+Y7BMrt2fw/dgNgO1mSzgyis7Pl84ZHzEAwHaYc4w+6eFlTSTlZYJ1NgZ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2idGIW72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2idGIW72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D35CC4CEE3;
	Tue, 29 Apr 2025 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948160;
	bh=UVZ39jJjHYpwi9TGahg2ysCOnt3L3vG3m53CSi1Pr7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2idGIW72WWYoMBafG7Tse2s5W1uOvX6Ykv2BpgzvOXdR63xl6XIyOrsgMGFe1aU3A
	 oEReazcoDnoaNJ8U3IS4W2Y6wrtwvCSEEhlwgcuwnffSH8IZuLB8theZDToounihV0
	 84s31Bh3osLCoNo/IVv7h+I3zMLQPsRnhiG0hjXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/280] usb: xhci: Complete error mid TD transfers when handling Missed Service
Date: Tue, 29 Apr 2025 18:41:57 +0200
Message-ID: <20250429161122.310265491@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit bfa8459942822bdcc86f0e87f237c0723ae64948 ]

Missed Service Error after an error mid TD means that the failed TD has
already been passed by the xHC without acknowledgment of the final TRB,
a known hardware bug. So don't wait any more and give back the TD.

Reproduced on NEC uPD720200 under conditions of ludicrously bad USB link
quality, confirmed to behave as expected using dynamic debug.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250306144954.3507700-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index f3266fe406baf..7001f9725cf7c 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2787,7 +2787,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		xhci_dbg(xhci,
 			 "Miss service interval error for slot %u ep %u, set skip flag\n",
 			 slot_id, ep_index);
-		return 0;
+		break;
 	case COMP_NO_PING_RESPONSE_ERROR:
 		ep->skip = true;
 		xhci_dbg(xhci,
@@ -2838,6 +2838,10 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		xhci_td_cleanup(xhci, td, ep_ring, td->status);
 	}
 
+	/* Missed TDs will be skipped on the next event */
+	if (trb_comp_code == COMP_MISSED_SERVICE_ERROR)
+		return 0;
+
 	if (list_empty(&ep_ring->td_list)) {
 		/*
 		 * Don't print wanings if ring is empty due to a stopped endpoint generating an
-- 
2.39.5



