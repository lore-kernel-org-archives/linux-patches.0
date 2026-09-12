Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2F41D212;
	Sat, 12 Sep 2026 08:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202572; cv=none; b=rkIyxajlhjDfOSLSHazNVkYa1BhLwcuHRMPK1whVDGmtuYWCMAwf8+1/klvh863PGQQsjrGT1BRalrAzDNiDsEo7tZxFZa3Fi0JtG7P6xQtmLwsBhdfa4aGaWf7Y1sYMOfAMLwYjEI1Xwtuj44COzX/NyJBnWZxC0C1GQOLP/3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202572; c=relaxed/simple;
	bh=W+pHPn2B+XcN18Sk7IpUVl+NAM9S4lMs+k061OFaLfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PknLiC3cGIsgIscoMACbI5AQH74jTu3hrM+2LhmfxkFR3ITF5YUatXHf//IyLmPCA8hgeeSJLubCcN9zFYST2XGpVndK2Z6w/vy5hJOxZkqjVFBvRz7zoJ9vuHZLK6bIRv/f1BsNv9lUpWoMo9O2oJx9qhql4C0Ohs0PglxIrVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2Cilb6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2Cilb6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A191F000FF;
	Sat, 12 Sep 2026 08:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202570;
	bh=3PCRF82rSrahU9kaZbCCcwt9rWE6Q55f3RUW1vi7cp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2Cilb6APgC2QJ0/Na0iqC9g/7R2R1JK3m5bR2CIaRWFX3ZN5//eCH1CvG26mZAo1
	 wfLtC28FyNSQX03RSIHwRXlxFKGnjn8MslUcI6E7Fgllacf+rA2emUg2EoTU00uew6
	 1mjXeMTSk2qhcqxngb1h534JjlgKUvREyTrBL6uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sun YangKai <sunyangkai@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1228/1815] btrfs: check if root is readonly when setting posix acl
Date: Sat, 12 Sep 2026 08:49:38 +0200
Message-ID: <20260912065717.840652217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e55b686fe1ab8..662cdd1cbdef6 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -15,6 +15,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "misc.h"
+#include "btrfs_inode.h"
 
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type, bool rcu)
 {
@@ -107,6 +108,9 @@ int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
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



