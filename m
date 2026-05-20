Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE818401A0B;
	Wed, 20 May 2026 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302413; cv=none; b=DW+SFEIE/158Gmj3/N2g2+WLbWyoirK0pzqkrJIO52v7tkHgUHydR5KltCUySvOhF1z+fgHp2M6F4a2l9p1B+h/AggOYyEkMc9oc+YKusEe7MqTc7Hpl56yJwLK++Dp/+uYsj83zGCnWMzvQcIpn8ANJBXZljPUS/Wm3jfUcXCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302413; c=relaxed/simple;
	bh=kmjYNpCUlhnhC6y6XT+I1YIy3KG8ZNg+eBnY3rCyLoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoAScyxP7WQ5M04cr0WKYwFAL5RW7M6Y0JDXoJ1A6eXOo8kkx61HZHRNwti/Z5WLqN1cT5IqzJ4OePE2t1PgeC/Zu/OUjXzWhb2+dpp68Gsm1HDN2xZhGoIs9CWfgUN4tWUPePhPUEwPKEdKbrneHLCn5OxpTkY6UgF6L83EwPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8bm3KCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8bm3KCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0441F000E9;
	Wed, 20 May 2026 18:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302411;
	bh=b2hZTTQtu798jXBbXMI/8Veca0HZwC3bVNUXldvgPjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8bm3KCIpnCHhgzS2AKq31QjMCVk+8OY+9YZuHGshxUyiuYMzhQgeu/MxivLSengr
	 yUAp/6whpn7ZLAzhKIKuRxD5Q0obp9aereGVo/O1ys0jiycPJudqanFioNf5oQcQHa
	 +NkuW6UpSR0gom/CrP909yaSCX5kR71NgcQ58cpo=
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
Subject: [PATCH 6.6 215/508] ocfs2: validate group add input before caching
Date: Wed, 20 May 2026 18:20:38 +0200
Message-ID: <20260520162103.297800140@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



