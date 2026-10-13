Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB8E4F3EDE;
	Tue, 13 Oct 2026 11:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891977; cv=none; b=IPLcSg5knwXF1JYow/CYpGNrlgGwnAzTFD7PYkA5SU/ISBAzYVn9N5hQe5dG4R6ZYqQGSTyf9Wry9kU/3+qnmnmUSlmHJ9WexwKWMHDkXiBTRDzsoQ9lyDtdSESuztAlaMjnVmUxUWMVwKNE4mCdX035U4zvCMbL0Thq7lTBtN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891977; c=relaxed/simple;
	bh=2HUWsTN+bUoTI4PtfAKqYSNRlpjRyuFsff5uudMO4t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s99DD8AD3xBVKt4Mwc2e113bFGrbM24+t5gRKL4oKh+faHqJMg76NtxwcaTGO7Y/ELPL0X50lP1ZTtLRyEJr845C+8zjoPXp4V9090tbF5nTzkVR1TGPPZTuet1/ZCOVgYd4ptdXJwGfDQvEQDhbYZTPQeALfJ48fm4lD5nTMI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjxmpLnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjxmpLnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2811F000FF;
	Tue, 13 Oct 2026 11:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891976;
	bh=drZkbrF7ucPURab2aC5+yYuIhJpW9+DTXwDd/NPdEvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjxmpLnW3nkDmTy2zbmlpuaxp62/LzH1YbRni3UHQZF87a+pWnB7Ff8q3Rd1ZgmhB
	 y9tQIHxuRq1mUDwxFqCRLcuVbD+TZCnQhGUwnoVUvWTSBUd8tbobk4I6AQ47VHI4wb
	 /+A2NYYWlXLK4oEuaWROrnVH8wIo2jolzaeDquw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Zi Yan <ziy@nvidia.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 002/281] fs: Free any excess xarray nodes in clear_inode()
Date: Tue, 13 Oct 2026 13:35:18 +0200
Message-ID: <20261013112855.109875978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit ee3f011250104129893d8e9599147e457d4d7280 ]

For many years we've had a hard to hit leak of xarray nodes.  Hugh
documented it well in commit 786b31121a2c.  Recently people and
syzbot have found ways to force it to happen with madvise.  Rather
than fix the leaks where they happen, just call xa_destroy() which
has the side-effect of cycling the i_pages lock.

Cc: Rik van Riel <riel@surriel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Link: https://lore.kernel.org/all/20260121062243.1893129-1-tujinjiang@huawei.com/
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20260623192850.1595958-1-willy@infradead.org
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index c6b08e8c5f627..efa801f3eb110 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -763,21 +763,18 @@ void clear_inode(struct inode *inode)
 		fsverity_cleanup_inode(inode);
 
 	/*
-	 * We have to cycle the i_pages lock here because reclaim can be in the
-	 * process of removing the last page (in __filemap_remove_folio())
-	 * and we must not free the mapping under it.
+	 * We have to cycle the i_pages lock here because reclaim
+	 * can be in the process of removing the last page (in
+	 * __filemap_remove_folio()) and we must not free the mapping
+	 * under it.  We also remove nodes which are empty; these
+	 * can occur in two different ways.  The first is that radix
+	 * tree expansion can fail partway and the second is that THP
+	 * collapse_file() can allocate some temporary nodes and not
+	 * clean them up.
 	 */
-	xa_lock_irq(&inode->i_data.i_pages);
+	xa_destroy(&inode->i_data.i_pages);
+
 	BUG_ON(inode->i_data.nrpages);
-	/*
-	 * Almost always, mapping_empty(&inode->i_data) here; but there are
-	 * two known and long-standing ways in which nodes may get left behind
-	 * (when deep radix-tree node allocation failed partway; or when THP
-	 * collapse_file() failed). Until those two known cases are cleaned up,
-	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
-	 * nor even WARN_ON(!mapping_empty).
-	 */
-	xa_unlock_irq(&inode->i_data.i_pages);
 	BUG_ON(!(inode_state_read_once(inode) & I_FREEING));
 	BUG_ON(inode_state_read_once(inode) & I_CLEAR);
 	BUG_ON(!list_empty(&inode->i_wb_list));
-- 
2.53.0



