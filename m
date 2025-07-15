Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8003C2E6D2B;
	Tue, 15 Jul 2025 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587052; cv=none; b=n803OcTaDqaXfYqLjE/bKR1wMBdA2ZNNQuPlKVKoKh7ouLPxPjSMgrHyxT4vKwLz50XMNuYF8B+R7Lhba+EB2dhD1pNGlqiewK/RF0nj9tuekOQx0iDwv6cBRXj3xuCeHK2jjJE84cors78G0CYKu/Glaj4VvBGnGs3imFNkQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587052; c=relaxed/simple;
	bh=9vTUqgJyRQX0It4WTZGkVMKsuyVZk8kHtaHISV5t7Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJqNXFg1TPcNsCKMJt7CkRjVVXGIVTonVq1wa3y2o9JxzFkLE/Ee7vgXP4B+OHAswVjhkX1h0Jk0Y2wAJq8ZGy2HOG4G3nztAj5NeIRZbpbIXyVbahl5gsd/HC7D0FdUZsFtQmP2YX+huF42tIj6L9jQGhX+DRij3k0chGV4ykE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0Js711X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0Js711X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13410C4CEE3;
	Tue, 15 Jul 2025 13:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587052;
	bh=9vTUqgJyRQX0It4WTZGkVMKsuyVZk8kHtaHISV5t7Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0Js711XMmcyzfRotS1JD0uR9yFGUPQgP0hYsyXqG4CynrAv++hiu8hYbyI8z7tXV
	 QdfBYiX0pr2cg1Oiz9hf8Tl4T42MT8ibgLj34IexygKO/u+o8bHvnsG6CdSTEzfSKh
	 ++CUenM7UPYizS34bWd8Y6FzFzLb6dG4B9csSk9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 148/192] erofs: refine readahead tracepoint
Date: Tue, 15 Jul 2025 15:14:03 +0200
Message-ID: <20250715130820.850885955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4cb4497b2767d..da1304a9bb435 100644
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
index 8791ecebcdce7..d21ae4802c7f1 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1855,13 +1855,12 @@ static void z_erofs_readahead(struct readahead_control *rac)
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
index a71b19ed5d0cf..dad7360f42f95 100644
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



