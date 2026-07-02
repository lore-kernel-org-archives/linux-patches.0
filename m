Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0281C695;
	Thu,  2 Jul 2026 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011324; cv=none; b=UC7G0r3mgXWMO3smFYLNO2CxKj1xLd2071itZXjt2QXOx5y3KC5s0ctx2/abklGTHmvfoUAJe9yM4yuNzHUW9nf+y/hyC+JxF4DCvHWMHqoq26xdErYF3SyUwQXIXJgaiOyBXBCNx6wAfbyTMF1NemmTNloMM/UByi/mh+nKfPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011324; c=relaxed/simple;
	bh=Y5yjC6AikUIMcWl8Bg+TlCuOW6F4CeGsWu5Wojj4+8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeK0EPKSXg/2atROj/MU/D5cxY3FxGiU241WizqddTlGzzik4OWFnw+DC94iuycB1iPiMKNLjqAhDK3DFhEMEEHUz93C6Glog/ZAm4y/+Se90REZdurnpZg+9g79M0eIkbH8f63A24nH3FNVv3N0J3z7Tqx/Kxgqf2SO/tXTKVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6BvzQCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6BvzQCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A5D1F000E9;
	Thu,  2 Jul 2026 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011322;
	bh=wUC51sAcY97P7dtKSvme8JAEMFB4uI1TBVO7+cKrq70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6BvzQCM3msGQTZbpAQAXwqFmM8QF1oc3WuWFm29ef6lPeQhlxbesLAnBnMUhbnSC
	 C4iRDTjRk5vfTtCSFzpQqPJNzLMBGKLd9d3DkHZD1x2FnQ7KrHXjStRRujJEppNvwt
	 dJFz5buDY00J0DL8WulpDKVwIilP5wYEWhJGt4PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 066/108] f2fs: keep atomic write retry from zeroing original data
Date: Thu,  2 Jul 2026 18:21:03 +0200
Message-ID: <20260702155113.479122184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

commit 6d874b65aadce56ac78f76129dbcfc2599b638f8 upstream.

A partial atomic write reserves a block in the COW inode before reading the
original data page for the untouched bytes in that page.

If that read fails, write_begin returns an error but leaves the COW inode
entry as NEW_ADDR. A retry of the same partial write then finds the COW
entry, treats it as existing COW data, and f2fs_write_begin() zeroes the
whole folio because blkaddr is NEW_ADDR.

If the retry is committed, the bytes outside the retried write range are
committed as zeroes instead of preserving the original file contents.

Only use the COW inode as the read source when it already has a real data
block. If the COW entry is still NEW_ADDR, treat it as a reservation to
reuse: keep reading the old data from the original inode and avoid
reserving or accounting the same atomic block again.

Cc: stable@kernel.org
Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3537,6 +3537,7 @@ static int prepare_atomic_write_begin(st
 	pgoff_t index = folio->index;
 	int err = 0;
 	block_t ori_blk_addr = NULL_ADDR;
+	bool cow_has_reserved_block = false;
 
 	/* If pos is beyond the end of file, reserve a new block in COW inode */
 	if ((pos & PAGE_MASK) >= i_size_read(inode))
@@ -3546,9 +3547,11 @@ static int prepare_atomic_write_begin(st
 	err = __find_data_block(cow_inode, index, blk_addr);
 	if (err) {
 		return err;
-	} else if (*blk_addr != NULL_ADDR) {
+	} else if (__is_valid_data_blkaddr(*blk_addr)) {
 		*use_cow = true;
 		return 0;
+	} else if (*blk_addr == NEW_ADDR) {
+		cow_has_reserved_block = true;
 	}
 
 	if (is_inode_flag_set(inode, FI_ATOMIC_REPLACE))
@@ -3561,10 +3564,13 @@ static int prepare_atomic_write_begin(st
 
 reserve_block:
 	/* Finally, we should reserve a new block in COW inode for the update */
-	err = __reserve_data_block(cow_inode, index, blk_addr, node_changed);
-	if (err)
-		return err;
-	inc_atomic_write_cnt(inode);
+	if (!cow_has_reserved_block) {
+		err = __reserve_data_block(cow_inode, index, blk_addr,
+					   node_changed);
+		if (err)
+			return err;
+		inc_atomic_write_cnt(inode);
+	}
 
 	if (ori_blk_addr != NULL_ADDR)
 		*blk_addr = ori_blk_addr;


