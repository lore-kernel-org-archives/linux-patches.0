Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D8B2E06E4;
	Sat, 12 Sep 2026 12:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215582; cv=none; b=GipP6qxznKu0oQ++mkCuri28mpaTJAjKR9KodNmyTczasu5i7AWvHYW6P9rQ5l5M6kS5Qn0dSYRNDiCujDvAUjLH4NutlOAbHh0SqHxjRQiQJG2x4lSQJKNgNMxO5tMk43DExZfifaIxuors1X6RXhpzJB7tgh2gG5NO255/RvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215582; c=relaxed/simple;
	bh=FFMPSaN7KC9j+Y9zEku5lkTA3epb4G+pGOkFcxV/9vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw5Tqy1rcuibX+0ewIMGsZWk8eybBYEC2W6K3TnPEc8KlP8j72YwIiG1BF5qPfw4O1Zuj4r4PQKF+QjM8OZsPs7k3Rx3fu95HrcFTTFTphqC0okUMyP9WOe0vGnIcd7BOKT46I4RhusWFVXaWka/cGlwlZwtD3Jl9ajXiuGxkHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHhN2HJ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHhN2HJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076271F000FF;
	Sat, 12 Sep 2026 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215581;
	bh=GWB3fROWimss050MgCYHKy5kHT9WBP8DUIMHrcve2pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHhN2HJ0F3iD2Ou/CbaUstjIahb32oQShsvhPaX73dTuJESFMflsmRhwDNo+UmzQT
	 vH6dsKdFAtH1vIiKQpvpM0raCyjtorDMTx6AVTOolqRTK0CstAj+1b7/JkxRok5BNY
	 9htYxrT4xWqOIRtKJbPeSVv0ofFXHzaaKyGgBWFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0518/1376] isofs: fix out-of-bounds page array access on empty zisofs block
Date: Sat, 12 Sep 2026 08:49:04 +0200
Message-ID: <20260912065619.081874809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 34d5baa5d88a0..05b9fa80ba9c2 100644
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



