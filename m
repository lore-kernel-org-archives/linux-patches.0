Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEF235A925;
	Sat, 12 Sep 2026 14:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224104; cv=none; b=lYpJMPqIeh+Jxs/saL8UpD7tPgBiJoMJYezIx1MG8JESvHtFbixO7XhfZ53704C+hiYLiVi/AZPYyuOjFAl/wzQ0whU5+XGY738aiHTQbdoDUy6gg0gmBjAd23RxmXqS52lsbNIR6F2NrjSocZlso+yPVWwMYPjhQojQxMxRVIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224104; c=relaxed/simple;
	bh=qTiLjgNIjLwSrViPGzSnctV4KHExaJnA1i+6j1tRNNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P69toMAmHON5lxBZIYAqtTxXO9cny+OmfRqQmKv4o+z9dsNdmSLBorGvOnjyQ2aYKFlhVIyVaqwbyWXInDrtRzkgVVAzs6Hr16NQSCwpAnfHKIYKgUjmriej/wGjnT+sQCFiF+R17vSqFJAQHl5FHb0L7S8IiBxjRcXyhTnErjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqYZfOtY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqYZfOtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0EE1F00893;
	Sat, 12 Sep 2026 14:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224098;
	bh=P3T8tfSgu3NTzYt48K0dgvCvXvAvSB4BG6Kt5K75tUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqYZfOtYAuNQSXaoYJ7b819art7rFozMRTARMsc7cD3rvbiBUEvD0wCuKuWkpQv3L
	 jFYQtSOLA2TWzakjv27BPvmewEjeOFZPvo3m8oCCr8rEzE1jzTlHPeiB0jRibDbOVT
	 GsVTVKWPB5/QKtIogjfSLEsPM3TypeAQmTvHkj8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0907/1424] nilfs2: add nilfs_end_folio_io()
Date: Sat, 12 Sep 2026 08:55:39 +0200
Message-ID: <20260912065627.638323865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 8f46eaf6fd8454b0621b4ce07df50b2aa471c880 ]

Patch series "nilfs2: Folio conversions for file paths".

This series advances page->folio conversions for a wide range of nilfs2,
including its file operations, block routines, and the log writer's
writeback routines.  It doesn't cover large folios support, but it saves a
lot of hidden compound_head() calls while preserving the existing support
range behavior.

The original series in post [1] also covered directory-related page->folio
conversions, but that was put on hold because a regression was found in
testing, so this is an excerpt from the first half of the original post.

[1] https://lkml.kernel.org/r/20231106173903.1734114-1-willy@infradead.org

I tested this series in both 32-bit and 64-bit environments, switching
between normal and small block sizes.  I also reviewed all changes in all
patches to ensure they do not break existing behavior.  There were no
problems.

This patch (of 20):

This is the folio counterpart of the existing nilfs_end_page_io() which is
retained as a wrapper of nilfs_end_folio_io().  Replaces nine hidden calls
to compound_head() with one.

Link: https://lkml.kernel.org/r/20231114084436.2755-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20231114084436.2755-2-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 66f4ad3ce158 ("nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 94458afcd5294..2879f1763deb0 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1744,17 +1744,18 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
 	return ret;
 }
 
-static void nilfs_end_page_io(struct page *page, int err)
+static void nilfs_end_folio_io(struct folio *folio, int err)
 {
-	if (!page)
+	if (!folio)
 		return;
 
-	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page)) {
+	if (buffer_nilfs_node(folio_buffers(folio)) &&
+			!folio_test_writeback(folio)) {
 		/*
 		 * For b-tree node pages, this function may be called twice
 		 * or more because they might be split in a segment.
 		 */
-		if (PageDirty(page)) {
+		if (folio_test_dirty(folio)) {
 			/*
 			 * For pages holding split b-tree node buffers, dirty
 			 * flag on the buffers may be cleared discretely.
@@ -1762,24 +1763,31 @@ static void nilfs_end_page_io(struct page *page, int err)
 			 * remaining buffers, and it must be cancelled if
 			 * all the buffers get cleaned later.
 			 */
-			lock_page(page);
-			if (nilfs_page_buffers_clean(page))
-				__nilfs_clear_page_dirty(page);
-			unlock_page(page);
+			folio_lock(folio);
+			if (nilfs_page_buffers_clean(&folio->page))
+				__nilfs_clear_page_dirty(&folio->page);
+			folio_unlock(folio);
 		}
 		return;
 	}
 
 	if (!err) {
-		if (!nilfs_page_buffers_clean(page))
-			__set_page_dirty_nobuffers(page);
-		ClearPageError(page);
+		if (!nilfs_page_buffers_clean(&folio->page))
+			filemap_dirty_folio(folio->mapping, folio);
+		folio_clear_error(folio);
 	} else {
-		__set_page_dirty_nobuffers(page);
-		SetPageError(page);
+		filemap_dirty_folio(folio->mapping, folio);
+		folio_set_error(folio);
 	}
 
-	end_page_writeback(page);
+	folio_end_writeback(folio);
+}
+
+static void nilfs_end_page_io(struct page *page, int err)
+{
+	if (!page)
+		return;
+	nilfs_end_folio_io(page_folio(page), err);
 }
 
 static void nilfs_abort_logs(struct list_head *logs, int err)
-- 
2.53.0



