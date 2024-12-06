Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B98145A05;
	Fri,  6 Dec 2024 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498324; cv=none; b=dhPgd0W6R2KaFu716Krbclni+MQbnnMLel36XANbWUCuH3iIJ/mmQklz++MPqJEZy1mVZwYevhzlupmIHIVuGBHpQElNIghHQAsQ2eOWEC6fEThS9tEqB/lHIIIhy8Spm2i6JTlLnUjemJprGmEDtN8xq8TQNcNuQ7yfJAzXyT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498324; c=relaxed/simple;
	bh=TXkH4LHYRLjxKtKWKRPQyVfzCwFxOvtx+xo8yxoWKpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgLpLr4iKHpHBSU9EcaS/8jIQSOQiFcecIseuAiad9Y6IYG/SnLkWZJluE1Qd9mQpcBEb9j5JQ/xXp7ONv+qNNR0TkW9EXA/kN4i8aN8DpbsXZNABamI8cx8k8WJjKdd69v5820cIRpy9rR2B48Ae0uy0Vx7zbJ6Kq1U2lsIUic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjLDBqgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjLDBqgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAB4C4CEDC;
	Fri,  6 Dec 2024 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498324;
	bh=TXkH4LHYRLjxKtKWKRPQyVfzCwFxOvtx+xo8yxoWKpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjLDBqgbk4arNg83WvrAnNfDvZfg4/abGua/ybejlMTPj41N6cJPUB2+ZXNKzqaK0
	 iCxr/YIEZ+gzrhnZhvyDOn3kRBo3JlgEh3tvc1cir7dfMEUJx6O1PHwiGoKypK/g3t
	 vsJ+3N3dFITtRh4Z1QI6rR1oZYoDP/ws1CaNUNfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+33379ce4ac76acf7d0c7@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 550/676] f2fs: fix to do sanity check on node blkaddr in truncate_node()
Date: Fri,  6 Dec 2024 15:36:09 +0100
Message-ID: <20241206143714.849301713@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


