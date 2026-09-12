Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124BD312834;
	Sat, 12 Sep 2026 09:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204309; cv=none; b=rB2hpkgv/6olwSsnE3mbiSS+JYtFBvhKrHgWOAuNK5deFe/OQFrGvNQrgWZ+tK1dOhoGHFzzseJqxXPKoV3oqNGbflAE07Nf/Wd8sAipPjaf5MEvMC8vFlB3OAnI6GyF/+mm5HfTyOuL8T1b33GWSVRGSGCae7oDJHLXbuijKHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204309; c=relaxed/simple;
	bh=jIFGQVIfwlpCGQ08UQ+ofhcaZ1S0QPtg8NxagM99wlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MC6/z0G7fZe7Rx/mmcNi8BQ3jbGatL5oCk6HhZHMqX2SY/jvjbwggWIKy1fwFaopGjIc15Tudn9NCNrXdvkbpeP/WbCLpW1c1ZdcpZWjwr0W84DTgl41YQdYv3wHJ9jV3j/WfQU57t683X2KHwpz0H4M56m8fpUHP2bhDAf7jDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQ34yGlE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQ34yGlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E481F000FF;
	Sat, 12 Sep 2026 09:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204307;
	bh=47xu7wcmp8iBgsrwZsodZ3M+zNjwKHv2OuyN9wBU0jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQ34yGlEEHus8GMz03xQ8wdCbZ+W0GZJkXgV6Fbr8mk0IItpF4v1vzI5iztbb98vH
	 HHWEuLT8hhoFnMHMRjQ01tuT17IArjcEDbR0I1nf/S4uOgNQwnxGU235cs+7ME1BUV
	 w1Ep4XlJ0OzFRNqmYw8L1Ca0TNaENd/G/ZoO+aGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1585/1815] fuse: check for NULL root inode in fuse_fill_super_submount
Date: Sat, 12 Sep 2026 08:55:35 +0200
Message-ID: <20260912065726.199145041@linuxfoundation.org>
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
index a51be4221a329..c219622720fef 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1644,6 +1644,8 @@ static int fuse_fill_super_submount(struct super_block *sb,
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



