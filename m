Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0081DF73C;
	Tue, 29 Apr 2025 17:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946265; cv=none; b=MbH0IWSQTGemXxEcMdAkyu2Hu9o1ROo8xVEfDGaQ1EC9bY9uXXOBosYfFbFJV1YhLn86NUhqj2WDimuWaZS3UHpn1bDaU0gsATpQwz65WRM7s66SVWVaqjThJpui2SEXegCU/nxds9c8ZTDTWSVjqvm1+BvmWiiiA4qbAhi2T0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946265; c=relaxed/simple;
	bh=BDv+0fVXC7ErWrkHeuCNQt5KR0AZcfZDJqhybr2jPnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgeknVhlwwZyo+2TSuSVqY685TPRQ3KbvELXoAFaMn2OO8rtQTEosYrkGT5Apfx7NeuiYt+RpIT7503QZ9T0Lj5k7L0Z3Ox9REY1jbFzQZ/QTz9nvKb6mRb0UhiSUma3XUBntDCuzi7/lyJd7x3jqAjEehe754FGpbmh7agVixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUc6zdt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUc6zdt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B6DC4CEE3;
	Tue, 29 Apr 2025 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946264;
	bh=BDv+0fVXC7ErWrkHeuCNQt5KR0AZcfZDJqhybr2jPnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUc6zdt11y//emdyx9gHkQ0O8w1P1Uh0wYIXJUJZCu52tQItBxR+ojrO+afEn0NNZ
	 j+k8V5Lh5E8FcvCdTtcBHJzC59Oao7rK+prIPxlsAvQNDm6oQ/4joX3hCsjHju3Hqk
	 uf0r8q7M+B6bnqZKjLWsdyORz2l/1QIBKDdPEXro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 209/311] usb: xhci: Complete error mid TD transfers when handling Missed Service
Date: Tue, 29 Apr 2025 18:40:46 +0200
Message-ID: <20250429161129.565239871@linuxfoundation.org>
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
index c64316638350e..7721215be79ff 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2789,7 +2789,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		xhci_dbg(xhci,
 			 "Miss service interval error for slot %u ep %u, set skip flag\n",
 			 slot_id, ep_index);
-		return 0;
+		break;
 	case COMP_NO_PING_RESPONSE_ERROR:
 		ep->skip = true;
 		xhci_dbg(xhci,
@@ -2837,6 +2837,10 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		xhci_dequeue_td(xhci, td, ep_ring, td->status);
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



