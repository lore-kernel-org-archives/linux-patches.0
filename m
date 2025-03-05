Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C66A1C6FF6;
	Wed,  5 Mar 2025 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198050; cv=none; b=C75fQB8QIaHTuHJiTfCYO0aWv/BXnhYx+TN+6DSnpJkDvKHpPWxotKbhVKOUnNgqgMGEee++k91woQqlPo5mtPexSVNYSZhtfNFbF/cP0MR64pdFZLZHLU5cIbaUKphw8w6Ylx9vwPRFNxW/S0VXKhz2VQxFt3VC14CeOoOB2gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198050; c=relaxed/simple;
	bh=nj0u/7UzOpW0a8pQXbdHu8vc1mSoRe+UuGL7dBZ5u1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVuVtkCHjLNq/wIeBqZzVyKZBzAr+Xh0ZjDY7oalQoMZCM08WCQV0KAbPqPhh1eyp2HM5FaoI6lv+gur2uObNWbbHqz35PLsRF3530K7gwz0jjybj+8/JXrremdWwOel1fDSnvFppprOwBoqCzz9r+z6LBQs3ZUTDhgoVcfJ52M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIxIvzW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIxIvzW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052F5C4CED1;
	Wed,  5 Mar 2025 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198050;
	bh=nj0u/7UzOpW0a8pQXbdHu8vc1mSoRe+UuGL7dBZ5u1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIxIvzW63XPC21FuHxxhejKTD3sSGVkZoTAP42XOiw8Y1x+WkJjN9Qyt6X+leKECT
	 VjuCGf4YUHFAQDiTrn7P1djYo67NOGsTggv4oEgEQbH8VbKugPvuvDClTleg07SAdf
	 HCOVZxsFBKYG3yn3q2ggnjoGpCg9bgrZdpD0GqMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+316db8a1191938280eb6@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/150] ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up
Date: Wed,  5 Mar 2025 18:47:24 +0100
Message-ID: <20250305174504.419938861@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b2c78621da44a..4388004a319d0 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -619,7 +619,6 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
 		err = ovl_do_link(ofs, ovl_dentry_upper(c->dentry), udir, upper);
-		dput(upper);
 
 		if (!err) {
 			/* Restore timestamps on parent (best effort) */
@@ -627,6 +626,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 			ovl_dentry_set_upper_alias(c->dentry);
 			ovl_dentry_update_reval(c->dentry, upper);
 		}
+		dput(upper);
 	}
 	inode_unlock(udir);
 	if (err)
-- 
2.39.5



