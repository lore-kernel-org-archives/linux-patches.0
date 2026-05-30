Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E9D21B191;
	Sat, 30 May 2026 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166423; cv=none; b=AtbPXJwgbOBlOyOo/tt8UNfNmnRaxnhLvzQyiRUABa9gNzzmNH3qv+UkdudlDKhxn/nYx+5LpuhxPSg9X4FPAaNIi/nx24uc4VC0DQHZOuj5ISiwKmCffB7YLRWUbKgKCOnZwtq8zHoTrwPYFhcj04DZz/YHWIUTCQTVlmmyJq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166423; c=relaxed/simple;
	bh=FEFVOEgR+sM9Ywt35iFvtKQ0ExYqJ6FXIHrUgA2NX7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoLaF4boKrmfLR4Ia2n5bCsZQMeak6kzKN218dTf7s6zjqfqlqzbXGnClPhagUv2BA2tlLAAfuGIyGsu+yYc4Z/fg0S9cVTFg/P8E1NK63URE0+PQnfuBxLZez6w6gT51gNu9ZO+IFdKn78ZZsssDBVZVNfh3tje+kHBVsUcj4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gzc0pUz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gzc0pUz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80F01F00898;
	Sat, 30 May 2026 18:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166421;
	bh=KlAz+y9mB++rDaypldnsZQspS+iQEueyiA55lwyCvsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gzc0pUz6YRPUcEBONlDEq4hK9iSmhfyWIzz7qqdIgKyr3K7shAbn31XqHnU1C36vh
	 Wn8nxOY+hkwk0u/LauAHQu7cQI4OYlvibOjoMWbLTOA28jQx0StOtEbUgiPPStPB0Q
	 pmeKuGw4lZm8vUCMBMO+gzMSMv6+aLmiuc6RAVE8=
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
Subject: [PATCH 5.10 369/589] ocfs2: fix listxattr handling when the buffer is full
Date: Sat, 30 May 2026 18:04:10 +0200
Message-ID: <20260530160234.526211742@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d1409187b3fd1..be982b727facb 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -913,8 +913,8 @@ static int ocfs2_xattr_list_entry(struct super_block *sb,
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



