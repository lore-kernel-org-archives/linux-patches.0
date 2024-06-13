Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E59384;
	Thu, 13 Jun 2024 12:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282156; cv=none; b=o/3vObBRk0nwAMe29SDxiHHPN4e8pwb5n8DglxZP5okBaJOT29F2Gy3TnA0ffHeuWxg0pxffloincZKeJtH6A1IMbZDuhNdeE2+4vJOyFuOA0GhbXZXuXhPZJYEiiH6mWXHX6oaIEmiYRrSL3Nfep1SAe/6fcj5dGUpGix+mLMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282156; c=relaxed/simple;
	bh=ww3494NSEG6WFhyzu9M13IzAqWqfdYenT/spkTf/7Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MyCNdbYirhoA44dYPDtzT/XyJ05cyC5QRxp91soG4wMJoP6p/RjhEPKgRJ+f6/kuycClxTaBQNFbqc+PmdtUm05f8c1B0I4Xa4gjbriDdkWUqGdw3aocxk5LP75pr6ChCIQjQNf9bHdjaHFdWP8+v55tPj5YUu1iMe+1xKrT6u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkPQjZzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkPQjZzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEF3C2BBFC;
	Thu, 13 Jun 2024 12:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282155;
	bh=ww3494NSEG6WFhyzu9M13IzAqWqfdYenT/spkTf/7Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkPQjZzrwBfMqaJQAR2wqnMiCu545NVYrMfwXjYbfQDgrUiIJGzonnpdegjVQESwf
	 Uj1Ny2jRiv6bKo2RiKT4M9adTsBpCT0WZ0Db55L1iQttB9Ll/sn+eYudqSECmAPmQ0
	 fN3mUmp/TSQb/4EqmwbBtjLLbSC32vEzb7zQXfCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Ira Weiny <ira.weiny@intel.com>,
	"Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/402] f2fs: Delete f2fs_copy_page() and replace with memcpy_page()
Date: Thu, 13 Jun 2024 13:32:17 +0200
Message-ID: <20240613113309.172096477@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio M. De Francesco <fmdefrancesco@gmail.com>

[ Upstream commit 1dd55358efc4f74e49fa9e1e97a03804852a4c20 ]

f2fs_copy_page() is a wrapper around two kmap() + one memcpy() from/to
the mapped pages. It unnecessarily duplicates a kernel API and it makes
use of kmap(), which is being deprecated in favor of kmap_local_page().

Two main problems with kmap(): (1) It comes with an overhead as mapping
space is restricted and protected by a global lock for synchronization and
(2) it also requires global TLB invalidation when the kmap’s pool wraps
and it might block when the mapping space is fully utilized until a slot
becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts).
It is faster than kmap() in kernels with HIGHMEM enabled. Therefore, its
use in __clone_blkaddrs() is safe and should be preferred.

Delete f2fs_copy_page() and use a plain memcpy_page() in the only one
site calling the removed function. memcpy_page() avoids open coding two
kmap_local_page() + one memcpy() between the two kernel virtual addresses.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: d3876e34e7e7 ("f2fs: fix to wait on page writeback in __clone_blkaddrs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 10 ----------
 fs/f2fs/file.c |  2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 647d53df6a3de..e49fca9daf2d3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2587,16 +2587,6 @@ static inline struct page *f2fs_pagecache_get_page(
 	return pagecache_get_page(mapping, index, fgp_flags, gfp_mask);
 }
 
-static inline void f2fs_copy_page(struct page *src, struct page *dst)
-{
-	char *src_kaddr = kmap(src);
-	char *dst_kaddr = kmap(dst);
-
-	memcpy(dst_kaddr, src_kaddr, PAGE_SIZE);
-	kunmap(dst);
-	kunmap(src);
-}
-
 static inline void f2fs_put_page(struct page *page, int unlock)
 {
 	if (!page)
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 378ab6bd1b8d8..9b7ecbb974258 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1276,7 +1276,7 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 				f2fs_put_page(psrc, 1);
 				return PTR_ERR(pdst);
 			}
-			f2fs_copy_page(psrc, pdst);
+			memcpy_page(pdst, 0, psrc, 0, PAGE_SIZE);
 			set_page_dirty(pdst);
 			set_page_private_gcing(pdst);
 			f2fs_put_page(pdst, 1);
-- 
2.43.0



