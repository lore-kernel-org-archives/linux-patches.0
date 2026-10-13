Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC473FD955;
	Tue, 13 Oct 2026 12:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894051; cv=none; b=dzt6S5u/kttpGVZYc8PBdSD9xAcbekad8qXE1EzSWPhWkd/2xatyzsttbwIOdXDip14af9dk7GWDIVDcaF4woVBI1g7CH5nq3c2sSv1D6FwxW5nrXWHOX0PwAqQghDtimXLn6um0KO+ggtjLnJFfPx7nwkb/dEDzHeAi0nRB7VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894051; c=relaxed/simple;
	bh=O+EV1SQW+33IITpCy191WtPT2LGCgiICup4pcvLS4w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5Nm2PAw6lBflQh9/TPcahA+Z16z32n57rVcdJ0wV0IACMzZDclMPZxXFxW1wv+FVXP2oS5MGYR0xoPSDluApnKTfZ8hwAycX62ynrzVVNVCt9bFwAd1oa8JATxPkZ10VejPfXb9x52zgYnkxwKYFcb0fkfmvA/I1dD5aBxIfzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvXkzP+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvXkzP+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713FA1F000FF;
	Tue, 13 Oct 2026 12:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894050;
	bh=VtdaKCNgUz3DTmcNrZV/Uka1ynOj5PHj3FXvDieAPv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvXkzP+zLAWMKq3dr2qbRKgaWUpvfH6h5C+rOtLx8AcLngqND3fTBmuRQnheWu2Cs
	 nFn+YikHJcRDk9pppUAgm/KStmzJvOccQvX0VFQ8t3BgjIBkfw7B6KHhR6vQwm6fr/
	 jqll0xypjhmK91YmCxNVKf1UamTtGy6a4rWyNR5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sun YangKai <sunyangkai@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 428/621] btrfs: check if root is readonly when setting posix acl
Date: Tue, 13 Oct 2026 13:37:03 +0200
Message-ID: <20261013112930.989877418@linuxfoundation.org>
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

From: Sun YangKai <sunyangkai@fnnas.com>

[ Upstream commit 01c2f41fc441f75b3f9326443372faceb1cb6638 ]

For a filesystem which has btrfs read-only property set to true, all
write operations including acl and xattr should be denied. However, acl
can still be set even if btrfs ro property is true.

This happens because no function on the set_acl code path checks the root
is readonly or not. It was checked in btrfs_setxattr_trans() but got
removed in commit 353c2ea735e4 ("btrfs: remove redundant readonly root
check in btrfs_setxattr_trans")

That commit didn't check if all the callers properly check the root's
read-only flag. A previous fix is commit b51111271b03 ("btrfs: check if
root is readonly while setting security xattr").

Always check if the root is read-only before performing the set acl
operation.

Fixes: 353c2ea735e4 ("btrfs: remove redundant readonly root check in btrfs_setxattr_trans")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/acl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index c336e2ab7f8a9..76d47e7d35ee9 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -15,6 +15,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "misc.h"
+#include "btrfs_inode.h"
 
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type, bool rcu)
 {
@@ -111,6 +112,9 @@ int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	umode_t old_mode = inode->i_mode;
 
+	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+		return -EROFS;
+
 	if (type == ACL_TYPE_ACCESS && acl) {
 		ret = posix_acl_update_mode(idmap, inode,
 					    &inode->i_mode, &acl);
-- 
2.53.0



