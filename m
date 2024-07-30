Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9D91A6169;
	Tue, 30 Jul 2024 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357841; cv=none; b=kf60dBpjIpc+yiYSzEIndb1Y84OdXL0dWec0JvrU4uNCU13B+em73HcZQWovIxUNQbsDBrbRqPhaSN+aKfCGNQq9cBtT+C6Mh5eKXkbCT1X8pPkSt7D58prdhjAS5wLDPuAWE0ZCQ2EOS7RwOHIur38K4hj6CEHoR6mxGZ+I9Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357841; c=relaxed/simple;
	bh=ICpdWMSArYU89HA6Ga/eEPFuC9Qie6EHO0SlrNrzCL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwlBRi7VzyaP46iPS7JhSQ743P7BdVC7WFs0woUGMCMzw7VVOT5QIyNPSHc931WXLrU0r6X3XGhke4Pgwgk26+uI1hHoa5EylV3te+dvRoWN9ecv529wuNNZ5da2/uHR2FiLnQGKS1btTfd3mCTu3vqKPhohVCPh0hxuPGN31g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zpu5SzVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zpu5SzVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633FBC32782;
	Tue, 30 Jul 2024 16:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357840;
	bh=ICpdWMSArYU89HA6Ga/eEPFuC9Qie6EHO0SlrNrzCL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zpu5SzVnDVKsHXBjQxQJb0mH7+N3hszOHsdpMLCdZ7ESaOnjGIrqHi6MuGNsVLrRA
	 Tg+C+lLg/l7d2qo87QYhcTms6EGsmCT51XUbph0J0DgX+UFmwdCLKgQ2kmaMZzpbvT
	 TRlRmrI4LHZpDWZ9Y2bsToqpdvulEaL3uWpGTCSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+848062ba19c8782ca5c8@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 332/440] f2fs: fix return value of f2fs_convert_inline_inode()
Date: Tue, 30 Jul 2024 17:49:25 +0200
Message-ID: <20240730151628.786533760@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit a8eb3de28e7a365690c61161e7a07a4fc7c60bbf upstream.

If device is readonly, make f2fs_convert_inline_inode()
return EROFS instead of zero, otherwise it may trigger
panic during writeback of inline inode's dirty page as
below:

 f2fs_write_single_data_page+0xbb6/0x1e90 fs/f2fs/data.c:2888
 f2fs_write_cache_pages fs/f2fs/data.c:3187 [inline]
 __f2fs_write_data_pages fs/f2fs/data.c:3342 [inline]
 f2fs_write_data_pages+0x1efe/0x3a90 fs/f2fs/data.c:3369
 do_writepages+0x359/0x870 mm/page-writeback.c:2634
 filemap_fdatawrite_wbc+0x125/0x180 mm/filemap.c:397
 __filemap_fdatawrite_range mm/filemap.c:430 [inline]
 file_write_and_wait_range+0x1aa/0x290 mm/filemap.c:788
 f2fs_do_sync_file+0x68a/0x1ae0 fs/f2fs/file.c:276
 generic_write_sync include/linux/fs.h:2806 [inline]
 f2fs_file_write_iter+0x7bd/0x24e0 fs/f2fs/file.c:4977
 call_write_iter include/linux/fs.h:2114 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xa72/0xc90 fs/read_write.c:590
 ksys_write+0x1a0/0x2c0 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Cc: stable@vger.kernel.org
Reported-by: syzbot+848062ba19c8782ca5c8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/000000000000d103ce06174d7ec3@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inline.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -204,8 +204,10 @@ int f2fs_convert_inline_inode(struct ino
 	struct page *ipage, *page;
 	int err = 0;
 
-	if (!f2fs_has_inline_data(inode) ||
-			f2fs_hw_is_readonly(sbi) || f2fs_readonly(sbi->sb))
+	if (f2fs_hw_is_readonly(sbi) || f2fs_readonly(sbi->sb))
+		return -EROFS;
+
+	if (!f2fs_has_inline_data(inode))
 		return 0;
 
 	err = f2fs_dquot_initialize(inode);


