Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C81D17BED0;
	Sat, 17 Oct 2026 16:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253937; cv=none; b=LP6H9lhLh5WgPPxiYVL9PTXsDA8QY3rtCzsc47f9ROcrBZOkr81jlPbu/+VYjYlmIYlcZ0ukGr2pgQtMfJeSGiEhTHtd0Jb5AChNhSlJ/3Wbt/tl39Dag5QFygpnZUogPoecrCHGDJfvkaTsLRv/ygoUCba7LEa73/nXJkimyvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253937; c=relaxed/simple;
	bh=dJ7AyRFjKEKkDoJwgVPd+hDW9n4qBgZjMLE0wcQAv8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoNFIN9skN8pWzbTgtp+LIv4fbuUuME/hlhcn//3FZxAAE/eMB1mrTmMT1pY5H97XjMr1VZZWW+TY5Ul75H6J5zwuCDkrv16zwyWBTT7EMtCbYaB9T1xIqE/O9FTiTN6ruMf2aaeYNhi4mpuRwEFuS2+Z/KrVlvrgmxamzUM568=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQMy76rQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQMy76rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95B01F000C4;
	Sat, 17 Oct 2026 16:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253936;
	bh=STsG7LSr8AzK7l6HsbXGgi0qSQm1DvOFlvaz6NUNnTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQMy76rQCgW5bs/dj7A/QviwZFY5plOyZrEyvIVNUCmOIrrUT58hAyjTCmxGNBymI
	 gMtyoe1z44FQ27cq6SZVLoQbVn0FQDqrVX4oJuAgVcOmqpHhX9Ql4uAdrq4tiuQq3s
	 jhJEHRvOoFteGm1ChsVGvAOouAdvmNwu4gBEbjU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 281/869] ceph: Remove call to PagePrivate2()
Date: Sat, 17 Oct 2026 17:52:02 +0200
Message-ID: <20261017160044.277649220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit fd15ba4cb00a43fb4df42e1f95f94857ad122eea ]

Use the folio that we already have to call folio_test_private_2()
instead.  This is the last call to PagePrivate2(), so replace its
PAGEFLAG() definition with FOLIO_FLAG().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20241002040111.1023018-6-willy@infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: a0d9555bf9ea ("ceph: fix num_ops off-by-one when crypto allocation fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c             | 20 ++++++++++----------
 include/linux/page-flags.h |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e5ea8fb6d9a6f..674aa886a66e3 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1052,7 +1052,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 		if (!nr_folios && !locked_pages)
 			break;
 		for (i = 0; i < nr_folios && locked_pages < max_pages; i++) {
-			page = &fbatch.folios[i]->page;
+			struct folio *folio = fbatch.folios[i];
+
+			page = &folio->page;
 			doutc(cl, "? %p idx %lu\n", page, page->index);
 			if (locked_pages == 0)
 				lock_page(page);  /* first page */
@@ -1079,8 +1081,6 @@ static int ceph_writepages_start(struct address_space *mapping,
 				continue;
 			}
 			if (page_offset(page) >= ceph_wbc.i_size) {
-				struct folio *folio = page_folio(page);
-
 				doutc(cl, "folio at %lu beyond eof %llu\n",
 				      folio->index, ceph_wbc.i_size);
 				if ((ceph_wbc.size_stable ||
@@ -1096,16 +1096,16 @@ static int ceph_writepages_start(struct address_space *mapping,
 				unlock_page(page);
 				break;
 			}
-			if (PageWriteback(page) ||
-			    PagePrivate2(page) /* [DEPRECATED] */) {
+			if (folio_test_writeback(folio) ||
+			    folio_test_private_2(folio) /* [DEPRECATED] */) {
 				if (wbc->sync_mode == WB_SYNC_NONE) {
-					doutc(cl, "%p under writeback\n", page);
-					unlock_page(page);
+					doutc(cl, "%p under writeback\n", folio);
+					folio_unlock(folio);
 					continue;
 				}
-				doutc(cl, "waiting on writeback %p\n", page);
-				wait_on_page_writeback(page);
-				folio_wait_private_2(page_folio(page)); /* [DEPRECATED] */
+				doutc(cl, "waiting on writeback %p\n", folio);
+				folio_wait_writeback(folio);
+				folio_wait_private_2(folio); /* [DEPRECATED] */
 			}
 
 			if (!clear_page_dirty_for_io(page)) {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4e8c6d0511c56..53171d714ac6d 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -543,7 +543,7 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
  * - PG_private and PG_private_2 cause release_folio() and co to be invoked
  */
 PAGEFLAG(Private, private, PF_ANY)
-PAGEFLAG(Private2, private_2, PF_ANY) TESTSCFLAG(Private2, private_2, PF_ANY)
+FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
 FOLIO_FLAG(owner_2, FOLIO_HEAD_PAGE)
-- 
2.53.0



