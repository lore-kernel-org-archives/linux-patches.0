Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD51BE4A;
	Tue, 15 Jul 2025 13:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586780; cv=none; b=CUI7uEtIRWshttL4pVUPlcQixKbpUh+eYOByQS3cfpE5X2ZXrL61IqGif5uhj6bgbtByjIFlNjqhs2ThuN41HlWSug9mJvMsZJAAE8+tJ6xNi9jjjf/DCqVWv4kEzRffs4xKC5PeIzcKIIvrreCRsw6l0tU1jACOOpKFdX9JGg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586780; c=relaxed/simple;
	bh=Gg7j3qDLtIaVrpjcyeihsnfqJw363u8PQVwQWzt+ysI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsSfje+iF9PuXhTXYU2k/0C7A8C2Y4GgJNUPE7AOhf6rQ3KVXNkaBcnHS/XibD5KGoN7mfFCaxmHkDaSxw7q0Gwc2EqU+d9Qg3vkZmBtSadjuiIysZpzXUOHH+p5PU+LCxu1CDth63VmJYbSu9oooMhjwP4Vs/pv+S485Wl2H3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgMVG9Qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgMVG9Qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD022C4CEE3;
	Tue, 15 Jul 2025 13:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586780;
	bh=Gg7j3qDLtIaVrpjcyeihsnfqJw363u8PQVwQWzt+ysI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgMVG9QyxWxQ28/MAz91u+4Ndw4Pf8IGDWO1ol7Za6MRbW1lyjj8N+ccrCfT2ghfz
	 AIWmlnNmCiaGE1EhlmATtmnsKhh6DKSwYsgWvyRVf3npvmcOtHNrwndH+pX53HWKPh
	 Vv2SvyJfi4vumkOTIBk9MP0q2MkShyNQHjBAy5c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Chintan Vankar <c-vankar@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 045/192] net: ethernet: ti: am65-cpsw-nuss: Fix skb size by accounting for skb_shared_info
Date: Tue, 15 Jul 2025 15:12:20 +0200
Message-ID: <20250715130816.658361268@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4cec05e0e3d9b..10e8a8309a034 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -856,8 +856,6 @@ static struct sk_buff *am65_cpsw_build_skb(void *page_addr,
 {
 	struct sk_buff *skb;
 
-	len += AM65_CPSW_HEADROOM;
-
 	skb = build_skb(page_addr, len);
 	if (unlikely(!skb))
 		return NULL;
@@ -1344,7 +1342,7 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_rx_flow *flow,
 	}
 
 	skb = am65_cpsw_build_skb(page_addr, ndev,
-				  AM65_CPSW_MAX_PACKET_SIZE, headroom);
+				  PAGE_SIZE, headroom);
 	if (unlikely(!skb)) {
 		new_page = page;
 		goto requeue;
-- 
2.39.5



