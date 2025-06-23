Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE64C3FB1B;
	Mon, 23 Jun 2025 22:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716257; cv=none; b=DbEVGaidmMfob+Uw3/CfCKXA5h/WdRqPl6mYSsgT7WYEa0ZZOc2Ncr6KSDLxrNzA9nZoBnNWwYgY+oMmeCCiuKg/6D2c1Ci3jl+QyovDVHj/1sOA275GUweO8lFH9FPASjhs69ouKbpeTey/Wjv5YOS/WCejFr5GppEd2WrnYfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716257; c=relaxed/simple;
	bh=iuIrzvnz7Br3LqzET1GC+1R/5+STImZdRH48NGYHcD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Spk/Q2mjbygKvukaA0w3Mo86SIqZYhk6Cjnf3gcEAHGnwQ9STlXLXD+/1KiMpFKu3ZmjodpY1IEoIG9a5RMxZlf6mQl/SB1JTris7I9wNAnoczLYbWz8nDOToW1qVO0MiyNeQGVoft7CqovD3a4fC3k+clu/9mLtIYTe38qtWCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNeHqJ0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNeHqJ0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461E7C4CEEA;
	Mon, 23 Jun 2025 22:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716257;
	bh=iuIrzvnz7Br3LqzET1GC+1R/5+STImZdRH48NGYHcD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNeHqJ0rdQScqfCt/QDMtB9CAUqn9axFDqMX1L7Ln4BQe1m7xkuq2+1SPUHhrxPdG
	 RIV30mXPIes1N8yuOxOuc4G+x5b87cTHE1c0gcbREQxH0K//RsV/KhpFU7xoD2GQJi
	 lsPaPWeKQVI6sq2nTxYyBwQ6E10WWOm5WOqTweTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/411] net: atlantic: generate software timestamp just before the doorbell
Date: Mon, 23 Jun 2025 15:07:41 +0200
Message-ID: <20250623130641.617612702@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 45ed097bfe49a..026e628664a9d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -117,7 +117,6 @@ static netdev_tx_t aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *nd
 	}
 #endif
 
-	skb_tx_timestamp(skb);
 	return aq_nic_xmit(aq_nic, skb);
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 25349a2ae5cfe..2afa61e9bf8c6 100644
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



