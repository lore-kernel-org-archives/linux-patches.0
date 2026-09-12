Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EC52F617C;
	Sat, 12 Sep 2026 18:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238690; cv=none; b=NkLbeu5L4UhcDHOAn7PIsIMQRmsqZBcr60728rW3fa+BC4CH8DvbuUd/cUtTK9l4EqqnZ+iUMQyB9BCo0TUW9YjCRQvSc7KAXjgP/PwPuqOu2nLp+56DjY0cljgXgPJ6c2cA737SBbqHdoJNOOyXzAca4Wtp8L2u+8gKS1KN1IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238690; c=relaxed/simple;
	bh=OWvaKnC7zaJrbxqQVEczmqUfdN89Qi/NBmxtYG6KuyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uREbQSswD2PYoXqfv2Yw3aE5Oe681EN5KorIJzm51u+JjziKQVwL1dKy9SDNu/ALGleSxlYK/GWpeZTFM1yxe+aSwnVZDmeSWzCLaDZzKtK2e1Ou2wWE8Onzih5dCgBlYhcjYh5y472toE2XSCLs9ApmqfK66X0OS1imD8hjwn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfAEqtMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfAEqtMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F681F000FF;
	Sat, 12 Sep 2026 18:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238688;
	bh=eQ8oTNZPOMgiQtytTbHgDmTc4/UIMZYvCAeZqO2w/Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfAEqtMNS1mwFtRNXYEQOMA15rJWF18M1PuWueCZwU4m9IA+BWDFqz05oyxbHDbuS
	 1RCMxTvGI3eRfpp1hqliztuPVKSDTSej3yPE0TXxJpRsCrEgrz5Jb1pUpRCcoJRtPp
	 PE97OsAvHYoBHfmMOkhlxqzkmSmv+CVHPSLkNoME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 513/935] fs/isofs: replace kmap() with kmap_local_page()
Date: Sat, 12 Sep 2026 08:59:03 +0200
Message-ID: <20260912065538.588554521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 5bb6ce3aeb02497668a4e8971268b041aa61de8d ]

The use of kmap() is being deprecated in favor of kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap's pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts).
Tasks can be preempted and, when scheduled to run again, the kernel
virtual addresses are restored and still valid.  It is faster than kmap()
in kernels with HIGHMEM enabled.

Since kmap_local_page() can be safely used in compress.c, it should be
called everywhere instead of kmap().

Therefore, replace kmap() with kmap_local_page() in compress.c.  Where it
is needed, use memzero_page() instead of open coding kmap_local_page()
plus memset() to fill the pages with zeros.  Delete the redundant
flush_dcache_page() in the two call sites of memzero_page().

Tested with mkisofs on a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel
with HIGHMEM64GB enabled.

Link: https://lkml.kernel.org/r/20220801122709.8164-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Pali Rohár <pali@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 68d4d3e78150 ("isofs: fix out-of-bounds page array access on empty zisofs block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/compress.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index bc12ac7e23127..f2deec0df49c5 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -67,8 +67,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 		for ( i = 0 ; i < pcount ; i++ ) {
 			if (!pages[i])
 				continue;
-			memset(page_address(pages[i]), 0, PAGE_SIZE);
-			flush_dcache_page(pages[i]);
+			memzero_page(pages[i], 0, PAGE_SIZE);
 			SetPageUptodate(pages[i]);
 		}
 		return ((loff_t)pcount) << PAGE_SHIFT;
@@ -120,7 +119,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 	       zerr != Z_STREAM_END) {
 		if (!stream.avail_out) {
 			if (pages[curpage]) {
-				stream.next_out = page_address(pages[curpage])
+				stream.next_out = kmap_local_page(pages[curpage])
 						+ poffset;
 				stream.avail_out = PAGE_SIZE - poffset;
 				poffset = 0;
@@ -176,6 +175,10 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 				flush_dcache_page(pages[curpage]);
 				SetPageUptodate(pages[curpage]);
 			}
+			if (stream.next_out != (unsigned char *)zisofs_sink_page) {
+				kunmap_local(stream.next_out);
+				stream.next_out = NULL;
+			}
 			curpage++;
 		}
 		if (!stream.avail_in)
@@ -183,6 +186,8 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 	}
 inflate_out:
 	zlib_inflateEnd(&stream);
+	if (stream.next_out && stream.next_out != (unsigned char *)zisofs_sink_page)
+		kunmap_local(stream.next_out);
 
 z_eio:
 	mutex_unlock(&zisofs_zlib_lock);
@@ -283,9 +288,7 @@ static int zisofs_fill_pages(struct inode *inode, int full_page, int pcount,
 	}
 
 	if (poffset && *pages) {
-		memset(page_address(*pages) + poffset, 0,
-		       PAGE_SIZE - poffset);
-		flush_dcache_page(*pages);
+		memzero_page(*pages, poffset, PAGE_SIZE - poffset);
 		SetPageUptodate(*pages);
 	}
 	return 0;
@@ -342,10 +345,8 @@ static int zisofs_readpage(struct file *file, struct page *page)
 	for (i = 0; i < pcount; i++, index++) {
 		if (i != full_page)
 			pages[i] = grab_cache_page_nowait(mapping, index);
-		if (pages[i]) {
+		if (pages[i])
 			ClearPageError(pages[i]);
-			kmap(pages[i]);
-		}
 	}
 
 	err = zisofs_fill_pages(inode, full_page, pcount, pages);
@@ -356,7 +357,6 @@ static int zisofs_readpage(struct file *file, struct page *page)
 			flush_dcache_page(pages[i]);
 			if (i == full_page && err)
 				SetPageError(pages[i]);
-			kunmap(pages[i]);
 			unlock_page(pages[i]);
 			if (i != full_page)
 				put_page(pages[i]);
-- 
2.53.0



