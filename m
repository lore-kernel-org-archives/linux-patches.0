Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA55A21C177;
	Mon,  2 Jun 2025 14:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874178; cv=none; b=SWJoJropscwgogiYirLPmYbahxgCeAXMKKMxwJZcTm4gJCyyzPw/4OyYZgtbs2rDHy9b/d5kbDKdFnXAr2d6yjogv9njgzrooC2LKMPBAAGvsupOBgf8YIq13MnOZ3Ecu8T5VPwI7D2kIcKvZVYYuX/9IPVPMG1XrK8gLq8Ab3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874178; c=relaxed/simple;
	bh=wNVovduaz+cgykLDvui4Ne0zK6CNI54+QiukPmarwNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gW+mZUXSxDq1+oW75RC85LoT1zMS6CJoM+Mjxvm6EdBWrXNS23En/8i7Y+fOwMpm5Guc2hYMwDYmSd09q8egloCNyuvD2ryN6mnWbR7o83Q2hVv5rjCHibR813altd3hA23A9u2lFy9VRyl/tpM/Vgy1k3nKU841OJOi2gLvY7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFPATlKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFPATlKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6FEC4CEEB;
	Mon,  2 Jun 2025 14:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874178;
	bh=wNVovduaz+cgykLDvui4Ne0zK6CNI54+QiukPmarwNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFPATlKcGeN4LHoU95PPOAg3FlQIg8dALmXPU9c7r10X+dsAfMT9c44xeSp32KJjX
	 pdse2x1zOsLZDjpefC7b26bEbat06bECB5AtFIWPB2H+LI6i8i6eSy0WIA1tiaqZqq
	 dlBMaMAnI5vGrTzS7+UsoGiI1H5wYUQAK30cBSjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 384/444] highmem: add folio_test_partial_kmap()
Date: Mon,  2 Jun 2025 15:47:28 +0200
Message-ID: <20250602134356.497829352@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/highmem.h    |    6 +++---
 include/linux/page-flags.h |    7 +++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -448,7 +448,7 @@ static inline void memcpy_from_folio(cha
 		const char *from = kmap_local_folio(folio, offset);
 		size_t chunk = len;
 
-		if (folio_test_highmem(folio) &&
+		if (folio_test_partial_kmap(folio) &&
 		    chunk > PAGE_SIZE - offset_in_page(offset))
 			chunk = PAGE_SIZE - offset_in_page(offset);
 		memcpy(to, from, chunk);
@@ -469,7 +469,7 @@ static inline void memcpy_to_folio(struc
 		char *to = kmap_local_folio(folio, offset);
 		size_t chunk = len;
 
-		if (folio_test_highmem(folio) &&
+		if (folio_test_partial_kmap(folio) &&
 		    chunk > PAGE_SIZE - offset_in_page(offset))
 			chunk = PAGE_SIZE - offset_in_page(offset);
 		memcpy(to, from, chunk);
@@ -501,7 +501,7 @@ static inline size_t memcpy_from_file_fo
 	size_t offset = offset_in_folio(folio, pos);
 	char *from = kmap_local_folio(folio, offset);
 
-	if (folio_test_highmem(folio)) {
+	if (folio_test_partial_kmap(folio)) {
 		offset = offset_in_page(offset);
 		len = min_t(size_t, len, PAGE_SIZE - offset);
 	} else
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -551,6 +551,13 @@ PAGEFLAG(Readahead, readahead, PF_NO_COM
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
 static __always_inline bool folio_test_swapcache(struct folio *folio)
 {


