Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2A91A6160;
	Tue, 30 Jul 2024 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356900; cv=none; b=VZHL91T1Dcg/8RG212NRgep5t+3E2cA5qM49nauHFgGvjRqyhOABzOwtxRQgfgBA/8jBPqr8/6CKEeFhHBdSXDNZoj+qlNgZ8aHNkSON+W6MIH/KLO5/uX+IHtmhuuCtak4Tb8JYOokCxJrTzrasZOwyK+5XZ3Pm3wfaCRLGLpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356900; c=relaxed/simple;
	bh=p+U57iSCG7DfZ8G+pt/m4vYP3NKnmfMmPcW6qoSRAfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEsYfCz19/lvAlZUpU+VNe9zUk/JbF9ojjVcPKgPe0W9fY4PmI7IhPREl4W0fi3XDPOhKyNmVSC1NKH9uETpMM6FwC99gWUUxSBdetGTz8B1B5+Bi/nzk2ZYgp+ZNBWfzudBVlqfDzgIiVGmTGSDGnDiJWLheSHLH7/5s0w+LMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gH5FR7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gH5FR7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07961C32782;
	Tue, 30 Jul 2024 16:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356900;
	bh=p+U57iSCG7DfZ8G+pt/m4vYP3NKnmfMmPcW6qoSRAfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gH5FR7BMwvjBRe/KPE4C/Ps+tdvaOZtVMmbJgvwHAmBDxawMkYHRZNCbQEDzRBfO
	 qNwmUm6QNyyKAmm1UJcgdjRZXcCpYcjgEWxgJ6jlPcIed9H0b4xRrgbDmZ/+vTHUF8
	 GgZd7RLYXVoXkHzVZncuQ57DcCUMIpEg7qs7K8Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/568] s390/mm: Convert gmap_make_secure to use a folio
Date: Tue, 30 Jul 2024 17:45:02 +0200
Message-ID: <20240730151647.499682280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0634448698b03..2aed5af7c4e52 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -201,13 +201,10 @@ static int expected_folio_refs(struct folio *folio)
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
@@ -280,7 +277,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	bool local_drain = false;
 	spinlock_t *ptelock;
 	unsigned long uaddr;
-	struct page *page;
+	struct folio *folio;
 	pte_t *ptep;
 	int rc;
 
@@ -309,15 +306,19 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	if (!ptep)
 		goto out;
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
@@ -327,10 +328,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
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
@@ -341,7 +342,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
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



