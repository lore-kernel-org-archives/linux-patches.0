Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43EC1448F3;
	Thu, 13 Jun 2024 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278835; cv=none; b=i+6Hk5UCBTxorAifzIsmEuiXphS6lGBlPonP42k1HFeGi+TDeDFHB4sy9kB62osCB+0UMPZx05ca4g2C2dnU1hALdRj7vFrPWhiZDTWIX+VgHne+R4H+tJyBZxO3QPuy58xtAw6lmm5580Xze25B75nXC+iLnwgkhmTEExx9VTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278835; c=relaxed/simple;
	bh=eOIRI4lFQjp+oAfKWe5GiYh+FgZP1/SIMKi3HpAjd34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIiziW+poUbgkntwygfavSOHNycIMKEqEMNEcWnnobML1j+uo5bU7E15bh/nbevhLaS0s5Xh6H+5p7eOtCkKxnCFukq9RQhyp+OO5rVoh4/jbgFRWAHfe2Dv5dgXyifydOsQKr70xAwHXf47vI3o9R1vkkFmMe1R3XBK7aXwAl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1lxFhzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1lxFhzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F2DC4AF1A;
	Thu, 13 Jun 2024 11:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278835;
	bh=eOIRI4lFQjp+oAfKWe5GiYh+FgZP1/SIMKi3HpAjd34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1lxFhzSBX2AU4PO3T72v6TTrGAqoVYcuZ22Q+m/pw4uyzKFc5ED81QLUY++q+XU9
	 GI5xecghIaypKw90ayaWt3isH2dSD0wj3RoOPSd4ZlE4BTCwRvgkKo7z3Co1xqwjFS
	 qOm1MQSbBfKe57cja+dzMchJ2pQjf4JsHLz299ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/213] net: usb: sr9700: stop lying about skb->truesize
Date: Thu, 13 Jun 2024 13:31:42 +0200
Message-ID: <20240613113230.094782669@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 05417aa9c0c038da2464a0c504b9d4f99814a23b ]

Some usb drivers set small skb->truesize and break
core networking stacks.

In this patch, I removed one of the skb->truesize override.

I also replaced one skb_clone() by an allocation of a fresh
and small skb, to get minimally sized skbs, like we did
in commit 1e2c61172342 ("net: cdc_ncm: reduce skb truesize
in rx path") and 4ce62d5b2f7a ("net: usb: ax88179_178a:
stop lying about skb->truesize")

Fixes: c9b37458e956 ("USB2NET : SR9700 : One chip USB 1.1 USB2NET SR9700Device Driver Support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240506143939.3673865-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sr9700.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 8bee8286e41a1..a0e5d066ac455 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -418,19 +418,15 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			skb_pull(skb, 3);
 			skb->len = len;
 			skb_set_tail_pointer(skb, len);
-			skb->truesize = len + sizeof(struct sk_buff);
 			return 2;
 		}
 
-		/* skb_clone is used for address align */
-		sr_skb = skb_clone(skb, GFP_ATOMIC);
+		sr_skb = netdev_alloc_skb_ip_align(dev->net, len);
 		if (!sr_skb)
 			return 0;
 
-		sr_skb->len = len;
-		sr_skb->data = skb->data + 3;
-		skb_set_tail_pointer(sr_skb, len);
-		sr_skb->truesize = len + sizeof(struct sk_buff);
+		skb_put(sr_skb, len);
+		memcpy(sr_skb->data, skb->data + 3, len);
 		usbnet_skb_return(dev, sr_skb);
 
 		skb_pull(skb, len + SR_RX_OVERHEAD);
-- 
2.43.0



