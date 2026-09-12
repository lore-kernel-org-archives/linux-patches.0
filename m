Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025D247DD5C;
	Sat, 12 Sep 2026 13:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218758; cv=none; b=RdIsAHOBPW+6rVm1AIUDoIfVSWjFUSUZwVsGBLaQhew/ahp25kVnE0j+4zn/ymGvaLL7HTDrNfQsVssZJXnWMtDCGqo8UURdAPaVWfwM+tTHTacurjuSpIUXxnZwbRfJ2M2q0nPIUW+LAvVQybdeI2iIWpkpXF/qA1L4QiJx6Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218758; c=relaxed/simple;
	bh=9xQqmK/HuAPPWgSNI2xw8ZkgVJbb1bONrGiLI5JSoCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rg5ZTltBJx8vgoE6RUcNsmjP+j52Z6zqeHNFLmg4k8ZZzq46YLuZJS+EWlgY7IBptUBXAN+1MaUKdferaPjfXrkZfmbD/dpilG+fHi/wqBYQN2ZCFIQw2RVpaClZRuMCrTwfdLaKfFEd4VbPBT0DmyiHICSN50qX8FdxmTz9+L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPAge+Ym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPAge+Ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7041F000FF;
	Sat, 12 Sep 2026 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218754;
	bh=ZP/CV3bUz9xjJl1GI47YLTjnWwBWdzbRTSeb+NKh038=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPAge+YmEcV2hdPw5qR+U6Df4f8I+o1j1uvLRo4gPb1QQ5ekxQZdKMhf0i+qsjQsY
	 AIif1GY38rcUdjgSldMyO9or2FWTSifLitu1eGMF7g2h69Nv2YPQburgY8qAxRobaj
	 7pO2HXxWd9K4+61gs2VFkvtY6M/3QTW2ZX4xC2jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1211/1376] fuse: check for NULL root inode in fuse_fill_super_submount
Date: Sat, 12 Sep 2026 09:00:37 +0200
Message-ID: <20260912065634.541359651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit 928f659a3e3650978a5b4829cc982324f72b474b ]

fuse_iget() can return NULL when its inode allocation fails, but
fuse_fill_super_submount() passed the result straight to get_fuse_inode()
and decremented fi->nlookup without checking it:

        root = fuse_iget(sb, parent_fi->nodeid, ...);
        fi = get_fuse_inode(root);
        fi->nlookup--;

Inside fuse_iget() the inode allocation can fail and return NULL.  The
submount root takes the iget5_locked() path, whose alloc_inode() can fail
under memory pressure (the auto-submount branch can fail the same way in
new_inode() or fuse_alloc_submount_lookup()):

        inode = iget5_locked(sb, nodeid, fuse_inode_eq, fuse_inode_set,
                             &nodeid);
        if (!inode)
                return NULL;

A NULL root makes get_fuse_inode() a container_of() on NULL and the
nlookup decrement a write to a bogus address, oopsing the mount.  With
CONFIG_KASAN the following null pointer dereference is reported when the
root inode allocation of an auto-submount fails (e.g. under memory
pressure):

==================================================================
BUG: KASAN: null-ptr-deref in fuse_get_tree_submount+0x656/0x8b0
Read of size 8 at addr 00000000000002b0 by task ls/942
CPU: 0 PID: 942 Comm: ls Tainted: G W 6.6 #15
Call Trace:
 <TASK>
 fuse_get_tree_submount+0x656/0x8b0
 vfs_get_tree+0x48/0x140
 fc_mount+0x13/0x50
 fuse_dentry_automount+0x7a/0xb0
 __traverse_mounts+0xca/0x330
 step_into+0x339/0xac0
 path_lookupat+0xc5/0x2f0
 filename_lookup+0x163/0x2a0
 vfs_statx+0xd5/0x200
 do_statx+0x83/0xd0
 __x64_sys_statx+0xa0/0xc0
 do_syscall_64+0x37/0x90
 entry_SYSCALL_64_after_hwframe+0x78/0xe2
 </TASK>
==================================================================

Return -ENOMEM instead; the caller tears down the partially built
superblock on error, matching the other error returns in this
function.

Fixes: 1866d779d5d2 ("fuse: Allow fuse_fill_super_common() for submounts")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 561c2093bd14a..08a47565cdad7 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1640,6 +1640,8 @@ static int fuse_fill_super_submount(struct super_block *sb,
 	fuse_fill_attr_from_inode(&root_attr, parent_fi);
 	root = fuse_iget(sb, parent_fi->nodeid, 0, &root_attr, 0, 0,
 			 fuse_get_evict_ctr(fm->fc));
+	if (!root)
+		return -ENOMEM;
 	/*
 	 * This inode is just a duplicate, so it is not looked up and
 	 * its nlookup should not be incremented.  fuse_iget() does
-- 
2.53.0



