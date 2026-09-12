Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269AC396B84;
	Sat, 12 Sep 2026 07:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196689; cv=none; b=HWsLQRlPidk7nA5zMeZW4nFPb9LLfWYkNG1rZcEjVlhcVyWI8XZKNRMDYlQxay1NmMyksG0rgbSI4hwPJmWUf7us4vyHBqpEUkDplQLsd8x0Cp8V4/DzW5cmtZlPkdAmBIJz9KK3s0wOt4oVZHy3KqQ3b7J0kaet8SveqnHbYNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196689; c=relaxed/simple;
	bh=o7FdxpGNum8SaEJiw3RBAm/2/QbT8hExicqg4l6LSqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=legDOJkHe6n8u/gSsljMyOfCU0MkIHoWK+oiMrgqBq33cAGoDV9Jtgizho/nwFb3CykC0WJBChtCHJXxgL7m+qx4L9aY3RacvadQgzsGpi28sCcAgklMAkANZMs52i0vqgT4adR/Kzr1ma5b5DIJNhT7q1owN0msU3gMzZyDv4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dePdXr9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dePdXr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DF01F00893;
	Sat, 12 Sep 2026 07:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196684;
	bh=lmViYTFSoxYu4uXA9Gv83h+9d6CDcYhH5NQ+/BFh26c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dePdXr9X09B3daOxUCbcOU2FaGxaeFy2mARUsK8BxJQ+jKz+N7VOLGlu/8ygQlJI
	 aVi1teawijmRg0Lt8put7O3zCIj4PKTNTOwpD2LPO4uVbNazUwwAsI6IjDhGEnmai2
	 J/a2ArZ7Z4COYlh31oVKAj2HkSmPYzsHF68fGoi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0017/1815] ksmbd: fix maximum allowed access checks
Date: Sat, 12 Sep 2026 08:29:27 +0200
Message-ID: <20260912065649.413421068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: b5ec6c462aab ("ksmbd: fix tree connection use-after-free in smb2_tree_connect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    9 ++++-
 fs/smb/server/smbacl.c  |   83 ++++++++++++++++++++++++++++++------------------
 fs/smb/server/smbacl.h  |    2 -
 3 files changed, 61 insertions(+), 33 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3601,6 +3601,7 @@ int smb2_open(struct ksmbd_work *work)
 
 	if (file_present && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
 		rc = smb_check_perm_dacl(conn, &path, &daccess,
+					 req->DesiredAccess,
 					 sess->user->uid);
 		if (rc)
 			goto err_out;
@@ -4173,8 +4174,12 @@ err_out2:
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
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1432,7 +1432,7 @@ bool smb_inherit_flags(int flags, bool i
 }
 
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
-			__le32 *pdaccess, int uid)
+			__le32 *pdaccess, __le32 raw_daccess, int uid)
 {
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	struct smb_ntsd *pntsd = NULL;
@@ -1442,10 +1442,11 @@ int smb_check_perm_dacl(struct ksmbd_con
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
@@ -1479,10 +1480,13 @@ int smb_check_perm_dacl(struct ksmbd_con
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
 		aces_size = acl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
@@ -1495,15 +1499,41 @@ int smb_check_perm_dacl(struct ksmbd_con
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
 	aces_size = acl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
@@ -1527,25 +1557,16 @@ int smb_check_perm_dacl(struct ksmbd_con
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
@@ -1583,14 +1604,16 @@ int smb_check_perm_dacl(struct ksmbd_con
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
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -95,7 +95,7 @@ bool smb_inherit_flags(int flags, bool i
 int smb_inherit_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     unsigned int uid, unsigned int gid);
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
-			__le32 *pdaccess, int uid);
+			__le32 *pdaccess, __le32 raw_daccess, int uid);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
 		 bool type_check, bool get_write);


