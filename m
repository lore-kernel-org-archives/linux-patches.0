Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A140373BF2;
	Sat, 12 Sep 2026 12:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216704; cv=none; b=r4mTeBAcGUQ+AfbkjSxbYI3qru8OhKuDd2z7da0lmG7KRwDtoGfPOV8bN6EQvMz54ke1xUs23460MYuC4I7d10XWfZF9wzLLKdmHCkoivhwFmrPcY67Z7LKD7PdCCasNzvCDr/1Jxs6JaSaCisverI3FqtTQw75JhN4XR8Cz+LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216704; c=relaxed/simple;
	bh=awyu5zys2+W/Gcsbk6WZdIhJnF5wf4rpmVZ0ywTBtNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIfOuG4gtODOCHGUInjayrUmFt0B8NAydvLQw16hNNHg0V4E42Xrh+stDyz1Uwe1r3Q0ucd9glMulVh/u4sQswPEqxP9xKbqwpVpBS/44959CdjhWImZLftlf+Kvkncf9iRkLWhhYCJIDLtaMN4gJaHo0MUyhRFAzuJNOQiLM6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elpgpzL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elpgpzL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CC41F000FF;
	Sat, 12 Sep 2026 12:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216702;
	bh=WgmxroV6UehcoXG/vM1EkjsXepiB0yogNbtVcwrFwlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elpgpzL3ju0lIeM9WngZFTgBZWxw5F6JkLYlM6ctCJbSNxIn/mOfgJdhk2Q0laz71
	 V+KalWLxWtPNZzgjrl5wQVQGb5dRlIP1stC66SM81Ne4iNhhmPjrZk22fZtoXWPK2m
	 B/i7VactCYHTgB26Q0dK3A2COoyeUfIYkA/NCUlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0748/1376] slab: simplify init_kmem_cache_nodes() error handling
Date: Sat, 12 Sep 2026 08:52:54 +0200
Message-ID: <20260912065624.214673524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit 9d4e6ab865c48c70e684b176d3ee1574d092626f ]

We don't need to call free_kmem_cache_nodes() immediately when failing
to allocate a kmem_cache_node, because when we return 0,
do_kmem_cache_create() calls __kmem_cache_release() which also performs
free_kmem_cache_nodes().

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Stable-dep-of: 4c6eb712a91f ("wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b61225c3503bf..68407f1177482 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5323,10 +5323,8 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 		n = kmem_cache_alloc_node(kmem_cache_node,
 						GFP_KERNEL, node);
 
-		if (!n) {
-			free_kmem_cache_nodes(s);
+		if (!n)
 			return 0;
-		}
 
 		init_kmem_cache_node(n);
 		s->node[node] = n;
-- 
2.53.0



