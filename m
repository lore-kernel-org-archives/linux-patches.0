Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBC917592;
	Tue, 30 Apr 2024 11:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476455; cv=none; b=bZV8bEwj+NLIJA154oPN1DhMtYgDBcz8eSgfJgOUc974oh1jNEh6wT5pVg6yXT0tisSCLzTS+6OlN4Mk2mWIxSqN6oyt4OgqPEwC+inpQslwcaPQXeKXcLOXAmduj6cE8yYg0HEwkcri+nhmL06WPrnpOhutRf8TtDylidPL9TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476455; c=relaxed/simple;
	bh=SUzFhPXCdTyUwTKUfERRoNxrW6xAFL36Nzj0BPji0tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvaINytpwBuxeYAsr+S9vXGCaQ1drLAbp9fq66nChJbLUR+t/0kFzP9n/yLGCeJkikadFujLLkLCB3GhFjq7aEKyErrX7Zvsq2UnOHoiwjk9T2CglgAxzOUdWDMLCgVz+zv5z7wrgoanb0yuT6j11DoiihFWZmbp1npytQ/RgOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wByg5wss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wByg5wss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3E9C2BBFC;
	Tue, 30 Apr 2024 11:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476455;
	bh=SUzFhPXCdTyUwTKUfERRoNxrW6xAFL36Nzj0BPji0tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wByg5wssktr0/qTbHrg019/EbFsTdj6fgg+QL8RHx2A/AowA7dM83DbNKdzEkb9Nj
	 mOE5SFZb7T0xXQ1goK5ELU6YeCclXZfOwJGfhnyQEk4nMu0gCg2HE3QnTIV+q8xokO
	 FyTvelkltgvg1IRge+qd+jkJq41Nlz+bwwmYtIRk=
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
Subject: [PATCH 6.1 037/110] net: usb: ax88179_178a: stop lying about skb->truesize
Date: Tue, 30 Apr 2024 12:40:06 +0200
Message-ID: <20240430103048.663068864@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



