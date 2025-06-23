Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0CC222576;
	Mon, 23 Jun 2025 21:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714880; cv=none; b=TX5h2nhnh+TQ1YT7ph6svAAOSggEkH5HdcHPGCkNbhLAA5VQBkCG5RPXyUn68m5eZr7dP7aT0rTJ2XwsUeon9iuDnmfiDYSfprodXuBfjNCBJDdvMlrifVglUepV6kYpUz917UndAm7NeSIVN9weQkpMxNJjUHJLsnfiYIXToLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714880; c=relaxed/simple;
	bh=2jAbxd1Yfrnr5VSDxrODcar+k8GkMcB80cP28xxrloY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8f8jNBKSeznWBdGAzc04X6zlyV0h/ENkUxQrc/3fn8PcvLwVoa4coQts/4lU4beYoWduZMUGYna5eZq/mvVYseFz7t8AzleVAXniaYfnnJSS+xtag0mchQi1/ZAAcqXphwg8356t7dbTqF1C8OO84PsQg3lCKagMOOn95J5kMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=belyNr1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="belyNr1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A6CC4CEEA;
	Mon, 23 Jun 2025 21:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714880;
	bh=2jAbxd1Yfrnr5VSDxrODcar+k8GkMcB80cP28xxrloY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=belyNr1FaFqRzmRgg+c9WEJZWqejPRqgdZnPJICPogIMWDIoftYRUtYM79MSRrqpy
	 o5oEqQOUBwsvHxHwMob0GVzeWaizWX21HKUzxbrDUNRWBIZLpPRtnjth6nbFL0FTtc
	 j5QHle1EXx1klsCASV0ZRpFh6uKxiUyqwQJGXJkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/355] net: atlantic: generate software timestamp just before the doorbell
Date: Mon, 23 Jun 2025 15:07:40 +0200
Message-ID: <20250623130634.541392598@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 285ad7477559b6b5ceed10ba7ecfed9d17c0e7c6 ]

Make sure the call of skb_tx_timestamp is as close as possible to the
doorbell.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Link: https://patch.msgid.link/20250510134812.48199-2-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 1 -
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c  | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 1401fc4632b51..d9d3bf9b9277b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -117,7 +117,6 @@ static netdev_tx_t aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *nd
 	}
 #endif
 
-	skb_tx_timestamp(skb);
 	return aq_nic_xmit(aq_nic, skb);
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 54aa84f06e403..8b0531c085be2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -751,6 +751,8 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 
 	frags = aq_nic_map_skb(self, skb, ring);
 
+	skb_tx_timestamp(skb);
+
 	if (likely(frags)) {
 		err = self->aq_hw_ops->hw_ring_tx_xmit(self->aq_hw,
 						       ring, frags);
-- 
2.39.5



