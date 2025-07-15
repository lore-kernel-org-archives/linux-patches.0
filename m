Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC942D8778;
	Tue, 15 Jul 2025 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587339; cv=none; b=aUSe7Q8NZdMeCTki2nf+Ainwgvn46labuOm5U4JjP7LXnywCLQX9FG1PQ/Xjz+a6xvF/W5ANpYsMYk5s2VvgWajFjKL7sEKz6sjG1QNcXfF3Gt6xGM6uheKhEW9yE6lMtTgyYYWwFt7ons47F0tZPXLFCaEBCQ+QlIGGfA4dvtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587339; c=relaxed/simple;
	bh=JdXWzgDCdUAlavtSPFlv03D3R5Qplkal/ydL4wWE2CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+0+niDx/IVwlMabQdU+ge7lw4zI5Q+0XN7pkmX2b3I0ecB8QWlurP6nRKn1r1uOy+m5lTfgESfRVz70mN27WhXEKJsLcKBRN4rZsAUD/B248NktNTsOOBLmnfI9uiYLABYBDZnr2iiaVmRiM+j4S9sIgEB9H4xe5haLIVgr7Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McYTnyqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McYTnyqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED2FC4CEE3;
	Tue, 15 Jul 2025 13:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587339;
	bh=JdXWzgDCdUAlavtSPFlv03D3R5Qplkal/ydL4wWE2CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McYTnyqkuUrCI2IeGz/dUlTJhvBJfXrOc6/T+PXFe3F3aILGwWIr2XPvu9zzoyt/1
	 BHt8oLLQbPyPWZdtkrcMeXqrBrAYkxiIqh1dusuRSTCLU5CiB1+GGVT7V7ZdFDVUnf
	 8PBQaZtU2ewfUfd8j60UugLyEBuyEhAaxVedhPNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 63/88] erofs: adapt folios for z_erofs_read_folio()
Date: Tue, 15 Jul 2025 15:14:39 +0200
Message-ID: <20250715130757.097373231@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit c33ad3b2b7100ac944aad38d3ebc89cb5f654e94 ]

It's a straight-forward conversion and no logic changes (except that
it renames the corresponding tracepoint.)

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230817083942.103303-1-hsiangkao@linux.alibaba.com
Stable-dep-of: 99f7619a77a0 ("erofs: fix to add missing tracepoint in erofs_read_folio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c             |  9 ++++-----
 include/trace/events/erofs.h | 16 ++++++++--------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index ac8c082798512..32ca6d3e373ab 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1680,17 +1680,16 @@ static void z_erofs_pcluster_readmore(struct z_erofs_decompress_frontend *f,
 
 static int z_erofs_read_folio(struct file *file, struct folio *folio)
 {
-	struct page *page = &folio->page;
-	struct inode *const inode = page->mapping->host;
+	struct inode *const inode = folio->mapping->host;
 	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
 	struct z_erofs_decompress_frontend f = DECOMPRESS_FRONTEND_INIT(inode);
 	int err;
 
-	trace_erofs_readpage(page, false);
-	f.headoffset = (erofs_off_t)page->index << PAGE_SHIFT;
+	trace_erofs_read_folio(folio, false);
+	f.headoffset = (erofs_off_t)folio->index << PAGE_SHIFT;
 
 	z_erofs_pcluster_readmore(&f, NULL, true);
-	err = z_erofs_do_read_page(&f, page);
+	err = z_erofs_do_read_page(&f, &folio->page);
 	z_erofs_pcluster_readmore(&f, NULL, false);
 	(void)z_erofs_collector_end(&f);
 
diff --git a/include/trace/events/erofs.h b/include/trace/events/erofs.h
index a5e7f79ba557f..54a876f52e9b4 100644
--- a/include/trace/events/erofs.h
+++ b/include/trace/events/erofs.h
@@ -75,11 +75,11 @@ TRACE_EVENT(erofs_fill_inode,
 		  __entry->blkaddr, __entry->ofs)
 );
 
-TRACE_EVENT(erofs_readpage,
+TRACE_EVENT(erofs_read_folio,
 
-	TP_PROTO(struct page *page, bool raw),
+	TP_PROTO(struct folio *folio, bool raw),
 
-	TP_ARGS(page, raw),
+	TP_ARGS(folio, raw),
 
 	TP_STRUCT__entry(
 		__field(dev_t,		dev	)
@@ -91,11 +91,11 @@ TRACE_EVENT(erofs_readpage,
 	),
 
 	TP_fast_assign(
-		__entry->dev	= page->mapping->host->i_sb->s_dev;
-		__entry->nid	= EROFS_I(page->mapping->host)->nid;
-		__entry->dir	= S_ISDIR(page->mapping->host->i_mode);
-		__entry->index	= page->index;
-		__entry->uptodate = PageUptodate(page);
+		__entry->dev	= folio->mapping->host->i_sb->s_dev;
+		__entry->nid	= EROFS_I(folio->mapping->host)->nid;
+		__entry->dir	= S_ISDIR(folio->mapping->host->i_mode);
+		__entry->index	= folio->index;
+		__entry->uptodate = folio_test_uptodate(folio);
 		__entry->raw = raw;
 	),
 
-- 
2.39.5



