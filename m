Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8661C86FF;
	Tue, 27 Aug 2024 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772014; cv=none; b=i7jBzck+38vl8gOChCUC4reMPdpMTSTbBZn3aauEX9R/iXrSbry6xm+KrHR9vSVdNGB5dOkwxw96IxdGLlzPpres5hOOU/5noIfawicIOqBc/AIQg5QkY42yLPScbESa3IjLvYKXhL5DJxcIIyk07XR1jX4c9uckSy095B+mfvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772014; c=relaxed/simple;
	bh=nmgki1iY2mKRa9OY0Wcp3JZFS0gskM164zXyZQ19hlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCEm9dSGGrpnBPd2L81zcMyBTMY8CuAArKGzWRjJ0CDc/YX4FnAXrSDHUTLWZQyUkuC3s941KYnMhWPXbDttNA1Uyit3bAXduDmTrmuMHFZja53k3VHL99Ebz13cBm7Lpdpx1atQzXwrkYeWSej8OdCB6WaVv5Aw0dQi6D3Sy0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZduE/hG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZduE/hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B6AC4DDEB;
	Tue, 27 Aug 2024 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772013;
	bh=nmgki1iY2mKRa9OY0Wcp3JZFS0gskM164zXyZQ19hlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZduE/hGxbc4uSpfehY6GQjFiIyLvKBqigP4mwV+M9i5EMt392XbSQ6C30rAX75WR
	 xQkorRh9v0Fve16EBwYdXzF2tn+2T44eAt0mumn+LWs1aphEt2ul7aeBtKzb0v/+WF
	 8/YOsEoCMbIIPfO6PNnCaSdSbCAFuFxTyMdvpa3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/321] atm: idt77252: prevent use after free in dequeue_rx()
Date: Tue, 27 Aug 2024 16:36:35 +0200
Message-ID: <20240827143841.551768948@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a9a18e8f770c9b0703dab93580d0b02e199a4c79 ]

We can't dereference "skb" after calling vcc->push() because the skb
is released.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/idt77252.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 2daf50d4cd47a..7810f974b2ca9 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -1118,8 +1118,8 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 	rpp->len += skb->len;
 
 	if (stat & SAR_RSQE_EPDU) {
+		unsigned int len, truesize;
 		unsigned char *l1l2;
-		unsigned int len;
 
 		l1l2 = (unsigned char *) ((unsigned long) skb->data + skb->len - 6);
 
@@ -1189,14 +1189,15 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 		ATM_SKB(skb)->vcc = vcc;
 		__net_timestamp(skb);
 
+		truesize = skb->truesize;
 		vcc->push(vcc, skb);
 		atomic_inc(&vcc->stats->rx);
 
-		if (skb->truesize > SAR_FB_SIZE_3)
+		if (truesize > SAR_FB_SIZE_3)
 			add_rx_skb(card, 3, SAR_FB_SIZE_3, 1);
-		else if (skb->truesize > SAR_FB_SIZE_2)
+		else if (truesize > SAR_FB_SIZE_2)
 			add_rx_skb(card, 2, SAR_FB_SIZE_2, 1);
-		else if (skb->truesize > SAR_FB_SIZE_1)
+		else if (truesize > SAR_FB_SIZE_1)
 			add_rx_skb(card, 1, SAR_FB_SIZE_1, 1);
 		else
 			add_rx_skb(card, 0, SAR_FB_SIZE_0, 1);
-- 
2.43.0



