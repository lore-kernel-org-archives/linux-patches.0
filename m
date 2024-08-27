Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D6F1BC9E3;
	Tue, 27 Aug 2024 15:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771125; cv=none; b=IKm63KqddLeQ7d7wbQ8QjyhQ5vfETmCpKkvte7/OMc8WyMnIkVsGOt9a/XaBg0pieqpmzszpBTrhGVISS6Bzldlzpi9hyN0TLK6mS5umqQiB5/szPNrNVXPejEuCSaTNBnrEGMt4Mxl/R+qGlTylM0rjtmw/c/URYGh87GMrCos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771125; c=relaxed/simple;
	bh=6s+TVL6QrCvUI24uxB7FDtqaBItX/a57yQTIuj9HfOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIbyc9pzS4ySUomRqkbafdFwwUMPfhEbEX5wW9EhybfPfIYBmahZ9fvze0DxkciWE0qvzvSbFBvL/wqXMcBnfM/p6fNZXbckiryYIYX+x21DAR+Pez2ctStCzNfi/QGRfTtVncIUyI/+GcOIM5MxnyDdWdKxhbpba3KKUcVj87Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0wIapqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0wIapqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D5DC6106C;
	Tue, 27 Aug 2024 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771125;
	bh=6s+TVL6QrCvUI24uxB7FDtqaBItX/a57yQTIuj9HfOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0wIapqSq3iKqjDKfAuRFF8sMISIdCGhjZaCL0EyxQd3QYitMfxFuyHqYy0PQjRWv
	 K1SRUpl9Hd37upJtQcp9SoUFc0RlBMI3kpnO4sNhAzyYLYtbjlHcb0pTBaoiAhyTlb
	 LSeMIp3hzvU05+Ls8eGIjuUcDlMWSD5NrdePnrTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 093/273] atm: idt77252: prevent use after free in dequeue_rx()
Date: Tue, 27 Aug 2024 16:36:57 +0200
Message-ID: <20240827143836.951802493@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index e7f713cd70d3f..a876024d8a05f 100644
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



