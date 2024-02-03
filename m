Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A27C45030;
	Sat,  3 Feb 2024 04:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933678; cv=none; b=SSijK5Yu+HT/qHYozGGRXcWP+irkwfH/oPkgeZUmiaperkceKd1Sz5rofYvrChdeSF1AmfA2m7jMuYpUCef+qF3s9F8ESoiI/TGjwDtkUUtfVRE5D9vkieEq3vNtRyQARVnpbe6wAiiogvU+PZR+d6iLBw8lCRKcHlhee6WykHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933678; c=relaxed/simple;
	bh=LIufBq7DfiJQH+qWs5IKm1KrZS5N/KjflTSK3x/731Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anwWUcvC07RYTKrVdtXye3Qw+nE0uzA3PgHM5hF/50uGdlMg+5ra3aGGR+IZUECJJ2+FdiYmDxFQddDefEa7qt9TnS0JWvQKyvfDxt7lIUE3o6/8xv//uZPCWAnQOmF6DZyiFIYlBC4UD1JpBfRz3mnBBlMPn1J49b/t+Pzgzyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAIwNPeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAIwNPeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627A8C433F1;
	Sat,  3 Feb 2024 04:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933678;
	bh=LIufBq7DfiJQH+qWs5IKm1KrZS5N/KjflTSK3x/731Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAIwNPeDco9sMs132gjyabhLX/wAxH+o0oh7uSyUEvI2NqVYvE+elyb0jAbFAwOaL
	 JHIvAl61UXjlb7oDsfVoNbkiwDE8IzMujmBR13KpwuYUoZqknVTwk0IBYszGyXpPXI
	 B4F3RDA5aJdw2faXfPhMTqli8Y1vX5x2JIa1izgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/322] gve: Fix skb truesize underestimation
Date: Fri,  2 Feb 2024 20:06:08 -0800
Message-ID: <20240203035407.869350362@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Kaligineedi <pkaligineedi@google.com>

[ Upstream commit 534326711000c318fe1523c77308450522baa499 ]

For a skb frag with a newly allocated copy page, the true size is
incorrectly set to packet buffer size. It should be set to PAGE_SIZE
instead.

Fixes: 82fd151d38d9 ("gve: Reduce alloc and copy costs in the GQ rx path")
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Link: https://lore.kernel.org/r/20240124161025.1819836-1-pkaligineedi@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 73655347902d..93ff7c8ec905 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -362,7 +362,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
 
 static struct sk_buff *gve_rx_add_frags(struct napi_struct *napi,
 					struct gve_rx_slot_page_info *page_info,
-					u16 packet_buffer_size, u16 len,
+					unsigned int truesize, u16 len,
 					struct gve_rx_ctx *ctx)
 {
 	u32 offset = page_info->page_offset + page_info->pad;
@@ -395,10 +395,10 @@ static struct sk_buff *gve_rx_add_frags(struct napi_struct *napi,
 	if (skb != ctx->skb_head) {
 		ctx->skb_head->len += len;
 		ctx->skb_head->data_len += len;
-		ctx->skb_head->truesize += packet_buffer_size;
+		ctx->skb_head->truesize += truesize;
 	}
 	skb_add_rx_frag(skb, num_frags, page_info->page,
-			offset, len, packet_buffer_size);
+			offset, len, truesize);
 
 	return ctx->skb_head;
 }
@@ -492,7 +492,7 @@ static struct sk_buff *gve_rx_copy_to_pool(struct gve_rx_ring *rx,
 
 		memcpy(alloc_page_info.page_address, src, page_info->pad + len);
 		skb = gve_rx_add_frags(napi, &alloc_page_info,
-				       rx->packet_buffer_size,
+				       PAGE_SIZE,
 				       len, ctx);
 
 		u64_stats_update_begin(&rx->statss);
-- 
2.43.0



