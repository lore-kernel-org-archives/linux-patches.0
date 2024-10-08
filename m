Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191C31DF98E;
	Tue,  8 Oct 2024 12:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390266; cv=none; b=gfRuwsfVjsIEHG5IAZNOPI2qTnM6ChcaY1ZUTQARQ/gfuCJ0vCpwoRmRd4HT/tgTFefUd/S2XuKDL8a9TROrdLTJpdNZMWZcUpGxfwvB1eJBaUf5KomRw19ByUkbQp3pQwpTOEW0Zf8jpFd8HG2SWBR6du3xz2Xa+binEOpxRiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390266; c=relaxed/simple;
	bh=0B+U/dLIko9gTvP/hBcUBLfFLTXB6et4xCxPKzTwCGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgAZAPzOKifkMYgByO87FPs+uv2cS9yq4hFS6kRaPfJR008U/p2Htk3FKWXqhiEPcrc44cj0vuXR86K7BxoMjW1a+bmEjA/312ksGOswD2G9H76NN1p17We/WLJhc3s1hMeM3N+9DBqJ5c++C/oIqZoZbegBrKTcm/8wPUv0B2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EI46NDGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EI46NDGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71839C4CED8;
	Tue,  8 Oct 2024 12:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390265;
	bh=0B+U/dLIko9gTvP/hBcUBLfFLTXB6et4xCxPKzTwCGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EI46NDGZY3ICUJr+MhoiDAy3ozi8Eghp8RRLxDTf9vEUR36uz8wTuHb4Zsvgk5b0i
	 TZYSsde5vxq+YP19akxLiHavgI5TDW6ZdO59MAXuf8Ax/dz1I0P/95YuyE6xg1MNkf
	 UHhJsxODOfJXlnBfpfrtYPzTrDT7k6JW8RNdcFCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Fei Lv <feilv@asrmicro.com>
Subject: [PATCH 6.10 240/482] ovl: fsync after metadata copy-up
Date: Tue,  8 Oct 2024 14:05:03 +0200
Message-ID: <20241008115657.741313238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 7d6899fb69d25e1bc6f4700b7c1d92e6b608593d ]

For upper filesystems which do not use strict ordering of persisting
metadata changes (e.g. ubifs), when overlayfs file is modified for
the first time, copy up will create a copy of the lower file and
its parent directories in the upper layer. Permission lost of the
new upper parent directory was observed during power-cut stress test.

Fix by moving the fsync call to after metadata copy to make sure that the
metadata copied up directory and files persists to disk before renaming
from tmp to final destination.

With metacopy enabled, this change will hurt performance of workloads
such as chown -R, so we keep the legacy behavior of fsync only on copyup
of data.

Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxj-pOvmw1-uXR3qVdqtLjSkwcR9nVKcNU_vC10Zyf2miQ@mail.gmail.com/
Reported-and-tested-by: Fei Lv <feilv@asrmicro.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 43 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a5ef2005a2cc5..051a802893a18 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -243,8 +243,24 @@ static int ovl_verify_area(loff_t pos, loff_t pos2, loff_t len, loff_t totlen)
 	return 0;
 }
 
+static int ovl_sync_file(struct path *path)
+{
+	struct file *new_file;
+	int err;
+
+	new_file = ovl_path_open(path, O_LARGEFILE | O_RDONLY);
+	if (IS_ERR(new_file))
+		return PTR_ERR(new_file);
+
+	err = vfs_fsync(new_file, 0);
+	fput(new_file);
+
+	return err;
+}
+
 static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
-			    struct file *new_file, loff_t len)
+			    struct file *new_file, loff_t len,
+			    bool datasync)
 {
 	struct path datapath;
 	struct file *old_file;
@@ -342,7 +358,8 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 
 		len -= bytes;
 	}
-	if (!error && ovl_should_sync(ofs))
+	/* call fsync once, either now or later along with metadata */
+	if (!error && ovl_should_sync(ofs) && datasync)
 		error = vfs_fsync(new_file, 0);
 out_fput:
 	fput(old_file);
@@ -574,6 +591,7 @@ struct ovl_copy_up_ctx {
 	bool indexed;
 	bool metacopy;
 	bool metacopy_digest;
+	bool metadata_fsync;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -634,7 +652,8 @@ static int ovl_copy_up_data(struct ovl_copy_up_ctx *c, const struct path *temp)
 	if (IS_ERR(new_file))
 		return PTR_ERR(new_file);
 
-	err = ovl_copy_up_file(ofs, c->dentry, new_file, c->stat.size);
+	err = ovl_copy_up_file(ofs, c->dentry, new_file, c->stat.size,
+			       !c->metadata_fsync);
 	fput(new_file);
 
 	return err;
@@ -701,6 +720,10 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
 		err = ovl_set_attr(ofs, temp, &c->stat);
 	inode_unlock(temp->d_inode);
 
+	/* fsync metadata before moving it into upper dir */
+	if (!err && ovl_should_sync(ofs) && c->metadata_fsync)
+		err = ovl_sync_file(&upperpath);
+
 	return err;
 }
 
@@ -860,7 +883,8 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 
 	temp = tmpfile->f_path.dentry;
 	if (!c->metacopy && c->stat.size) {
-		err = ovl_copy_up_file(ofs, c->dentry, tmpfile, c->stat.size);
+		err = ovl_copy_up_file(ofs, c->dentry, tmpfile, c->stat.size,
+				       !c->metadata_fsync);
 		if (err)
 			goto out_fput;
 	}
@@ -1135,6 +1159,17 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	    !kgid_has_mapping(current_user_ns(), ctx.stat.gid))
 		return -EOVERFLOW;
 
+	/*
+	 * With metacopy disabled, we fsync after final metadata copyup, for
+	 * both regular files and directories to get atomic copyup semantics
+	 * on filesystems that do not use strict metadata ordering (e.g. ubifs).
+	 *
+	 * With metacopy enabled we want to avoid fsync on all meta copyup
+	 * that will hurt performance of workloads such as chown -R, so we
+	 * only fsync on data copyup as legacy behavior.
+	 */
+	ctx.metadata_fsync = !OVL_FS(dentry->d_sb)->config.metacopy &&
+			     (S_ISREG(ctx.stat.mode) || S_ISDIR(ctx.stat.mode));
 	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
 
 	if (parent) {
-- 
2.43.0



