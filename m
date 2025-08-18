Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3062264B1;
	Mon, 18 Aug 2025 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526129; cv=none; b=j/E1nsAMZd9ZpvxFwXwaD9eFsoSACH+bk04QhHB7iVi0BbRo+XWFyME7hkEhF2Lsul2WNTabeN779hj46VNoTp1aq1Mqf/eiZkOVFGglDfniK+bXNE5vdohzTqxzdL6ZqWP0wvDtFLyEFMygzh/Bd9o+c1nl75Jlxv0xs4eKcWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526129; c=relaxed/simple;
	bh=x0p4UPjpwBQzrZiyW7VMX3V+csqqGLNoQuZjdks15YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilddWmBMKDEdmar4LpXc1CCrvyIgx88esgYIpnyT54VSUEfI2EAKwDo6ACQWghVGARxF8Ncw17Va80k3jTJ7f0n85w+wmY7lywYr8pNYAz6czWdDmtiWEev1V5v273TggMojvtCmgnVgZQe5G7syGv/OT/kX65/ju+c9noQbnrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFeCxThl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFeCxThl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11768C2BC86;
	Mon, 18 Aug 2025 14:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526128;
	bh=x0p4UPjpwBQzrZiyW7VMX3V+csqqGLNoQuZjdks15YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFeCxThlwU+l7NQlIVKXMQomsjffoQKkjrK2g/KdrEiV4mkydk+uwhEXr1og87oF+
	 4NFhsAfDFzvtA+2M9AfHw36lx+waibbEnRQJJhtWBXnUocMxE+5FQmurLwwvZKXZh0
	 cbsDQ6EFXpoYZFmsF6WHmarpu+eKnJ53CjSTFnFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Evtushenko <koevtushenko@yandex.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 466/570] pNFS: Handle RPC size limit for layoutcommits
Date: Mon, 18 Aug 2025 14:47:33 +0200
Message-ID: <20250818124523.824396490@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit d897d81671bc4615c80f4f3bd5e6b218f59df50c ]

When there are too many block extents for a layoutcommit, they may not
all fit into the maximum-sized RPC. This patch allows the generic pnfs
code to properly handle -ENOSPC returned by the block/scsi layout driver
and trigger additional layoutcommits if necessary.

Co-developed-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250630183537.196479-5-sergeybashirov@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 1a7ec68bde15..3fd0971bf16f 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -3340,6 +3340,7 @@ pnfs_layoutcommit_inode(struct inode *inode, bool sync)
 	struct nfs_inode *nfsi = NFS_I(inode);
 	loff_t end_pos;
 	int status;
+	bool mark_as_dirty = false;
 
 	if (!pnfs_layoutcommit_outstanding(inode))
 		return 0;
@@ -3391,19 +3392,23 @@ pnfs_layoutcommit_inode(struct inode *inode, bool sync)
 	if (ld->prepare_layoutcommit) {
 		status = ld->prepare_layoutcommit(&data->args);
 		if (status) {
-			put_cred(data->cred);
+			if (status != -ENOSPC)
+				put_cred(data->cred);
 			spin_lock(&inode->i_lock);
 			set_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags);
 			if (end_pos > nfsi->layout->plh_lwb)
 				nfsi->layout->plh_lwb = end_pos;
-			goto out_unlock;
+			if (status != -ENOSPC)
+				goto out_unlock;
+			spin_unlock(&inode->i_lock);
+			mark_as_dirty = true;
 		}
 	}
 
 
 	status = nfs4_proc_layoutcommit(data, sync);
 out:
-	if (status)
+	if (status || mark_as_dirty)
 		mark_inode_dirty_sync(inode);
 	dprintk("<-- %s status %d\n", __func__, status);
 	return status;
-- 
2.39.5



