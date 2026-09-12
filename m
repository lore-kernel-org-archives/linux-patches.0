Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89090326927;
	Sat, 12 Sep 2026 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224238; cv=none; b=umNP7H/TzkIaU7b/Ew85NX/l1A95WIrG1WB6r0UnjzCxbkQymPBsXv/Qs46KfzDyW4whA7LlGMquVqdHq7a9VePd8s30Imyz6fa9kpiqEacUNnr2LUXRWIUqPZfrGyCL6hz6zddecM1NB473KTX816Dy/xI7KJzj/v2d+U78Gm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224238; c=relaxed/simple;
	bh=9R5Dvz9faf2FRx8tR2bogkxbObaZZ9T3WxzSrvDrWMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJEDHw7VlwlIzVUvTeHEF+UNlpTNf8Xygf4sXIhhK4YOhC8U5m4BOIZlz2SegNBRnJi4dkVtu+RRMOgCU2Km3PssXzvv9iFKqHSt6IaVRwTZVOF7VkoHibp2FIlejcQ6piFnZ0VT0ZlHb+3XaFPaZ+km55egYMYjX7zoBZk3FXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/Lp473f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/Lp473f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32E11F000FF;
	Sat, 12 Sep 2026 14:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224237;
	bh=dQQT4hMGnYLbd5Kq5lgPuuDBgpStg88V5yO+fDqZHoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/Lp473f/dfXUcANZg+plXNm2xWccEufk/K5B8+X6MkY3+rtZ59EnKlBGduDeflqp
	 ygXOD84ZI4OuTQ2mGijIIut3j7VRwFryl36xjxjrWwLBHgX0buwEAU5FR+xiCz5pPy
	 KxgFtYth4K4JPQ9kJTHVGoBu23rerUp3RF080yR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0910/1424] nilfs2: convert nilfs_btnode_prepare_change_key to use a folio
Date: Sat, 12 Sep 2026 08:55:42 +0200
Message-ID: <20260912065627.705690051@linuxfoundation.org>
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

[ Upstream commit 7c5c654c09c3d08ed04fb19ff0798784027eb33a ]

Saves three calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-19-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 66f4ad3ce158 ("nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btnode.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 3dda7c39089bb..2d6935dcc69ad 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -199,23 +199,23 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 	ctxt->newbh = NULL;
 
 	if (inode->i_blkbits == PAGE_SHIFT) {
-		struct page *opage = obh->b_page;
-		lock_page(opage);
+		struct folio *ofolio = obh->b_folio;
+		folio_lock(ofolio);
 retry:
 		/* BUG_ON(oldkey != obh->b_folio->index); */
-		if (unlikely(oldkey != opage->index))
-			NILFS_PAGE_BUG(opage,
+		if (unlikely(oldkey != ofolio->index))
+			NILFS_PAGE_BUG(&ofolio->page,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
 
 		xa_lock_irq(&btnc->i_pages);
-		err = __xa_insert(&btnc->i_pages, newkey, opage, GFP_NOFS);
+		err = __xa_insert(&btnc->i_pages, newkey, ofolio, GFP_NOFS);
 		xa_unlock_irq(&btnc->i_pages);
 		/*
-		 * Note: page->index will not change to newkey until
+		 * Note: folio->index will not change to newkey until
 		 * nilfs_btnode_commit_change_key() will be called.
-		 * To protect the page in intermediate state, the page lock
+		 * To protect the folio in intermediate state, the folio lock
 		 * is held.
 		 */
 		if (!err)
@@ -227,7 +227,7 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 		if (!err)
 			goto retry;
 		/* fallback to copy mode */
-		unlock_page(opage);
+		folio_unlock(ofolio);
 	}
 
 	nbh = nilfs_btnode_create_block(btnc, newkey);
@@ -239,7 +239,7 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 	return 0;
 
  failed_unlock:
-	unlock_page(obh->b_page);
+	folio_unlock(obh->b_folio);
 	return err;
 }
 
-- 
2.53.0



