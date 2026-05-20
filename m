Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F91F3A4526;
	Wed, 20 May 2026 16:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295830; cv=none; b=VeDCfe43tXPnapYV9a/wN3ug7hKMSPL9uZLbrRAX8YezrypU6BYQcOCQAM+cVw0qvljl8kcsmkr9XIxT/QtKBUmAag+PRV4oqP2ZqRvziulaDXmvwcbT/qfFlje24bzXSAV8A2NI8PlLfBusrnmnnSqBaI2hM32fFLsmuq0ZCeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295830; c=relaxed/simple;
	bh=Bj5mrrONu76spvZeOnWZSZA0maoyibBppvvRpe3uud8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQQvJCh6/AAVBy26UAGKj+Aoe4YIASbmEKMR5d356VPC/w2FjhIiY15/qG4XoGy3DMDMXyMhXvdVWBykD7ifuLg8WO5GkLMwOGQL9VLKGs1oWCahwKyVnVnFEt89XoFxw2eiVx6DRlP+j633fhWK3KdX2THBVT6LZ5XBIz+UYJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndD5gVZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndD5gVZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAD31F000E9;
	Wed, 20 May 2026 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295829;
	bh=wv4pOq0ZFZ4ZhJG02RQZp2L1t3XRc146wSwHle5jJIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndD5gVZ8svU84Lo8Lb9+JgE8IFjEEq07IZ1kLYFqgujQWiRevP5SGu5YsoL9+iZ0M
	 UzqFttzmBx0EPgl3zn6Jv8shL7ydsMS8PAMFI4z4MSCkgGVh4lccjPtFSYt5ac53OA
	 d3OijCR1mwUv2SWSER4EZYRNM1X8xpXg77KRe+Ao=
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
Subject: [PATCH 7.0 0569/1146] ocfs2: fix listxattr handling when the buffer is full
Date: Wed, 20 May 2026 18:13:39 +0200
Message-ID: <20260520162201.061665964@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit d12f558e6200b3f47dbef9331ed6d115d2410e59 ]

[BUG]
If an OCFS2 inode has both inline and block-based xattrs, listxattr()
can return a size larger than the caller's buffer when the inline names
consume that buffer exactly.

kernel BUG at mm/usercopy.c:102!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:usercopy_abort+0xb7/0xd0 mm/usercopy.c:102
Call Trace:
 __check_heap_object+0xe3/0x120 mm/slub.c:8243
 check_heap_object mm/usercopy.c:196 [inline]
 __check_object_size mm/usercopy.c:250 [inline]
 __check_object_size+0x5c5/0x780 mm/usercopy.c:215
 check_object_size include/linux/ucopysize.h:22 [inline]
 check_copy_size include/linux/ucopysize.h:59 [inline]
 copy_to_user include/linux/uaccess.h:219 [inline]
 listxattr+0xb0/0x170 fs/xattr.c:926
 filename_listxattr fs/xattr.c:958 [inline]
 path_listxattrat+0x137/0x320 fs/xattr.c:988
 __do_sys_listxattr fs/xattr.c:1001 [inline]
 __se_sys_listxattr fs/xattr.c:998 [inline]
 __x64_sys_listxattr+0x7f/0xd0 fs/xattr.c:998
 ...

[CAUSE]
Commit 936b8834366e ("ocfs2: Refactor xattr list and remove
ocfs2_xattr_handler().") replaced the old per-handler list accounting
with ocfs2_xattr_list_entry(), but it kept using size == 0 to detect
probe mode.

That assumption stops being true once ocfs2_listxattr() finishes the
inline-xattr pass. If the inline names fill the caller buffer exactly,
the block-xattr pass runs with a non-NULL buffer and a remaining size of
zero. ocfs2_xattr_list_entry() then skips the bounds check, keeps
counting block names, and returns a positive size larger than the
supplied buffer.

[FIX]
Detect probe mode by testing whether the destination buffer pointer is
NULL instead of whether the remaining size is zero.

That restores the pre-refactor behavior and matches the OCFS2 getxattr
helpers. Once the remaining buffer reaches zero while more names are
left, the block-xattr pass now returns -ERANGE instead of reporting a
size larger than the allocated list buffer.

Link: https://lkml.kernel.org/r/20260410040339.3837162-1-gality369@gmail.com
Fixes: 936b8834366e ("ocfs2: Refactor xattr list and remove ocfs2_xattr_handler().")
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
 fs/ocfs2/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 42ee5db362d3e..b9a6bdbf596c2 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -911,8 +911,8 @@ static int ocfs2_xattr_list_entry(struct super_block *sb,
 	total_len = prefix_len + name_len + 1;
 	*result += total_len;
 
-	/* we are just looking for how big our buffer needs to be */
-	if (!size)
+	/* No buffer means we are only looking for the required size. */
+	if (!buffer)
 		return 0;
 
 	if (*result > size)
-- 
2.53.0



