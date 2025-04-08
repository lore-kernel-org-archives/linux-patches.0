Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B002676DE;
	Tue,  8 Apr 2025 11:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112996; cv=none; b=lTZuhX+Hj0yPEkIwA9hcwxoswsfJV6DOG3jnnFX6/qm6c/ePwZofg2+ofOTguMkYWjJa8OuN9x2y/FmlFEPjTzdum+0VEcZni5serm6BrL24UeLEE+VYzaTNuVDBc5bi/Pcs3wjLDoeS1AFUHzeUR/ChfFydxX+rPwO4rzwDgwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112996; c=relaxed/simple;
	bh=B6yGGl1atyB/7zPJeP0gQffv7wIuGB2Op6eA6kMIZuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERKTcIRV32PlkjAUiOp3s4m7io2h3J2tUOwohbuuYqGrTYxbkjis/qJJTYHAyRGNFCmYrPcrqzTqiC79huE5pb+T2mXvGq/wUEtnzdLHo023nWmn8lQxLLFM4mp7hT20NksysmDWHN5gqk1ZLoYBRZF2bAifkp18deGM393Fxek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZtAnhxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZtAnhxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8521C4CEEB;
	Tue,  8 Apr 2025 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112996;
	bh=B6yGGl1atyB/7zPJeP0gQffv7wIuGB2Op6eA6kMIZuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZtAnhxMhxegEmKffh6e3njhJvMT5y3i2+q0MMdODmaW17VHAH2LCfxTQ96TADTW3
	 G/PF7rRZQb12mSmNQlhR54aFpwHyt+fu8KL+NU+HXiu88XAzfgbg/KuhjM4RsNGss9
	 7C/I6EavOVpWlO+CbSUbtpX8hA1LH7MknJOmMw6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+9120834fc227768625ba@syzkaller.appspotmail.com>,
	Roman Smirnov <r.smirnov@omp.ru>,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 5.15 275/279] jfs: add index corruption check to DT_GETPAGE()
Date: Tue,  8 Apr 2025 12:50:58 +0200
Message-ID: <20250408104833.817543648@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Roman Smirnov <r.smirnov@omp.ru>

commit a8dfb2168906944ea61acfc87846b816eeab882d upstream.

If the file system is corrupted, the header.stblindex variable
may become greater than 127. Because of this, an array access out
of bounds may occur:

------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/jfs/jfs_dtree.c:3096:10
index 237 is out of range for type 'struct dtslot[128]'
CPU: 0 UID: 0 PID: 5822 Comm: syz-executor740 Not tainted 6.13.0-rc4-syzkaller-00110-g4099a71718b0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_out_of_bounds+0x121/0x150 lib/ubsan.c:429
 dtReadFirst+0x622/0xc50 fs/jfs/jfs_dtree.c:3096
 dtReadNext fs/jfs/jfs_dtree.c:3147 [inline]
 jfs_readdir+0x9aa/0x3c50 fs/jfs/jfs_dtree.c:2862
 wrap_directory_iterator+0x91/0xd0 fs/readdir.c:65
 iterate_dir+0x571/0x800 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:403 [inline]
 __se_sys_getdents64+0x1e2/0x4b0 fs/readdir.c:389
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>
---[ end trace ]---

Add a stblindex check for corruption.

Reported-by: syzbot <syzbot+9120834fc227768625ba@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=9120834fc227768625ba
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/jfs_dtree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -117,7 +117,8 @@ do {									\
 	if (!(RC)) {							\
 		if (((P)->header.nextindex >				\
 		     (((BN) == 0) ? DTROOTMAXSLOT : (P)->header.maxslot)) || \
-		    ((BN) && ((P)->header.maxslot > DTPAGEMAXSLOT))) {	\
+		    ((BN) && (((P)->header.maxslot > DTPAGEMAXSLOT) ||	\
+		    ((P)->header.stblindex >= DTPAGEMAXSLOT)))) {	\
 			BT_PUTPAGE(MP);					\
 			jfs_error((IP)->i_sb,				\
 				  "DT_GETPAGE: dtree page corrupt\n");	\


