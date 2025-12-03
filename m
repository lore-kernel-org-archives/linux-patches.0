Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1586731CA54;
	Wed,  3 Dec 2025 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776902; cv=none; b=oG+31wB/ec6XIoUVDI3U86jOfmSracZBquCu86VBgCamzwjTmvKWLjH4vVhMuEuOlj/xExwF8Oe0+bH3C0IZg/odEuxcVgJJmOcgkvUVQfxOwzGWRUQzEDfWqEJL3lvMythUbc3fdeM+bAy48XN/5/cxDB8+I6k4F7qqlvEQsoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776902; c=relaxed/simple;
	bh=MYQwbxCqzsQLOqjqDQeYG4sdFyHN/HDgYGCoYS/B4mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eK/t22Vrg0zMs/zxstwLM9yBPp9yjbKFr7P/l0p3FC0IdUoNw5faDTD4X5ens380L+9QiAapf4PItvcPtAqOYGyye/Di48xSYKLppuX/4l331E23WJZtkCU8YWPVTxKDrty+EW3FwimY0uNt2PsKGVNO2C52aJmsoeXq0YWdmEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2jh+bGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2jh+bGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7738BC4CEF5;
	Wed,  3 Dec 2025 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776902;
	bh=MYQwbxCqzsQLOqjqDQeYG4sdFyHN/HDgYGCoYS/B4mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2jh+bGcAbXyZOYguJbIJBuAU0gOfYOGeSgtBYkRF/BRDc3LYyyr8KFhrjhtqBzfg
	 fxbYYnQ6v/CbPpWjPnVuLNOzCk8lD1MIN3v14YOBhQOb3x8ZkXLQy9+YAhZ9inkfB6
	 tiqh4uypGDRNPeSNA/6BB/gWrMkkVfaN6dd9iU1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 021/146] xsk: avoid overwriting skb fields for multi-buffer traffic
Date: Wed,  3 Dec 2025 16:26:39 +0100
Message-ID: <20251203152347.244759972@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit c30d084960cf316c95fbf145d39974ce1ff7889c ]

We are unnecessarily setting a bunch of skb fields per each processed
descriptor, which is redundant for fragmented frames.

Let us set these respective members for first fragment only. To address
both paths that we have within xsk_build_skb(), move assignments onto
xsk_set_destructor_arg() and rename it to xsk_skb_init_misc().

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20250925160009.2474816-2-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0ebc27a4c67d ("xsk: avoid data corruption on cq descriptor number")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 72e34bd2d925c..01f258894faeb 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -618,11 +618,16 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	sock_wfree(skb);
 }
 
-static void xsk_set_destructor_arg(struct sk_buff *skb, u64 addr)
+static void xsk_skb_init_misc(struct sk_buff *skb, struct xdp_sock *xs,
+			      u64 addr)
 {
 	BUILD_BUG_ON(sizeof(struct xsk_addr_head) > sizeof(skb->cb));
 	INIT_LIST_HEAD(&XSKCB(skb)->addrs_list);
+	skb->dev = xs->dev;
+	skb->priority = READ_ONCE(xs->sk.sk_priority);
+	skb->mark = READ_ONCE(xs->sk.sk_mark);
 	XSKCB(skb)->num_descs = 0;
+	skb->destructor = xsk_destruct_skb;
 	skb_shinfo(skb)->destructor_arg = (void *)(uintptr_t)addr;
 }
 
@@ -673,7 +678,7 @@ static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 
 		skb_reserve(skb, hr);
 
-		xsk_set_destructor_arg(skb, desc->addr);
+		xsk_skb_init_misc(skb, xs, desc->addr);
 	} else {
 		xsk_addr = kmem_cache_zalloc(xsk_tx_generic_cache, GFP_KERNEL);
 		if (!xsk_addr)
@@ -757,7 +762,7 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 			if (unlikely(err))
 				goto free_err;
 
-			xsk_set_destructor_arg(skb, desc->addr);
+			xsk_skb_init_misc(skb, xs, desc->addr);
 		} else {
 			int nr_frags = skb_shinfo(skb)->nr_frags;
 			struct xsk_addr_node *xsk_addr;
@@ -826,14 +831,10 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 
 			if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
 				skb->skb_mstamp_ns = meta->request.launch_time;
+			xsk_tx_metadata_to_compl(meta, &skb_shinfo(skb)->xsk_meta);
 		}
 	}
 
-	skb->dev = dev;
-	skb->priority = READ_ONCE(xs->sk.sk_priority);
-	skb->mark = READ_ONCE(xs->sk.sk_mark);
-	skb->destructor = xsk_destruct_skb;
-	xsk_tx_metadata_to_compl(meta, &skb_shinfo(skb)->xsk_meta);
 	xsk_inc_num_desc(skb);
 
 	return skb;
-- 
2.51.0



