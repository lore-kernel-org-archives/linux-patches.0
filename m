Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E321482E8;
	Fri,  9 Jan 2026 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962932; cv=none; b=CbT+D8VEvi7jnv3+8SNYo4/ICF6zJ3Ka19bgc0HNHRSOYNqnbI5se4/Eq6Y9slZVTty9ml0nYGAtcEcBZFhnTuPiw34XAKyqf/Q0IuNV6T5Tt5rRbQqZVTxDROZu/X1naxsIgrraGUNVWZSrZCDP2/qkaWS4E4BUfR5rgJxokHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962932; c=relaxed/simple;
	bh=VscB7dg29+Aa4mLEOXDeWvbhVR2yn0FIL4Ym8pVZuiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNde2+yl0z3NMCoSNh28Ib8g59KwRbpfU4jaLZpmDa7hSDVn3GHZeZ2y9ItxU3JQSxM/Dnol7o0FQ93aumdnNIsP2d1o98rZ45mottLt/nyFfveuvaNkghBR7msenXN1tt9BItuzgHlRlo2biAT1b++QhwR0MugxVO+s7V3Ff38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2hZns1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2hZns1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBD6C4CEF1;
	Fri,  9 Jan 2026 12:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962931;
	bh=VscB7dg29+Aa4mLEOXDeWvbhVR2yn0FIL4Ym8pVZuiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2hZns1a4IpMuE8c76e5cABJaQbxZevGVNZb1wfuDXKXZxg/pTvrBTTh0/IKledy2
	 ZyuD6cYmcRGmaz1KBQZnfcjMGSI0exFxh0PxS4po+BFWmfLkAi+GM5bwIrmzmA2hPb
	 X3DS7LKc+nmzQxKJ9iV2R8a0fpSvZOAcpyDDj2+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 539/634] can: gs_usb: gs_can_open(): fix error handling
Date: Fri,  9 Jan 2026 12:43:37 +0100
Message-ID: <20260109112137.864335274@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 3e54d3b4a8437b6783d4145c86962a2aa51022f3 ]

Commit 2603be9e8167 ("can: gs_usb: gs_can_open(): improve error handling")
added missing error handling to the gs_can_open() function.

The driver uses 2 USB anchors to track the allocated URBs: the TX URBs in
struct gs_can::tx_submitted for each netdev and the RX URBs in struct
gs_usb::rx_submitted for the USB device. gs_can_open() allocates the RX
URBs, while TX URBs are allocated during gs_can_start_xmit().

The cleanup in gs_can_open() kills all anchored dev->tx_submitted
URBs (which is not necessary since the netdev is not yet registered), but
misses the parent->rx_submitted URBs.

Fix the problem by killing the rx_submitted instead of the tx_submitted.

Fixes: 2603be9e8167 ("can: gs_usb: gs_can_open(): improve error handling")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251210-gs_usb-fix-error-handling-v1-1-d6a5a03f10bb@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ adapted error handling for simpler code structure without timestamp stop functionality ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -985,7 +985,7 @@ out_usb_free_urb:
 	usb_free_urb(urb);
 out_usb_kill_anchored_urbs:
 	if (!parent->active_channels)
-		usb_kill_anchored_urbs(&dev->tx_submitted);
+		usb_kill_anchored_urbs(&parent->rx_submitted);
 
 	close_candev(netdev);
 


