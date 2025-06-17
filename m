Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751E01E8332;
	Tue, 17 Jun 2025 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174471; cv=none; b=eMb/yJ0BZrEWHbxB1G2sqy87zaDRROfzmHTqor4hq4h29oJiXh/TYWL+QQh1SUC9VKUobMzZJd2jtpQCBDos9uwM23Y4ZRRVYL30vjisao1ECjAjbwK7Hfzsn7NFgpZNeejxiK33ijvctr/+ofnZH6OtSfmRSBgCzkLukBhIljs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174471; c=relaxed/simple;
	bh=BpwGGftfzDuyQ2ojm9i7RifdTIBPPlmLYqmdgPgthyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/gG9DRgMEW1RqOhr5eD4zCgEayH4AOnuQ9XTbcYW9AkMCxEo0PqLeuIsIybUGqFlQfO4Ub91RltY7gtQh1SoOWflGN6ZSgVbipQ1y3rdNushb/M7q/n0+Gk5dbSeGPXqhLvf47r+hCLv45/f6LVgTKHOHfemOXBbuI2CtEtVYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwLo/5X6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwLo/5X6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2140C4CEE3;
	Tue, 17 Jun 2025 15:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174471;
	bh=BpwGGftfzDuyQ2ojm9i7RifdTIBPPlmLYqmdgPgthyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwLo/5X6SGDTNHz33Uit0xGdRM936HKA6uoxntvSv2yloRyE1zjG0VU0Sz6Z8ciGR
	 OIhaKFvOHO2YogyjzyXRZZi//1M2wBo3s8C15yxCVT9rYa88XBUGCYaz8AkeiUEhIx
	 rOx9m99x6N9Vp4rJkN9GLPjWx4uKA3Fb2lCqa+zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/512] erofs: fix file handle encoding for 64-bit NIDs
Date: Tue, 17 Jun 2025 17:19:50 +0200
Message-ID: <20250617152420.510603383@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3421448fef0e3..1143e1913f25b 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -537,24 +537,52 @@ static int erofs_fc_parse_param(struct fs_context *fc,
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
@@ -570,7 +598,7 @@ static struct dentry *erofs_get_parent(struct dentry *child)
 }
 
 static const struct export_operations erofs_export_ops = {
-	.encode_fh = generic_encode_ino32_fh,
+	.encode_fh = erofs_encode_fh,
 	.fh_to_dentry = erofs_fh_to_dentry,
 	.fh_to_parent = erofs_fh_to_parent,
 	.get_parent = erofs_get_parent,
-- 
2.39.5



