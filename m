Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8A01494B2;
	Fri,  6 Dec 2024 14:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496819; cv=none; b=UKKyym8FVvVpx61Mt+LTjDv82DCnglJk3UdKuWSilcZ45wHVsAPaBGfImDuI709x0CYyTm9dSzWr2gXvOVxYUjWF03Ik72i7mj9HvJFN++VYSYfPl8SFsnOShEvm1aeoN/HjW07YEKGCNCAOjN2fDsEDqmmsd3fJ4FkLOSV9gD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496819; c=relaxed/simple;
	bh=BZHnfSS8Le/2Tkv1uXOeUehP3DlgfiRlYqxpaFKVH2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8d+7fySVFK92Xpz3oecDZvB+OvocdxDj/1wCzuUh7FhhWs2PvRMfT31wEfXiWUbbbqpdsNQ0YCa3JLbQtDXPySbdfDaVTKvX23rs6C9kM5SVyw8eW/SCGi0E+bbPEjSaHn9uCnGkQOu5+F7cJ2KyjcPh9UjEr7hQz/GV+ojQbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9jLzzr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9jLzzr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38957C4CED1;
	Fri,  6 Dec 2024 14:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496819;
	bh=BZHnfSS8Le/2Tkv1uXOeUehP3DlgfiRlYqxpaFKVH2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9jLzzr9irL2jeS3U45iBwLE0VGzaOZ0pFUHO4lkTGUp+dH/QEaeswtDlKIQzPjMD
	 0wUbQMJy7kM0WJYET9Y0/mXZn1Bx1E+AnLWMkYApVfr0fpnr9jX6551bgBmjgYCZZI
	 WNayrEzQXphQKG0hFb6f+/JEVUXi76z3IhBytxZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/676] ext4: pipeline buffer reads in mext_page_mkuptodate()
Date: Fri,  6 Dec 2024 15:28:11 +0100
Message-ID: <20241206143656.179123423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 368a83cebbb949adbcc20877c35367178497d9cc ]

Instead of synchronously reading one buffer at a time, submit reads
as we walk the buffers in the first loop, then wait for them in the
second loop.  This should be significantly more efficient, particularly
on HDDs, but I have not measured.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20240718223005.568869-2-willy@infradead.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 2f3d93e210b9 ("ext4: fix race in buffer_head read fault injection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/move_extent.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index a3aa85795d4a1..28d59548770d7 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -173,7 +173,9 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
 	sector_t block;
 	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
 	unsigned int blocksize, block_start, block_end;
-	int i, err,  nr = 0, partial = 0;
+	int i, nr = 0;
+	bool partial = false;
+
 	BUG_ON(!folio_test_locked(folio));
 	BUG_ON(folio_test_writeback(folio));
 
@@ -193,13 +195,13 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
 		block_end = block_start + blocksize;
 		if (block_end <= from || block_start >= to) {
 			if (!buffer_uptodate(bh))
-				partial = 1;
+				partial = true;
 			continue;
 		}
 		if (buffer_uptodate(bh))
 			continue;
 		if (!buffer_mapped(bh)) {
-			err = ext4_get_block(inode, block, bh, 0);
+			int err = ext4_get_block(inode, block, bh, 0);
 			if (err)
 				return err;
 			if (!buffer_mapped(bh)) {
@@ -208,6 +210,12 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
 				continue;
 			}
 		}
+		lock_buffer(bh);
+		if (buffer_uptodate(bh)) {
+			unlock_buffer(bh);
+			continue;
+		}
+		ext4_read_bh_nowait(bh, 0, NULL);
 		BUG_ON(nr >= MAX_BUF_PER_PAGE);
 		arr[nr++] = bh;
 	}
@@ -217,11 +225,10 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
 
 	for (i = 0; i < nr; i++) {
 		bh = arr[i];
-		if (!bh_uptodate_or_lock(bh)) {
-			err = ext4_read_bh(bh, 0, NULL);
-			if (err)
-				return err;
-		}
+		wait_on_buffer(bh);
+		if (buffer_uptodate(bh))
+			continue;
+		return -EIO;
 	}
 out:
 	if (!partial)
-- 
2.43.0



