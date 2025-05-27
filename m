Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417CE2566;
	Tue, 27 May 2025 17:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368576; cv=none; b=AnWQOTt/Y/WsHSQ9cLhRMHnOl0MlH0S7WRukIb2tSD2TeI5k+l8TVLcR0k+sN99wE/x5SEkWYkqgm18banZD+hAebbQ2XuI7MiDRqWVt/EaSxCc7LeaEeb0E6orp/prl4q9vLm3R3//DlhqCWcvG9hxnwe8uBHVwGdyBsurPtc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368576; c=relaxed/simple;
	bh=mn2kQoYqdyNElWJY7SVf4EIWFn9HvaQVneJ1p6IlMl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p57tajoUii4joX3Ak2cfrWi71PamQh2wT4G7osShW3+XgG91S2E2gyY8l1Qu3hEtvdXiQLACMmJiIbvXEf4KcjQIyhi67dbvTFcAg3HfpzGLThZGC6LK4ZP0fAeiyxGTvAQ9EURfKJkx1htKEvhqQ4CmH9Oi/H5ddw2tl/wZjtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8BdlvnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8BdlvnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B57C4CEE9;
	Tue, 27 May 2025 17:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368576;
	bh=mn2kQoYqdyNElWJY7SVf4EIWFn9HvaQVneJ1p6IlMl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8BdlvnRm1VgOWeScZ6IMl8qCRp/IxYjPjLtc5PX3szJFUTPZyWGl7mV1w/pddi2/
	 rSWtxzDW6sD+6LB42dEpvlbkWG/AxVAYF5K5d7+Nm37Dlnna5IWA81nWkng240jDXT
	 9EGQ6u35rSSL7g0rZcICRLCaOYIOhR2VuAs6/XDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 752/783] highmem: add folio_test_partial_kmap()
Date: Tue, 27 May 2025 18:29:09 +0200
Message-ID: <20250527162543.750153587@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -578,6 +578,13 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
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


