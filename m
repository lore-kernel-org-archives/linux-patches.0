Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8B515ADB4;
	Wed,  3 Dec 2025 15:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776828; cv=none; b=AXwbgcICh1vAOyzuxotFUlRVSgLQQZvLd4QFGMSJAYS3Y8XOaDB/MJghr8EnvKZKLvYacAx14No58+K43TDghmYEDYinXpfdIKEr5KCR0PEd51nGmvE6z+NulEwPITMIdrV5VV2Rn2GWoR6LkRAnSdFGgCBT+2is8BArcales3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776828; c=relaxed/simple;
	bh=qZG6BCo/YC/kJWQhtoFWRu7sBzu5k20Zt9IfAlcyFaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkYYvnqW0v5N7MfhQqwz0goFnDQhQSrnRVhe7x2G8jnW/5cWmDbFxCqRA1EMW48FoIq+rfjFr7HLp2og9bsAStrC+VwWtR0SrTAw6k1TWV0F6nft/zKQ1l1llXf95QwZcyCihEnZ1nqp3KtqC/BP9D9qpNq+UJPK/Llk6Rzsvm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgLnW6Bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgLnW6Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AE1C4CEF5;
	Wed,  3 Dec 2025 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776828;
	bh=qZG6BCo/YC/kJWQhtoFWRu7sBzu5k20Zt9IfAlcyFaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgLnW6BgBjeCapgdwAcBTLlR9V5qBERbMIE9RytF9WRslWXOXAim8KyzJcLbfn5LP
	 A4eFPhQHV9D/Tb6E5x9JqtMSQUzC4K+/craLikRRz7d5iQnghL/v57zlJYo8hHqQLZ
	 gu3PrLK4WiNszNrd0538fiGg3m2zctoqOYF2QkWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+316db8a1191938280eb6@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Bin Lan <lanbincn@qq.com>
Subject: [PATCH 5.10 299/300] ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up
Date: Wed,  3 Dec 2025 16:28:23 +0100
Message-ID: <20251203152411.698835585@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
[ Minor context change fixed. ]
Signed-off-by: Bin Lan <lanbincn@qq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -469,7 +469,6 @@ static int ovl_link_up(struct ovl_copy_u
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
 		err = ovl_do_link(ovl_dentry_upper(c->dentry), udir, upper);
-		dput(upper);
 
 		if (!err) {
 			/* Restore timestamps on parent (best effort) */
@@ -477,6 +476,7 @@ static int ovl_link_up(struct ovl_copy_u
 			ovl_dentry_set_upper_alias(c->dentry);
 			ovl_dentry_update_reval(c->dentry, upper);
 		}
+		dput(upper);
 	}
 	inode_unlock(udir);
 	if (err)


