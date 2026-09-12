Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CE92F617C;
	Sat, 12 Sep 2026 18:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238695; cv=none; b=OXxidl8DhHTt1FIsj6rA4XR7iX8OIFpJNbTrU3sUEtvjwUIi9FQdQXH900FYehP3o0Zzmi3iucRpzhplPJIkDJALfw+0Ib1DtFI6l1KsoUvemlm8+uPKM8F9MGFoYP7C+uZibO+RlyJnUdzYDDXoJYxY8ZogYB+9GPTrgfokGjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238695; c=relaxed/simple;
	bh=fu5H6qLRq0K8edLeeIGd3PYBSFCnzNxc85CRYft5mpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THLB+DsjWwrBAJT3WMF/nmzoC3eFfi5qkrw7Ph9l+9PY56uqjKKoHWQ9Hzz2vXWJDT/FTwGEnqi+AoQYgknKgsZ1LhMcX/Nw0fM7OoFq7rbyqX/mIpnVQSm78TIuS4+GWhcOgsbuM7eaprKZ/eFXT1Bm51WUmcQIowvyXvdTG2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hotDng4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hotDng4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69851F000FF;
	Sat, 12 Sep 2026 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238694;
	bh=+O2In1mIO0FOPsTxbs40VjUFoqQB7/y9Y2f9D3738P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hotDng4muBM+AeKQfRoQljzrvV2oAeTK3d9uMQJsn38mOCRlz5oxEV63jDIwbxnHi
	 1U5p85F6m+XtAMFG0n3FyEeZWnTJn415sJ2sS+bvnV3yGQy6VZOiniPr3381mclXtw
	 gFcr0rsuxL1A2BbREsfLiSAWVZ7KECTmT2t+jUpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 514/935] isofs: fix out-of-bounds page array access on empty zisofs block
Date: Sat, 12 Sep 2026 08:59:04 +0200
Message-ID: <20260912065538.611272350@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 68d4d3e78150c7ed7d1195af63ad1e6ace30c661 ]

zisofs_uncompress_block()'s empty-block fast path returns
pcount << PAGE_SHIFT, ignoring the incoming poffset, unlike the
decompression path which returns bytes produced relative to poffset.
zisofs_fill_pages() uses that return to advance its page cursor, so when
the zisofs block size is below PAGE_SIZE and a sub-page block leaves
poffset partway into a page, a following empty block over-counts and
advances pages[] one element past its end, after which
"if (poffset && *pages)" reads pages[1] out of bounds.  rock.c only
rejects a block-size shift > 17, so a crafted "ZF" Rock Ridge record can
set it below PAGE_SHIFT; the bug is reached by an ordinary read() of a
compressed file on such a mounted ISO9660 image.

Return the byte count relative to poffset and zero only
[poffset, PAGE_SIZE) of the first page, matching the decompression path.
The page-aligned case (poffset == 0) is unaffected.

  BUG: KASAN: slab-out-of-bounds in zisofs_read_folio (fs/isofs/compress.c:290)
  Read of size 8 at addr ffff88800f5eac48 by task exploit/142
   zisofs_read_folio (fs/isofs/compress.c:290)
   read_pages (mm/readahead.c:184)
   ...
   filemap_read (mm/filemap.c:2814)
   vfs_read (fs/read_write.c:574)
   __x64_sys_pread64 (fs/read_write.c:769)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  The buggy address is located 0 bytes to the right of the
  allocated 8-byte region in the kmalloc-8 cache

Fixes: 59bc055211b8 ("zisofs: Implement reading of compressed files when PAGE_CACHE_SIZE > compress block size")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260712234150.3213467-1-xmei5@asu.edu
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/compress.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index f2deec0df49c5..b81415e73aaf4 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -65,12 +65,14 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 	/* Empty block? */
 	if (block_size == 0) {
 		for ( i = 0 ; i < pcount ; i++ ) {
+			unsigned int off = i ? 0 : poffset;
+
 			if (!pages[i])
 				continue;
-			memzero_page(pages[i], 0, PAGE_SIZE);
+			memzero_page(pages[i], off, PAGE_SIZE - off);
 			SetPageUptodate(pages[i]);
 		}
-		return ((loff_t)pcount) << PAGE_SHIFT;
+		return (((loff_t)pcount) << PAGE_SHIFT) - poffset;
 	}
 
 	/* Because zlib is not thread-safe, do all the I/O at the top. */
-- 
2.53.0



