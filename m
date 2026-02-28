Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326A036DA12;
	Sat, 28 Feb 2026 17:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301443; cv=none; b=UuX8iL/7ocrjxlS8+QqI0jVCc0JSZb8USl7yx/A3o3/gWvvhR7H5/fvL7gp29iD998baj7g1qQKjY+ttH/9ZQPAVu0cC/AF/AfQEzQtFu8K+seOkCVspOmv1tMP8T5uSO4xF3tBJg1dF0xOWIKtKKOa0kxg5DOc+Gg77RRGgivc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301443; c=relaxed/simple;
	bh=72RPNUc/iXLcDRYOIDPFhqLI8iZaaPVe6lyiIJlNqvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxMPjccuKMaF5c6zwNSJ1bhOAdzEA3DEb4z/FYmkUO6PGqOdf95vGbDNWV6Ol7AcibYJ0MTNUK8ZzeU4DOc30mlsJua5/snG8G//el8MCv8WVVXU8N+K54i76+Jj+QDIId4vEGgoLTxxFAOZ9h+467Q/ul8sC/1zXLsJ5ZY+nKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmRxl3HJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmRxl3HJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42982C19423;
	Sat, 28 Feb 2026 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301443;
	bh=72RPNUc/iXLcDRYOIDPFhqLI8iZaaPVe6lyiIJlNqvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmRxl3HJmzU7hj0uVoH/BymOsrQGNOViqteRMU/HFlgkL0s//BLAbiWBgjyTSq4vM
	 aCV9GtUSNIZrxnI4KTTJ+0HN+kQSN0FMW5T+RFb/9OcLntkji1WRSVHxXM3jPmXNpS
	 qiJdgWqSuMgo2lADQJOUmo63fdAv1BX5nNGyUPtTJ7j017/DO96XuWzqrlBtuRvU19
	 HgEca+YkWvYaxNw638iuYThc/HeIgyIT0o0OGQSuExC4/KnuaXGiN6w3IrCFVdhbo3
	 MBXQ1itws3mH49RuRr554ahtNmUGLCN7U7oSVh8FfQZ8+Pb+8rXPeKPM8vYXzx7dPn
	 s7CFm/C8OkrhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vlastimil Babka <vbabka@suse.cz>,
	kernel test robot <oliver.sang@intel.com>,
	stable@vger.kernel.org,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 629/752] mm/slab: add rcu_barrier() to kvfree_rcu_barrier_on_cache()
Date: Sat, 28 Feb 2026 12:45:40 -0500
Message-ID: <20260228174750.1542406-629-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit b55b423e8518361124ff0a9e15df431b3682ee4f ]

After we submit the rcu_free sheaves to call_rcu() we need to make sure
the rcu callbacks complete. kvfree_rcu_barrier() does that via
flush_all_rcu_sheaves() but kvfree_rcu_barrier_on_cache() doesn't. Fix
that.

This currently causes no issues because the caches with sheaves we have
are never destroyed. The problem flagged by kernel test robot was
reported for a patch that enables sheaves for (almost) all caches, and
occurred only with CONFIG_KASAN. Harry Yoo found the root cause [1]:

  It turns out the object freed by sheaf_flush_unused() was in KASAN
  percpu quarantine list (confirmed by dumping the list) by the time
  __kmem_cache_shutdown() returns an error.

  Quarantined objects are supposed to be flushed by kasan_cache_shutdown(),
  but things go wrong if the rcu callback (rcu_free_sheaf_nobarn()) is
  processed after kasan_cache_shutdown() finishes.

  That's why rcu_barrier() in __kmem_cache_shutdown() didn't help,
  because it's called after kasan_cache_shutdown().

  Calling rcu_barrier() in kvfree_rcu_barrier_on_cache() guarantees
  that it'll be added to the quarantine list before kasan_cache_shutdown()
  is called. So it's a valid fix!

[1] https://lore.kernel.org/all/aWd6f3jERlrB5yeF@hyeyoo/

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601121442.c530bed3-lkp@intel.com
Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
Cc: stable@vger.kernel.org
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 87bde1d8916be..0f58265ca200e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2134,8 +2134,11 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
  */
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
-	if (s->cpu_sheaves)
+	if (s->cpu_sheaves) {
 		flush_rcu_sheaves_on_cache(s);
+		rcu_barrier();
+	}
+
 	/*
 	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
 	 * on a specific slab cache.
-- 
2.51.0

