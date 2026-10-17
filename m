Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086C43B388C;
	Sat, 17 Oct 2026 17:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258956; cv=none; b=DF29AISvWfhFKGeNESKDoRESvI+rHX5W1b9WYwiYrEI8rdGdqvvvQoiXbjXSTXEyo9w1J5I+7aiWfSJOXOcd+yr3u9cqQ1nJjoRSeQ7Q4Q2DUBLO0G8Ym1mwUm4Ox+uaKwD7Z1e1AeWgOpXkP0Cn0YzoD4V2viJVSwuqZWEcrtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258956; c=relaxed/simple;
	bh=EP2QQTYDfZSq5ABP0HRgjXa0cH2PlDFGt0lxRTSlPe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAKBn8LalbwHM0rJF03XTZKA1NgTAh33Og3DSAW0kvJjrSjQzlkBGmnH0yPBFeo/zExE2qP6j1rbC8z/DDKcYyLbgYn3+j7pxacGBo59DiEVgK9Fwo2iPrjmv9jFAgsxI5mAJQfNIodQAuz9XKaLEm4Bhd3EuQZGOfRmfRZpr9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PS344WVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PS344WVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C84E1F000C4;
	Sat, 17 Oct 2026 17:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258954;
	bh=PjlWh5fKX8DU0laaTOSzik5/DwFuxkWcOsMepE+n0l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PS344WVE+FvTeDlX33OUxNJdemd4s4lWKl0tNMLV3o4/SaOuWw7tj7Te2yebCbItH
	 USfgISzYzum0LecwIRpDPLh6UBytXRAXXnCRTViH2fb3q+YrPcu1vy4F/1gqOxu1E0
	 P4fC0C5aCEqUM5T01XCT/ivoe9smsAJJUdu2cQug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyi Liu <moss80199@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1053/1674] ksmbd: validate SID in parent security descriptor during ACL inheritance
Date: Sat, 17 Oct 2026 17:55:25 +0200
Message-ID: <20261017160458.155841754@linuxfoundation.org>
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

From: Junyi Liu <moss80199@gmail.com>

[ Upstream commit 69f030cf95488ae1186c72ac8c66fd279664ea7f ]

Introduce smb_validate_ntsd_sid() helper to safely validate Owner SID
and Group SID inside the NT Security Descriptor (smb_ntsd) retrieved
from the parent directory.

Cc: stable@vger.kernel.org
Signed-off-by: Junyi Liu <moss80199@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 66 ++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 16 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index b9419c10bdd9c..7824c20dc80e2 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1136,6 +1136,40 @@ static int smb_append_inherited_ace(struct smb_ace **ace, int *nt_size,
 	return 0;
 }
 
+static int smb_validate_ntsd_sid(struct smb_ntsd *pntsd, size_t pntsd_size,
+				  unsigned int sid_offset, struct smb_sid **sid,
+				  size_t *sid_size)
+{
+	size_t sid_end;
+
+	*sid = NULL;
+	*sid_size = 0;
+
+	if (!sid_offset)
+		return 0;
+
+	if (sid_offset < sizeof(struct smb_ntsd) ||
+	    check_add_overflow(sid_offset, (size_t)CIFS_SID_BASE_SIZE,
+			       &sid_end) ||
+	    sid_end > pntsd_size)
+		return -EINVAL;
+
+	*sid = (struct smb_sid *)((char *)pntsd + sid_offset);
+	if ((*sid)->num_subauth > SID_MAX_SUB_AUTHORITIES)
+		return -EINVAL;
+
+	if (check_add_overflow((size_t)CIFS_SID_BASE_SIZE,
+			       sizeof(__le32) * (size_t)(*sid)->num_subauth,
+			       &sid_end))
+		return -EINVAL;
+
+	if (sid_offset > pntsd_size || sid_end > pntsd_size - sid_offset)
+		return -EINVAL;
+
+	*sid_size = sid_end;
+	return 0;
+}
+
 int smb_inherit_dacl(struct ksmbd_conn *conn,
 		     const struct path *path,
 		     unsigned int uid, unsigned int gid)
@@ -1148,28 +1182,28 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	struct dentry *parent = path->dentry->d_parent;
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	int inherited_flags = 0, flags = 0, i, nt_size = 0, pdacl_size;
-	int rc = 0, pntsd_type, pntsd_size, acl_len, aces_size;
+	int rc = 0, pntsd_type, ppntsd_size, acl_len, aces_size;
 	unsigned int dacloffset;
 	size_t dacl_struct_end;
 	u16 num_aces, ace_cnt = 0;
 	char *aces_base;
 	bool is_dir = S_ISDIR(d_inode(path->dentry)->i_mode);
 
-	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap,
+	ppntsd_size = ksmbd_vfs_get_sd_xattr(conn, idmap,
 					    parent, &parent_pntsd);
-	if (pntsd_size <= 0)
+	if (ppntsd_size <= 0)
 		return -ENOENT;
 
 	dacloffset = le32_to_cpu(parent_pntsd->dacloffset);
 	if (!dacloffset ||
 	    check_add_overflow(dacloffset, sizeof(struct smb_acl), &dacl_struct_end) ||
-	    dacl_struct_end > (size_t)pntsd_size) {
+	    dacl_struct_end > (size_t)ppntsd_size) {
 		rc = -EINVAL;
 		goto free_parent_pntsd;
 	}
 
 	parent_pdacl = (struct smb_acl *)((char *)parent_pntsd + dacloffset);
-	acl_len = pntsd_size - dacloffset;
+	acl_len = ppntsd_size - dacloffset;
 	num_aces = le16_to_cpu(parent_pdacl->num_aces);
 	pntsd_type = le16_to_cpu(parent_pntsd->type);
 	pdacl_size = le16_to_cpu(parent_pdacl->size);
@@ -1283,19 +1317,19 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		struct smb_ntsd *pntsd;
 		struct smb_acl *pdacl;
 		struct smb_sid *powner_sid = NULL, *pgroup_sid = NULL;
-		int powner_sid_size = 0, pgroup_sid_size = 0, pntsd_size;
+		size_t powner_sid_size = 0, pgroup_sid_size = 0, pntsd_size;
 		size_t pntsd_alloc_size;
 
-		if (parent_pntsd->osidoffset) {
-			powner_sid = (struct smb_sid *)((char *)parent_pntsd +
-					le32_to_cpu(parent_pntsd->osidoffset));
-			powner_sid_size = 1 + 1 + 6 + (powner_sid->num_subauth * 4);
-		}
-		if (parent_pntsd->gsidoffset) {
-			pgroup_sid = (struct smb_sid *)((char *)parent_pntsd +
-					le32_to_cpu(parent_pntsd->gsidoffset));
-			pgroup_sid_size = 1 + 1 + 6 + (pgroup_sid->num_subauth * 4);
-		}
+		rc = smb_validate_ntsd_sid(parent_pntsd, ppntsd_size,
+					   le32_to_cpu(parent_pntsd->osidoffset),
+					   &powner_sid, &powner_sid_size);
+		if (rc)
+			goto free_aces_base;
+		rc = smb_validate_ntsd_sid(parent_pntsd, ppntsd_size,
+					   le32_to_cpu(parent_pntsd->gsidoffset),
+					   &pgroup_sid, &pgroup_sid_size);
+		if (rc)
+			goto free_aces_base;
 
 		if (check_add_overflow(sizeof(struct smb_ntsd),
 				       (size_t)powner_sid_size,
-- 
2.53.0



