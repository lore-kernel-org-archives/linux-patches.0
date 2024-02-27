Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCF513A25D;
	Tue, 27 Feb 2024 13:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040719; cv=none; b=G2SIorKuYr4NjjhgnuHcuO68ww9oCSAkZARY2xArBGYNqKwM2QafzL7naIWQW3FA7uU0LrQkHnrgZJTse6qIp4XyS9xDtK7Nkrw854rYgQFvQEJI9sgnZjDQlfGr2zvmyhYchgHPnS5MNMA8gHG2kUcd6wlUc4d+hEaM8Yzr+SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040719; c=relaxed/simple;
	bh=F3KRkCtKgIlBsu0PAyJFF4Yflu4TQ1wg6/hyIfRcGR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYuUvUz80AG+1eSWk0xoQ1PocyhbLPkVe2MEmvHa/ELcsZlbj3fzjD2+8nRtDHkhBAtZ9BAeGm9RyLlC66S07r9Ey2sAHeW5Qu71njms1aksBLD4hMQ/jVKQ7PBvHZBPkUm2q7K725lOUepzg1T81hw1Q7Sve2SUNOp0IejbWoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKZP35oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKZP35oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4ADC433C7;
	Tue, 27 Feb 2024 13:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040719;
	bh=F3KRkCtKgIlBsu0PAyJFF4Yflu4TQ1wg6/hyIfRcGR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKZP35oeJWHnExg59SCPhgw48/kFfs3rJoQ5OZnYMl3FBUegC23aXbpIAERfNhHo9
	 wwH4ToB3mCxFjUL74VfTHJGTzc7jCXvxEaastQhJG66TrkfJMnWd7FCxARROWRozY/
	 Cc6IxM/yMQEJIEdEFl4MB+f2qE/8/SvMU/qrIyUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 084/334] fs/ntfs3: Correct use bh_read
Date: Tue, 27 Feb 2024 14:19:02 +0100
Message-ID: <20240227131633.240614582@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit a40b73f608e7de2120fdb9ddc8970421b3c50bc9 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c  | 19 +++++++++----------
 fs/ntfs3/inode.c |  7 +++----
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index a5a30a24ce5df..5691f04e6751a 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -188,6 +188,7 @@ static int ntfs_zero_range(struct inode *inode, u64 vbo, u64 vbo_to)
 	u32 bh_next, bh_off, to;
 	sector_t iblock;
 	struct folio *folio;
+	bool dirty = false;
 
 	for (; idx < idx_end; idx += 1, from = 0) {
 		page_off = (loff_t)idx << PAGE_SHIFT;
@@ -223,29 +224,27 @@ static int ntfs_zero_range(struct inode *inode, u64 vbo, u64 vbo_to)
 			/* Ok, it's mapped. Make sure it's up-to-date. */
 			if (folio_test_uptodate(folio))
 				set_buffer_uptodate(bh);
-
-			if (!buffer_uptodate(bh)) {
-				err = bh_read(bh, 0);
-				if (err < 0) {
-					folio_unlock(folio);
-					folio_put(folio);
-					goto out;
-				}
+			else if (bh_read(bh, 0) < 0) {
+				err = -EIO;
+				folio_unlock(folio);
+				folio_put(folio);
+				goto out;
 			}
 
 			mark_buffer_dirty(bh);
-
 		} while (bh_off = bh_next, iblock += 1,
 			 head != (bh = bh->b_this_page));
 
 		folio_zero_segment(folio, from, to);
+		dirty = true;
 
 		folio_unlock(folio);
 		folio_put(folio);
 		cond_resched();
 	}
 out:
-	mark_inode_dirty(inode);
+	if (dirty)
+		mark_inode_dirty(inode);
 	return err;
 }
 
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index fa6c7965473c8..bba0208c4afde 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -345,9 +345,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 			inode->i_size = le16_to_cpu(rp.SymbolicLinkReparseBuffer
 							    .PrintNameLength) /
 					sizeof(u16);
-
 			ni->i_valid = inode->i_size;
-
 			/* Clear directory bit. */
 			if (ni->ni_flags & NI_FLAG_DIR) {
 				indx_clear(&ni->dir);
@@ -653,9 +651,10 @@ static noinline int ntfs_get_block_vbo(struct inode *inode, u64 vbo,
 			off = vbo & (PAGE_SIZE - 1);
 			folio_set_bh(bh, folio, off);
 
-			err = bh_read(bh, 0);
-			if (err < 0)
+			if (bh_read(bh, 0) < 0) {
+				err = -EIO;
 				goto out;
+			}
 			folio_zero_segment(folio, off + voff, off + block_size);
 		}
 	}
-- 
2.43.0



