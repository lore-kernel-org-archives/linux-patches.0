Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE14466B5F;
	Tue, 16 Jun 2026 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624398; cv=none; b=V7thnveQ5E25LWqwaTmUTsnhoFLO6cFft2lVLRiq7jJVAxc0aD/WpFMHVDpY5qzJapPJZWEUAzLaviIBFKYRBqKCfNK3YrxBUBjNSGK3KcYmsbjLLuEZJpDRGDpoH7Z+By/gYJscZcbyj67uNYNOIuXzF8QaVNQ3ty+9tlOhbxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624398; c=relaxed/simple;
	bh=xpO8+ixLwp087x/MB23ZflzTRZGCU15DyRWucfVi3yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5O0w6/d/EN2qAbQMF+YM+/CJazv7EQDHmROCWK1LbEwuT11+4Tx9oBvcS3PVApKzizjlbmnL1K82MMo73/r9yJ7WoMM2XKsECastQQzmG+EloPwTCpll2zsVPI+CvCQ5Af/pZ/yYusvnLx1HtSYbaHKbv/tJT+pQxnSvwummk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWdFSlgb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWdFSlgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDB51F00A3A;
	Tue, 16 Jun 2026 15:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624397;
	bh=NqKCTrunp9G3sgjzZ6jfKb+8pXyE+KBJggmHuklBQd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWdFSlgbdoKZ4G94sUSu+eqOgKgUuBndoKkgm9Gj1+sCSFr2UiRpd2jfyjbYAw/2y
	 Bricdvup+x9KlctpTCj7i1x4S44m497sUom6GYG/BTwMBRHIHAvML3WIO26sVo45ve
	 n2WmXADSvGCiTgMqN2bl1vTpam2vPs2GRggFbPAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 301/378] mm/damon/reclaim: handle ctx allocation failure
Date: Tue, 16 Jun 2026 20:28:52 +0530
Message-ID: <20260616145125.946640619@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -344,6 +344,10 @@ static int damon_reclaim_enabled_store(c
 	if (!damon_initialized())
 		return 0;
 
+	/* damon_modules_new_paddr_ctx_target() in the init function failed. */
+	if (!ctx)
+		return -ENOMEM;
+
 	return damon_reclaim_turn(enabled);
 }
 


