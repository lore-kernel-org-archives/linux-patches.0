Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D848208A7;
	Sun,  1 Sep 2024 16:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209907; cv=none; b=b80KZ0Fxf0XuITvfuUjmuYQ+hf6+JOTUycm7PIu21am1EzUp32S4digCXBmgnF2Z6f36Ldll7fQodTOIwKrIIItUJyEvY0agOf892hu2PBGynunVromBOq8K40/2Q626kgxJL1b+Y3qnqJsBEcpUDIrjsNFxp9DB8c4SXZYmcI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209907; c=relaxed/simple;
	bh=tENLYeFr+xgjerf49lhjnkd01FUKwZJORkI+16tP5Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjwRKslw4sjJknwTQ3p4RFy5ISVsreF4xb7nKdEACDmopyoTDQW2Bsa9jkuhGmJxzjao+87ouF7+rT+wY7j3DxxwcDCpUl3rtIT7aDj1XKuKFQuVE2gNt9pPGCqN4ZTkppDutzcM0ItFsQ6+ynvE8qisFHYY8MzzkhfH518mMbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvFRS1Su; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvFRS1Su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C22C4CEC3;
	Sun,  1 Sep 2024 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209907;
	bh=tENLYeFr+xgjerf49lhjnkd01FUKwZJORkI+16tP5Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvFRS1Suq5//ILUauQk+9+/zhHQNRsGY47U8/1j6UxOvaDAp54aHDDzeuRyO14xg4
	 VEEjIFP61RwZVoVBP2cZ9Qvl+ZncR3EJGNpzkzTcoUkQAvSYXpITIGQbhC8PIEXr18
	 zTyfP7pvULgnVseZoFTrZT1SmXnsp8T5OcT+Ae7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/215] atm: idt77252: prevent use after free in dequeue_rx()
Date: Sun,  1 Sep 2024 18:15:41 +0200
Message-ID: <20240901160824.365214347@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



