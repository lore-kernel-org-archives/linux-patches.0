Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0CF192594;
	Tue,  8 Oct 2024 12:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391466; cv=none; b=gKTpscIeFnS1NKuCFJOGpvErMXhu2lcHpWaNUN+KeUvqzFxPyLa9eHr9S/TVLpzW83w0BtWvrTiRS22qnyb6D3DrmPrzLPk3wmfSdrZE5pPvzlfuotJaIqywbIic60cU7dmpY3dEyNSHWFgR0JRKiXxy6ONnoYBGuwXcD+OchK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391466; c=relaxed/simple;
	bh=nAvjSBVUHPiBz02njfWaKv2b+YtZ4KKJSLR7IFdRxSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mw0v3D/4ptZ4eb6ryrHUbZ2tGwSWxiEC05wTZlhg0Fv3TooWYHC/pJKttkLaB0ZIPyReVcyi6nb4xsk6eA7cbY/CayEKXmIuz+SqULFkkQqRFZzQopEMaF6vcCz+q3gT3tQT2/81KdVwj3wK+p5aUX9WD02DVyf/06rBOBd/BTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aM4xaH3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aM4xaH3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B07C4CEC7;
	Tue,  8 Oct 2024 12:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391466;
	bh=nAvjSBVUHPiBz02njfWaKv2b+YtZ4KKJSLR7IFdRxSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aM4xaH3OSAVNOmfIXW9TYCVV7n1R7OIw4lDXfC1yzUQxQqWdi7prZ7yLx0ecVjd2a
	 vcgIk01ON89CoibO3DDIVMRjRGoZFCKTM86x+0OrYDOB0o0uhxoD8oChePoWxftoFs
	 wXF2yjUcWrV7auvJTkBDSHyM2Ld53Wa9uiBaISGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 123/558] net: skbuff: sprinkle more __GFP_NOWARN on ingress allocs
Date: Tue,  8 Oct 2024 14:02:33 +0200
Message-ID: <20241008115707.206351102@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c89cca307b20917da739567a255a68a0798ee129 ]

build_skb() and frag allocations done with GFP_ATOMIC will
fail in real life, when system is under memory pressure,
and there's nothing we can do about that. So no point
printing warnings.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 83f8cd8aa2d16..de2a044cc6656 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -314,8 +314,8 @@ void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 	fragsz = SKB_DATA_ALIGN(fragsz);
 
 	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
-	data = __page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC,
-				       align_mask);
+	data = __page_frag_alloc_align(&nc->page, fragsz,
+				       GFP_ATOMIC | __GFP_NOWARN, align_mask);
 	local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
 	return data;
 
@@ -330,7 +330,8 @@ void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 		struct page_frag_cache *nc = this_cpu_ptr(&netdev_alloc_cache);
 
 		fragsz = SKB_DATA_ALIGN(fragsz);
-		data = __page_frag_alloc_align(nc, fragsz, GFP_ATOMIC,
+		data = __page_frag_alloc_align(nc, fragsz,
+					       GFP_ATOMIC | __GFP_NOWARN,
 					       align_mask);
 	} else {
 		local_bh_disable();
@@ -349,7 +350,7 @@ static struct sk_buff *napi_skb_cache_get(void)
 	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
 	if (unlikely(!nc->skb_count)) {
 		nc->skb_count = kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
-						      GFP_ATOMIC,
+						      GFP_ATOMIC | __GFP_NOWARN,
 						      NAPI_SKB_CACHE_BULK,
 						      nc->skb_cache);
 		if (unlikely(!nc->skb_count)) {
@@ -418,7 +419,8 @@ struct sk_buff *slab_build_skb(void *data)
 	struct sk_buff *skb;
 	unsigned int size;
 
-	skb = kmem_cache_alloc(net_hotdata.skbuff_cache, GFP_ATOMIC);
+	skb = kmem_cache_alloc(net_hotdata.skbuff_cache,
+			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -469,7 +471,8 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
 {
 	struct sk_buff *skb;
 
-	skb = kmem_cache_alloc(net_hotdata.skbuff_cache, GFP_ATOMIC);
+	skb = kmem_cache_alloc(net_hotdata.skbuff_cache,
+			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
 
-- 
2.43.0



