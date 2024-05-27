Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E53262BE;
	Mon, 27 May 2024 19:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838173; cv=none; b=J97BvHPuHumgx+kg2F0skp6YS3xMPQaSuSTruFgSwNInZnnki6U+lhzZvPqs/nqV7rGv31ckWQ/RCNYBj8aTlYOLIo7dXSRmd/lErBnucpfim3zWXzxaSXed7N59e6NBYD7OIkCARxeiEwGGLQVUzr4Cc4SMa7Kz3I6SmsOGZBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838173; c=relaxed/simple;
	bh=hmwDLfZ2Gltj2UAL+eIZuUGlExktg+TMS7PoV1EyfNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2r6hhcGoD6aLp+I2oIl3NPqHjQu7PfTlHjHcmGiGbdn0Seo7oqD7jUexXNvgnVOO/II53XIBFf8Ake2h6S+Z8gBhEpT2DVTMbKHAqr6p5lajMzTxn+5lNQsG4AArsxg+ep/apwX0IX6qAvSoQpO7u+bgynbIv/Oel5hYQDrKqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJbBkNt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJbBkNt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FBDC2BBFC;
	Mon, 27 May 2024 19:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838172;
	bh=hmwDLfZ2Gltj2UAL+eIZuUGlExktg+TMS7PoV1EyfNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJbBkNt3jI0+oPP13b9ygmqR7aR68WyOQkwf66ESH9T3lMO8dmTkIN6uFWG0ez9de
	 mTrAL81ToF5woT8o63lV0wqqrRHXuP5HkktHm13Q2m8WIw/HhP+M3CLP0JMjUGLCAv
	 +wofebL5woBWv7jovfoA1zSAErvWKwFJXiYpBWVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 293/493] usb: aqc111: stop lying about skb->truesize
Date: Mon, 27 May 2024 20:54:55 +0200
Message-ID: <20240527185639.886883198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9aad6e45c4e7d16b2bb7c3794154b828fb4384b4 ]

Some usb drivers try to set small skb->truesize and break
core networking stacks.

I replace one skb_clone() by an allocation of a fresh
and small skb, to get minimally sized skbs, like we did
in commit 1e2c61172342 ("net: cdc_ncm: reduce skb truesize
in rx path") and 4ce62d5b2f7a ("net: usb: ax88179_178a:
stop lying about skb->truesize")

Fixes: 361459cd9642 ("net: usb: aqc111: Implement RX data path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240506135546.3641185-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/aqc111.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 7b8afa589a53c..284375f662f1e 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -1141,17 +1141,15 @@ static int aqc111_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			continue;
 		}
 
-		/* Clone SKB */
-		new_skb = skb_clone(skb, GFP_ATOMIC);
+		new_skb = netdev_alloc_skb_ip_align(dev->net, pkt_len);
 
 		if (!new_skb)
 			goto err;
 
-		new_skb->len = pkt_len;
+		skb_put(new_skb, pkt_len);
+		memcpy(new_skb->data, skb->data, pkt_len);
 		skb_pull(new_skb, AQ_RX_HW_PAD);
-		skb_set_tail_pointer(new_skb, new_skb->len);
 
-		new_skb->truesize = SKB_TRUESIZE(new_skb->len);
 		if (aqc111_data->rx_checksum)
 			aqc111_rx_checksum(new_skb, pkt_desc);
 
-- 
2.43.0



