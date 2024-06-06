Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1F9196D8C;
	Thu,  6 Jun 2024 14:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682922; cv=none; b=ev70WXp4twNxcRlol9ldDIOqQsSX1ywPrtUYzwG7GocNeR3/utPgD12fBakSxuvy4RHa/G6Ye6PuWEI5SoXkmkqeD7vAvKiBjAG+BajzoTLY3vQFWbiAg3rPv3Aopfa4YZqtg9hA/OKufKsbsbFV8k9yRQmyVoGOl+XUgSJplr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682922; c=relaxed/simple;
	bh=XcPkhZ9oCYH89D/GuhIzJ6hm50cD4/lg9XHJwUbrAY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+buayek8KwI0Hp0YoOdv+InQTXXybCZ9KsicbxEYdPMcTKCYockGCplHt04ftHyJvA8+t/CsWE9D3vcy6GU/L+6/uo8J8mEZikZVls+C90+oXG5H7lOFcRONalMF1PUg+sAMOeDkA2ccqqIahKXFVj9g+JrRmjvANprGj4emBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwgIw+Jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwgIw+Jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24986C2BD10;
	Thu,  6 Jun 2024 14:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682922;
	bh=XcPkhZ9oCYH89D/GuhIzJ6hm50cD4/lg9XHJwUbrAY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwgIw+JlwIqFeFDh+pdvSj/r75pzbCTD7yduSS8YgQX5cf9yHZB2P8r2x/5R07gY1
	 uA/HQlk47U8D2bt7cghvFpgAPfBz0QAVR+6TFTcPrTq9WjFDufv2A41Use7g0czyV2
	 qvIbaAuJcvypqKHku7bmYtPwRlycbMs8zNMFrrFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 062/374] udf: Convert udf_expand_file_adinicb() to use a folio
Date: Thu,  6 Jun 2024 16:00:41 +0200
Message-ID: <20240606131653.931689628@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 2f831a3a91afe..bbf8918417fd8 100644
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



