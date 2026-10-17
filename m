Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2AC3B813A;
	Sat, 17 Oct 2026 18:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260702; cv=none; b=E/ywmWTITaosuDvB6bHxdhnxtJPpvBT+A1YYNodMHgPdglRMcKwcI709Syxgf9nzTBmlFWuGyvKGNh2VLEsrt9Stu59GSjwqUiSgUi5DFzNgx7BlJD3VfZXv1P48vcPBTHSS0q3P8Ulu186reLMf8jGTmJTAullWX94BjOoPz08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260702; c=relaxed/simple;
	bh=HGNPqUIZHGSeDKFu/RbKVZ5qA3edNOx5xjw6URazPTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZNxpbfN3KVGVHkMHMwx2tvn7FZMOb0WngDVh3zSEXh/DS2KtpibUTbeRgDZgY1sfiLKLzreWZFuLu4b2cg34CImu12GrTBYoCp6LxNQ5SCTLt6iXBLGBxpNsY3bN4210fqiuj5CxejepXRTl+mo85D6BvL2/1Ncv2Gdj4slsuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4Z6998M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4Z6998M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01E81F000C4;
	Sat, 17 Oct 2026 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260701;
	bh=LQvJcglAZ8rEgDgSSETa/qyrYwfaXhbt5QjXcPYq1e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4Z6998M5b1h1LJS20ElWgIVil0mlSO1dyD5Nlq+Oe6B7H0AEYtrQyjOAb0lUs2Bv
	 5TjPKa7Hft701QrhCaNy7de5xsirfIn0gTRmaz+QR7U0q5aJgULOHHMH0QSgtlYgKo
	 rq3hGBva0oSTYjRZ1wq1iNNVDsCYpDkDkKDa/Atk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1591/1674] smb: client: honor forceuid/forcegid when mapping SIDs to uid/gid
Date: Sat, 17 Oct 2026 18:04:23 +0200
Message-ID: <20261017160511.929749056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 18a72975e9f35aadecc75b031f693f2d1f49308f ]

When the administrator mounts with forceuid or forcegid (uid=/gid=
mount options), they expect all files to appear owned by the specified
user/group.  However, several code paths unconditionally called
sid_to_id() to overwrite cf_uid/cf_gid with server-provided values,
ignoring the administrator's explicit override:

  - smb311_posix_info_to_fattr() (stat via POSIX extensions)
  - cifs_posix_to_fattr() (readdir via POSIX extensions)
  - parse_sec_desc() (CIFS ACL ownership mapping)

This allowed an untrusted server to dictate local file ownership even
when the mount was configured to force specific uid/gid values.

Fix all three call sites to check CIFS_MOUNT_OVERR_UID and
CIFS_MOUNT_OVERR_GID before calling sid_to_id(), following the
same pattern already used by cifs_unix_basic_to_fattr() for unix
extensions.

Closes: https://sashiko.dev/#/patchset/20260906155816.603278-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 29 ++++++++++++++++++-----------
 fs/smb/client/inode.c   |  9 +++++++--
 fs/smb/client/readdir.c | 11 +++++++----
 3 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 7752a6d33cee4..4ed7b6311af55 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1312,6 +1312,7 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 {
 	int rc = 0;
 	struct smb_sid *owner_sid_ptr, *group_sid_ptr;
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 	struct smb_acl *dacl_ptr; /* no need for SACL ptr */
 	char *end_of_acl = ((char *)pntsd) + acl_len;
 	__u32 dacloffset;
@@ -1328,17 +1329,21 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
 		 le32_to_cpu(pntsd->gsidoffset),
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
-/*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+
 	rc = parse_sid(owner_sid_ptr, end_of_acl);
 	if (rc) {
 		cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func__, rc);
 		return rc;
 	}
-	rc = sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
-	if (rc) {
-		cifs_dbg(FYI, "%s: Error %d mapping Owner SID to uid\n",
-			 __func__, rc);
-		return rc;
+	if (!(sbflags & CIFS_MOUNT_OVERR_UID)) {
+		rc = sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
+		if (rc) {
+			cifs_dbg(FYI, "%s: Error %d mapping Owner SID to uid\n",
+				 __func__, rc);
+			return rc;
+		}
 	}
 
 	rc = parse_sid(group_sid_ptr, end_of_acl);
@@ -1347,11 +1352,13 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 			 __func__, rc);
 		return rc;
 	}
-	rc = sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
-	if (rc) {
-		cifs_dbg(FYI, "%s: Error %d mapping Group SID to gid\n",
-			 __func__, rc);
-		return rc;
+	if (!(sbflags & CIFS_MOUNT_OVERR_GID)) {
+		rc = sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
+		if (rc) {
+			cifs_dbg(FYI, "%s: Error %d mapping Group SID to gid\n",
+				 __func__, rc);
+			return rc;
+		}
 	}
 
 	if (dacloffset) {
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1859e3ceb9a4c..8d201db930281 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -772,6 +772,7 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
 	struct smb311_posix_qinfo *info = &data->posix_fi;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 
 	memset(fattr, 0, sizeof(*fattr));
 
@@ -816,8 +817,12 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
 		fattr->cf_symlink_target = data->symlink_target;
 		data->symlink_target = NULL;
 	}
-	sid_to_id(cifs_sb, &data->posix_owner, fattr, SIDOWNER);
-	sid_to_id(cifs_sb, &data->posix_group, fattr, SIDGROUP);
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+	if (!(sbflags & CIFS_MOUNT_OVERR_UID))
+		sid_to_id(cifs_sb, &data->posix_owner, fattr, SIDOWNER);
+	if (!(sbflags & CIFS_MOUNT_OVERR_GID))
+		sid_to_id(cifs_sb, &data->posix_group, fattr, SIDGROUP);
 
 	cifs_dbg(FYI, "POSIX query info: mode 0x%x uniqueid 0x%llx nlink %d\n",
 		fattr->cf_mode, fattr->cf_uniqueid, fattr->cf_nlink);
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 434d5f74b2ef7..7b7942f0f53ea 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -241,6 +241,7 @@ static void
 cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		    struct cifs_sb_info *cifs_sb)
 {
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 	struct smb2_posix_info_parsed parsed;
 	int rc;
 
@@ -281,15 +282,17 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		 le32_to_cpu(info->ReparseTag),
 		 le32_to_cpu(info->Mode));
 
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 	if (rc < 0) {
 		cifs_dbg(VFS, "%s: failed to parse SIDs: %d\n",
 			 __func__, rc);
-		fattr->cf_uid = cifs_sb->ctx->linux_uid;
-		fattr->cf_gid = cifs_sb->ctx->linux_gid;
-	} else {
+		return;
+	}
+	if (!(sbflags & CIFS_MOUNT_OVERR_UID))
 		sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
+	if (!(sbflags & CIFS_MOUNT_OVERR_GID))
 		sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
-	}
 }
 
 static void __dir_info_to_fattr(struct cifs_fattr *fattr, const void *info)
-- 
2.53.0



