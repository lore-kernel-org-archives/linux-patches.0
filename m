Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23052255246;
	Thu, 17 Apr 2025 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915980; cv=none; b=I7RLM2dhTLJt+amd7aOrOdPzWdnaEajvTvo32AW9CJEJG9SUtaMtnmiTC/wBtjfvjNxt4DGOJNR5jeR3I1R4aftgGCkRjQ/XwmzLFLrNVx9/e3k+OXijiMowEZKS9/ZZzq3RNcgt19WK59BueUor50rT4rbpwE1Hyp5mkgUa3zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915980; c=relaxed/simple;
	bh=IH9GAb9gRQi9+IZCvfQ4Nl+kYwJD65V/pEk/F3sRRfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn2wWPkqnxUuQOhx/6vDEqI67lTK3XfdmIKrv86qtbeTep1HLqV3nyCw/fdlR3CaYKWjVAOpyn3rCMt/AtDFdrXlM4GE4FfuZ9BSB/72N7yXNRKXRnMRD/oLIZ5XzuPs8RrFsIHsUZocillqtJt/gEkmwqbk8JO5KVPEVurjh30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KmsB9bF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KmsB9bF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9516EC4CEE4;
	Thu, 17 Apr 2025 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915980;
	bh=IH9GAb9gRQi9+IZCvfQ4Nl+kYwJD65V/pEk/F3sRRfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KmsB9bFdo9aP3gHYTI2DGLi+6zscVhUgefTOGNv8/gDkM3P009VIzx8CqeG+RSdr
	 yR+DYnzUzs6aNzkMSFP48OlNUVDAyG9DkJ7EOlNM71NhpGnBSFV3X88pW4KlDXeL53
	 Fkjb2rly0fgqhCa4S3omu2rjCzqllNmWFjcxi4/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usamaarif642@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 303/393] mm/damon/ops: have damon_get_folio return folio even for tail pages
Date: Thu, 17 Apr 2025 19:51:52 +0200
Message-ID: <20250417175119.798662739@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usamaarif642@gmail.com>

commit 3a06696305e757f652dd0dcf4dfa2272eda39434 upstream.

Patch series "mm/damon/paddr: fix large folios access and schemes handling".

DAMON operations set for physical address space, namely 'paddr', treats
tail pages as unaccessed always.  It can also apply DAMOS action to a
large folio multiple times within single DAMOS' regions walking.  As a
result, the monitoring output has poor quality and DAMOS works in
unexpected ways when large folios are being used.  Fix those.

The patches were parts of Usama's hugepage_size DAMOS filter patch
series[1].  The first fix has collected from there with a slight commit
message change for the subject prefix.  The second fix is re-written by SJ
and posted as an RFC before this series.  The second one also got a slight
commit message change for the subject prefix.

[1] https://lore.kernel.org/20250203225604.44742-1-usamaarif642@gmail.com
[2] https://lore.kernel.org/20250206231103.38298-1-sj@kernel.org


This patch (of 2):

This effectively adds support for large folios in damon for paddr, as
damon_pa_mkold/young won't get a null folio from this function and won't
ignore it, hence access will be checked and reported.  This also means
that larger folios will be considered for different DAMOS actions like
pageout, prioritization and migration.  As these DAMOS actions will
consider larger folios, iterate through the region at folio_size and not
PAGE_SIZE intervals.  This should not have an affect on vaddr, as
damon_young_pmd_entry considers pmd entries.

Link: https://lkml.kernel.org/r/20250207212033.45269-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250207212033.45269-2-sj@kernel.org
Fixes: a28397beb55b ("mm/damon: implement primitives for physical address space monitoring")
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/ops-common.c |    2 +-
 mm/damon/paddr.c      |   24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -24,7 +24,7 @@ struct folio *damon_get_folio(unsigned l
 	struct page *page = pfn_to_online_page(pfn);
 	struct folio *folio;
 
-	if (!page || PageTail(page))
+	if (!page)
 		return NULL;
 
 	folio = page_folio(page);
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -264,11 +264,14 @@ static unsigned long damon_pa_pageout(st
 		damos_add_filter(s, filter);
 	}
 
-	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+	addr = r->ar.start;
+	while (addr < r->ar.end) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
 
-		if (!folio)
+		if (!folio) {
+			addr += PAGE_SIZE;
 			continue;
+		}
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
@@ -282,6 +285,7 @@ static unsigned long damon_pa_pageout(st
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -296,11 +300,14 @@ static inline unsigned long damon_pa_mar
 {
 	unsigned long addr, applied = 0;
 
-	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+	addr = r->ar.start;
+	while (addr < r->ar.end) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
 
-		if (!folio)
+		if (!folio) {
+			addr += PAGE_SIZE;
 			continue;
+		}
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
@@ -311,6 +318,7 @@ static inline unsigned long damon_pa_mar
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
@@ -454,11 +462,14 @@ static unsigned long damon_pa_migrate(st
 	unsigned long addr, applied;
 	LIST_HEAD(folio_list);
 
-	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+	addr = r->ar.start;
+	while (addr < r->ar.end) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
 
-		if (!folio)
+		if (!folio) {
+			addr += PAGE_SIZE;
 			continue;
+		}
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
@@ -467,6 +478,7 @@ static unsigned long damon_pa_migrate(st
 			goto put_folio;
 		list_add(&folio->lru, &folio_list);
 put_folio:
+		addr += folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_pa_migrate_pages(&folio_list, s->target_nid);


