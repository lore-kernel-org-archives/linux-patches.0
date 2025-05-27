Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC3813790B;
	Tue, 27 May 2025 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366120; cv=none; b=UgTeopcX8oSKUZ13/9ePo2bW+m9l/YiynD2fPnLGAA5A4yu7xVAvzDAc9QpKAUL2MZDAOiXE/jkqe9OcpoZShalvidXLHIocMxE46xHTtz89xGD6unSHMAi0qj04Us1tSwOtPhH07YQP/vZGINKkgK7ZITJwvFgncoaCvHveu7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366120; c=relaxed/simple;
	bh=2WCJlNYS/fWyW/RMHce7bsQR+T2L3lFv/454Yb0WIEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grb9mGi98GB99XnHt6aKH/K10dfWjKCGDP0hft5mWzsX5mO1GQSzlrzWWw2s2NVnNv1ewTu0zlwJjwPfO4EkjOboZPlV54LMbGjZ+wibL9BXJDwB967wPmwtadDJ1HO4OeMBvO9E/cCvFBY3daNHLCcdt64L/3LRH4OwrJWjqcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAtK1yud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAtK1yud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B201DC4CEE9;
	Tue, 27 May 2025 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366120;
	bh=2WCJlNYS/fWyW/RMHce7bsQR+T2L3lFv/454Yb0WIEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAtK1yudKPB6Di9VjNnRIgAFo3aJU5Egerz/NprJLgeJOQzYE2WXRXf7lSdNIMLTP
	 6JJq4+SUhAZYWfzFnbln8UO9AGw5LCi2DPwQmpj3kev5USnpZIqpy7PtzBO0lebz4T
	 L6dcOfj90A4iTaF4s2VJfWHFE8E+0N6HEYpBicDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 597/626] highmem: add folio_test_partial_kmap()
Date: Tue, 27 May 2025 18:28:10 +0200
Message-ID: <20250527162509.252121962@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 97dfbbd135cb5e4426f37ca53a8fa87eaaa4e376 upstream.

In commit c749d9b7ebbc ("iov_iter: fix copy_page_from_iter_atomic() if
KMAP_LOCAL_FORCE_MAP"), Hugh correctly noted that if KMAP_LOCAL_FORCE_MAP
is enabled, we must limit ourselves to PAGE_SIZE bytes per call to
kmap_local().  The same problem exists in memcpy_from_folio(),
memcpy_to_folio(), folio_zero_tail(), folio_fill_tail() and
memcpy_from_file_folio(), so add folio_test_partial_kmap() to do this more
succinctly.

Link: https://lkml.kernel.org/r/20250514170607.3000994-2-willy@infradead.org
Fixes: 00cdf76012ab ("mm: add memcpy_from_file_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/highmem.h    |   10 +++++-----
 include/linux/page-flags.h |    7 +++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -461,7 +461,7 @@ static inline void memcpy_from_folio(cha
 		const char *from = kmap_local_folio(folio, offset);
 		size_t chunk = len;
 
-		if (folio_test_highmem(folio) &&
+		if (folio_test_partial_kmap(folio) &&
 		    chunk > PAGE_SIZE - offset_in_page(offset))
 			chunk = PAGE_SIZE - offset_in_page(offset);
 		memcpy(to, from, chunk);
@@ -489,7 +489,7 @@ static inline void memcpy_to_folio(struc
 		char *to = kmap_local_folio(folio, offset);
 		size_t chunk = len;
 
-		if (folio_test_highmem(folio) &&
+		if (folio_test_partial_kmap(folio) &&
 		    chunk > PAGE_SIZE - offset_in_page(offset))
 			chunk = PAGE_SIZE - offset_in_page(offset);
 		memcpy(to, from, chunk);
@@ -522,7 +522,7 @@ static inline __must_check void *folio_z
 {
 	size_t len = folio_size(folio) - offset;
 
-	if (folio_test_highmem(folio)) {
+	if (folio_test_partial_kmap(folio)) {
 		size_t max = PAGE_SIZE - offset_in_page(offset);
 
 		while (len > max) {
@@ -560,7 +560,7 @@ static inline void folio_fill_tail(struc
 
 	VM_BUG_ON(offset + len > folio_size(folio));
 
-	if (folio_test_highmem(folio)) {
+	if (folio_test_partial_kmap(folio)) {
 		size_t max = PAGE_SIZE - offset_in_page(offset);
 
 		while (len > max) {
@@ -597,7 +597,7 @@ static inline size_t memcpy_from_file_fo
 	size_t offset = offset_in_folio(folio, pos);
 	char *from = kmap_local_folio(folio, offset);
 
-	if (folio_test_highmem(folio)) {
+	if (folio_test_partial_kmap(folio)) {
 		offset = offset_in_page(offset);
 		len = min_t(size_t, len, PAGE_SIZE - offset);
 	} else
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -573,6 +573,13 @@ FOLIO_FLAG(readahead, FOLIO_HEAD_PAGE)
 PAGEFLAG_FALSE(HighMem, highmem)
 #endif
 
+/* Does kmap_local_folio() only allow access to one page of the folio? */
+#ifdef CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
+#define folio_test_partial_kmap(f)	true
+#else
+#define folio_test_partial_kmap(f)	folio_test_highmem(f)
+#endif
+
 #ifdef CONFIG_SWAP
 static __always_inline bool folio_test_swapcache(const struct folio *folio)
 {


