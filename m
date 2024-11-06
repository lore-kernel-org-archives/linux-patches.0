Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D01DFE0E;
	Wed,  6 Nov 2024 12:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895821; cv=none; b=bTeXYeth+HlmiYgBRirCuN9Nx4Rv5UWQy6mHffAzFB2Es++/60r7R+FK1FfqrNcTwiUI1cbLoh5bo7hCzh1XZqnyXykR1qVaiHZ1GVzisLWMAn+iq70oY8LdoXbSASKqhXovwDPN/I62DlRbj7Sos6mn8h9Yq/6FpwrAYQGAQ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895821; c=relaxed/simple;
	bh=Kv/gyRKfIwjWg26Vud+U43WDnKPeNIwmBb+Oxinz4AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtY1GK8vRzb3C5IN3EIOHa6MduazXtwHJyqnm6npJlOOWRXiI6j9g+OFaTg1SkrogTFRKkwyjA3VEQDb72bsZwhuL6xrCa7WdwCy57xPoNey1MMSJBILxxsxLk7WkM2uW/BVtpLq4UcDXFYRMbUDhrfp1WXf+CAGJ6HrdUMa640=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsUC3jRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsUC3jRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A4EC4CECD;
	Wed,  6 Nov 2024 12:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895821;
	bh=Kv/gyRKfIwjWg26Vud+U43WDnKPeNIwmBb+Oxinz4AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsUC3jRdaYymuM+WEU/JcDLQvhW9+4JtmUiv0Eb82+Ov0y3bD73P65hmkQIspOalG
	 l2mIhddGkhh9e3DtCrK2X/3QcRDMdpZZ/D9E+AOy7W2HqlWaF90Q4Y7wgnQ2BvKEID
	 y/57RVsRYjSM/79hASGUHpNsnzeO1VYCB8AFJRrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 346/350] nilfs2: fix potential deadlock with newly created symlinks
Date: Wed,  6 Nov 2024 13:04:34 +0100
Message-ID: <20241106120329.232432634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit b3a033e3ecd3471248d474ef263aadc0059e516a upstream.

Syzbot reported that page_symlink(), called by nilfs_symlink(), triggers
memory reclamation involving the filesystem layer, which can result in
circular lock dependencies among the reader/writer semaphore
nilfs->ns_segctor_sem, s_writers percpu_rwsem (intwrite) and the
fs_reclaim pseudo lock.

This is because after commit 21fc61c73c39 ("don't put symlink bodies in
pagecache into highmem"), the gfp flags of the page cache for symbolic
links are overwritten to GFP_KERNEL via inode_nohighmem().

This is not a problem for symlinks read from the backing device, because
the __GFP_FS flag is dropped after inode_nohighmem() is called.  However,
when a new symlink is created with nilfs_symlink(), the gfp flags remain
overwritten to GFP_KERNEL.  Then, memory allocation called from
page_symlink() etc.  triggers memory reclamation including the FS layer,
which may call nilfs_evict_inode() or nilfs_dirty_inode().  And these can
cause a deadlock if they are called while nilfs->ns_segctor_sem is held:

Fix this issue by dropping the __GFP_FS flag from the page cache GFP flags
of newly created symlinks in the same way that nilfs_new_inode() and
__nilfs_read_inode() do, as a workaround until we adopt nofs allocation
scope consistently or improve the locking constraints.

Link: https://lkml.kernel.org/r/20241020050003.4308-1-konishi.ryusuke@gmail.com
Fixes: 21fc61c73c39 ("don't put symlink bodies in pagecache into highmem")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9ef37ac20608f4836256
Tested-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/namei.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -156,6 +156,9 @@ static int nilfs_symlink(struct inode *d
 	/* slow symlink */
 	inode->i_op = &nilfs_symlink_inode_operations;
 	inode_nohighmem(inode);
+	mapping_set_gfp_mask(inode->i_mapping,
+			     mapping_gfp_constraint(inode->i_mapping,
+						    ~__GFP_FS));
 	inode->i_mapping->a_ops = &nilfs_aops;
 	err = page_symlink(inode, symname, l);
 	if (err)


