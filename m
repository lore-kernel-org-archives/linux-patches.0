Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECCA33B945;
	Mon, 20 Apr 2026 16:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701470; cv=none; b=K8pyNb87do8Fn7cZGyTdT2NZcKPOTrKOhWCtjp8jDsmQtqwqTaWayqDp3b/TfvP4P7ZXqKCs1M+ib5iJpBlVf2OnzUNUvqtkZQs7X2mpfM+fXrzy2Xhb0D81sdLs03lU9Ym9oQp6mWI5sEwTYgMYetFWw/pcz3yfGW+a//FSwrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701470; c=relaxed/simple;
	bh=wN2XWpf1KFEcPouMR7rlaBuT4SxBY+i2d5G8PELXVrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVYr/byf2pYrH9RkJDqdaJ8U6c3FVBl4bwKteQ53UWDuc7SWdf+QnpgCUP1g2pYhqQF9y4xuzzGsBIs+dV/AUavwbXIoSeIH7szXBXw6RxmKXvbVvjbWc4iS/Vp9Rli9fQwOCRBCXVCtmDlLaKgJ8uD/KiVr2JsBseFfORw8ObE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJHcdvMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJHcdvMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECD3C19425;
	Mon, 20 Apr 2026 16:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701470;
	bh=wN2XWpf1KFEcPouMR7rlaBuT4SxBY+i2d5G8PELXVrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJHcdvMXHqXgm6G6ukLRRqrJ+hI3c5L6QW2ivhvuoPBaiN6Gpcm1JlDebVr2zQb1G
	 OwX6YmgJ+fQXH/pm1+eAeIb1YZmYqN+oyMw1T4TI09mKaNzbru9K1f6C8LGut0ayRZ
	 4lxv1XjY4YPgqzbIGHiEY8CFgDQ66m9iJXbDCq/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 127/162] ocfs2: handle invalid dinode in ocfs2_group_extend
Date: Mon, 20 Apr 2026 17:42:39 +0200
Message-ID: <20260420153931.641428753@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

From: ZhengYuan Huang <gality369@gmail.com>

commit 4a1c0ddc6e7bcf2e9db0eeaab9340dcfe97f448f upstream.

[BUG]
kernel BUG at fs/ocfs2/resize.c:308!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_group_extend+0x10aa/0x1ae0 fs/ocfs2/resize.c:308
Code: 8b8520ff ffff83f8 860f8580 030000e8 5cc3c1fe
Call Trace:
 ...
 ocfs2_ioctl+0x175/0x6e0 fs/ocfs2/ioctl.c:869
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 x64_sys_call+0x1144/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 ...

[CAUSE]
ocfs2_group_extend() assumes that the global bitmap inode block
returned from ocfs2_inode_lock() has already been validated and
BUG_ONs when the signature is not a dinode. That assumption is too
strong for crafted filesystems because the JBD2-managed buffer path
can bypass structural validation and return an invalid dinode to the
resize ioctl.

[FIX]
Validate the dinode explicitly in ocfs2_group_extend(). If the global
bitmap buffer does not contain a valid dinode, report filesystem
corruption with ocfs2_error() and fail the resize operation instead of
crashing the kernel.

Link: https://lkml.kernel.org/r/20260401092303.3709187-1-gality369@gmail.com
Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/resize.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -303,9 +303,13 @@ int ocfs2_group_extend(struct inode * in
 
 	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
 
-	/* main_bm_bh is validated by inode read inside ocfs2_inode_lock(),
-	 * so any corruption is a code bug. */
-	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+	/* JBD-managed buffers can bypass validation, so treat this as corruption. */
+	if (!OCFS2_IS_VALID_DINODE(fe)) {
+		ret = ocfs2_error(main_bm_inode->i_sb,
+				  "Invalid dinode #%llu\n",
+				  (unsigned long long)OCFS2_I(main_bm_inode)->ip_blkno);
+		goto out_unlock;
+	}
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
 		ocfs2_group_bitmap_size(osb->sb, 0,


