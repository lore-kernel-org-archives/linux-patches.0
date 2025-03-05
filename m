Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95079250BE9;
	Wed,  5 Mar 2025 17:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197384; cv=none; b=FNUPDpdFaiBNlnYjY9ykSICeb3FG49xaIfF+D+m5xUNmnFAOeXR0WnOoobY/+rKdwrtLfsxx1euCMHgBx4ui1qFnpFbTuhy1C7NPTEhhtO0RN0XwlVV3bMCaImHRYT5htTGIjZhbiPd4vYAXKaxSknUT/q+g9IW4wLUaB6PqFVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197384; c=relaxed/simple;
	bh=cBcgtfEB/4giwI4PiZvnysKoBxtGEEvADolXR+s1Ye8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOQWcYccHTizTJVK8tfNmKX0a8VEb9c+1ajI3W9n0jl+oHikukxa5N/YjNUUeSE31nQcLpi4va8R5pkZWhKVaUFJ8fKmY4C/P+sWfRF47q8A7CeR9s/aYqytmifY0NyISFUbCyT/zjON7BczhbBKGazvCDqHXi1N/zG9ifzkj4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxcdCGl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxcdCGl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2D9C4CED1;
	Wed,  5 Mar 2025 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197384;
	bh=cBcgtfEB/4giwI4PiZvnysKoBxtGEEvADolXR+s1Ye8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxcdCGl9VaRkWpvCQSu4ySZ2NACozj5qhsHvP8Pr4+hagUWIsJGrCSidwE8lyYNUc
	 X3YAI31ncpvO6xV6vVq4vlePgAoIVtTJvpjUkHq+HMAKq7HKr7+fa9OEATRFFt0o+f
	 Sxw2QkMaRvn4ooTUjDESXt+Oqmb1vDUy9i9QiBXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+316db8a1191938280eb6@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/176] ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up
Date: Wed,  5 Mar 2025 18:47:55 +0100
Message-ID: <20250305174509.721412710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit c84e125fff2615b4d9c259e762596134eddd2f27 ]

The issue was caused by dput(upper) being called before
ovl_dentry_update_reval(), while upper->d_flags was still
accessed in ovl_dentry_remote().

Move dput(upper) after its last use to prevent use-after-free.

BUG: KASAN: slab-use-after-free in ovl_dentry_remote fs/overlayfs/util.c:162 [inline]
BUG: KASAN: slab-use-after-free in ovl_dentry_update_reval+0xd2/0xf0 fs/overlayfs/util.c:167

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0xc3/0x620 mm/kasan/report.c:488
 kasan_report+0xd9/0x110 mm/kasan/report.c:601
 ovl_dentry_remote fs/overlayfs/util.c:162 [inline]
 ovl_dentry_update_reval+0xd2/0xf0 fs/overlayfs/util.c:167
 ovl_link_up fs/overlayfs/copy_up.c:610 [inline]
 ovl_copy_up_one+0x2105/0x3490 fs/overlayfs/copy_up.c:1170
 ovl_copy_up_flags+0x18d/0x200 fs/overlayfs/copy_up.c:1223
 ovl_rename+0x39e/0x18c0 fs/overlayfs/dir.c:1136
 vfs_rename+0xf84/0x20a0 fs/namei.c:4893
...
 </TASK>

Fixes: b07d5cc93e1b ("ovl: update of dentry revalidate flags after copy up")
Reported-by: syzbot+316db8a1191938280eb6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=316db8a1191938280eb6
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://lore.kernel.org/r/20250214215148.761147-1-kovalev@altlinux.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 86d4b6975dbcb..203b88293f6bb 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -532,7 +532,6 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
 		err = ovl_do_link(ofs, ovl_dentry_upper(c->dentry), udir, upper);
-		dput(upper);
 
 		if (!err) {
 			/* Restore timestamps on parent (best effort) */
@@ -540,6 +539,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 			ovl_dentry_set_upper_alias(c->dentry);
 			ovl_dentry_update_reval(c->dentry, upper);
 		}
+		dput(upper);
 	}
 	inode_unlock(udir);
 	if (err)
-- 
2.39.5



