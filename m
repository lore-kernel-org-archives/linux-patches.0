Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762D444BCB8;
	Tue, 16 Jun 2026 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626215; cv=none; b=RECQXbbrVWrsTPRliCwuEwCAPQr2L8t3xAeSnaEdh4Zrf3TwIRR0RLXNHLdPsNI7NxcKLBDKHZ9T1Sv42x2t9U90S13Z36aYXz9TYcNU4hKVqaMh18YUS3hbqYruLJeuyMmhtzVy2ghHXbTvNCnXPapo9nh8VLCY3mzbkxKYhz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626215; c=relaxed/simple;
	bh=RqIKc2rQQru0RwLN4RwnM/6tFe3zpALILAGIa/3JufU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jo71mDGcEkVzYwuLah4gvLlLUj4qHXuqN/SbRE2IF2d6qlpqLbWUXSt6mCRJ9p/hqEyVtscH8raq6e1NJn11pX8V/ffz+9HcjIHUUMYfXpYl81dRW6hKWYqPiL/O0mogaJxo+6fiBGdNawD0n3kARguIKHmVdPhDo7xcj5TLPcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G11SwANA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G11SwANA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234C91F000E9;
	Tue, 16 Jun 2026 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626214;
	bh=oaix62ZiYHsUzS/BG1p3OrsIFlA9Uoa1E68ARllCQtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G11SwANAU42vT978XWHgFksfDBKDIVF21ZBXGaRifDkZCt6FspNwwqCUAW4r6/TWD
	 Mke4FvfDwktQUz6ol5UgvVJcsor2G9+tTp7BTnLVBpZ7yvkgsyltaPYx0I6QVkfeHT
	 KVOcwCR2PpiNJHrSN42Ygb9y0MxFUtnw86w1kBDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 252/325] mm/damon/reclaim: handle ctx allocation failure
Date: Tue, 16 Jun 2026 20:30:48 +0530
Message-ID: <20260616145111.092547223@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 7e2ed8a29427af534bf2cb9b8bc51762b8b6e654 upstream.

Patch series "mm/damon/{reclaim,lru_sort}: handle ctx allocation failures".

DAMON_RECLAIM and DAMON_LRU_SORT could dereference NULL pointers if their
damon_ctx object allocations fail.  The bugs are expected to happen
infrequently because the allocations are arguably too small to fail on
common setups.  But theoretically they are possible and the consequences
are bad.  Fix those.

The issues were discovered [1] by Sashiko.


This patch (of 2):

DAMON_RECLAIM allocates the damon_ctx object for its kdamond in its init
function.  damon_reclaim_enabled_store() wrongly assumes the allocation
will always succeed once tried.  If the damon_ctx allocation was failed,
therefore, code execution reaches to damon_commit_ctx() while 'ctx' is
NULL.  As a result, it dereferences the NULL 'ctx' pointer.  Avoid the
NULL dereference by returning -ENOMEM if 'ctx' is NULL.

Link: https://lore.kernel.org/20260529000104.7006-2-sj@kernel.org
Link: https://lore.kernel.org/20260419014800.877-1-sj@kernel.org [1]
Fixes: 3f7a914ab9a5 ("mm/damon/reclaim: use damon_initialized()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/reclaim.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -343,6 +343,10 @@ static int damon_reclaim_enabled_store(c
 	if (!damon_initialized())
 		return 0;
 
+	/* damon_modules_new_paddr_ctx_target() in the init function failed. */
+	if (!ctx)
+		return -ENOMEM;
+
 	return damon_reclaim_turn(enabled);
 }
 


