Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1957719AA40;
	Thu,  6 Jun 2024 14:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683289; cv=none; b=TQt332Dny74mzsaS+cqv9CRwQLpHdkyj8SMMJ/+szMDV4zmrDCdHWS0Qi4750WQchdxyQY10edp9QYsJt/CjOzo78utskuASxWcjlbEAL0KGPB1um41Ng8ZZmFIsQ98kcuSNXMmjESvSnSBQO6JND0PuZJrQMVyk3FpUJQ4cN9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683289; c=relaxed/simple;
	bh=5NX8PTCyTjaZ71hf8uTaKej8E+hc1KOGYE6GktIZk3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHCVRljRvAE/xa4m8ceqevOe4avBcPipDaRuxpFubvdCN54qYuIqnD0r8jAr1pjasjU57JhTf3c4eA4yBLaVI53rtL3EMb34OBgtaH6czB48ssD/Z+OA8vGfFuiuSYG/b80ctSQap8WgOI4KvRuKvnXKjAkfnMkbYBJWlSeKDFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbtZZBxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbtZZBxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2C9C2BD10;
	Thu,  6 Jun 2024 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683289;
	bh=5NX8PTCyTjaZ71hf8uTaKej8E+hc1KOGYE6GktIZk3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbtZZBxrBuw+Ptl44LGHPfrq7IaF0aEQY8UOPkzusmeqcwqHbryVI1QysavjKKZtB
	 CPeq9fY6GxPT3s5TS5dy5oAbbvrfQbymq/EWPEb6cHkClxcu3lGT0YddGlr9uTLPwp
	 H4X1syWEUSAgKtt4gQUrX2oHIebP2O+QAxnGN6k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/473] net: usb: sr9700: stop lying about skb->truesize
Date: Thu,  6 Jun 2024 16:01:34 +0200
Message-ID: <20240606131705.402398243@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 3164451e1010c..0a662e42ed965 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -421,19 +421,15 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
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



