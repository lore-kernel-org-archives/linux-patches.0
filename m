Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7A21386CB;
	Tue, 27 Feb 2024 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043354; cv=none; b=CRDYUFttQ4VLl1sr0WmglBmCSjIyaGFWVVieOp5tcOQidWNFdiMb5tJPoo6XQH2muAs7Y72PjcjnM3OeAwAPHSMIoQTPr1IXHtzahB1Gpklnj4hZTGnGXc59UZgjk4jnYZaR2aQNa+HlB7bQ/gchjdojW8b8a5h+3Kx0tKSojNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043354; c=relaxed/simple;
	bh=YuvVI+ZlrHtZxQhE+ByXpg6PDzj87xrGNpNUaqNLjVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibETPqxo07fC4TssN81sDUdSrgGCvS845JRuJdXWoVCw0A2xIOb3dCXYgFJGkqyBgr+glEgN3MqBiUB8BVhvrw3jgXVF4x9jscRkNhyVmdzUsgFEV1dlZ1i7AQK9Zk9S9FSBzj2DINIGFGYnwoNHmMaeAQPUkQu0KzBV8SXxdx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ae0tT7mN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ae0tT7mN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A73C433C7;
	Tue, 27 Feb 2024 14:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043354;
	bh=YuvVI+ZlrHtZxQhE+ByXpg6PDzj87xrGNpNUaqNLjVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ae0tT7mNjPGwzYRKsZoMbmS4DW6CH4vfxe9KPnmczyjw0S/jzANJQNT29Vm0bIm39
	 76fBzugN8pCTXWvwNLtKDg5KOhJ5LJ9/waNYFdBXxOwOupylId0EshfukudMog1hQN
	 kCZS5sJ7qWq0J3iNdKAdhb+WcLCI58D7UoDrzLXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/195] smb: client: set correct d_type for reparse points under DFS mounts
Date: Tue, 27 Feb 2024 14:25:39 +0100
Message-ID: <20240227131613.069761373@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 55c7788c37242702868bfac7861cdf0c358d6c3d ]

Send query dir requests with an info level of
SMB_FIND_FILE_FULL_DIRECTORY_INFO rather than
SMB_FIND_FILE_DIRECTORY_INFO when the client is generating its own
inode numbers (e.g. noserverino) so that reparse tags still
can be parsed directly from the responses, but server won't
send UniqueId (server inode number)

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/readdir.c | 15 ++++++++-------
 fs/smb/client/smb2pdu.c |  6 ++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 2d75ba5aaa8ad..5990bdbae598f 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -304,14 +304,16 @@ cifs_dir_info_to_fattr(struct cifs_fattr *fattr, FILE_DIRECTORY_INFO *info,
 }
 
 static void cifs_fulldir_info_to_fattr(struct cifs_fattr *fattr,
-				       SEARCH_ID_FULL_DIR_INFO *info,
+				       const void *info,
 				       struct cifs_sb_info *cifs_sb)
 {
+	const FILE_FULL_DIRECTORY_INFO *di = info;
+
 	__dir_info_to_fattr(fattr, info);
 
-	/* See MS-FSCC 2.4.19 FileIdFullDirectoryInformation */
+	/* See MS-FSCC 2.4.14, 2.4.19 */
 	if (fattr->cf_cifsattrs & ATTR_REPARSE)
-		fattr->cf_cifstag = le32_to_cpu(info->EaSize);
+		fattr->cf_cifstag = le32_to_cpu(di->EaSize);
 	cifs_fill_common_info(fattr, cifs_sb);
 }
 
@@ -425,7 +427,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	} else /* not srvinos - BB fixme add check for backlevel? */ {
-		cifsFile->srch_inf.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
+		cifsFile->srch_inf.info_level = SMB_FIND_FILE_FULL_DIRECTORY_INFO;
 	}
 
 	search_flags = CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH_RETURN_RESUME;
@@ -1019,10 +1021,9 @@ static int cifs_filldir(char *find_entry, struct file *file,
 				       (FIND_FILE_STANDARD_INFO *)find_entry,
 				       cifs_sb);
 		break;
+	case SMB_FIND_FILE_FULL_DIRECTORY_INFO:
 	case SMB_FIND_FILE_ID_FULL_DIR_INFO:
-		cifs_fulldir_info_to_fattr(&fattr,
-					   (SEARCH_ID_FULL_DIR_INFO *)find_entry,
-					   cifs_sb);
+		cifs_fulldir_info_to_fattr(&fattr, find_entry, cifs_sb);
 		break;
 	default:
 		cifs_dir_info_to_fattr(&fattr,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c1fc1651d8b69..4c1231496a725 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5010,6 +5010,9 @@ int SMB2_query_directory_init(const unsigned int xid,
 	case SMB_FIND_FILE_POSIX_INFO:
 		req->FileInformationClass = SMB_FIND_FILE_POSIX_INFO;
 		break;
+	case SMB_FIND_FILE_FULL_DIRECTORY_INFO:
+		req->FileInformationClass = FILE_FULL_DIRECTORY_INFORMATION;
+		break;
 	default:
 		cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
 			info_level);
@@ -5079,6 +5082,9 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 		/* note that posix payload are variable size */
 		info_buf_size = sizeof(struct smb2_posix_info);
 		break;
+	case SMB_FIND_FILE_FULL_DIRECTORY_INFO:
+		info_buf_size = sizeof(FILE_FULL_DIRECTORY_INFO);
+		break;
 	default:
 		cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
 			 srch_inf->info_level);
-- 
2.43.0



