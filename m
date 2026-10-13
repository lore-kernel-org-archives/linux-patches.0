Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2702045FFA7;
	Tue, 13 Oct 2026 12:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894256; cv=none; b=tAnRsCZx0BwGOyrpDDW2dLnMKd5Y/V4Tv3WGH19f0TVYn7g+pbdX5NzmzzTvNDA2E3WQDsxlcfttFMvLxIwMTqyD4vp6OWjSX91mwzdhfKsGt5DW1/ELCuAToD9bV73dETz8h3tSjcxTaSv8NnYAo1qK6UolP6wl5J+xk12Cvuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894256; c=relaxed/simple;
	bh=29H2scz0hqHvV5nQyJQoqAnd6sMTRj04r1hzRzgol3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kj8pQlGo0Q191ZFynTNI8Cv+5CssOncXgK5eTyeNPZHu0DUk7cW73W6Bjc9VItXINCA7OpVDG+OAItfEtE61C0v9rE+OfdwhUU1TmEoNILab7KT4C7BDm1uxbSBUso6BU1RT/x3ZrIPI3W+GC8OIJPee4N/onHql2PzP+egfEoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XysWiBqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XysWiBqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFD21F00893;
	Tue, 13 Oct 2026 12:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894255;
	bh=L6xUiWAUyamCNGuxGdqB9uFef90/LflGUeeF+Q/4VpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XysWiBqKYOsEhgce/2xMqPCXPQN/L65TbjqH7EcNrasOLACcS8JmkrKRNTUzDImoz
	 +GSfxaxFCHMkG1lVF3GRbuo03LzIYjP9JKcxIMzyTBSgNF/ufudAP0tkMGQQ2xhWmN
	 gtEkYKzo7M+JbMvWKnIW8+HnYz5hv53WQa1SyZwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 500/621] ksmbd: fix maximum allowed access checks
Date: Tue, 13 Oct 2026 13:38:15 +0200
Message-ID: <20261013112932.693629635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit cc2f133e80eb2c4a04bfa77a2f207749fe2f516a ]

The DACL permission check looks for an ACE matching the current user and
falls back to the Everyone ACE. It does not consider an Authenticated
Users ACE, even though an authenticated session is a member of that
well-known group.

As a result, opening a file whose access is granted through S-1-5-11 can
incorrectly fail with STATUS_ACCESS_DENIED. Treat an Authenticated Users
ACE as a fallback entry alongside Everyone.

The maximal access calculation also combines access masks from every ACE,
regardless of whether its SID applies to the current user. This can grant
rights belonging to an unrelated principal. Process only ACEs applying to
the user, Everyone, or Authenticated Users, and accumulate allowed and
denied masks in ACL order. Preserve explicitly requested access bits so
they are validated against the resulting maximal mask.

When ACCESS_SYSTEM_SECURITY is denied, report STATUS_PRIVILEGE_NOT_HELD
instead of the generic STATUS_ACCESS_DENIED. Access to the system ACL
requires a security privilege that ksmbd does not grant.

For regular files, include FILE_EXECUTE in maximal access when the client
requested GENERIC_EXECUTE and the DACL grants the complete file-read set.
Keep a direct FILE_EXECUTE request subject to the explicit DACL bit. This
matches the POSIX file ACL mapping without broadening specific execute
requests.

Do not replace rights from an applicable NT ACE with a POSIX ACL entry.
The POSIX ACL is only a fallback when no user, Everyone, or Authenticated
Users ACE applies; otherwise it can incorrectly broaden the stored DACL.

This fixes smb2.maximum_allowed.maximum_allowed.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c |  9 ++++-
 fs/smb/server/smbacl.c  | 83 ++++++++++++++++++++++++++---------------
 fs/smb/server/smbacl.h  |  2 +-
 3 files changed, 61 insertions(+), 33 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 33ffe63f26dcd..f2bb853b0198d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3259,6 +3259,7 @@ int smb2_open(struct ksmbd_work *work)
 
 	if (file_present && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
 		rc = smb_check_perm_dacl(conn, &path, &daccess,
+					 req->DesiredAccess,
 					 sess->user->uid);
 		if (rc)
 			goto err_out;
@@ -3805,8 +3806,12 @@ int smb2_open(struct ksmbd_work *work)
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		else if (rc == -EOPNOTSUPP)
 			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
-		else if (rc == -EACCES || rc == -ESTALE || rc == -EXDEV)
-			rsp->hdr.Status = STATUS_ACCESS_DENIED;
+		else if (rc == -EACCES || rc == -ESTALE || rc == -EXDEV) {
+			if (req->DesiredAccess & FILE_ACCESS_SYSTEM_SECURITY_LE)
+				rsp->hdr.Status = STATUS_PRIVILEGE_NOT_HELD;
+			else
+				rsp->hdr.Status = STATUS_ACCESS_DENIED;
+		}
 		else if (rc == -ENOENT)
 			rsp->hdr.Status = STATUS_OBJECT_NAME_INVALID;
 		else if (rc == -EPERM)
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 114fd2e67725d..a4447c9c660dc 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1445,7 +1445,7 @@ bool smb_inherit_flags(int flags, bool is_dir)
 }
 
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
-			__le32 *pdaccess, int uid)
+			__le32 *pdaccess, __le32 raw_daccess, int uid)
 {
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	struct smb_ntsd *pntsd = NULL;
@@ -1455,10 +1455,11 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	unsigned int dacl_offset;
 	size_t dacl_struct_end;
 	struct smb_sid sid;
-	int granted = le32_to_cpu(*pdaccess & ~FILE_MAXIMAL_ACCESS_LE);
+	int requested = le32_to_cpu(*pdaccess & ~FILE_MAXIMAL_ACCESS_LE);
+	int granted = requested;
 	struct smb_ace *ace;
 	int i, found = 0;
-	unsigned int access_bits = 0;
+	unsigned int access_bits = 0, denied = 0;
 	struct smb_ace *others_ace = NULL;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
@@ -1492,10 +1493,13 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		goto err_out;
 	}
 
+	if (!uid)
+		sid_type = SIDUNIX_USER;
+	id_to_sid(uid, sid_type, &sid);
+
 	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
-		granted = READ_CONTROL | WRITE_DAC | FILE_READ_ATTRIBUTES |
+		access_bits = READ_CONTROL | WRITE_DAC | FILE_READ_ATTRIBUTES |
 			DELETE;
-
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = pdacl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
@@ -1508,15 +1512,41 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 				       CIFS_SID_BASE_SIZE)
 				break;
 			aces_size -= ace_size;
-			granted |= le32_to_cpu(ace->access_req);
+
+			if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+			    ace_size < offsetof(struct smb_ace, sid) +
+				      CIFS_SID_BASE_SIZE +
+				      sizeof(__le32) * ace->sid.num_subauth)
+				break;
+
+			if (ace->flags & INHERIT_ONLY_ACE ||
+			    (compare_sids(&sid, &ace->sid) &&
+			     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
+			     compare_sids(&sid_everyone, &ace->sid) &&
+			     compare_sids(&sid_authusers, &ace->sid)))
+				goto next_ace;
+
+			switch (ace->type) {
+			case ACCESS_ALLOWED_ACE_TYPE:
+				access_bits |= le32_to_cpu(ace->access_req);
+				break;
+			case ACCESS_DENIED_ACE_TYPE:
+			case ACCESS_DENIED_CALLBACK_ACE_TYPE:
+				denied |= ~access_bits &
+					le32_to_cpu(ace->access_req);
+				break;
+			}
+next_ace:
 			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 		}
+		access_bits &= ~denied;
+		if ((raw_daccess & FILE_GENERIC_EXECUTE_LE) &&
+		    S_ISREG(d_inode(path->dentry)->i_mode) &&
+		    (access_bits & GENERIC_READ_FLAGS) == GENERIC_READ_FLAGS)
+			access_bits |= FILE_EXECUTE;
+		granted = requested | access_bits;
 	}
 
-	if (!uid)
-		sid_type = SIDUNIX_USER;
-	id_to_sid(uid, sid_type, &sid);
-
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 	aces_size = pdacl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
@@ -1540,25 +1570,16 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			found = 1;
 			break;
 		}
-		if (!compare_sids(&sid_everyone, &ace->sid))
+		if (!compare_sids(&sid_everyone, &ace->sid) ||
+		    !compare_sids(&sid_authusers, &ace->sid))
 			others_ace = ace;
 
 		ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 	}
 
-	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE && found) {
-		granted = READ_CONTROL | WRITE_DAC | FILE_READ_ATTRIBUTES |
-			DELETE;
-
-		granted |= le32_to_cpu(ace->access_req);
-
-		if (!pdacl->num_aces)
-			granted = GENERIC_ALL_FLAGS;
-	}
-
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
 		posix_acls = get_inode_acl(d_inode(path->dentry), ACL_TYPE_ACCESS);
-		if (!IS_ERR_OR_NULL(posix_acls) && !found) {
+		if (!IS_ERR_OR_NULL(posix_acls) && !found && !others_ace) {
 			unsigned int id = -1;
 
 			pa_entry = posix_acls->a_entries;
@@ -1596,14 +1617,16 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		}
 	}
 
-	switch (ace->type) {
-	case ACCESS_ALLOWED_ACE_TYPE:
-		access_bits = le32_to_cpu(ace->access_req);
-		break;
-	case ACCESS_DENIED_ACE_TYPE:
-	case ACCESS_DENIED_CALLBACK_ACE_TYPE:
-		access_bits = le32_to_cpu(~ace->access_req);
-		break;
+	if (!(*pdaccess & FILE_MAXIMAL_ACCESS_LE)) {
+		switch (ace->type) {
+		case ACCESS_ALLOWED_ACE_TYPE:
+			access_bits = le32_to_cpu(ace->access_req);
+			break;
+		case ACCESS_DENIED_ACE_TYPE:
+		case ACCESS_DENIED_CALLBACK_ACE_TYPE:
+			access_bits = le32_to_cpu(~ace->access_req);
+			break;
+		}
 	}
 
 check_access_bits:
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index ab21ba2cd4df3..bf0312bfa0405 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -95,7 +95,7 @@ bool smb_inherit_flags(int flags, bool is_dir);
 int smb_inherit_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     unsigned int uid, unsigned int gid);
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
-			__le32 *pdaccess, int uid);
+			__le32 *pdaccess, __le32 raw_daccess, int uid);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
 		 bool type_check, bool get_write);
-- 
2.53.0



