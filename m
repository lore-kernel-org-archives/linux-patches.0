Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53281A01CC;
	Thu, 15 Aug 2024 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729156; cv=none; b=Ecy3gOO9u77or5SGmpHQDyZOYs3FXOb29yueMGvn/8yGzMzHve7/bYXC0CWvHswT7erhoWv8pzRFVxcaL8H15Q3QfTxh8Pna6sK4HrWAxVJJEPizeNaWv+5hF1Fv2DgvydGNecHQTG0xAoQrhjzF0ZcOKYI+Mn+FFho/WZjsu84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729156; c=relaxed/simple;
	bh=NQ6uqzXhFyhlnqhMBGxs/d2CwXhTwB7UrzyAiUS3dB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjN4jpie4tZlHKsBDLBVf2NcFLbJ0bLP5gQX7rkRQg4rtGY78BDxOE4bvZ8BcnYEKF4WJWwqSdaUAkyRVnXuCMs6J2Glfor2U2wc9XyJD0TIS6FeJkMgWLCB7xhJ9rh31We9HjyqpaGJ9nrDEL3lQt2MKrbIJ/+8IBP1psH+Sro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIcZVuU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIcZVuU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41039C32786;
	Thu, 15 Aug 2024 13:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729156;
	bh=NQ6uqzXhFyhlnqhMBGxs/d2CwXhTwB7UrzyAiUS3dB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIcZVuU1o9BMVG0zFJOZBnjZ6EoHNSo3oloR15z5qn+TR08PAU7Kcd7abrHkkmVTt
	 R+yODrfquoF0wOicPTFvGndOpE9j4qLhdZfAAuY/NUXU1Tt+CS85HS4oNBXPwAfq7H
	 qgf2Bu/8NZuASlaud2mp7B/48oKxHCuQHLKiwGxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+848062ba19c8782ca5c8@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 001/484] f2fs: fix return value of f2fs_convert_inline_inode()
Date: Thu, 15 Aug 2024 15:17:39 +0200
Message-ID: <20240815131941.318544012@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -203,8 +203,10 @@ int f2fs_convert_inline_inode(struct ino
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


