Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F8C1BD4ED;
	Thu,  6 Jun 2024 14:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683521; cv=none; b=rFbSHncQf5Dtz0S0GAMvBQ3GJ2c6rwFp+fm7WtRsIjs4bQXq/C9Cz0d6tAC1uzvHxhDFzrvROdBU7UBB6NDXVjfpxHp1pqFVdlNueCIE5Nffc7tmGHk25oJCQ/sz9i38xUpXz8McrxMj8gIX5IMO41rvfraTBfmlLF4QqLMgPjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683521; c=relaxed/simple;
	bh=48GOCwA3acNuK6MfLJ6IXO9wgE7HKZr7fnKB9gUPY4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cArzxjS8RTJK301OVvEYH3dbpD4TknlUPm8+FCW3lRE20DuejYsrR3nVKJLF73EHB/fAFaJpr3JuvxusGf3zvsUcOBi5mmp2HeSUNVQpZVRtcovY2jQlYJjgWo32fmX6lvds59rDN5YUiCI8OZLmDjWIUDCmGpiE2mjLdsG0FiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nA6wGjeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nA6wGjeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167D7C4AF09;
	Thu,  6 Jun 2024 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683521;
	bh=48GOCwA3acNuK6MfLJ6IXO9wgE7HKZr7fnKB9gUPY4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nA6wGjegOsibLVXENDv0NWpx1dlRAgcXJLGzbfRXPXqpRILyODqk0q/vIIEjNJs7x
	 0hU2I+4BRLVfod50zur7L9dP0Th8aAhOsjenz3SAbkqDofNrQDiByAqQYoDQ7DJ4i/
	 0ls43z54QD0RyM/PdDI0J2ZDgTKmNHhK++5LLa/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 462/744] udf: Convert udf_expand_file_adinicb() to use a folio
Date: Thu,  6 Jun 2024 16:02:14 +0200
Message-ID: <20240606131747.294526243@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit db6754090a4f99c67e05ae6b87343ba6e013531f ]

Use the folio APIs throughout this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 1eeceaec794e ("udf: Convert udf_expand_file_adinicb() to avoid kmap_atomic()")
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20240417150416.752929-4-willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7f7610dddcba1..1ff8c1f17f9e6 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -341,7 +341,7 @@ const struct address_space_operations udf_aops = {
  */
 int udf_expand_file_adinicb(struct inode *inode)
 {
-	struct page *page;
+	struct folio *folio;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int err;
 
@@ -357,12 +357,13 @@ int udf_expand_file_adinicb(struct inode *inode)
 		return 0;
 	}
 
-	page = find_or_create_page(inode->i_mapping, 0, GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
+	folio = __filemap_get_folio(inode->i_mapping, 0,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
 
-	if (!PageUptodate(page))
-		udf_adinicb_readpage(page);
+	if (!folio_test_uptodate(folio))
+		udf_adinicb_readpage(&folio->page);
 	down_write(&iinfo->i_data_sem);
 	memset(iinfo->i_data + iinfo->i_lenEAttr, 0x00,
 	       iinfo->i_lenAlloc);
@@ -371,22 +372,22 @@ int udf_expand_file_adinicb(struct inode *inode)
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
 	else
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
-	set_page_dirty(page);
-	unlock_page(page);
+	folio_mark_dirty(folio);
+	folio_unlock(folio);
 	up_write(&iinfo->i_data_sem);
 	err = filemap_fdatawrite(inode->i_mapping);
 	if (err) {
 		/* Restore everything back so that we don't lose data... */
-		lock_page(page);
+		folio_lock(folio);
 		down_write(&iinfo->i_data_sem);
-		memcpy_to_page(page, 0, iinfo->i_data + iinfo->i_lenEAttr,
-			       inode->i_size);
-		unlock_page(page);
+		memcpy_from_folio(iinfo->i_data + iinfo->i_lenEAttr,
+				folio, 0, inode->i_size);
+		folio_unlock(folio);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		iinfo->i_lenAlloc = inode->i_size;
 		up_write(&iinfo->i_data_sem);
 	}
-	put_page(page);
+	folio_put(folio);
 	mark_inode_dirty(inode);
 
 	return err;
-- 
2.43.0



