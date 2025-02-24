Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A231124502A;
	Mon, 24 Feb 2025 14:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407799; cv=none; b=VA21QAHi2gVvdXdXO8KZMZ868oTbC6qWGOYQDLd3at+0Ru0vzuNlioMs/pJpTwE07zcq/mNeQCYKxqJyGuSpk64Yun9Y+izUk/MKPe5J49LwHzZ1xLpipvafYTir1pPG6MtGlJ292BYDvy7vIsulVV4pGhY5uhtV8KB2pa+N+es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407799; c=relaxed/simple;
	bh=ccwwhGiUhtkpj7j1x4Jq2wZs8aYbUbDQS1pvMQI7lqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOAAVblC+X5wIpSFHhMqum109+O9t2Jr5qywsUb2dMU8ZVHZmQW85KV7/NSjN9tXxiOcJDicKuPS6igRzzAxNB8/HCcEvKq9gmpk7QkZ3zKCM3Jp0OsMe1PHGkykbQHGUuhjtLlmb4ODgWlhcFnk6k6p+CO2rJ9KfvSb7I/vOA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMGhe8xM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMGhe8xM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EAEC4CED6;
	Mon, 24 Feb 2025 14:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407799;
	bh=ccwwhGiUhtkpj7j1x4Jq2wZs8aYbUbDQS1pvMQI7lqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMGhe8xMxGQZ5VkQ8gNlANGiW2fQmh2oXub198zpxAu4UwTbv1ezG3fD+bDAwxOIT
	 8e95/aLQM6RPbKPYMQqNxXXOmQSHVRMD7G06uhe3EMUdD0qKgPIxOaah0RRtl/FCQ1
	 TzTkKgzSrjfMZdKGjEpIQDPvzRzQbne/SJGyFqY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 013/140] xfs: dont ifdef around the exact minlen allocations
Date: Mon, 24 Feb 2025 15:33:32 +0100
Message-ID: <20250224142603.531099993@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit b611fddc0435738e64453bbf1dadd4b12a801858 upstream.

Exact minlen allocations only exist as an error injection tool for debug
builds.  Currently this is implemented using ifdefs, which means the code
isn't even compiled for non-XFS_DEBUG builds.  Enhance the compile test
coverage by always building the code and use the compilers' dead code
elimination to remove it from the generated binary instead.

The only downside is that the alloc_minlen_only field is unconditionally
added to struct xfs_alloc_args now, but by moving it around and packing
it tightly this doesn't actually increase the size of the structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    7 ++-----
 fs/xfs/libxfs/xfs_alloc.h |    4 +---
 fs/xfs/libxfs/xfs_bmap.c  |    6 ------
 3 files changed, 3 insertions(+), 14 deletions(-)

--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2581,7 +2581,6 @@ __xfs_free_extent_later(
 	return 0;
 }
 
-#ifdef DEBUG
 /*
  * Check if an AGF has a free extent record whose length is equal to
  * args->minlen.
@@ -2620,7 +2619,6 @@ out:
 
 	return error;
 }
-#endif
 
 /*
  * Decide whether to use this allocation group for this allocation.
@@ -2694,15 +2692,14 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, alloc_flags))
 		goto out_agbp_relse;
 
-#ifdef DEBUG
-	if (args->alloc_minlen_only) {
+	if (IS_ENABLED(CONFIG_XFS_DEBUG) && args->alloc_minlen_only) {
 		int stat;
 
 		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
 		if (error || !stat)
 			goto out_agbp_relse;
 	}
-#endif
+
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -53,11 +53,9 @@ typedef struct xfs_alloc_arg {
 	int		datatype;	/* mask defining data type treatment */
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
+	bool		alloc_minlen_only; /* allocate exact minlen extent */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
-#ifdef DEBUG
-	bool		alloc_minlen_only; /* allocate exact minlen extent */
-#endif
 } xfs_alloc_arg_t;
 
 /*
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3388,7 +3388,6 @@ xfs_bmap_process_allocated_extent(
 	xfs_bmap_btalloc_accounting(ap, args);
 }
 
-#ifdef DEBUG
 static int
 xfs_bmap_exact_minlen_extent_alloc(
 	struct xfs_bmalloca	*ap)
@@ -3450,11 +3449,6 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 	return 0;
 }
-#else
-
-#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
-
-#endif
 
 /*
  * If we are not low on available data blocks and we are allocating at


