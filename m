Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AE41F890F;
	Tue,  3 Dec 2024 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242647; cv=none; b=sOtWyEjy2ucijmJsZxIesRWGmL0glfBTmTP8RrWzNPVkLWRiIg7LArZrCZktxWAA0KfLybuk0LBBg/zJYiCTWbEur8nmf1nV8LuIegV7tD2eMvqCVosurCaqRzMWBk8PjL72W9kXPcZ3UkhJuC2fn+txEH/YgL1W1BGubpHwUjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242647; c=relaxed/simple;
	bh=1xtGOh5yqhcc9KBL7ikqWNOst5dBO+j8zB8+bGgdJ1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/gtcszno/m297Gr9dG82lUwLp9l5MVnmSkk+K19JGd0tDJ5fKD4a9700mXDE2D6m3j7c49aXeafaBH/1hNYUJzmZ3RoO3SPaGalMLFWhArfS9m1uX7nqYvi0tcPLw2vWwS3footfdlzuJACQb87QYDo94t08ZBjq1ay58lbHSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvFR2T6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvFR2T6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CABC4CECF;
	Tue,  3 Dec 2024 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242647;
	bh=1xtGOh5yqhcc9KBL7ikqWNOst5dBO+j8zB8+bGgdJ1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvFR2T6jqZaaZeKHzwDaQ5MNRyZHuvarqEbcfM9rX8LZ+mGJn+7/DpehDK80MesBA
	 kgG6Yer8UhmQR97YbbdeNV6MHC6UPrzODxfiUZ8YobjoCdscGW20dukJRhDFmUD/R+
	 VCo0fNqV010jabY2dN+KQ1HzMf261/vlKuC4tXrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+33379ce4ac76acf7d0c7@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 767/826] f2fs: fix to do sanity check on node blkaddr in truncate_node()
Date: Tue,  3 Dec 2024 15:48:14 +0100
Message-ID: <20241203144813.686275781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 6babe00ccd34fc65b78ef8b99754e32b4385f23d upstream.

syzbot reports a f2fs bug as below:

------------[ cut here ]------------
kernel BUG at fs/f2fs/segment.c:2534!
RIP: 0010:f2fs_invalidate_blocks+0x35f/0x370 fs/f2fs/segment.c:2534
Call Trace:
 truncate_node+0x1ae/0x8c0 fs/f2fs/node.c:909
 f2fs_remove_inode_page+0x5c2/0x870 fs/f2fs/node.c:1288
 f2fs_evict_inode+0x879/0x15c0 fs/f2fs/inode.c:856
 evict+0x4e8/0x9b0 fs/inode.c:723
 f2fs_handle_failed_inode+0x271/0x2e0 fs/f2fs/inode.c:986
 f2fs_create+0x357/0x530 fs/f2fs/namei.c:394
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0010:f2fs_invalidate_blocks+0x35f/0x370 fs/f2fs/segment.c:2534

The root cause is: on a fuzzed image, blkaddr in nat entry may be
corrupted, then it will cause system panic when using it in
f2fs_invalidate_blocks(), to avoid this, let's add sanity check on
nat blkaddr in truncate_node().

Reported-by: syzbot+33379ce4ac76acf7d0c7@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/0000000000009a6cd706224ca720@google.com/
Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -905,6 +905,16 @@ static int truncate_node(struct dnode_of
 	if (err)
 		return err;
 
+	if (ni.blk_addr != NEW_ADDR &&
+		!f2fs_is_valid_blkaddr(sbi, ni.blk_addr, DATA_GENERIC_ENHANCE)) {
+		f2fs_err_ratelimited(sbi,
+			"nat entry is corrupted, run fsck to fix it, ino:%u, "
+			"nid:%u, blkaddr:%u", ni.ino, ni.nid, ni.blk_addr);
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		f2fs_handle_error(sbi, ERROR_INCONSISTENT_NAT);
+		return -EFSCORRUPTED;
+	}
+
 	/* Deallocate node address */
 	f2fs_invalidate_blocks(sbi, ni.blk_addr);
 	dec_valid_node_count(sbi, dn->inode, dn->nid == dn->inode->i_ino);


