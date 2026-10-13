Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91E44EDCB8;
	Tue, 13 Oct 2026 12:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893530; cv=none; b=av9U79pLxkBu/O2pUFqP9pm5nPnz9kOSOHNEnefgTwoACO0LYfiJKsorU80IPz/l7RjtgNj04arWc6bIfSMebHHn8M/Rpk4wzEL+rYxDMUiP4oamGYr+n9s92Hg4ZxgZyv9cG1Y37Tyx2mIq5flEUnNpc/9px24tfMAh7Yp7/vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893530; c=relaxed/simple;
	bh=sx12uz3LtbO+MHVhQYLaS41xAuHml1XBLmyJv20EUqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVNjVV68/Ay6GIzJXs51t5TTGEPbkq/103SO+xws7SG2qR0raopeNTCxn5IxEXTo6zgVedj5mEdMCJEc1ryOf47ojR5F3qyIGZLBF1JKOboKUj+ikbLUXPe6EQAkWU1wRYNQQyfvp1cbdLWRD2QH+hLGMS6NT2D5g/k9k3Zm9LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=il2+du2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="il2+du2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9C91F000FF;
	Tue, 13 Oct 2026 12:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893528;
	bh=PL44NypY1FygoU1bpokbk91hWfCpNgNqzkDXzGgMO04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=il2+du2GQXjmwBnWfJ/jUBhzDUbpP7dYy5xeEAZnUZtJpc6SSwIwxFGdRhj5Ni+zs
	 lKoCUKq/e/Gl5S23af4FYLiXT892C/Q1MRPtv5hfkapbsfXSAHWu5rqJAZY0sToXJZ
	 ADzvHGhFxdGMC+ebGPLQkaSfqjVppgppbl6qTmQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 249/621] erofs: fix metabuf leak in inode xattr initialization
Date: Tue, 13 Oct 2026 13:34:04 +0200
Message-ID: <20261013112926.771763049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jia Zhu <zhujia.zj@bytedance.com>

[ Upstream commit 79b09c54c6563df9846ca3094bcfd72082c3e1d7 ]

commit bb88e8da0025 ("erofs: use meta buffers for xattr operations")
converted xattr operations to use on-stack erofs_buf instances.
erofs_init_inode_xattrs() uses such a metabuf while reading the inline
xattr header and shared xattr id array.

Some error paths after erofs_read_metabuf() leave through out_unlock
without dropping the metabuf, so the folio reference can leak.

Consolidate the cleanup at out_unlock. erofs_put_metabuf() is a
no-op if no folio has been acquired, and this keeps all paths after
taking EROFS_I_BL_XATTR_BIT covered by a single cleanup site.

Fixes: bb88e8da0025 ("erofs: use meta buffers for xattr operations")
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Fixes: bb88e8da0025 ("erofs: use meta buffers for xattr operations")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/xattr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index 396536d9a8621..59de3253e4665 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -34,6 +34,8 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	int ret = 0;
 
+	it.buf = __EROFS_BUF_INITIALIZER;
+
 	/* the most case is that xattrs of this inode are initialized. */
 	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags)) {
 		/*
@@ -76,7 +78,6 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 		goto out_unlock;
 	}
 
-	it.buf = __EROFS_BUF_INITIALIZER;
 	ret = erofs_init_metabuf(&it.buf, sb, erofs_inode_in_metabox(inode));
 	if (ret)
 		goto out_unlock;
@@ -95,7 +96,6 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 	vi->xattr_shared_xattrs = kmalloc_array(vi->xattr_shared_count,
 						sizeof(uint), GFP_KERNEL);
 	if (!vi->xattr_shared_xattrs) {
-		erofs_put_metabuf(&it.buf);
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
@@ -114,13 +114,13 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 		vi->xattr_shared_xattrs[i] = le32_to_cpu(*(__le32 *)it.kaddr);
 		it.pos += sizeof(__le32);
 	}
-	erofs_put_metabuf(&it.buf);
 
 	/* paired with smp_mb() at the beginning of the function. */
 	smp_mb();
 	set_bit(EROFS_I_EA_INITED_BIT, &vi->flags);
 
 out_unlock:
+	erofs_put_metabuf(&it.buf);
 	clear_and_wake_up_bit(EROFS_I_BL_XATTR_BIT, &vi->flags);
 	return ret;
 }
-- 
2.53.0



