Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE1D10E0;
	Tue, 26 Aug 2025 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218188; cv=none; b=b83Th4Bq3LjWbLK2JkT3GK7MiRQCLVCkEGoH05ell1dI9I3uuLvcLWGm0Z4m9O7/jqyUMdu/0O+lq7EydpPT51Ooc/zhoD9OU1HaU+X1eL03xG3YJeH6xaSU4RU8P6prI4CoyyXPSwtf1KyWtYPAxs/yeGunwKq9SGp6Tc4ddT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218188; c=relaxed/simple;
	bh=7J4nFONPhlLszpGvd51ppet5mJrujuqzZTRk9CbghIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpM4uE6uXB+TA9VZ60YcFWgChfbSbz2zzyI+jJx4QAD8NN2eDkKJQPkqnTnzoXH9ICDxZY3Yr/nevkHL6eM1vrtSt7nHsLMLmwc+/pg12AdJMn9Zm2f1wKZ63tlJumLKgMtl7O/3rg4tVLKTjipAq2rstxDyo/0HJa8gsK3Bp1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xo3LAFFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xo3LAFFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A0EC4CEF1;
	Tue, 26 Aug 2025 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218188;
	bh=7J4nFONPhlLszpGvd51ppet5mJrujuqzZTRk9CbghIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xo3LAFFp5enwKna4vfHtxmtbeRJl+5IwqzqIXU3dbU+XYAsiZipNOIlm8hpn1Oclb
	 1W+g8EtnJvicD9GP2u9jqc5QI6n3CCymI62lGTny7iIIT8gR8lBveELcTKNbVrOu+2
	 9CY2L/VkLlN4EooEhbZ+67MSycF5RrQPzArY7o1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 426/523] mm/zsmalloc.c: convert to use kmem_cache_zalloc in cache_alloc_zspage()
Date: Tue, 26 Aug 2025 13:10:36 +0200
Message-ID: <20250826110934.964700624@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit f0231305acd53375c6cf736971bf5711105dd6bb ]

We always memset the zspage allocated via cache_alloc_zspage.  So it's
more convenient to use kmem_cache_zalloc in cache_alloc_zspage than caller
do it manually.

Link: https://lkml.kernel.org/r/20210114120032.25885-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 694d6b99923e ("mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -357,7 +357,7 @@ static void cache_free_handle(struct zs_
 
 static struct zspage *cache_alloc_zspage(struct zs_pool *pool, gfp_t flags)
 {
-	return kmem_cache_alloc(pool->zspage_cachep,
+	return kmem_cache_zalloc(pool->zspage_cachep,
 			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
 }
 
@@ -1067,7 +1067,6 @@ static struct zspage *alloc_zspage(struc
 	if (!zspage)
 		return NULL;
 
-	memset(zspage, 0, sizeof(struct zspage));
 	zspage->magic = ZSPAGE_MAGIC;
 	migrate_lock_init(zspage);
 


