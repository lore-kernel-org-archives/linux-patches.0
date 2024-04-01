Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9C2482EF;
	Mon,  1 Apr 2024 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990362; cv=none; b=oCzDNqaW2AJgpFgqN6USoI1kO8PPEix0n8CsjHX1g2Q/AGP+Pdm+yO74k9rd+lTcNIhzZQBiPChRbLLV2BN75jsxi3jWnI1kJQ8wZlOHGDbF2FX0GTnAZcI+1ibXXbEUTskPosGvv2iXN+UNOE1lLmeMI1/7xvMQ9qU4epEprU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990362; c=relaxed/simple;
	bh=/szOagmt8e00JpdQZclALeoLWrMCU+yIAx9L8dsRc7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cY4DysT+vcwwzsigDYlzRoztAMXEZnV6VION3HknV1qtpNDU4QXyri03yFDgH0XauTvEsaq8gU97X7zj04Q+/0SXBDffGSDxwJ1WqeeTMGbCtNZe7bh7+EgfnC2PJBJHbAaAYJqZen4tPn4cZB7rNSH4WYT6Jya2PqVY/rqdgRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4ouqKYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4ouqKYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE253C433F1;
	Mon,  1 Apr 2024 16:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990362;
	bh=/szOagmt8e00JpdQZclALeoLWrMCU+yIAx9L8dsRc7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4ouqKYPwp7u6gtwUt0Sr8PpiztsOuu+APQk+YciSpAP9o/SA+rtertjgEB8RcRK1
	 1OSiimrIIcLrQG9SkIz/n+Ticfx4/AysDLuSvgkewqsmR7MYybWm+WVFpmhmy/FyVJ
	 2p747+lqr87OjXDSE8XuqUSNRxWqnV1lE2Cssq9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.6 328/396] mm: cachestat: fix two shmem bugs
Date: Mon,  1 Apr 2024 17:46:17 +0200
Message-ID: <20240401152557.689899535@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Johannes Weiner <hannes@cmpxchg.org>

commit d5d39c707a4cf0bcc84680178677b97aa2cb2627 upstream.

When cachestat on shmem races with swapping and invalidation, there
are two possible bugs:

1) A swapin error can have resulted in a poisoned swap entry in the
   shmem inode's xarray. Calling get_shadow_from_swap_cache() on it
   will result in an out-of-bounds access to swapper_spaces[].

   Validate the entry with non_swap_entry() before going further.

2) When we find a valid swap entry in the shmem's inode, the shadow
   entry in the swapcache might not exist yet: swap IO is still in
   progress and we're before __remove_mapping; swapin, invalidation,
   or swapoff have removed the shadow from swapcache after we saw the
   shmem swap entry.

   This will send a NULL to workingset_test_recent(). The latter
   purely operates on pointer bits, so it won't crash - node 0, memcg
   ID 0, eviction timestamp 0, etc. are all valid inputs - but it's a
   bogus test. In theory that could result in a false "recently
   evicted" count.

   Such a false positive wouldn't be the end of the world. But for
   code clarity and (future) robustness, be explicit about this case.

   Bail on get_shadow_from_swap_cache() returning NULL.

Link: https://lkml.kernel.org/r/20240315095556.GC581298@cmpxchg.org
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Chengming Zhou <chengming.zhou@linux.dev>	[Bug #1]
Reported-by: Jann Horn <jannh@google.com>		[Bug #2]
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>				[v6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4201,7 +4201,23 @@ static void filemap_cachestat(struct add
 				/* shmem file - in swap cache */
 				swp_entry_t swp = radix_to_swp_entry(folio);
 
+				/* swapin error results in poisoned entry */
+				if (non_swap_entry(swp))
+					goto resched;
+
+				/*
+				 * Getting a swap entry from the shmem
+				 * inode means we beat
+				 * shmem_unuse(). rcu_read_lock()
+				 * ensures swapoff waits for us before
+				 * freeing the swapper space. However,
+				 * we can race with swapping and
+				 * invalidation, so there might not be
+				 * a shadow in the swapcache (yet).
+				 */
 				shadow = get_shadow_from_swap_cache(swp);
+				if (!shadow)
+					goto resched;
 			}
 #endif
 			if (workingset_test_recent(shadow, true, &workingset))


