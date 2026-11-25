Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622883;
	b=BXGuhISsNxCKl5Qo/jgt4G0DsO7AhRPqOe45qqcYOBdLLgRlmtC5aypz1Q1+ymEc/AMj
	 TS8W7759eTpCTG7/1qUOWLvR4//zkdaBNOScJuPU+meGfMc7x23/lPk3Anxic6UKF+Wrr
	 XBzP5M3BykO6fEWB9O8PNoj/9IvS0vusGWY6yuEtiQITcTtvw3JtiRwtAVSpZgcRntJ/D
	 IThMECuLj3+nWxHvPAkG6ZzcxPucuGu16DBEyQTgtrn8MYjPfvBpMInc8akQsbtAltvas
	 LA3z85/2EVr0yPpFjsDewnfsrhs59twBC0SccxGFdxmJ8nPbnwepge2EnkhbjmEAQfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wbc3YJDGE+O1SWx2O+JkKt6xN6d+OtMcUJ0EfN6S+8Q=;
	b=rhrSOckiFlf6Xax+jJhCsdFUNnngpRgOfqpgFysNdBejZIiGEeOsFsO/PCM1AQZohmDd
	 LAxv/TWcwsuXKIO8vVnUrh7Zxygd+yWYhWLBZdP75xU4F/zgVlXV/8rb4F6wBkf8UNVbL
	 xXLjQekV+cRLO37HlUI2y5SZ7tMPp2SVqsXJSyE0TZHS5qM4wjx9/qdnr7rvz/Cb96OCH
	 v45TAMJt+MFMJz9AwR6rb3yzMtkVbKdq98Qz2xJQe9HqGDWXdIUUSLs79OzwlSfYMWBil
	 Lhy37ZwenQxVfuIGa4WULOPakXgiGec95OEywveU5SjtKhWxMabHud2LZkO+O2YDJeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzzFklgi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A7B606A31E;
	Wed, 25 Nov 2026 16:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzzFklgi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C651F000C4;
	Wed, 25 Nov 2026 16:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622883;
	bh=Wbc3YJDGE+O1SWx2O+JkKt6xN6d+OtMcUJ0EfN6S+8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzzFklgiLFaYeYB7eWeX7S0XWhpV0QPiOr2VgNJo+Co8P2R5ITXm4ULs30/KgorzI
	 6CWnZQ58gMrPYmju2MeU0pWMInKeOl9ySjIHxezWuyhmPCT1VMcmx0lWxjGbd3k7Ma
	 IBTRKqQ0NGeWjc25UJCZnDlIqwATx74LKUsJRzYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 679/990] mm: page_frag: refill the cache for large fragments
Date: Wed, 25 Nov 2026 15:34:06 +0100
Message-ID: <20261125143837.992323017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit c028ecdf15131a2ab70d78a76657b81c00fa240d upstream.

A fragment which is larger than PAGE_SIZE can only be served from the
32K page of a page_frag_cache. If memory is low and the cache had to fall
back to a single page, __page_frag_alloc_align() returns NULL and keeps
that page.

Since the offset counts up, this check comes first and is made whenever
the fragment does not fit behind nc->offset, no matter how big the page
of the cache is. So the cache is never refilled on behalf of a large
fragment: with fragsz = 10000 the first three allocations succeed, the
fourth one and all the following ones fail although memory is plentiful.
nc->offset does not move either, so this lasts until smaller fragments
have used up the rest of the page, which never happens if the cache has
no other user.

The nfp driver allocates its receive buffers with napi_alloc_frag() and
netdev_alloc_frag(). They are larger than a page with a jumbo MTU.

Only give up if the fragment does not fit into the page at all, which is
what the comment describes. The fourth allocation in the scenario above
with a 32k page will thus now proceed to refill the cache.

Fixes: 8218f62c9c9b ("mm: page_frag: use initial zero offset for page_frag_alloc_align()")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
[vbabka@kernel.org: make the comment more obvious]
Link: https://patch.msgid.link/20261103-pgalloc-ai-hotfixes-v2-2-e0d2890ab74f@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_frag_cache.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -119,15 +119,20 @@ refill:
 	size = PAGE_SIZE << encoded_page_decode_order(encoded_page);
 	offset = __ALIGN_KERNEL_MASK(nc->offset, ~align_mask);
 	if (unlikely(offset + fragsz > size)) {
-		if (unlikely(fragsz > PAGE_SIZE)) {
+		if (unlikely(fragsz > size)) {
 			/*
-			 * The caller is trying to allocate a fragment
-			 * with fragsz > PAGE_SIZE but the cache isn't big
-			 * enough to satisfy the request, this may
-			 * happen in low memory conditions.
-			 * We don't release the cache page because
-			 * it could make memory pressure worse
-			 * so we simply return NULL here.
+			 * The caller is trying to allocate a fragment that's
+			 * larger than the whole cache page.
+			 *
+			 * Either fragsz is larger than PAGE_FRAG_CACHE_MAX_SIZE
+			 * so this cannot ever succeed.
+			 *
+			 * Or the refill has fallen back to order-0 due to a low
+			 * memory condition. Then we don't want to release the
+			 * cache page to attempt a new large-size refill because
+			 * it could make memory pressure worse.
+			 *
+			 * So in both cases we simply return NULL here.
 			 */
 			return NULL;
 		}


