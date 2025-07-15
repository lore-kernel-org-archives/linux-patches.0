Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B362E175C;
	Tue, 15 Jul 2025 13:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585738; cv=none; b=a6tr0mM7aW0JRHmUxEUEX9y17Ggp5kASS+0/EkgC2zXHN7w87ddXTImitJ4oTRVe3Xs2u2K7u94nBaa1IZYzvUsyHoLzQ0vNly4FP/3rs9apIqTMnAP29PvFHVwELeg460dhkkQA6m/0jEBAyQBVsABlfmnmW30rU3tsmZYsJZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585738; c=relaxed/simple;
	bh=mTV7CdBa4w+ZhNCO386NAZ25W3KBxOLLKa0hPeWEYTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Smb20ooDAvzUHsQ+7OXNxbomi1bBbhGEjEf7Mgx7yA9buKn0RQzzYgWR2iPBrxipjtmMzd7OSIGWc6Eyq1hhaIyM3jt0z9Emr8TAF4EO9l1YBV+kjdRDlz5yrAavEvYTvnFb1EWz+REvGI21yLC7vAfLDEc3HSI+gNKCYkNVWME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBnDZDcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBnDZDcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2A8C4CEE3;
	Tue, 15 Jul 2025 13:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585738;
	bh=mTV7CdBa4w+ZhNCO386NAZ25W3KBxOLLKa0hPeWEYTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBnDZDcdYQfw22wbsJW2kCs67Bj1g4Pba1lw2ROzzmKL+LqxhZbseoqrOeNYuaJDb
	 8VjmVRtvGlu+HNLCrhCCLbeFh1kiyfTOo6xm4xuPQ0YFKsnDmwuQEpI9mG16Vj5L0G
	 412d3pegmSxpLOphLJk+ff6/e86UyR8z6x7o8SyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/163] erofs: refine readahead tracepoint
Date: Tue, 15 Jul 2025 15:13:10 +0200
Message-ID: <20250715130813.745505183@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 4eb56b0761e75034dd35067a81da4c280c178262 ]

 - trace_erofs_readpages => trace_erofs_readahead;

 - Rename a redundant statement `nrpages = readahead_count(rac);`;

 - Move the tracepoint to the beginning of z_erofs_readahead().

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://lore.kernel.org/r/20250514120820.2739288-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: d53238b614e0 ("erofs: fix to add missing tracepoint in erofs_readahead()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fileio.c            | 2 +-
 fs/erofs/zdata.c             | 5 ++---
 include/trace/events/erofs.h | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index c8805bc732c6b..c865a7a610306 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -180,7 +180,7 @@ static void erofs_fileio_readahead(struct readahead_control *rac)
 	struct folio *folio;
 	int err;
 
-	trace_erofs_readpages(inode, readahead_index(rac),
+	trace_erofs_readahead(inode, readahead_index(rac),
 			      readahead_count(rac), true);
 	while ((folio = readahead_folio(rac))) {
 		err = erofs_fileio_scan_folio(&io, folio);
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index f13052c3532ab..94c1e2d64df96 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1869,13 +1869,12 @@ static void z_erofs_readahead(struct readahead_control *rac)
 {
 	struct inode *const inode = rac->mapping->host;
 	Z_EROFS_DEFINE_FRONTEND(f, inode, readahead_pos(rac));
-	struct folio *head = NULL, *folio;
 	unsigned int nrpages = readahead_count(rac);
+	struct folio *head = NULL, *folio;
 	int err;
 
+	trace_erofs_readahead(inode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
-	nrpages = readahead_count(rac);
-	trace_erofs_readpages(inode, readahead_index(rac), nrpages, false);
 	while ((folio = readahead_folio(rac))) {
 		folio->private = head;
 		head = folio;
diff --git a/include/trace/events/erofs.h b/include/trace/events/erofs.h
index ad79f1ca4fb5a..198a0c644bea1 100644
--- a/include/trace/events/erofs.h
+++ b/include/trace/events/erofs.h
@@ -113,7 +113,7 @@ TRACE_EVENT(erofs_read_folio,
 		__entry->raw)
 );
 
-TRACE_EVENT(erofs_readpages,
+TRACE_EVENT(erofs_readahead,
 
 	TP_PROTO(struct inode *inode, pgoff_t start, unsigned int nrpage,
 		bool raw),
-- 
2.39.5



