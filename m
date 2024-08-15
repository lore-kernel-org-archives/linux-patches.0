Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977BD1A00D2;
	Thu, 15 Aug 2024 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729428; cv=none; b=q4k7+CUC3E+58OEy6qy3hcFUs7a2ViIIBFbNOd7QcWb2ZSp9xSIPIg7vOhvK4fN5WYXZ7Zj2rIra8hODS6Nas3ftWAd7CTrMosUT/tu2sdrJp7ZlSJC/dngho5jRXaa97CQKBfd4HXbhnB9PfIlIcq7LWsQ49U2yPCHGagyTesc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729428; c=relaxed/simple;
	bh=P2K2WBLP6EaxPjfGsWYfa29NmgoGUnPOGSjaLDOnC48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOkB83jWppQqn3XVcu5Z7s0WYbJh/HXyyvQUJol9a339WVlrmSzkl04T5EB3IuKFauAs/i6hRY7QYoqmNTJgjWcLhyNp27RrDAUIb9aSeRJBnG7tbD1N2rt1fz3lf543oFjgMvRvwTgSnC17WJFrDap+dZ6o/BWPzFm/pZ4HIeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ky22rB62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ky22rB62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4A8C32786;
	Thu, 15 Aug 2024 13:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729428;
	bh=P2K2WBLP6EaxPjfGsWYfa29NmgoGUnPOGSjaLDOnC48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ky22rB62enGrBeOu6CD9fQbttGP0iZErnLtVciGwr62DHNZeIBSptOibAujuG09/O
	 edGA5rBZc0rvLb26TZU4AWfWNHxIpFjxuMr8QDD5BoBQQLOUEHZ0xRah39Z4OSdn6e
	 U++vU8DysfXcomWbOx2xt/FILy/NwnQeyJNq9GCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/484] s390/mm: Convert gmap_make_secure to use a folio
Date: Thu, 15 Aug 2024 15:19:11 +0200
Message-ID: <20240815131944.882241292@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit d35c34bb32f2cc4ec0b52e91ad7a8fcab55d7856 ]

Remove uses of deprecated page APIs, and move the check for large
folios to here to avoid taking the folio lock if the folio is too large.
We could do better here by attempting to split the large folio, but I'll
leave that improvement for someone who can test it.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20240322161149.2327518-3-willy@infradead.org
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: 3f29f6537f54 ("s390/uv: Don't call folio_wait_writeback() without a folio reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 425f6e4b30267..b54376c658688 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -192,13 +192,10 @@ static int expected_folio_refs(struct folio *folio)
 	return res;
 }
 
-static int make_page_secure(struct page *page, struct uv_cb_header *uvcb)
+static int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 {
-	struct folio *folio = page_folio(page);
 	int expected, cc = 0;
 
-	if (folio_test_large(folio))
-		return -EINVAL;
 	if (folio_test_writeback(folio))
 		return -EAGAIN;
 	expected = expected_folio_refs(folio);
@@ -264,7 +261,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	bool local_drain = false;
 	spinlock_t *ptelock;
 	unsigned long uaddr;
-	struct page *page;
+	struct folio *folio;
 	pte_t *ptep;
 	int rc;
 
@@ -291,15 +288,19 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	rc = -ENXIO;
 	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
 	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
-		page = pte_page(*ptep);
+		folio = page_folio(pte_page(*ptep));
+		rc = -EINVAL;
+		if (folio_test_large(folio))
+			goto unlock;
 		rc = -EAGAIN;
-		if (trylock_page(page)) {
+		if (folio_trylock(folio)) {
 			if (should_export_before_import(uvcb, gmap->mm))
-				uv_convert_from_secure(page_to_phys(page));
-			rc = make_page_secure(page, uvcb);
-			unlock_page(page);
+				uv_convert_from_secure(PFN_PHYS(folio_pfn(folio)));
+			rc = make_folio_secure(folio, uvcb);
+			folio_unlock(folio);
 		}
 	}
+unlock:
 	pte_unmap_unlock(ptep, ptelock);
 out:
 	mmap_read_unlock(gmap->mm);
@@ -309,10 +310,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 		 * If we are here because the UVC returned busy or partial
 		 * completion, this is just a useless check, but it is safe.
 		 */
-		wait_on_page_writeback(page);
+		folio_wait_writeback(folio);
 	} else if (rc == -EBUSY) {
 		/*
-		 * If we have tried a local drain and the page refcount
+		 * If we have tried a local drain and the folio refcount
 		 * still does not match our expected safe value, try with a
 		 * system wide drain. This is needed if the pagevecs holding
 		 * the page are on a different CPU.
@@ -323,7 +324,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 			return -EAGAIN;
 		}
 		/*
-		 * We are here if the page refcount does not match the
+		 * We are here if the folio refcount does not match the
 		 * expected safe value. The main culprits are usually
 		 * pagevecs. With lru_add_drain() we drain the pagevecs
 		 * on the local CPU so that hopefully the refcount will
-- 
2.43.0



