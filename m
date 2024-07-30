Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A3B1A616E;
	Tue, 30 Jul 2024 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355900; cv=none; b=ncpXyNUOg8T0QWFVOp+FepCyNb7oH/Ekmj2hZX7zXnFmmZ9oNQ6pogxF6XA8HCL7IfXa/VYUFba64AwYowdIm6mJhiA3EBJ6tM0no90ENopoAkJmso+fYrRXWkWKxR+GaB0FIQPu+YRobJXkvIExtagOQH2RjaZt7uT7XWE6A/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355900; c=relaxed/simple;
	bh=8Wp7H5IOZFWyTypc+2I2kqtYFU1tTQ25J71u0ORoFw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rO9CGRuWr5QP4TxEDaMGQ6jt95yWvi5Jz1kRues5hftDHhfl0k9xsHvnvLr9sXEw+K+SBeYbOigYGnVEDmoJwrBnJ4v1bQrPUigokjllS/PemT7Q70mNHQhPPsOQvsngwWzOVwYaGzf4DMpYrCe8EUflX+0y4uWbItT04y6vR5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9W2PYz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9W2PYz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E5AC32782;
	Tue, 30 Jul 2024 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355900;
	bh=8Wp7H5IOZFWyTypc+2I2kqtYFU1tTQ25J71u0ORoFw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9W2PYz6nTQczV67fXZ+dunnKLh4iHX0MySOU/Wyv0rq+oeHovQY4EEA46ZDQDWcX
	 WODVV8vBk32dtpijdeYB+8DOIB8fn5L2AUR6BsxPz738gM1Pl5CcMzrtqLuDB7V1PZ
	 VtAa/WfyCPcWJqsgQ9ujSlEwFRNZlkrkXt8siz68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/440] s390/mm: Convert gmap_make_secure to use a folio
Date: Tue, 30 Jul 2024 17:46:15 +0200
Message-ID: <20240730151621.428047001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 97567fb8936c7..6f661add0a5d6 100644
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



