Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B531E50A;
	Tue, 30 Apr 2024 11:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475323; cv=none; b=iK3wPcaDiX4kawwMtxTHmx5G40ojk0BRzrxlEKjZnEowoqOx7EmzTGVKZuO3EoZpIaH2tvgNrQe+BQa5hROSrPIIMbZF3SEQPj8pRHus6ZJSTlu29/QCF0eG3WJI0Dh/dHSICBiFb05AI9r9GKGj7l59Y5KebUGsMOkvHvODQEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475323; c=relaxed/simple;
	bh=ien2W0vUjyEyqPDY0Pvplgmb1ZVEZ9UZ64X8Er97ePY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCREnggdNYk53cRV0X8UJfC1vaDRlXUhEPrlyTefikQRepdJ82LFMfZCzMh9IZsudFfxJrHh8GUmPF0q8+/FiqeloN8/PJfDzuAW8Sv5laDLngcHrIQKM+ii+Z1KWH3+z9QUJt76VUCS3txV5n3mOR/7tmnZmHJBKOlQmmwpbuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTnYg0tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTnYg0tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864C7C2BBFC;
	Tue, 30 Apr 2024 11:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475323;
	bh=ien2W0vUjyEyqPDY0Pvplgmb1ZVEZ9UZ64X8Er97ePY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTnYg0tbG++oUcbriN0V52cFGfyznkSHaPhL9sAZx8p9AXNsd7mhjTdPkdp2hLyS3
	 2Bo8u5CaQRXoXfN/ta8gJYAayrzFD2pT2RPLYjI0nHB27fEjISYT1mDIfvMOVMrMJ+
	 ZOCvv4H0YN5OSEW0c8yYBKefMWSKiQ3s7ERhmgns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shironeko <shironeko@tesaguri.club>,
	Eric Dumazet <edumazet@google.com>,
	Jose Alonso <joalonsof@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/186] net: usb: ax88179_178a: stop lying about skb->truesize
Date: Tue, 30 Apr 2024 12:38:34 +0200
Message-ID: <20240430103059.839419178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4ce62d5b2f7aecd4900e7d6115588ad7f9acccca ]

Some usb drivers try to set small skb->truesize and break
core networking stacks.

In this patch, I removed one of the skb->truesize overide.

I also replaced one skb_clone() by an allocation of a fresh
and small skb, to get minimally sized skbs, like we did
in commit 1e2c61172342 ("net: cdc_ncm: reduce skb truesize
in rx path")

Fixes: f8ebb3ac881b ("net: usb: ax88179_178a: Fix packet receiving")
Reported-by: shironeko <shironeko@tesaguri.club>
Closes: https://lore.kernel.org/netdev/c110f41a0d2776b525930f213ca9715c@tesaguri.club/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jose Alonso <joalonsof@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240421193828.1966195-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88179_178a.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 3078511f76083..21b6c4d94a632 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1456,21 +1456,16 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			/* Skip IP alignment pseudo header */
 			skb_pull(skb, 2);
 
-			skb->truesize = SKB_TRUESIZE(pkt_len_plus_padd);
 			ax88179_rx_checksum(skb, pkt_hdr);
 			return 1;
 		}
 
-		ax_skb = skb_clone(skb, GFP_ATOMIC);
+		ax_skb = netdev_alloc_skb_ip_align(dev->net, pkt_len);
 		if (!ax_skb)
 			return 0;
-		skb_trim(ax_skb, pkt_len);
+		skb_put(ax_skb, pkt_len);
+		memcpy(ax_skb->data, skb->data + 2, pkt_len);
 
-		/* Skip IP alignment pseudo header */
-		skb_pull(ax_skb, 2);
-
-		skb->truesize = pkt_len_plus_padd +
-				SKB_DATA_ALIGN(sizeof(struct sk_buff));
 		ax88179_rx_checksum(ax_skb, pkt_hdr);
 		usbnet_skb_return(dev, ax_skb);
 
-- 
2.43.0



