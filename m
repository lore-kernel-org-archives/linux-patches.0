Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950D126AC5;
	Sat, 12 Sep 2026 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228693; cv=none; b=jNKEWKwCXhvez5JfN6aUZZLzR4D+qyXfUQ7QTbftEGApbeUK1obD62aFjhAJ6q3LIvd21rUSCQvwWBcmqm7EZFYJtD6+SvODZwH0pc16+dwzNQN0gScw8954kfhcRHZqP/x8mFW8+myhHs4YHOvtIGx3jV8mrr4Fxr+yV4iJsms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228693; c=relaxed/simple;
	bh=YDO3aGoTF5shcJPVfncdem42qTSZIFsix5MN4ut1LYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaGpyRwMnMmmEtdhmwzHbMvJIK+1q9FoTo8/j20iWKpwLuu1cXyut0E0Jq42iq5cbeEHK5Z7mLTyyJa9SDBVe2Qbd4LJZ1T9q/pYH1+EBa0FFPpQD0c9t9PkRIsQZme9zNaOdQ93VOy0cp2/5S2o8IuJrh435DvOtK8LlDRITow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XICPGlpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XICPGlpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9611F000FF;
	Sat, 12 Sep 2026 15:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228692;
	bh=1Yf5kDr/Vmi6vzXjyvHxERIjxA/NdpQo7pQupuPdzjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XICPGlpAotwcPYf/Y0Jg+C+w0G1naFDjc1M6Et52/xhjjxVIBABnwP4GSHj1WDLnX
	 Poki7RRfZBqZS9AvKaTk3aajN1ROHLO8IH6Zg1T64+Q4WRkb0qPtI1S1WwDx2nTVn8
	 27SZRQUvpH6aFVbSg20RrvL1IvPUCqhUT/qlB7dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0437/1191] mm/damon/paddr: drop last same folio access check reuse optimization
Date: Sat, 12 Sep 2026 08:52:45 +0200
Message-ID: <20260912065558.048653795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit f23f0aa62b2f32c2b12f95959fc4603ef81678b2 ]

It can race when multiple kdamonds are being used.  The problem from the
race is doubtful, but the gain from the optimization is also doubtful.
Simply drop the optimization in favor of code simplicity.

The user impact is doubtfully trivial.  After all, this kind of
interference can happen only by intentional user setup.  Even if it
happens, it will be rare, and the consequence is degradation of the
best-effort monitoring results.  No critical consequences like kernel
panic or memory corruption happen.

The race was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-5-sj@kernel.org
Link: https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org [1]
Fixes: a28397beb55b ("mm/damon: implement primitives for physical address space monitoring")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/paddr.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 7bc8d79c7fa07..d1d047f494aed 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -120,7 +120,7 @@ static bool __damon_pa_young(struct folio *folio, struct vm_area_struct *vma,
 	return !result->accessed;
 }
 
-static bool damon_pa_young(unsigned long paddr, unsigned long *page_sz)
+static bool damon_pa_young(unsigned long paddr)
 {
 	struct folio *folio;
 	struct page *page = damon_get_page(PHYS_PFN(paddr));
@@ -161,29 +161,16 @@ static bool damon_pa_young(unsigned long paddr, unsigned long *page_sz)
 	folio_put(folio);
 
 out:
-	*page_sz = result.page_sz;
 	return result.accessed;
 }
 
 static void __damon_pa_check_access(struct damon_region *r)
 {
-	static unsigned long last_addr;
-	static unsigned long last_page_sz = PAGE_SIZE;
-	static bool last_accessed;
-
-	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_page_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_page_sz)) {
-		if (last_accessed)
-			r->nr_accesses++;
-		return;
-	}
+	bool accessed;
 
-	last_accessed = damon_pa_young(r->sampling_addr, &last_page_sz);
-	if (last_accessed)
+	accessed = damon_pa_young(r->sampling_addr);
+	if (accessed)
 		r->nr_accesses++;
-
-	last_addr = r->sampling_addr;
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
-- 
2.53.0



