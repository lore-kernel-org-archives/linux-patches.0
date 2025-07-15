Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A8F2472AE;
	Tue, 15 Jul 2025 13:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585449; cv=none; b=itm59iqpI+s7P9DUnAqNdlZKPxqkDRvaDWoBJ7VB7lNx37nVOlDlY4+Oz9QbEz9CGV1jEXGyLPFWyLisQ53raI6Qt5H7mExP4v71gjVoAMDHM0QOZtGD+7w3EpqdrCHwU31M99BwO7qGd9woPgF4D7BZOEb8NWDSk5S9JQ8yfPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585449; c=relaxed/simple;
	bh=tZba4MvOLuRi7Pysc3V0IoTv5lrJz0KiN+sH1O+BCgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPDLBV0xbH6DyiRot8VSCoT/VfsDL+a59zLWrmYxU+eyZJJf8ywwPaUH9sbxOU2VILpHXzqESwOdZ2/N3D45ytkgR+V41aKYUYK1jO1JITkd4iXhNBic/4/GZ7ws7ppW8BD3thkLNe5HPua0wbj4NfL+Vpc447QSyTHmSHg7KIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaH+NFLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaH+NFLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF101C4CEE3;
	Tue, 15 Jul 2025 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585449;
	bh=tZba4MvOLuRi7Pysc3V0IoTv5lrJz0KiN+sH1O+BCgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaH+NFLizSI7OXHIYmBGbPH/8u5pTPiw/TbtfM0yKpL9Sj5jJfFpIu/Q/xevjYHXR
	 a9rg3OzJefjEYYB/mkeOSVL3ivAZgNsgEI3on96zTSB3w7f++/UYbDyzslBHm9GLC0
	 SfSMYG4dznf3CfLZChI6lifaK+pF6IaQKjeTAvq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Chintan Vankar <c-vankar@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/163] net: ethernet: ti: am65-cpsw-nuss: Fix skb size by accounting for skb_shared_info
Date: Tue, 15 Jul 2025 15:11:52 +0200
Message-ID: <20250715130810.530076799@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chintan Vankar <c-vankar@ti.com>

[ Upstream commit 02c4d6c26f1f662da8885b299c224ca6628ad232 ]

While transitioning from netdev_alloc_ip_align() to build_skb(), memory
for the "skb_shared_info" member of an "skb" was not allocated. Fix this
by allocating "PAGE_SIZE" as the skb length, accounting for the packet
length, headroom and tailroom, thereby including the required memory space
for skb_shared_info.

Fixes: 8acacc40f733 ("net: ethernet: ti: am65-cpsw: Add minimal XDP support")
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Chintan Vankar <c-vankar@ti.com>
Link: https://patch.msgid.link/20250707085201.1898818-1-c-vankar@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 393cc5192e90d..6b5cff087686e 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -612,8 +612,6 @@ static struct sk_buff *am65_cpsw_build_skb(void *page_addr,
 {
 	struct sk_buff *skb;
 
-	len += AM65_CPSW_HEADROOM;
-
 	skb = build_skb(page_addr, len);
 	if (unlikely(!skb))
 		return NULL;
@@ -1217,7 +1215,7 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_rx_flow *flow,
 	}
 
 	skb = am65_cpsw_build_skb(page_addr, ndev,
-				  AM65_CPSW_MAX_PACKET_SIZE, headroom);
+				  PAGE_SIZE, headroom);
 	if (unlikely(!skb)) {
 		new_page = page;
 		goto requeue;
-- 
2.39.5



