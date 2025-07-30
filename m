Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B975293C4B;
	Wed, 30 Jul 2025 09:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869269; cv=none; b=lOOw5RBy8niUy9o2OUHKEnOUKyElLg/UFNXcdzO3LglFSfjkWS4JXl1cKNnWpIICl2vRcfRbkXdoLl4MCrP+ymaFK18Ox32WeyLISAoGmF5DitN1vXLnR2LFXX9hVmR8DjI/ISGjMyF3RkcIKi4eNaSbyrEqn9ldI5vsUVL6kGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869269; c=relaxed/simple;
	bh=+oznMkJv7HfzA60uyCd3JCf0vK/mdL+8agN7IkiE2gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az4L2mcKXOemGPkMd7EJvg8dot70XgR3jMdDZkQy60SYZOpz27CCe6Y2yG6PNPQCqwBkkCTWRx5LpgwZqEpI2q7s2KfXVIwKMP8N7bUAaieY4QhKhCG7+JREbw/NtyYoYirFaPNeifsgd7JbG8rOmHHJ3Zr+KjqycGQP4cvaZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgOThebd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgOThebd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2513AC4CEFA;
	Wed, 30 Jul 2025 09:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869269;
	bh=+oznMkJv7HfzA60uyCd3JCf0vK/mdL+8agN7IkiE2gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgOThebd4yug9hIpTz/2QTy3qtOLkGq53VXSqhTWDw+l1NDxl+vnPKCxEYp3mxvNx
	 vO27Z7G820VQGOaRs5dWGqTOmvySAN0tOrOrASEokRLmHNfK+B+KOy+vqE8GC88XR1
	 gQcR26dveSiRzgcouPNzaJFtUV/bMQc6W/DB1UqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Yoo <harry.yoo@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 79/92] mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n
Date: Wed, 30 Jul 2025 11:36:27 +0200
Message-ID: <20250730093233.811136065@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

From: Harry Yoo <harry.yoo@oracle.com>

commit 694d6b99923eb05a8fd188be44e26077d19f0e21 upstream.

Commit 48b4800a1c6a ("zsmalloc: page migration support") added support for
migrating zsmalloc pages using the movable_operations migration framework.
However, the commit did not take into account that zsmalloc supports
migration only when CONFIG_COMPACTION is enabled.  Tracing shows that
zsmalloc was still passing the __GFP_MOVABLE flag even when compaction is
not supported.

This can result in unmovable pages being allocated from movable page
blocks (even without stealing page blocks), ZONE_MOVABLE and CMA area.

Possible user visible effects:
- Some ZONE_MOVABLE memory can be not actually movable
- CMA allocation can fail because of this
- Increased memory fragmentation due to ignoring the page mobility
  grouping feature
I'm not really sure who uses kernels without compaction support, though :(


To fix this, clear the __GFP_MOVABLE flag when
!IS_ENABLED(CONFIG_COMPACTION).

Link: https://lkml.kernel.org/r/20250704103053.6913-1-harry.yoo@oracle.com
Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1053,6 +1053,9 @@ static struct zspage *alloc_zspage(struc
 	if (!zspage)
 		return NULL;
 
+	if (!IS_ENABLED(CONFIG_COMPACTION))
+		gfp &= ~__GFP_MOVABLE;
+
 	zspage->magic = ZSPAGE_MAGIC;
 	zspage->pool = pool;
 	zspage->class = class->index;


