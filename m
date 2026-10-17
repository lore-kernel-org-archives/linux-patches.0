Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EADE37DEBE;
	Sat, 17 Oct 2026 16:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255046; cv=none; b=b9KEoceCRI/IJFPF6T1PSlb08zSqbb+0YkvOCmdOuJypHldGUHdogb437MNFpOTCaGSXATmRLWFrGyG/8o2KfWLShM7Gete9OZqVfunYQsdjBnI8QM9BKp0RDGvWhgV1JpPNH9u98kx4BDcb+kPeX68tU2KwY6rzMJ1aPybxzJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255046; c=relaxed/simple;
	bh=/lHbooIkpIlygnfM1B/R0nbaNOma+N6/c3kVF1oNn+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2Q+VJ6ujqHtPqSkujI4VWoMxI4H44K8/u3ECu9sqxmxBOtOhLe9Cw+U4W31anTIiTESySHt3dO9Y9bvtoooS9TViTjOMyw52x4k6zZo81lV5+MoNU3bAKFNlJLTJahq0Thiaqh8pFLDc8Rbx26Q0EVlWwBtLS2bvmbVjNnpiRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TeCWeun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TeCWeun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9431F000C4;
	Sat, 17 Oct 2026 16:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255045;
	bh=p/t3eEf2anaNwlGL5v9QluGyWgyfVnl2EW/TX2RZDOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TeCWeun8Y6kOnCGFWLsSi8IgNU199E2RhaBnP+9wsCN49dZXdQQ4WnJ25lxuy8AT
	 7f9hYpk6xZRs9zFvFtyc055wzr58+BN7ZCoMtuiqyo11s4EHKNFQ3K3ByqY+BjLB/s
	 /g7MQlVF2kIv2OUVGMh14ok4slUHszzTrCoc1nVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sun YangKai <sunyangkai@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 645/869] btrfs: check if root is readonly when setting posix acl
Date: Sat, 17 Oct 2026 17:58:06 +0200
Message-ID: <20261017160053.550663453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e0ba00d64ea0b..d1c67faacc187 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -14,6 +14,7 @@
 #include "ctree.h"
 #include "xattr.h"
 #include "acl.h"
+#include "btrfs_inode.h"
 
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type, bool rcu)
 {
@@ -116,6 +117,9 @@ int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
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



