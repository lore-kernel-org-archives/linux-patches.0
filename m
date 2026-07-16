Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E44828505E;
	Thu, 16 Jul 2026 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211720; cv=none; b=SZ1rBu3wiWPpQeO6HLrvvubkeBSQl7f32RMwoM85LxLlZNeLys2aCE91RE54B4wasBWXuBTFOryG8nTSVRBmws9GJRHO23Hnsln3lR3T5p0MftB4rM0r/j5m5MZDSDVYbts/rl+1hOv3xNsmvk5txg79EE7NDkAEaMrswqYiemY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211720; c=relaxed/simple;
	bh=ZsjsqXiTW8pLq7AEq0SfxhRxXQdzIhhUDvfahqcq6vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tV5d4OqdICQhVjXLgylm/A2OgTiTn4O8lmdpb4jU+dvEz8L4SggENB4rD0pNvmyGYrs/zsmIlM/1tgiTURzdi9mS16WLhvzFuRzoxCblygNo4nwoRoKMBZjMvSUzArqPwc1GvoP+x/4iPpJyLx0Db9/6SGtVLF1Q+jSMB87oOmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCFGZfrJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCFGZfrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729C01F000E9;
	Thu, 16 Jul 2026 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211719;
	bh=KWZvmvoCxqQRL2KxKk1AolnGGVAVHo157l3eGToa7+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZCFGZfrJNQPZZZjtlhj66GTkPfhllnZ756KjrJjrbEVIVWcsZLRSt1VL04IJnGKJd
	 oy87+5uu7wGcXn+Fpla0D4UvCl4+rwC4tXnps+JVCXFu5CmQvQkKr94SQ33foic9ty
	 CwDO2QYK3SwxnH6bUf0PH+JSTY+NYUEP9DbnvGPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	chenyichong <chenyichong@uniontech.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/349] mm/vmalloc: take vmap_purge_lock in shrinker
Date: Thu, 16 Jul 2026 15:29:05 +0200
Message-ID: <20260716133033.544413641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

[ Upstream commit ec05f51f1e65bce95528543eb73fda56fd201d94 ]

decay_va_pool_node() can be invoked concurrently from two paths:
__purge_vmap_area_lazy() when pools are being purged, and the shrinker via
vmap_node_shrink_scan().

However, decay_va_pool_node() is not safe to run concurrently, and the
shrinker path currently lacks serialization, leading to races and possible
leaks.

Protect decay_va_pool_node() by taking vmap_purge_lock in the shrinker
path to ensure serialization with purge users.

Link: https://lore.kernel.org/20260413192646.14683-1-urezki@gmail.com
Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: chenyichong <chenyichong@uniontech.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ kept index-based loop instead of for_each_vmap_node() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1d2262fb541850..d4a42980b4d028 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5204,6 +5204,7 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	int i;
 
+	guard(mutex)(&vmap_purge_lock);
 	for (i = 0; i < nr_vmap_nodes; i++)
 		decay_va_pool_node(&vmap_nodes[i], true);
 
-- 
2.53.0



