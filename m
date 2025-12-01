Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB893064A5;
	Mon,  1 Dec 2025 11:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588607; cv=none; b=qjbAaUppNABgpm0AZZOznqMfWvklUVD7A12jhfA7iPFGfH/IHC2IxNFKNyLTpgO+W6rxSI867bRdEHugretCZmYemH/rXLaFgEhGAkzvAqsmeeCBkUHVGMdcL2ZC9X5tXSZ6VDsNr7XOayiaBszYyVPA71MleVxY5l4sHy/fnb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588607; c=relaxed/simple;
	bh=5B/m+GiHA30OtP82Ft/L2zuviOAt6oI2BBYCLsZBWys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7JwskX2qWd0ZmsfqysZUpZ5rIRPsU6vxOttPXgFPFO5NS/NNHOFh0OIElqcP8eg2/Lx9PA6WpRjQ6k8TTzlP4Yga3jleiYbDwJYnvSnvCWinmK1b1zcSH/vpk0HmkuFMTuAkzVp8bkolzbmCcqWBCymhG4hpFJenx+4Fr/4CBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWbh1eFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWbh1eFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6D3C4CEF1;
	Mon,  1 Dec 2025 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588607;
	bh=5B/m+GiHA30OtP82Ft/L2zuviOAt6oI2BBYCLsZBWys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWbh1eFvsxGuAxm40SFTfjzXThl8QoD6n78bdu/N5a7FlQ/7I4+to4INqdDciiR1B
	 CdDEmR/iAownICiXZb96DumtRD2rXRLiLTT73jZ2LML2rWjTbSy6TDabVpfMzE0LEN
	 G3Vgv/jk6n7YqO3Ks/5AVquDLqikFSm7+kesh+/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yikang Yue <yikangy2@illinois.edu>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/187] fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink
Date: Mon,  1 Dec 2025 12:23:35 +0100
Message-ID: <20251201112245.101459426@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yikang Yue <yikangy2@illinois.edu>

[ Upstream commit 32058c38d3b79a28963a59ac0353644dc24775cd ]

The function call new_inode() is a primitive for allocating an inode in memory,
rather than planning disk space for it. Therefore, -ENOMEM should be returned
as the error code rather than -ENOSPC.

To be specific, new_inode()'s call path looks like this:
new_inode
  new_inode_pseudo
    alloc_inode
      ops->alloc_inode (hpfs_alloc_inode)
        alloc_inode_sb
          kmem_cache_alloc_lru

Therefore, the failure of new_inode() indicates a memory presure issue (-ENOMEM),
not a lack of disk space. However, the current implementation of
hpfs_mkdir/create/mknod/symlink incorrectly returns -ENOSPC when new_inode() fails.
This patch fix this by set err to -ENOMEM before the goto statement.

BTW, we also noticed that other nested calls within these four functions,
like hpfs_alloc_f/dnode and hpfs_add_dirent, might also fail due to memory presure.
But similarly, only -ENOSPC is returned. Addressing these will involve code
modifications in other functions, and we plan to submit dedicated patches for these
issues in the future. For this patch, we focus on new_inode().

Signed-off-by: Yikang Yue <yikangy2@illinois.edu>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hpfs/namei.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 1aee39160ac5b..bc1309ef4cfa5 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -52,8 +52,10 @@ static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	dee.fnode = cpu_to_le32(fno);
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail2;
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
@@ -154,9 +156,10 @@ static int hpfs_create(struct inode *dir, struct dentry *dentry, umode_t mode, b
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
-	
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	result->i_mode |= S_IFREG;
@@ -241,9 +244,10 @@ static int hpfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, de
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
-
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
@@ -317,8 +321,10 @@ static int hpfs_symlink(struct inode *dir, struct dentry *dentry, const char *sy
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
+	}
 	result->i_ino = fno;
 	hpfs_init_inode(result);
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
-- 
2.51.0



