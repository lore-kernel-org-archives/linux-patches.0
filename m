Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98DF3438BE;
	Sat, 12 Sep 2026 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223166; cv=none; b=ZYPIjrtFbjC7gjYm3Ft7zIMnqRCdad6wnas3zYFy6v4rbX9ptc80kCHr9E84XeUj3LVXi+8mjG+OO0AhPBF1ghmTHeaeKfGdxpDmU1nK26r/1s/GVQtT4znQV4FxJODR47qydWGm+6N548belX+G13qVKJucFGfPYRu7EX1GPlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223166; c=relaxed/simple;
	bh=82tZKz7lkdqckNNDeW2AEGCUuOP3ng7RJT/gnLixMKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJkiaVX110G0LOWsxkT/0A6do4ciGbowVCfrHYaeEoY8aYWG/7XnL+tG25gzuxnpPkROH8X5YDbT5o6ibUEWXveEZRfxDEcXrHUj2dEjpZjXy08bQvm7s7yANOCnqh0O4cnVMEID6LAHGEdpa8OLzMO4aZuiczNdNwiR9nH0Rn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Jcc3az2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Jcc3az2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C96F1F000FF;
	Sat, 12 Sep 2026 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223164;
	bh=4Ph9GsgjffY05WAE+0oq+JGTdnF9nrI/9lNDu4uKTXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Jcc3az2WDWf4FjYoOcg5IxGUVIrOoU+te7ZRh4Q3RO8OoS9xD26YAwufQTWBXQ7d
	 rWb57d390jf2X11VKCgc01jQdO08DNSKeqZQjWkCP9EbMcX45sfaRC0Q/IhhYIqbtz
	 FF+cj1k+uxj5Ayxby3EGU2c+MFYMkRwABRu2a7oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0735/1424] isofs: fix out-of-bounds page array access on empty zisofs block
Date: Sat, 12 Sep 2026 08:52:47 +0200
Message-ID: <20260912065623.757497010@linuxfoundation.org>
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
index c4da3f634b92e..b94b56211b5ce 100644
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



