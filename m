Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070473019D8;
	Sat, 12 Sep 2026 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224208; cv=none; b=AgSC8dTtBEniZqB0Jxq5nYhnd23KFKGrxAsNqwc1Z2F3SlZuMAkCgZlQQKR6XJu6DADTzxZbHP14vyhv2ItRALzDUfkNNyJwkyereiFOrtYl/rc6kPO7c0ZXlNMsceq4WWHr9Dd8RXfXKAMNCCz6VDOMXke/+aJtGEcVODLQtt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224208; c=relaxed/simple;
	bh=F+JCguq5vp6pBiAnoipjEua/aWXino+pKBj+8UqFmfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4efgUs/cJeDWmex4tA4TOto1qRY/v8s3NB0+eW42J1jg5JOaVj0TwEVc1zbcurzag9ud1+bWxo+y4Zg3do2mObifJLeMdSsqJ/8n0K0HtIHPwb+srJL/jCWUv07VpjxPf9EIEA5bxA4xtU8CBU4n6zln6JVWxsw1b38UHiCHec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANOeCZ1x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANOeCZ1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3451F000FF;
	Sat, 12 Sep 2026 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224206;
	bh=qljK5k8gYNtItO15W1Nm5bMqLCroZRp8mPYe67yIRDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANOeCZ1x9JBakbw7vlEqUcZsDotyQHBBYRtArnPFvg5YWFF/B15scS/4eQlO3e8FP
	 Vaj6v38WZzQwK4Pup28qWhk+em8gMYQnAStcbKQF9/l+QuX6rIZza0Q4d3nC+DEjTD
	 jzpgj+zhtQEZHnugpZFVSdzo+hV92pO3T0dzwYIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0909/1424] nilfs2: convert to nilfs_folio_buffers_clean()
Date: Sat, 12 Sep 2026 08:55:41 +0200
Message-ID: <20260912065627.683107656@linuxfoundation.org>
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

[ Upstream commit 36319c0c1c6c4374949f7351a018aa922fb6ef3d ]

All callers of nilfs_page_buffers_clean() now have a folio, so convert it
to take a folio.  While I'm at it, make it return a bool.

Link: https://lkml.kernel.org/r/20231114084436.2755-6-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 66f4ad3ce158 ("nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/page.c    | 18 +++++++++---------
 fs/nilfs2/page.h    |  2 +-
 fs/nilfs2/segment.c |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 2582e8a508d60..d9a34f5010622 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -82,7 +82,7 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
-	if (nilfs_page_buffers_clean(&folio->page))
+	if (nilfs_folio_buffers_clean(folio))
 		__nilfs_clear_page_dirty(&folio->page);
 
 	bh->b_blocknr = -1;
@@ -132,23 +132,23 @@ void nilfs_copy_buffer(struct buffer_head *dbh, struct buffer_head *sbh)
 }
 
 /**
- * nilfs_page_buffers_clean - check if a page has dirty buffers or not.
- * @page: page to be checked
+ * nilfs_folio_buffers_clean - Check if a folio has dirty buffers or not.
+ * @folio: Folio to be checked.
  *
- * nilfs_page_buffers_clean() returns zero if the page has dirty buffers.
- * Otherwise, it returns non-zero value.
+ * nilfs_folio_buffers_clean() returns false if the folio has dirty buffers.
+ * Otherwise, it returns true.
  */
-int nilfs_page_buffers_clean(struct page *page)
+bool nilfs_folio_buffers_clean(struct folio *folio)
 {
 	struct buffer_head *bh, *head;
 
-	bh = head = page_buffers(page);
+	bh = head = folio_buffers(folio);
 	do {
 		if (buffer_dirty(bh))
-			return 0;
+			return false;
 		bh = bh->b_this_page;
 	} while (bh != head);
-	return 1;
+	return true;
 }
 
 void nilfs_page_bug(struct page *page)
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 21ddcdd4d63e5..69e03ff2e8695 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -36,7 +36,7 @@ struct buffer_head *nilfs_grab_buffer(struct inode *, struct address_space *,
 				      unsigned long, unsigned long);
 void nilfs_forget_buffer(struct buffer_head *);
 void nilfs_copy_buffer(struct buffer_head *, struct buffer_head *);
-int nilfs_page_buffers_clean(struct page *);
+bool nilfs_folio_buffers_clean(struct folio *);
 void nilfs_page_bug(struct page *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 2879f1763deb0..be67304825201 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1764,7 +1764,7 @@ static void nilfs_end_folio_io(struct folio *folio, int err)
 			 * all the buffers get cleaned later.
 			 */
 			folio_lock(folio);
-			if (nilfs_page_buffers_clean(&folio->page))
+			if (nilfs_folio_buffers_clean(folio))
 				__nilfs_clear_page_dirty(&folio->page);
 			folio_unlock(folio);
 		}
@@ -1772,7 +1772,7 @@ static void nilfs_end_folio_io(struct folio *folio, int err)
 	}
 
 	if (!err) {
-		if (!nilfs_page_buffers_clean(&folio->page))
+		if (!nilfs_folio_buffers_clean(folio))
 			filemap_dirty_folio(folio->mapping, folio);
 		folio_clear_error(folio);
 	} else {
-- 
2.53.0



