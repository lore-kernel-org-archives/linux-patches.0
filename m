Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30602391E51;
	Sat, 17 Oct 2026 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260056; cv=none; b=U9aft0HGdnQ3rngMFcZ8ZJ9hmukmCmlu7BB9DBCQAUP6uvCImFedmtSJ+HI1nWm/UoiBnc7yVPT2J686ieKIADoDZsqQGgNLS1XHdPZaLWv7dZqPjzqX4HvKKBiStKIz6PFYBI/rqdtMX7lEsryiae3hLGaPV/AQxIbQoNJQHmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260056; c=relaxed/simple;
	bh=PSsAYk5KpEPlDjbmYJDr0xzMPRJQ/+8Ni2f3Iq0KqG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnFSpG0G77/9B5QJzurFDeWqCu6z8jFdB9EDzPAvTLBVLeJJRvWhB9xRvhi2mf0IG2zQ4d4iFiwLD8cM4z2ujaNhYWPj5NXEkCK105ltvObE9BQuNUWmht5fU2Jl0gsZFuo5eRt2TWCt/4q4xmkajgm31F55t5HDxBJsTlFLwYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJeWTgJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJeWTgJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3531F000C4;
	Sat, 17 Oct 2026 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260055;
	bh=o8utehvZ8B+cPUMMrZhkDEuZ7pIDTJYtZr7XopuhtFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJeWTgJEPsOjxZVsE3Xy29mFIFTRGGZUOGmAYZSuWeC5pMMLBX970pgda9AG9c6kX
	 8fSY1avrtsufr5Vr4S3e77G0fy90MEnlFO2dPsid7JbsCpc7SSvPS3r7J7MKoGQ8zg
	 DfRITSHCKwZFc4NRPTATOUyrgL9pHWo386sNKpjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sun YangKai <sunyangkai@fnnas.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1419/1674] btrfs: check if root is readonly when setting posix acl
Date: Sat, 17 Oct 2026 18:01:31 +0200
Message-ID: <20261017160507.602990872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/btrfs/acl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 7427449a04a3f..eb78685f1c466 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -117,6 +117,9 @@ int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
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



