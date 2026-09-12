Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6A3326927;
	Sat, 12 Sep 2026 14:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224243; cv=none; b=aoNJ7khgVwuZ7XMU4DQ8V2d/JGmq3RPYiIKMURxisx2r2B+FCUQUXR6gkDRXE3zCNFSVS1jL1BJv3tKTP4MNt10m3LVpjrUWaVwOq8OdEcgcVjJZdiRvjfKUQtQzBn6UaJ5AjJ8Zq/Evj8RffkuVe0cNqpPT0m7jlbHn5P7i6BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224243; c=relaxed/simple;
	bh=4kWMCYGjQnGwxHcN3WUuhfCqpuoEnkisHyZhLr+fX3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aamp/NV7n4ZHe3GzkV6xH9CVCVap4xs3CTH+GNVEAjGt0vb7QIIrF/yX9TfKobAktLNhyfd8BhkBbSNOj/Ry9gzxukcHzxspr7CDfmi50Bjv5IbqOpCVV14VviXq0WVOfgMzumBDT5VTUgvGCyTWZqE5Uel5wCXMienX0I/nCb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM5Esbw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM5Esbw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FBA1F000FF;
	Sat, 12 Sep 2026 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224242;
	bh=EjoinQBovZPL46dWtXIko1Vo9glSw5TgciQI73+qFKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LM5Esbw3mlkz+/EyjHI/r7sDoL55gUpoHHSw7wvfMmccueIQv0dlecLoMyyWfnpET
	 C3VhOhyrnYpgvofYM9aVQZ/NmxBogwmuXE9molEd2h2IpM5BldhTzyIs/8Q3+jnc0V
	 gmXlG7c6mOjqT0RwBCIWgdE/8t0RcyItZvx4asWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0911/1424] nilfs2: convert nilfs_btnode_commit_change_key to use a folio
Date: Sat, 12 Sep 2026 08:55:43 +0200
Message-ID: <20260912065627.727506067@linuxfoundation.org>
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

[ Upstream commit c2a491f3d88a7d94fed070fe48c859dfc5c9d47c ]

Saves one call to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-20-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 66f4ad3ce158 ("nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btnode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 2d6935dcc69ad..26873a02a7481 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -252,15 +252,15 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 {
 	struct buffer_head *obh = ctxt->bh, *nbh = ctxt->newbh;
 	__u64 oldkey = ctxt->oldkey, newkey = ctxt->newkey;
-	struct page *opage;
+	struct folio *ofolio;
 
 	if (oldkey == newkey)
 		return;
 
 	if (nbh == NULL) {	/* blocksize == pagesize */
-		opage = obh->b_page;
-		if (unlikely(oldkey != opage->index))
-			NILFS_PAGE_BUG(opage,
+		ofolio = obh->b_folio;
+		if (unlikely(oldkey != ofolio->index))
+			NILFS_PAGE_BUG(&ofolio->page,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
@@ -271,8 +271,8 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 		__xa_set_mark(&btnc->i_pages, newkey, PAGECACHE_TAG_DIRTY);
 		xa_unlock_irq(&btnc->i_pages);
 
-		opage->index = obh->b_blocknr = newkey;
-		unlock_page(opage);
+		ofolio->index = obh->b_blocknr = newkey;
+		folio_unlock(ofolio);
 	} else {
 		nilfs_copy_buffer(nbh, obh);
 		mark_buffer_dirty(nbh);
-- 
2.53.0



