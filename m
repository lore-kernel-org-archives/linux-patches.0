Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003DA13B7AE;
	Thu, 23 May 2024 13:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470666; cv=none; b=t1p5W96K4slUm/w0CaMRKa8u9YgvhmqLDpT0ZGJHBsSSj/xxkNq/l7EhdBB3B0l+l8uY9OWkiOkVn1TIStloK81t/xas8N0uJ5BzSTsHFNxkZi7KOJLwGsxqrJARE52O50QJcUeeVkChcC269nWq4vFRfU6tCRU99VJj8H4f830=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470666; c=relaxed/simple;
	bh=uiPwcAQOxbfHo3gn7jfFVEJZDQBKpSaffxprEomLZ1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlzYBnKS3D4KxCbNdun1Jt54XOVRvu2Vp/Zr4fgQkwY1iwJ/Ztwb6+VWqALB3jrbbe2BNSJSvQ4DAIXmY5vi28GwoaPnQMKgmHWrtpTzRalZqcbnuQ49j0cXq0RSgs1d6SWU9EbTBoYnqpr7cVcY29GkLs79t9bUXFkth1LBewo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IszQq43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IszQq43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31448C32781;
	Thu, 23 May 2024 13:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470665;
	bh=uiPwcAQOxbfHo3gn7jfFVEJZDQBKpSaffxprEomLZ1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IszQq43GznkKmvQYmKO1d0pNybubZXA8/RvKBagLFjMk60LHXC8rW/29vgwnsoAa
	 iyCII3ZswGCbqjqinZ9ic80a8vZIZqXi18aZm7Rh0ySPhxk5ZdSfttDgvVb0gz9hEw
	 z/6x8FXMYhQ2cMcdun1AdVMB0mVYblJe6fhoB/J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/102] smb: client: handle special files and symlinks in SMB3 POSIX
Date: Thu, 23 May 2024 15:12:43 +0200
Message-ID: <20240523130343.150748137@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 9c38568a75c160786d5f5d5b96aeefed0c1b76bd ]

Parse reparse points in SMB3 posix query info as they will be
supported and required by the new specification.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 50 +++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 89dfb405f9c1e..b8260ace2bee9 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -693,29 +693,36 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
 		fattr->cf_mtime.tv_sec += tcon->ses->server->timeAdj;
 	}
 
+	/*
+	 * The srv fs device id is overridden on network mount so setting
+	 * @fattr->cf_rdev isn't needed here.
+	 */
 	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
 	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
 	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
-
 	fattr->cf_nlink = le32_to_cpu(info->HardLinks);
 	fattr->cf_mode = (umode_t) le32_to_cpu(info->Mode);
-	/* The srv fs device id is overridden on network mount so setting rdev isn't needed here */
-	/* fattr->cf_rdev = le32_to_cpu(info->DeviceId); */
 
-	if (data->symlink) {
-		fattr->cf_mode |= S_IFLNK;
-		fattr->cf_dtype = DT_LNK;
-		fattr->cf_symlink_target = data->symlink_target;
-		data->symlink_target = NULL;
-	} else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
+	if (cifs_open_data_reparse(data) &&
+	    cifs_reparse_point_to_fattr(cifs_sb, fattr, data))
+		goto out_reparse;
+
+	fattr->cf_mode &= ~S_IFMT;
+	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
 		fattr->cf_mode |= S_IFDIR;
 		fattr->cf_dtype = DT_DIR;
 	} else { /* file */
 		fattr->cf_mode |= S_IFREG;
 		fattr->cf_dtype = DT_REG;
 	}
-	/* else if reparse point ... TODO: add support for FIFO and blk dev; special file types */
 
+out_reparse:
+	if (S_ISLNK(fattr->cf_mode)) {
+		if (likely(data->symlink_target))
+			fattr->cf_eof = strnlen(data->symlink_target, PATH_MAX);
+		fattr->cf_symlink_target = data->symlink_target;
+		data->symlink_target = NULL;
+	}
 	sid_to_id(cifs_sb, owner, fattr, SIDOWNER);
 	sid_to_id(cifs_sb, group, fattr, SIDGROUP);
 
@@ -740,25 +747,25 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	if (tag == IO_REPARSE_TAG_NFS && buf) {
 		switch (le64_to_cpu(buf->InodeType)) {
 		case NFS_SPECFILE_CHR:
-			fattr->cf_mode |= S_IFCHR | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFCHR;
 			fattr->cf_dtype = DT_CHR;
 			fattr->cf_rdev = nfs_mkdev(buf);
 			break;
 		case NFS_SPECFILE_BLK:
-			fattr->cf_mode |= S_IFBLK | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFBLK;
 			fattr->cf_dtype = DT_BLK;
 			fattr->cf_rdev = nfs_mkdev(buf);
 			break;
 		case NFS_SPECFILE_FIFO:
-			fattr->cf_mode |= S_IFIFO | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFIFO;
 			fattr->cf_dtype = DT_FIFO;
 			break;
 		case NFS_SPECFILE_SOCK:
-			fattr->cf_mode |= S_IFSOCK | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFSOCK;
 			fattr->cf_dtype = DT_SOCK;
 			break;
 		case NFS_SPECFILE_LNK:
-			fattr->cf_mode = S_IFLNK | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFLNK;
 			fattr->cf_dtype = DT_LNK;
 			break;
 		default:
@@ -770,29 +777,29 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
-		fattr->cf_mode |= S_IFLNK | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
 		break;
 	case IO_REPARSE_TAG_LX_FIFO:
-		fattr->cf_mode |= S_IFIFO | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFIFO;
 		fattr->cf_dtype = DT_FIFO;
 		break;
 	case IO_REPARSE_TAG_AF_UNIX:
-		fattr->cf_mode |= S_IFSOCK | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFSOCK;
 		fattr->cf_dtype = DT_SOCK;
 		break;
 	case IO_REPARSE_TAG_LX_CHR:
-		fattr->cf_mode |= S_IFCHR | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFCHR;
 		fattr->cf_dtype = DT_CHR;
 		break;
 	case IO_REPARSE_TAG_LX_BLK:
-		fattr->cf_mode |= S_IFBLK | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFBLK;
 		fattr->cf_dtype = DT_BLK;
 		break;
 	case 0: /* SMB1 symlink */
 	case IO_REPARSE_TAG_SYMLINK:
 	case IO_REPARSE_TAG_NFS:
-		fattr->cf_mode = S_IFLNK | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
 		break;
 	default:
@@ -832,6 +839,7 @@ static void cifs_open_info_to_fattr(struct cifs_fattr *fattr,
 	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
 	fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
 
+	fattr->cf_mode = cifs_sb->ctx->file_mode;
 	if (cifs_open_data_reparse(data) &&
 	    cifs_reparse_point_to_fattr(cifs_sb, fattr, data))
 		goto out_reparse;
-- 
2.43.0



