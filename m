Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F235186E36;
	Mon, 12 Aug 2024 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479257; cv=none; b=IiysR/+/H2ly7UlEWxuPxqCQ0fDK346lgFdJGqjEcSEIFv0DgMgiElRqSTEkQG0q7GS+Igyv2Dv/Y/7w/9HtHbXBy8Zgn4rqQfrQjdYOVZEtMosvErsQILmCvJ6ggj4JJdBPOF/VlXLIf4A8DARyqIGzIPlxTJxmR3Li+iW4hMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479257; c=relaxed/simple;
	bh=GWznM5V3p/P+GvEkcSCtRpBshFF4QPvodoH+p6hcGX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMJaYZWQfWMV5LRLGilK5aWWsLDRFtJz7EpgjqNUILOihEGiT2hhKNSNsvmpxm2jdKOVsdiLXVdULdaZf3cG+A81VCKvs1Jd+hF+H7jeNvDuBcsQShOWQXNeHUV8Si+g5FkWfXRGlYiDSRuU57xK6XYwM4c4FuuCZI4QC0Efl2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhmJdEIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhmJdEIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709AEC32782;
	Mon, 12 Aug 2024 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479256;
	bh=GWznM5V3p/P+GvEkcSCtRpBshFF4QPvodoH+p6hcGX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhmJdEItUrgyyiSvqp7WEemj3yWEKFcQbudy+QPjMPVdFp6YzoC3Y/TTE/7JiVqRq
	 wMiE2JAqemPw435vmw06F3v2L4kJUO58OZbD4bnUCAQNLT0urBiH5FJGh/smsaRnDJ
	 BRLdNz4OZJXrYedVayUpQXXqYDT/uZ+yEmSubsNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>,
	Tom Talpey <tom@talpey.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/189] smb: client: handle lack of FSCTL_GET_REPARSE_POINT support
Date: Mon, 12 Aug 2024 18:01:04 +0200
Message-ID: <20240812160132.459955293@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

[ Upstream commit 4b96024ef2296b1d323af327cae5e52809b61420 ]

As per MS-FSA 2.1.5.10.14, support for FSCTL_GET_REPARSE_POINT is
optional and if the server doesn't support it,
STATUS_INVALID_DEVICE_REQUEST must be returned for the operation.

If we find files with reparse points and we can't read them due to
lack of client or server support, just ignore it and then treat them
as regular files or junctions.

Fixes: 5f71ebc41294 ("smb: client: parse reparse point flag in create response")
Reported-by: Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>
Tested-by: Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c     | 17 +++++++++++++++--
 fs/smb/client/reparse.c   |  4 ++++
 fs/smb/client/reparse.h   | 19 +++++++++++++++++--
 fs/smb/client/smb2inode.c |  2 ++
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 9cdbc3ccc1d14..e74ba047902d8 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1023,13 +1023,26 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 	}
 
 	rc = -EOPNOTSUPP;
-	switch ((data->reparse.tag = tag)) {
-	case 0: /* SMB1 symlink */
+	data->reparse.tag = tag;
+	if (!data->reparse.tag) {
 		if (server->ops->query_symlink) {
 			rc = server->ops->query_symlink(xid, tcon,
 							cifs_sb, full_path,
 							&data->symlink_target);
 		}
+		if (rc == -EOPNOTSUPP)
+			data->reparse.tag = IO_REPARSE_TAG_INTERNAL;
+	}
+
+	switch (data->reparse.tag) {
+	case 0: /* SMB1 symlink */
+		break;
+	case IO_REPARSE_TAG_INTERNAL:
+		rc = 0;
+		if (le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY) {
+			cifs_create_junction_fattr(fattr, sb);
+			goto out;
+		}
 		break;
 	case IO_REPARSE_TAG_MOUNT_POINT:
 		cifs_create_junction_fattr(fattr, sb);
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index a0ffbda907331..689d8a506d459 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -505,6 +505,10 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	}
 
 	switch (tag) {
+	case IO_REPARSE_TAG_INTERNAL:
+		if (!(fattr->cf_cifsattrs & ATTR_DIRECTORY))
+			return false;
+		fallthrough;
 	case IO_REPARSE_TAG_DFS:
 	case IO_REPARSE_TAG_DFSR:
 	case IO_REPARSE_TAG_MOUNT_POINT:
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 6b55d1df9e2f8..2c0644bc4e65a 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -12,6 +12,12 @@
 #include "fs_context.h"
 #include "cifsglob.h"
 
+/*
+ * Used only by cifs.ko to ignore reparse points from files when client or
+ * server doesn't support FSCTL_GET_REPARSE_POINT.
+ */
+#define IO_REPARSE_TAG_INTERNAL ((__u32)~0U)
+
 static inline dev_t reparse_nfs_mkdev(struct reparse_posix_data *buf)
 {
 	u64 v = le64_to_cpu(*(__le64 *)buf->DataBuffer);
@@ -78,10 +84,19 @@ static inline u32 reparse_mode_wsl_tag(mode_t mode)
 static inline bool reparse_inode_match(struct inode *inode,
 				       struct cifs_fattr *fattr)
 {
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct timespec64 ctime = inode_get_ctime(inode);
 
-	return (CIFS_I(inode)->cifsAttrs & ATTR_REPARSE) &&
-		CIFS_I(inode)->reparse_tag == fattr->cf_cifstag &&
+	/*
+	 * Do not match reparse tags when client or server doesn't support
+	 * FSCTL_GET_REPARSE_POINT.  @fattr->cf_cifstag should contain correct
+	 * reparse tag from query dir response but the client won't be able to
+	 * read the reparse point data anyway.  This spares us a revalidation.
+	 */
+	if (cinode->reparse_tag != IO_REPARSE_TAG_INTERNAL &&
+	    cinode->reparse_tag != fattr->cf_cifstag)
+		return false;
+	return (cinode->cifsAttrs & ATTR_REPARSE) &&
 		timespec64_equal(&ctime, &fattr->cf_ctime);
 }
 
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 86f8c81791374..28031c7ba6b19 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -930,6 +930,8 @@ int smb2_query_path_info(const unsigned int xid,
 
 	switch (rc) {
 	case 0:
+		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
+		break;
 	case -EOPNOTSUPP:
 		/*
 		 * BB TODO: When support for special files added to Samba
-- 
2.43.0



