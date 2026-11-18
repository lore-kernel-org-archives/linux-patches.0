Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038417;
	b=CX8tmFMElypDn5YwjN7exoDF6ZnslUOYorZbxm+PvyOJsjLA+xtR1bpT8GyLFJBCHwbb
	 FtryQyWqxwj3HUYra8pt67+c9mPjZ7lkst9kDfmqTYka0JP4MfnTl4dBtgF4BlQOp2Z3D
	 LTpMGh+OhMDxIInI9Z6WbKn6EWVu0N9/lslUQhDEjIRGveMoTzBBQ1ALbix/IpNDY6eNA
	 U9YRuS/6QA3MHOFT10uNS8ZwMDM+AMt0dUQiRChmdX9qCm7pVrSIvuKqaxdQKK+/rgOBk
	 3ksmTrfdQzBxmzVDSjS2s9HhRprAWLVsaj+OJvBA0ac7SahiDVsOr4Lk5vrrWaeGflQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DzQImuQfu7K7QP/z7cNBE0X4fPPM81c4SvSFXPRYRmc=;
	b=KxWXfK5/oULmwN8IGaDzdMLo+/kzS/gT4usevFDItMdcINBWnGUG9eaoG+6ALP1lR1sX
	 guLa3+DyL+jyL4/ryMTdBtoXWtgkep6HoWSzM96C+GYJeZYWo6FrL5z8BTykfWCDAZxqb
	 PecCAgk9TlnqawWjelmsVImeUSoCqf+VKzSYdtl1yJp2sgxBF1W8Q3pXpH5+suZ2T7FDh
	 xUAAWxgWcL53xSV6VIZXSrM4q/VQVu5U5xLjPduGGpoq4HtKJSUmUIeU7ExANMlOXfpbM
	 O1tTla0V50T1mpUaw138SNyjbUrlxPU78MOEe0HgFEJWMN38zMkeqVHDvQ6PvkI2oYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xxRJvAnl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406DA606A325;
	Wed, 18 Nov 2026 21:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xxRJvAnl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6861F000C4;
	Wed, 18 Nov 2026 21:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038417;
	bh=DzQImuQfu7K7QP/z7cNBE0X4fPPM81c4SvSFXPRYRmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxRJvAnl47bpVZ7KnFTbGt5gxKGgqxXtC7wsVgsqtQgQ3qRh+6VTCvOe3qlRnc6Cy
	 RIfYqhQFcYV1WC0BS3pKbSv/akkw2VO4hmja2niFvZg9fTaUs48rE3uBpSNCoeHpbb
	 G0gWvLbA9C5eXnhCWJDPAqPxQrlqb5Q9NFPW5K2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Jiaming Zhang <r772577952@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1734/3318] nilfs2: force clear dirty state when restoring from the shadow map
Date: Wed, 18 Nov 2026 15:39:16 +0100
Message-ID: <20261118150413.885192947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit cb6702e63e0a16afd83875294e5ce53becdd1b1f ]

When garbage collection fails, nilfs2 rolls the DAT metadata file's page
cache back to a shadow copy taken before GC started.
nilfs_clear_dirty_pages() drops the dirty state of the folios in the DAT
cache, then nilfs_copy_back_pages() overwrites them with the saved
contents and warns if one is still dirty:

	/* overwrite existing folio in the destination cache */
	WARN_ON(folio_test_dirty(dfolio));

nilfs_clear_dirty_pages() used to clear the dirty state unconditionally,
which is safe here because the rollback runs with the log writer
stopped, so nothing else can dirty the cache while it runs.  The same
helper is also used when writeback finds dirty folios after the
filesystem has degraded to read-only, where it does run concurrently
with the log writer, so commit ca76bb226bf4 ("nilfs2: do not force clear
folio if buffer is referenced") made nilfs_clear_folio_dirty() skip a
folio if any of its buffer heads is busy.  The rollback caller shares
that helper, so its clearing step can now return with a folio still
dirty.

A DAT folio can hold a busy buffer head without anyone modifying the
folio: nilfs_mdt_read_block() submits read-ahead for the blocks
following the one it was asked for and waits only for the first, so the
read-ahead buffers are still locked when it returns.  With a block size
smaller than the page size, a locked read-ahead buffer can share a folio
with a block that GC dirtied and keep the whole folio dirty past the
clearing step.

Add a force flag to nilfs_clear_dirty_pages() and
nilfs_clear_folio_dirty() that skips the busy buffer check, and set it
in the two calls from nilfs_mdt_restore_from_shadow_map().  The
read-only fallback callers keep passing false, so that commit still
protects them and the WARN_ON() is left alone.

Fixes: ca76bb226bf4 ("nilfs2: do not force clear folio if buffer is referenced")
Closes: https://lore.kernel.org/lkml/CANypQFZSYrtcshnUzOPiqatyLd-M8_OReOewQoAi_V5yY0dTtg@mail.gmail.com/
Cc: stable@vger.kernel.org
Suggested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Assisted-by: Claude Code:claude-opus-5
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
[ sashal: adapted nilfs_clear_folio_dirty() to nilfs_clear_dirty_page() while preserving the separate silent argument ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/inode.c |  4 ++--
 fs/nilfs2/mdt.c   |  6 +++---
 fs/nilfs2/page.c  | 51 ++++++++++++++++++++++++++++-------------------
 fs/nilfs2/page.h  |  5 +++--
 4 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 5e17408c80ae6..32063441e898f 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -162,7 +162,7 @@ static int nilfs_writepages(struct address_space *mapping,
 	int err = 0;
 
 	if (sb_rdonly(inode->i_sb)) {
-		nilfs_clear_dirty_pages(mapping, false);
+		nilfs_clear_dirty_pages(mapping, false, false);
 		return -EROFS;
 	}
 
@@ -185,7 +185,7 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 		 * have dirty pages that try to be flushed in background.
 		 * So, here we simply discard this dirty page.
 		 */
-		nilfs_clear_dirty_page(page, false);
+		nilfs_clear_dirty_page(page, false, false);
 		unlock_page(page);
 		return -EROFS;
 	}
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 75a2ed5ee6e09..c0c1e217bd384 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -411,7 +411,7 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 		 * have dirty pages that try to be flushed in background.
 		 * So, here we simply discard this dirty page.
 		 */
-		nilfs_clear_dirty_page(page, false);
+		nilfs_clear_dirty_page(page, false, false);
 		unlock_page(page);
 		return -EROFS;
 	}
@@ -634,10 +634,10 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 	if (mi->mi_palloc_cache)
 		nilfs_palloc_clear_cache(inode);
 
-	nilfs_clear_dirty_pages(inode->i_mapping, true);
+	nilfs_clear_dirty_pages(inode->i_mapping, true, true);
 	nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping);
 
-	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
+	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true, true);
 	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
 			      NILFS_I(shadow->inode)->i_assoc_inode->i_mapping);
 
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 2dbf74936a7ed..c664cf867e9d6 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -370,8 +370,10 @@ void nilfs_copy_back_pages(struct address_space *dmap,
  * nilfs_clear_dirty_pages - discard dirty pages in address space
  * @mapping: address space with dirty pages for discarding
  * @silent: suppress [true] or print [false] warning messages
+ * @force: whether to clear the dirty state regardless of busy buffer heads
  */
-void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
+void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent,
+			     bool force)
 {
 	struct folio_batch fbatch;
 	unsigned int i;
@@ -392,7 +394,7 @@ void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
 			 * was acquired.  Skip processing in that case.
 			 */
 			if (likely(folio->mapping == mapping))
-				nilfs_clear_dirty_page(&folio->page, silent);
+				nilfs_clear_dirty_page(&folio->page, silent, force);
 
 			folio_unlock(folio);
 		}
@@ -405,13 +407,16 @@ void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
  * nilfs_clear_dirty_page - discard dirty page
  * @page: dirty page that will be discarded
  * @silent: suppress [true] or print [false] warning messages
+ * @force: whether to clear the states regardless of busy buffer heads
  *
  * nilfs_clear_dirty_page() clears working states including dirty state for
- * the page and its buffers.  If the page has buffers, clear only if it is
- * confirmed that none of the buffer heads are busy (none have valid
- * references and none are locked).
+ * the page and its buffers.  If the page has buffers and force is false,
+ * clear only if it is confirmed that none of the buffer heads are busy (none
+ * have valid references and none are locked).  If force is true, the states
+ * are cleared unconditionally, the caller should guarantee that the page is
+ * not being modified concurrently.
  */
-void nilfs_clear_dirty_page(struct page *page, bool silent)
+void nilfs_clear_dirty_page(struct page *page, bool silent, bool force)
 {
 	struct inode *inode = page->mapping->host;
 	struct super_block *sb = inode->i_sb;
@@ -429,24 +434,28 @@ void nilfs_clear_dirty_page(struct page *page, bool silent)
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
 			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
 			 BIT(BH_Delay));
-		bool busy, invalidated = false;
+
+		if (!force) {
+			bool busy, invalidated = false;
 
 recheck_buffers:
-		busy = false;
-		bh = head;
-		do {
-			if (atomic_read(&bh->b_count) | buffer_locked(bh)) {
-				busy = true;
-				break;
+			busy = false;
+			bh = head;
+			do {
+				if (atomic_read(&bh->b_count) |
+				    buffer_locked(bh)) {
+					busy = true;
+					break;
+				}
+			} while (bh = bh->b_this_page, bh != head);
+
+			if (busy) {
+				if (invalidated)
+					return;
+				invalidate_bh_lrus();
+				invalidated = true;
+				goto recheck_buffers;
 			}
-		} while (bh = bh->b_this_page, bh != head);
-
-		if (busy) {
-			if (invalidated)
-				return;
-			invalidate_bh_lrus();
-			invalidated = true;
-			goto recheck_buffers;
 		}
 
 		bh = head;
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index bff6257ef83bd..bce9a1b5c8f02 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -41,8 +41,9 @@ void nilfs_folio_bug(struct folio *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
-void nilfs_clear_dirty_page(struct page *, bool);
-void nilfs_clear_dirty_pages(struct address_space *, bool);
+void nilfs_clear_dirty_page(struct page *page, bool silent, bool force);
+void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent,
+			     bool force);
 unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
 					    unsigned int);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
-- 
2.53.0



