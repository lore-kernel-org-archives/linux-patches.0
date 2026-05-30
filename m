Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DD6348C5E;
	Sat, 30 May 2026 18:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164351; cv=none; b=HYq7wV8bU64Q6ug+gt5/NCbOa6d69l9bG12Wty1Xy7evhf99J6knSKAbtQBXzc4e+96wlvfVN0W6LcWoY5gNxd0YzbKd9Bx+cAwdSuaxfy9bfM7bBHcXvHJysvTzn+024Y3nI77sfzoHCKPxe8MpEQ61z1xogO1nxRRo3UxgoCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164351; c=relaxed/simple;
	bh=XxPRmPKhY0fagRfs3X0gOIWCX72sitYCrb4v9PPFmm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtfIeunYiKK57UvINbyJOedtKrqn2nW8YW4bLb/CIhE9vvAWHOxi15ZIHnFjGmALACVVMNPtrnX5qRkLvUjVEVv4ZmAfGJZhLqTMYL3jZ6J2/2X9a/YWgkS2y6aP9kKMV2mcXwUCp3SN92TWpdOedHYIouW7VA/vDUNH4ldZnak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqDsmUNg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqDsmUNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E4B1F00893;
	Sat, 30 May 2026 18:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164350;
	bh=bEpOxumtGyaN4nPzU3FSfvWab6dMryXirejWi/ogb0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqDsmUNgySY6IsWunN6sTcend1G/F4gTXj+9artpCPqfv5GbsSHwOehw7gUvYRjh1
	 eLSAemPT9daUE859M2Hrg+9hlzP7nAH6i42oDOuzB7E/a4BEFn0i6tNOMxrJ1xPtUB
	 k2yjrNBMF48E74gD1gGUFI8SbH1dKVZWgIkgntqY=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 499/776] ocfs2: validate group add input before caching
Date: Sat, 30 May 2026 18:03:33 +0200
Message-ID: <20260530160253.192136860@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit 70b672833f4025341c11b22c7f83778a5cd611bc ]

[BUG]
OCFS2_IOC_GROUP_ADD can trigger a BUG_ON in
ocfs2_set_new_buffer_uptodate():

kernel BUG at fs/ocfs2/uptodate.c:509!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_set_new_buffer_uptodate+0x194/0x1e0 fs/ocfs2/uptodate.c:509
Code: ffffe88f 42b9fe4c 89e64889 dfe8b4df
Call Trace:
 ocfs2_group_add+0x3f1/0x1510 fs/ocfs2/resize.c:507
 ocfs2_ioctl+0x309/0x6e0 fs/ocfs2/ioctl.c:887
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 x64_sys_call+0x1144/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7bbfb55a966d

[CAUSE]
ocfs2_group_add() calls ocfs2_set_new_buffer_uptodate() on a
user-controlled group block before ocfs2_verify_group_and_input()
validates that block number. That helper is only valid for newly
allocated metadata and asserts that the block is not already present in
the chosen metadata cache. The code also uses INODE_CACHE(inode) even
though the group descriptor belongs to main_bm_inode and later journal
accesses use that cache context instead.

[FIX]
Validate the on-disk group descriptor before caching it, then add it to
the metadata cache tracked by INODE_CACHE(main_bm_inode). Keep the
validation failure path separate from the later cleanup path so we only
remove the buffer from that cache after it has actually been inserted.
This keeps the group buffer lifetime consistent across validation,
journaling, and cleanup.

Link: https://lkml.kernel.org/r/20260410020209.3786348-1-gality369@gmail.com
Fixes: 7909f2bf8353 ("[PATCH 2/2] ocfs2: Implement group add for online resize")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/resize.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 42c0d314f95e8..acf2769f4c8c7 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -500,14 +500,14 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		goto out_unlock;
 	}
 
-	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), group_bh);
-
 	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_free_group_bh;
 	}
 
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(main_bm_inode), group_bh);
+
 	trace_ocfs2_group_add((unsigned long long)input->group,
 			       input->chain, input->clusters, input->frees);
 
@@ -515,7 +515,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	if (IS_ERR(handle)) {
 		mlog_errno(PTR_ERR(handle));
 		ret = -EINVAL;
-		goto out_free_group_bh;
+		goto out_remove_cache;
 	}
 
 	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
@@ -569,9 +569,11 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 
-out_free_group_bh:
+out_remove_cache:
 	if (ret < 0)
-		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
+		ocfs2_remove_from_cache(INODE_CACHE(main_bm_inode), group_bh);
+
+out_free_group_bh:
 	brelse(group_bh);
 
 out_unlock:
-- 
2.53.0



