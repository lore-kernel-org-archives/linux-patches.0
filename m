Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502393214;
	Thu, 15 Aug 2024 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732097; cv=none; b=FTuCNkNP+68S3jzOPd9bKkXNzJAyEBiG7SV98kgD037CEOLxTysIelkM8EblA6TpuOyD492X1QS+/ojduPWPVDLqF55116sBLCYuMLbuedB+dPGSUstVFOmsDTfjJ911Nn++12P2NzTlS0CDrbN76y3uAiZ1uH5zrk9GXqRD3yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732097; c=relaxed/simple;
	bh=ebAOZSdUyAVhUxuFMIoJOsO5qHos8pZy8I+PaWnzCpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LX32Mnr7oQ7BAxMqWptHA35pSro2t0G+/8vJAT3fFJGHxtGVcZI/Y6/dttZe/KjjYgU5wKat79MOxetx8aA475Rca+JSM4GxuiVXXCFD/HPL9gZJ+8tfkicSe39WIhQ6f/cll08lb+dCpnPTaX+y0Tu1IfWL1FARSCVgmrYUWVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBJrO9rM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBJrO9rM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97EEC32786;
	Thu, 15 Aug 2024 14:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732097;
	bh=ebAOZSdUyAVhUxuFMIoJOsO5qHos8pZy8I+PaWnzCpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBJrO9rMxlhq7pTVwcgpPDLpsInbybo5wX2APBp3blulu4VEjtUyrTiKf3EP0sHms
	 8RpgaVPlbg+TqrCSKciiJBKFF4X7p0itsTIVl9FaDKrOHvUp6yM/62CNAF+BVV0lIH
	 H4qItn3mI+eLNF9IBtBIU0QXlm+IOxFj1P+DRb3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/352] KVM: s390: fix race in gmap_make_secure()
Date: Thu, 15 Aug 2024 15:22:19 +0200
Message-ID: <20240815131922.064188355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit c148dc8e2fa403be501612ee409db866eeed35c0 ]

Fix a potential race in gmap_make_secure() and remove the last user of
follow_page() without FOLL_GET.

The old code is locking something it doesn't have a reference to, and
as explained by Jason and David in this discussion:
https://lore.kernel.org/linux-mm/Y9J4P%2FRNvY1Ztn0Q@nvidia.com/
it can lead to all kind of bad things, including the page getting
unmapped (MADV_DONTNEED), freed, reallocated as a larger folio and the
unlock_page() would target the wrong bit.
There is also another race with the FOLL_WRITE, which could race
between the follow_page() and the get_locked_pte().

The main point is to remove the last use of follow_page() without
FOLL_GET or FOLL_PIN, removing the races can be considered a nice
bonus.

Link: https://lore.kernel.org/linux-mm/Y9J4P%2FRNvY1Ztn0Q@nvidia.com/
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20230428092753.27913-2-imbrenda@linux.ibm.com>
Stable-dep-of: 3f29f6537f54 ("s390/uv: Don't call folio_wait_writeback() without a folio reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index c38103f3044da..6abf73e832445 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -213,21 +213,10 @@ static int expected_page_refs(struct page *page)
 	return res;
 }
 
-static int make_secure_pte(pte_t *ptep, unsigned long addr,
-			   struct page *exp_page, struct uv_cb_header *uvcb)
+static int make_page_secure(struct page *page, struct uv_cb_header *uvcb)
 {
-	pte_t entry = READ_ONCE(*ptep);
-	struct page *page;
 	int expected, cc = 0;
 
-	if (!pte_present(entry))
-		return -ENXIO;
-	if (pte_val(entry) & _PAGE_INVALID)
-		return -ENXIO;
-
-	page = pte_page(entry);
-	if (page != exp_page)
-		return -ENXIO;
 	if (PageWriteback(page))
 		return -EAGAIN;
 	expected = expected_page_refs(page);
@@ -318,17 +307,18 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 		goto out;
 
 	rc = -ENXIO;
-	page = follow_page(vma, uaddr, FOLL_WRITE);
-	if (IS_ERR_OR_NULL(page))
-		goto out;
-
-	lock_page(page);
 	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
-	if (should_export_before_import(uvcb, gmap->mm))
-		uv_convert_from_secure(page_to_phys(page));
-	rc = make_secure_pte(ptep, uaddr, page, uvcb);
+	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
+		page = pte_page(*ptep);
+		rc = -EAGAIN;
+		if (trylock_page(page)) {
+			if (should_export_before_import(uvcb, gmap->mm))
+				uv_convert_from_secure(page_to_phys(page));
+			rc = make_page_secure(page, uvcb);
+			unlock_page(page);
+		}
+	}
 	pte_unmap_unlock(ptep, ptelock);
-	unlock_page(page);
 out:
 	mmap_read_unlock(gmap->mm);
 
-- 
2.43.0



