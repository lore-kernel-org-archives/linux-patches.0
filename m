Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9108E3E123F;
	Wed, 20 May 2026 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298633; cv=none; b=nmWUHpNrUTRZVxv9s1jFnQr+W53QwYcw2WHJ8t1jB7MqntrkeLoNcPIXccFmOXx8Fd8EPB7GPWgYmmzTdRQzei0HdHxerg7aAYJ7MZndoC461i6KwNd5QgGhrP/4LVyROKNq9N09D8hrsPvrV79H1zR4ZLTFkYeDYtoP3IWspEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298633; c=relaxed/simple;
	bh=dJTklL6QRHP69HFKTQg+OrSp8pHrPl+FNt74uy9JMv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdmSI0iDcVLRzyogb7OJdnPLWeW9Uz/ucEbW9yn+GZn5984dRqoOzkaBgU7FfBB0kHQoHk3vA3hNIoMX73n8Dt5FSY9g+ZdwJzQOvQFAo/Y1MzsFGFokzBEdEwNWzX0HZ8BGRqIVNNTuyIIjJ3fuob/CngJAYDnEdH124BnF4QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zmk02SKw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zmk02SKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD651F00893;
	Wed, 20 May 2026 17:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298630;
	bh=G7mb3aDSbSmbxIzBfcTvhs9WgCymFhI7FH2oWNKKyAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zmk02SKwlUU7UQs1kPMkFiAUVTXZVOa8CgreLqsUxGfdQnM7RjK6H82xeb1Bk6ZcU
	 Oyi/eIM/7S/EnYVWo4LWCdvbEf2Bik8G8HY+Q9ymkGIXQH+Vmx0e3gHG4/4Svv14QM
	 TWWiA+wYNPqPW2dfGkn+IcHmZw98BUnhzGBbsMgc=
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
Subject: [PATCH 6.18 443/957] ocfs2: fix listxattr handling when the buffer is full
Date: Wed, 20 May 2026 18:15:26 +0200
Message-ID: <20260520162144.127929189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 64ba3946f8408..8f7018bad283b 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -907,8 +907,8 @@ static int ocfs2_xattr_list_entry(struct super_block *sb,
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



