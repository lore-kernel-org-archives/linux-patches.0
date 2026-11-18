Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046941;
	b=evL7vBZ8flqFns0qrbKGw+Ibe9H1xv8cZsoKvDK+xxxgAw2fzKFmALUziYbvu/WgVzWM
	 NQZoGbQYWId4eyF7J/OSbHH/2Qt/okc0ocBoxGD/luJ2ya8v54F0A+GSmnnEcO/SDAETo
	 SzSkHWoGSHUb55oVfRA6xBeyWoPM+H0uj/hjYytDQMJtx3Tjhiijo37jQ0+psZt3n5eAe
	 it2bxNHJhR0Y39KhVW1dQ47fwjK/JOgUiw1tpj5H/NaK3ka3qfWARQscGfdUrRQXMlm8Z
	 D4TZBIwsptDbHw+2MRIlF9cW9YmDtLysADdKnZbIWTVq+X7d8UyPvM8ouBtzQHIsdkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8iXdIhzfmaD9NjnsRD5QwWJ8Rp3VT1HJnWMCeDQn/h8=;
	b=24XlL4zrUwawYRiwotIFVVPZPwhenQGwhV4GFgiExj9vpKfq1GFPEzgQa3THygckWInn
	 s4zBs3iBFe15pB/5ftzDVFJwUlthazC5JI8rKBtWY0/GqCV1bGCA4IMe8yUj3frB7ThIZ
	 yi/cpm7BwiN5yX3KrrcpruKt5N/NoicEm4sxxfnwo3jRiPSRRBK/FS2gmqvXUCtn73hjz
	 UD27+R58Mrdr1EXkz41HLSIBg+7G19lZaXT8dR0RBQyw74M+vj0R9piO5iOVLMYjPejqN
	 1fXwl2cfL6Tklep4lVx+LHBjjwTiCtyIujhkLOnGQCcGHf6AcAXU04riVvRimWtbRXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7CB+sUT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2409E606A320;
	Thu, 19 Nov 2026 00:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7CB+sUT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18101F000C4;
	Thu, 19 Nov 2026 00:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046941;
	bh=8iXdIhzfmaD9NjnsRD5QwWJ8Rp3VT1HJnWMCeDQn/h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7CB+sUTghY5NvflRRIIkYJWa4XJT2Yqnot5oNYV80cMkbKj8+LM910tW1Ez4MxG/
	 ojppf7tQC0h27zMHX8vfdLNGG3F2moJRyHIImLLMORn2SWqCnQ4MXyrdCoBG5fdd1o
	 uHCbCTxnsW5fktLoFlX/mVYyP+tb1YA4EhQwAsh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1459/2857] f2fs: remove mappedtodisk flag usage in mmap write path
Date: Wed, 18 Nov 2026 15:41:33 +0100
Message-ID: <20261118150253.848224216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>

[ Upstream commit b3c9843589257631bac18f30655e82d88970688a ]

PG_mappedtodisk was inherited from the nobh/buffer-head era.  However,
f2fs has no buffer heads and the flag is no longer meaningful.  The only
user of the flag is the "no holes" shortcut in f2fs_vm_page_mkwrite(),
which makes mmap write faults skip marking the folio dirty.  Moreover,
it causes the following race condition with filesystem freezing:

 CPU0 (write fault)     CPU1 (freeze_super)
 ----                   ----
 f2fs_vm_page_mkwrite()
 sb_start_pagefault()
 /* shortcut: no dirty */
 sb_end_pagefault()

                        sb_wait_write(SB_FREEZE_PAGEFAULT)
                        /* no waiter, passes */
                        sync_filesystem()
                        /* folio not dirty, skipped */

 finish_fault()
 /* PTE writable */
 fault_dirty_shared_page()
 folio_mark_dirty()
 /* dirty folio on a frozen fs */

It will also skip APP_MAPPED_IO iostat/REQ_TIME updates and post-EOF
folio zeroing.

Remove this shortcut in f2fs_vm_page_mkwrite() and stop setting it in
f2fs_read_single_page().

Reported-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/linux-f2fs-devel/496b913c-eb81-4fa8-be72-c6a06a10aba2@kernel.org/
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Fixes: fbfa2cc58d53 ("f2fs: add file operations")
Cc: stable@vger.kernel.org
Signed-off-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: adapted folio-based mappedtodisk flag removals to the equivalent page-based APIs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 1 -
 fs/f2fs/file.c | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c07077f0b56d4..691f32c720a38 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2158,7 +2158,6 @@ static int f2fs_read_single_page(struct inode *inode, struct page *page,
 got_it:
 	if ((map->m_flags & F2FS_MAP_MAPPED)) {
 		block_nr = map->m_pblk + block_in_file - map->m_lblk;
-		SetPageMappedToDisk(page);
 
 		if (!f2fs_is_valid_blkaddr(F2FS_I_SB(inode), block_nr,
 						DATA_GENERIC_ENHANCE_READ)) {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index bde1c9cfe1df4..8f94cd81944f1 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -134,12 +134,6 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	/* wait for GCed page writeback via META_MAPPING */
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
-	/*
-	 * check to see if the page is mapped already (no holes)
-	 */
-	if (PageMappedToDisk(page))
-		goto out_sem;
-
 	/* page is wholly or partially inside EOF */
 	if (((loff_t)(page->index + 1) << PAGE_SHIFT) >
 						i_size_read(inode)) {
-- 
2.53.0



