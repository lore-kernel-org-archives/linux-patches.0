Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CF22ECE80;
	Tue, 17 Jun 2025 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174956; cv=none; b=SPuEcZ32nfWxB4Zn1scffxOwST+9VpcBM52t2IyY8rgL2qJsZTexbfGV4mCKiwXyV2XAZ5AU6Ocu8kV5XOr8YYy0HMRQMxlz+G0BhOpeusXzQ2W4svgTdAMP6jjY7hPPwdgNYVqm/QSYZ3uaXEVgZDghu4ud6R29Vpl7QFMxqg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174956; c=relaxed/simple;
	bh=bqbNnGCXfgY6gcJZu1N1t1sdo0QcLU9X7j6fpynzIGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMHRoOesxqPnJMlck8e9Pn3azhymMKSADr3Chk6hgjPMY1Kb6Xt6S/m0ggvLFtaAEgb2Cl4HmAVpE6G3kGhyPuuuFl+bX/5US3WMFRyX+4FK/ONmyg1B+KXcOsk8Urrc+7W2vhG2zNIjEejlui9KxE/QvrOVBWMOiH2FphFNa1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/NS4pWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/NS4pWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AEDC4CEE3;
	Tue, 17 Jun 2025 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174956;
	bh=bqbNnGCXfgY6gcJZu1N1t1sdo0QcLU9X7j6fpynzIGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/NS4pWnfbygE2HaMkAT1F/2WYggUFZqmQRcEHqfHZrDfHQ/sGKPiiFLxGSdtd179
	 re2X8FQuvE7xXmWF+9wMCrRlxfatMAVkd0R8OQvaIECww5RA7vh73p4JU2uepAWuG8
	 E1vOYTIyCXj385yAXvbip62eWuJlnV9jLe3D+nNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 037/780] erofs: fix file handle encoding for 64-bit NIDs
Date: Tue, 17 Jun 2025 17:15:45 +0200
Message-ID: <20250617152453.011905604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit 510de8363f2c3d8e67fa9dfb2366e821382036e0 ]

EROFS uses NID to indicate the on-disk inode offset, which can
exceed 32 bits. However, the default encode_fh uses the ino32,
thus it doesn't work if the image is larger than 128GiB.

Let's introduce our own helpers to encode file handles.

It's easy to reproduce:
  1. prepare an erofs image with nid bigger than U32_MAX
  2. mount -t erofs foo.img /mnt/erofs
  3. set exportfs with configuration: /mnt/erofs *(rw,sync,
     no_root_squash)
  4. mount -t nfs $IP:/mnt/erofs /mnt/nfs
  5. md5sum /mnt/nfs/foo # foo is the file which nid bigger
     than U32_MAX.  # you will get ESTALE error.

In the case of overlayfs, the underlying filesystem's file
handle is encoded in ovl_fb.fid, which is similar to NFS's
case. If the NID of file is larger than U32_MAX, the overlay
will get -ESTALE error when calls exportfs_decode_fh.

Fixes: 3e917cc305c6 ("erofs: make filesystem exportable")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250507094015.14007-1-lihongbo22@huawei.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 44 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index da6ee7c39290d..bcb99c3c2594b 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -510,24 +510,52 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 	return 0;
 }
 
-static struct inode *erofs_nfs_get_inode(struct super_block *sb,
-					 u64 ino, u32 generation)
+static int erofs_encode_fh(struct inode *inode, u32 *fh, int *max_len,
+			   struct inode *parent)
 {
-	return erofs_iget(sb, ino);
+	erofs_nid_t nid = EROFS_I(inode)->nid;
+	int len = parent ? 6 : 3;
+
+	if (*max_len < len) {
+		*max_len = len;
+		return FILEID_INVALID;
+	}
+
+	fh[0] = (u32)(nid >> 32);
+	fh[1] = (u32)(nid & 0xffffffff);
+	fh[2] = inode->i_generation;
+
+	if (parent) {
+		nid = EROFS_I(parent)->nid;
+
+		fh[3] = (u32)(nid >> 32);
+		fh[4] = (u32)(nid & 0xffffffff);
+		fh[5] = parent->i_generation;
+	}
+
+	*max_len = len;
+	return parent ? FILEID_INO64_GEN_PARENT : FILEID_INO64_GEN;
 }
 
 static struct dentry *erofs_fh_to_dentry(struct super_block *sb,
 		struct fid *fid, int fh_len, int fh_type)
 {
-	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
-				    erofs_nfs_get_inode);
+	if ((fh_type != FILEID_INO64_GEN &&
+	     fh_type != FILEID_INO64_GEN_PARENT) || fh_len < 3)
+		return NULL;
+
+	return d_obtain_alias(erofs_iget(sb,
+		((u64)fid->raw[0] << 32) | fid->raw[1]));
 }
 
 static struct dentry *erofs_fh_to_parent(struct super_block *sb,
 		struct fid *fid, int fh_len, int fh_type)
 {
-	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
-				    erofs_nfs_get_inode);
+	if (fh_type != FILEID_INO64_GEN_PARENT || fh_len < 6)
+		return NULL;
+
+	return d_obtain_alias(erofs_iget(sb,
+		((u64)fid->raw[3] << 32) | fid->raw[4]));
 }
 
 static struct dentry *erofs_get_parent(struct dentry *child)
@@ -543,7 +571,7 @@ static struct dentry *erofs_get_parent(struct dentry *child)
 }
 
 static const struct export_operations erofs_export_ops = {
-	.encode_fh = generic_encode_ino32_fh,
+	.encode_fh = erofs_encode_fh,
 	.fh_to_dentry = erofs_fh_to_dentry,
 	.fh_to_parent = erofs_fh_to_parent,
 	.get_parent = erofs_get_parent,
-- 
2.39.5



