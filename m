Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A949D3214;
	Thu, 15 Aug 2024 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732100; cv=none; b=MvUja/u17UixJwi3SFRei3ZXdusprlD9N5fQzbOUCqaZFTzh5ur4bL2t+AmjnmgkMDSwVkXUhDdySv5oOzw7fwmCKbUbFkVD5uKiMcvQG46o/NSQJEA72YGDRCTtkq3TX9ZfQ9dyEEl2lCy7PPEh1SsA6eXKQSCwZK1UNmLNY2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732100; c=relaxed/simple;
	bh=ULw1uyoYgtkX9YTEQaIcgN04jNrD8/NCKe5jsWF20yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvPpmYrU+svK1Ka99VHTF9l9GvNvDs/zdSt0utYVqAWUEEyUllpRd3gur+YbK7Y5DhT2mqivSgHvUaFgzknoJjFBrs03n8E9eps2Pnanwn/MzNrrEcDc/JX6/ZrJynaCsef9cZfYcdGkNfI1gWnpXyrSXSmE4k3B5wXs4wiGZYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKROg/Gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKROg/Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D7FC32786;
	Thu, 15 Aug 2024 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732100;
	bh=ULw1uyoYgtkX9YTEQaIcgN04jNrD8/NCKe5jsWF20yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKROg/Gcl3yZh8+fJhBqtMkp7aC4vVbVJqDj7TI7lCEJ/9n3InEk8nAcx7PQ+UG6f
	 BuhY0OroyJnkkhjVXaPTfMQ/aGCbL7480o0kikRQnrQGnaxLEzfDoeav+MDPEgpJQ4
	 JBI58NCfAWndm7dEAm31fggxQLuZURuizT0H1XSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/352] s390/mm: Convert make_page_secure to use a folio
Date: Thu, 15 Aug 2024 15:22:20 +0200
Message-ID: <20240815131922.102962152@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 259e660d91d0e7261ae0ee37bb37266d6006a546 ]

These page APIs are deprecated, so convert the incoming page to a folio
and use the folio APIs instead.  The ultravisor API cannot handle large
folios, so return -EINVAL if one has slipped through.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20240322161149.2327518-2-willy@infradead.org
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: 3f29f6537f54 ("s390/uv: Don't call folio_wait_writeback() without a folio reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 6abf73e832445..c99b7f9de1e1f 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -193,21 +193,21 @@ int uv_convert_owned_from_secure(unsigned long paddr)
 }
 
 /*
- * Calculate the expected ref_count for a page that would otherwise have no
+ * Calculate the expected ref_count for a folio that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
  * the kernel, but with some slight modifications. We know that a secure
- * page can not be a huge page for example.
+ * folio can not be a large folio, for example.
  */
-static int expected_page_refs(struct page *page)
+static int expected_folio_refs(struct folio *folio)
 {
 	int res;
 
-	res = page_mapcount(page);
-	if (PageSwapCache(page)) {
+	res = folio_mapcount(folio);
+	if (folio_test_swapcache(folio)) {
 		res++;
-	} else if (page_mapping(page)) {
+	} else if (folio_mapping(folio)) {
 		res++;
-		if (page_has_private(page))
+		if (folio->private)
 			res++;
 	}
 	return res;
@@ -215,14 +215,17 @@ static int expected_page_refs(struct page *page)
 
 static int make_page_secure(struct page *page, struct uv_cb_header *uvcb)
 {
+	struct folio *folio = page_folio(page);
 	int expected, cc = 0;
 
-	if (PageWriteback(page))
+	if (folio_test_large(folio))
+		return -EINVAL;
+	if (folio_test_writeback(folio))
 		return -EAGAIN;
-	expected = expected_page_refs(page);
-	if (!page_ref_freeze(page, expected))
+	expected = expected_folio_refs(folio);
+	if (!folio_ref_freeze(folio, expected))
 		return -EBUSY;
-	set_bit(PG_arch_1, &page->flags);
+	set_bit(PG_arch_1, &folio->flags);
 	/*
 	 * If the UVC does not succeed or fail immediately, we don't want to
 	 * loop for long, or we might get stall notifications.
@@ -232,9 +235,9 @@ static int make_page_secure(struct page *page, struct uv_cb_header *uvcb)
 	 * -EAGAIN and we let the callers deal with it.
 	 */
 	cc = __uv_call(0, (u64)uvcb);
-	page_ref_unfreeze(page, expected);
+	folio_ref_unfreeze(folio, expected);
 	/*
-	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
+	 * Return -ENXIO if the folio was not mapped, -EINVAL for other errors.
 	 * If busy or partially completed, return -EAGAIN.
 	 */
 	if (cc == UVC_CC_OK)
-- 
2.43.0



