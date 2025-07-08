Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CBB2E2F0D;
	Tue,  8 Jul 2025 16:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992892; cv=none; b=FJ0JlUEU013vrU4wu/a+w9uhajY1vm7nwra5t8cn1P0uQuVaf9ry1bBdREtpdBWhZ3LweNX/aeDbvonrCHsapQLKDAT8qmkDQsY+EV+2s+qjKzmrrwIdGsFjv5oCVBPx7UDBKc6ILiNDYjpg0H/rtLf+sOArVQaL524xbYpocT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992892; c=relaxed/simple;
	bh=R5ju/AEgwdtGii/zJbbdme4ko7C0DRm/j3YwdiO3L1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byxU58KkOliIrkvxmuRMjahAbICuNukDnslLTKwZqgPmG1Yb/bxkwR7BwLZ17sFOG4zu+eaBkb5vWiaDAYVAqqcsFLUz0aYwTwIWjvX5QMNMOzQTIfUf9HjTaooVArk464CL+/ymcC4UH2nUmQ+64bSz9xpume03T8+BGCAGu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juXdVUif; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juXdVUif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A90DC4CEED;
	Tue,  8 Jul 2025 16:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992891;
	bh=R5ju/AEgwdtGii/zJbbdme4ko7C0DRm/j3YwdiO3L1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juXdVUifRKliipzMOiN8TvcZ+sPLAdZ5sEfq10R1GcGvdwWf4Jixi/fQCMdxd0caP
	 N7uz/avrci2lmZB2vke9vuUNbniADmjf25k5lkCeGsiCmu/fkJxU8i0PdESeG2emNU
	 Ux++k/DK+BcDaMkYEpQe/pKVbhZ96Reh+LynxTNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/232] gfs2: Move gfs2_trans_add_databufs
Date: Tue,  8 Jul 2025 18:21:52 +0200
Message-ID: <20250708162244.474654850@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit d50a64e3c55e59e45e415c65531b0d76ad4cea36 ]

Move gfs2_trans_add_databufs() to trans.c.  Pass in a glock instead of
a gfs2_inode.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 5a90f8d49922 ("gfs2: Don't start unnecessary transactions during log flush")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/aops.c  | 23 +----------------------
 fs/gfs2/aops.h  |  2 --
 fs/gfs2/bmap.c  |  3 ++-
 fs/gfs2/trans.c | 21 +++++++++++++++++++++
 fs/gfs2/trans.h |  2 ++
 5 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 68fc8af14700d..ed2c708a215a4 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -37,27 +37,6 @@
 #include "aops.h"
 
 
-void gfs2_trans_add_databufs(struct gfs2_inode *ip, struct folio *folio,
-			     size_t from, size_t len)
-{
-	struct buffer_head *head = folio_buffers(folio);
-	unsigned int bsize = head->b_size;
-	struct buffer_head *bh;
-	size_t to = from + len;
-	size_t start, end;
-
-	for (bh = head, start = 0; bh != head || !start;
-	     bh = bh->b_this_page, start = end) {
-		end = start + bsize;
-		if (end <= from)
-			continue;
-		if (start >= to)
-			break;
-		set_buffer_uptodate(bh);
-		gfs2_trans_add_data(ip->i_gl, bh);
-	}
-}
-
 /**
  * gfs2_get_block_noalloc - Fills in a buffer head with details about a block
  * @inode: The inode
@@ -133,7 +112,7 @@ static int __gfs2_jdata_write_folio(struct folio *folio,
 					inode->i_sb->s_blocksize,
 					BIT(BH_Dirty)|BIT(BH_Uptodate));
 		}
-		gfs2_trans_add_databufs(ip, folio, 0, folio_size(folio));
+		gfs2_trans_add_databufs(ip->i_gl, folio, 0, folio_size(folio));
 	}
 	return gfs2_write_jdata_folio(folio, wbc);
 }
diff --git a/fs/gfs2/aops.h b/fs/gfs2/aops.h
index a10c4334d2489..f9fa41aaeaf41 100644
--- a/fs/gfs2/aops.h
+++ b/fs/gfs2/aops.h
@@ -9,7 +9,5 @@
 #include "incore.h"
 
 void adjust_fs_space(struct inode *inode);
-void gfs2_trans_add_databufs(struct gfs2_inode *ip, struct folio *folio,
-			     size_t from, size_t len);
 
 #endif /* __AOPS_DOT_H__ */
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 1795c4e8dbf66..28ad07b003484 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -988,7 +988,8 @@ static void gfs2_iomap_put_folio(struct inode *inode, loff_t pos,
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 
 	if (!gfs2_is_stuffed(ip))
-		gfs2_trans_add_databufs(ip, folio, offset_in_folio(folio, pos),
+		gfs2_trans_add_databufs(ip->i_gl, folio,
+					offset_in_folio(folio, pos),
 					copied);
 
 	folio_unlock(folio);
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 192213c7359af..42cf8c5204db4 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -226,6 +226,27 @@ void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
 	unlock_buffer(bh);
 }
 
+void gfs2_trans_add_databufs(struct gfs2_glock *gl, struct folio *folio,
+			     size_t from, size_t len)
+{
+	struct buffer_head *head = folio_buffers(folio);
+	unsigned int bsize = head->b_size;
+	struct buffer_head *bh;
+	size_t to = from + len;
+	size_t start, end;
+
+	for (bh = head, start = 0; bh != head || !start;
+	     bh = bh->b_this_page, start = end) {
+		end = start + bsize;
+		if (end <= from)
+			continue;
+		if (start >= to)
+			break;
+		set_buffer_uptodate(bh);
+		gfs2_trans_add_data(gl, bh);
+	}
+}
+
 void gfs2_trans_add_meta(struct gfs2_glock *gl, struct buffer_head *bh)
 {
 
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index f8ce5302280d3..790c55f59e612 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -42,6 +42,8 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 
 void gfs2_trans_end(struct gfs2_sbd *sdp);
 void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh);
+void gfs2_trans_add_databufs(struct gfs2_glock *gl, struct folio *folio,
+			     size_t from, size_t len);
 void gfs2_trans_add_meta(struct gfs2_glock *gl, struct buffer_head *bh);
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
 void gfs2_trans_remove_revoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len);
-- 
2.39.5



