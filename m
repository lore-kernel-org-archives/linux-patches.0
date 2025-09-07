Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D4F1A704B;
	Sun,  7 Sep 2025 20:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277599; cv=none; b=gNQoiPzjBRR7a3kgDvUe2bKFAGSzEqaXjwQStMOt2g8fMXR6Ts4qMtDisPCWK9s+x3rHW/oFY9o1sl6juR/oKVcCjNmUzz77iuxWaWyxapBoDACXQT1LN0HbDs8m2igZZ/FXSO2jT2gtzbOlMjzJfYrO67Je50qlqpXkGemDo9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277599; c=relaxed/simple;
	bh=mKgtjXX73+PL8ybNZko9+OeSstLmstQ72an+WoTXlSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZF2tPa2zrPCco7ORKS/eq+qFnzUlx4mH7SMkwwL3y36jb7OqQ4zMM/Pztr+ZbSR3E+seHdDVINHYpqU98ZmqozjDlFhEr9deJHUQ9GJev2TdIbC9wRrkRlEHEPupp79NWsbWvgl2XWBLTyi3dQDHhW02NI8ZIX+twotnC5ng/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lc7+HMDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lc7+HMDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54355C4CEF0;
	Sun,  7 Sep 2025 20:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277599;
	bh=mKgtjXX73+PL8ybNZko9+OeSstLmstQ72an+WoTXlSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lc7+HMDHgIhmwyVVB57EXd7al9NC+hkavti7RfALrBgERE0MHwThrT9RmgGBglILE
	 cm9O7WmklEgNsE8zhOGuergXmNhSIS/vwI7JhoXoL3Rswc8FvFSaT/Q1XwoWsqsy2z
	 MbIqttT/XRIA2ZkW6smMPkkkdrRBtmCxr6NjMIAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 063/183] net: mctp: usb: initialise mac header in RX path
Date: Sun,  7 Sep 2025 21:58:10 +0200
Message-ID: <20250907195617.288781281@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit e27e34bc99413a29cafae02ad572ea3c9beba2ce ]

We're not currently setting skb->mac_header on ingress, and the netdev
core rx path expects it. Without it, we'll hit a warning on DEBUG_NETDEV
from commit 1e4033b53db4 ("net: skb_reset_mac_len() must check if
mac_header was set")

Initialise the mac_header to refer to the USB transport header.

Fixes: 0791c0327a6e ("net: mctp: Add MCTP USB transport driver")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20250829-mctp-usb-mac-header-v1-1-338ad725e183@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mctp/mctp-usb.c b/drivers/net/mctp/mctp-usb.c
index 775a386d0aca1..36ccc53b17975 100644
--- a/drivers/net/mctp/mctp-usb.c
+++ b/drivers/net/mctp/mctp-usb.c
@@ -183,6 +183,7 @@ static void mctp_usb_in_complete(struct urb *urb)
 		struct mctp_usb_hdr *hdr;
 		u8 pkt_len; /* length of MCTP packet, no USB header */
 
+		skb_reset_mac_header(skb);
 		hdr = skb_pull_data(skb, sizeof(*hdr));
 		if (!hdr)
 			break;
-- 
2.50.1



