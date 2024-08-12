Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C951117C7C8;
	Mon, 12 Aug 2024 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479943; cv=none; b=brWshM9hvbay9NfEA4r3AaN6TwbxV7K2eYT9qPuNIknLAIhmkwu8fS0HIcgN9f4P0WK1v6TtF9FTcQjMQZ96sSAbg+DNGzUsIVlVPx3b9KUULpQkJcd0rUnol68SWwI125sG3p8/w4DrDH6zYDi3gPNmP3hHPsFtjdLuvBJKk14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479943; c=relaxed/simple;
	bh=oVpUb2ZZBmI8P+Jd7/4HLl1X8eMps0yX1e37He3g6U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nV5WNyXiiAoj/PaX0Kql55PLZNuSdpj8i4bLpuGjrHae+K9srz1be/bKxpN90c9RHXr+58XF7Q/tWuQjxYX0Jg2tizLWln6gRzbJyseudOoX2ptnjLwZ5pCuvExQzqeJVC0xRXb/aE3M3QiOjYqZlFFk4wQCoi0qA5j4uZXoEFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNeJ1+WF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNeJ1+WF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5175DC32782;
	Mon, 12 Aug 2024 16:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479943;
	bh=oVpUb2ZZBmI8P+Jd7/4HLl1X8eMps0yX1e37He3g6U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNeJ1+WFkkoMbYJUKDmWK8AbZtSPOB6SXHHqiZInaMqs4MH7m36llX0h28sKlZC2p
	 QD5hTG9oq/TSv+QEpm7VShY1ve/7qOhFADMTO+1huiCBoPH2kAyWJ71WhQ+Y90ufDd
	 T7RhRklx2/3w/A6UvYK0G7JRvcdc7gjp2VPJvVx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>,
	Tom Talpey <tom@talpey.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 017/263] smb: client: handle lack of FSCTL_GET_REPARSE_POINT support
Date: Mon, 12 Aug 2024 18:00:18 +0200
Message-ID: <20240812160147.201273546@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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
index 4a8aa1de95223..dd0afa23734c8 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1042,13 +1042,26 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
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
index 5c02a12251c84..062b86a4936fd 100644
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



