Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D018047D93B;
	Thu, 20 Aug 2026 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244076; cv=none; b=J1XPdlMCa80ehzyvaHxNtMEBzG0ZimlfnZJaSkeghU2Ws/jlC7q8olojhu7ZtJNMGVtRXA2JzxmpqJqH4rsi5XOG5jTStyawPZymJY1y6H+5FX9uDTBNdHcLDqfRSIYAND2crzDyioCa2B/PmLlO/3QlE0FPY0987gEwUS7MN5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244076; c=relaxed/simple;
	bh=BrytGzIEhOqtB46E5sG5EEfP0jeevAle97zAqXSiYgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPeB5COlweA1nzoBdWtXOCIC5RivmfTNBYKI20mb1DKyHZdKFXFRjaY491O12YjsXea4KqLaCwBl5/G9Vq1f4D2w2OsrGFXdcrdmP2Yn84f8NbLpy2++1og+HNQznD+AGjGx1YbGcx4VYb3xcwbCbou5L2OFnZqdokaG//DRrys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LybliOgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LybliOgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382461F000E9;
	Thu, 20 Aug 2026 16:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244074;
	bh=Hn0YarH3YP9A0KyzAv0ssaN3ETBnR2Jc5zhkp7jNZ64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LybliOgBSGLqkK0v/kq6XPWYBXKVFcnmu9AcVNRS4McE8y5SRXO3faIpAU9ijMFKy
	 4wePd8f1/skuMKBWcuLJpYjuw5L8+C2bw8vUuIzP48+6jXtNGixgPim6yzi1QWzh0P
	 ilDLIEXb9d7BQCTg4J1xfJ29NpDOWuaZRBAg0avU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JY <JY.Ho@mediatek.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>
Subject: [PATCH 5.10 042/235] f2fs: fix UAF issue in f2fs_merge_page_bio()
Date: Thu, 20 Aug 2026 16:54:38 +0200
Message-ID: <20260820145217.708153172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit edf7e9040fc52c922db947f9c6c36f07377c52ea upstream.

As JY reported in bugzilla [1],

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
pc : [0xffffffe51d249484] f2fs_is_cp_guaranteed+0x70/0x98
lr : [0xffffffe51d24adbc] f2fs_merge_page_bio+0x520/0x6d4
CPU: 3 UID: 0 PID: 6790 Comm: kworker/u16:3 Tainted: P    B   W  OE      6.12.30-android16-5-maybe-dirty-4k #1 5f7701c9cbf727d1eebe77c89bbbeb3371e895e5
Tainted: [P]=PROPRIETARY_MODULE, [B]=BAD_PAGE, [W]=WARN, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Workqueue: writeback wb_workfn (flush-254:49)
Call trace:
 f2fs_is_cp_guaranteed+0x70/0x98
 f2fs_inplace_write_data+0x174/0x2f4
 f2fs_do_write_data_page+0x214/0x81c
 f2fs_write_single_data_page+0x28c/0x764
 f2fs_write_data_pages+0x78c/0xce4
 do_writepages+0xe8/0x2fc
 __writeback_single_inode+0x4c/0x4b4
 writeback_sb_inodes+0x314/0x540
 __writeback_inodes_wb+0xa4/0xf4
 wb_writeback+0x160/0x448
 wb_workfn+0x2f0/0x5dc
 process_scheduled_works+0x1c8/0x458
 worker_thread+0x334/0x3f0
 kthread+0x118/0x1ac
 ret_from_fork+0x10/0x20

[1] https://bugzilla.kernel.org/show_bug.cgi?id=220575

The panic was caused by UAF issue w/ below race condition:

kworker
- writepages
 - f2fs_write_cache_pages
  - f2fs_write_single_data_page
   - f2fs_do_write_data_page
    - f2fs_inplace_write_data
     - f2fs_merge_page_bio
      - add_inu_page
      : cache page #1 into bio & cache bio in
        io->bio_list
  - f2fs_write_single_data_page
   - f2fs_do_write_data_page
    - f2fs_inplace_write_data
     - f2fs_merge_page_bio
      - add_inu_page
      : cache page #2 into bio which is linked
        in io->bio_list
						write
						- f2fs_write_begin
						: write page #1
						 - f2fs_folio_wait_writeback
						  - f2fs_submit_merged_ipu_write
						   - f2fs_submit_write_bio
						   : submit bio which inclues page #1 and #2

						software IRQ
						- f2fs_write_end_io
						 - fscrypt_free_bounce_page
						 : freed bounced page which belongs to page #2
      - inc_page_count( , WB_DATA_TYPE(data_folio), false)
      : data_folio points to fio->encrypted_page
        the bounced page can be freed before
        accessing it in f2fs_is_cp_guarantee()

It can reproduce w/ below testcase:
Run below script in shell #1:
for ((i=1;i>0;i++)) do xfs_io -f /mnt/f2fs/enc/file \
-c "pwrite 0 32k" -c "fdatasync"

Run below script in shell #2:
for ((i=1;i>0;i++)) do xfs_io -f /mnt/f2fs/enc/file \
-c "pwrite 0 32k" -c "fdatasync"

So, in f2fs_merge_page_bio(), let's avoid using fio->encrypted_page after
commit page into internal ipu cache.

Fixes: 0b20fcec8651 ("f2fs: cache global IPU bio")
Reported-by: JY <JY.Ho@mediatek.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -968,7 +968,7 @@ alloc_new:
 	if (fio->io_wbc)
 		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
-	inc_page_count(fio->sbi, WB_DATA_TYPE(page));
+	inc_page_count(fio->sbi, WB_DATA_TYPE(fio->page));
 
 	*fio->last_block = fio->new_blkaddr;
 	*fio->bio = bio;


