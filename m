Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DBA3FE364;
	Wed, 20 May 2026 18:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303056; cv=none; b=K1n0xl/oICnepHP3WydlBhJLJy7eha3izxRke7lhJP2zNS3XlmlDt2OVY+TzItpu3L1z3onccLXqZSJjdSwxQdMGujmSeEh0bu02JTq4QrkHzqHgOWPrrN+urBb75uHrpBgMSMe/8riQ4ymXE1xXvuczdtaSAMx5gnPtFyiBRek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303056; c=relaxed/simple;
	bh=4szzK773UjBpR3kQY85FVs1zX7eaVMzU/wtCeHtoFEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLq5m/ZSaizYZh2SYh0Ov26Rw7beNo0IOHLzRFzlYtdRtZfyXAICuH26HRyy5Zhy5SMzj7PKwbsnRh0NzJW00cVun4dZZHSaVk6HdtQHkaaNvWOX1rNfEEKonw0nDaIO2r81pT9LBrGLr7nmk6cII6zqN/4bfLACRwp03eMVIuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQKTjChk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQKTjChk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FF51F00893;
	Wed, 20 May 2026 18:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303053;
	bh=JKuWDIJubFCbPctX/nRsxwC7kNUlTiW83G/Bverefjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQKTjChkbUMPS6jIEh1+lztyMqTQQZ/9DQxY3TmiraGXmRDGUl3iO1H8NlyZEwlXH
	 0GrBlC3sIEsphH15CLwhy6HAYidcwQ6kY8eCGxJ+2ztRKNOAGuDQKXRQkdZI+7sMJO
	 9Ghtk3HT4Zr/N9y9zKUtx6uWs0MtkpX8PU3uLMac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shota Zaizen <s@zaizen.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 501/508] ksmbd: validate inherited ACE SID length
Date: Wed, 20 May 2026 18:25:24 +0200
Message-ID: <20260520162109.456401768@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Shota Zaizen <s@zaizen.me>

[ Upstream commit 996454bc0da84d5a1dedb1a7861823087e01a7ae ]

smb_inherit_dacl() walks the parent directory DACL loaded from the
security descriptor xattr. It verifies that each ACE contains the fixed
SID header before using it, but does not verify that the variable-length
SID described by sid.num_subauth is fully contained in the ACE.

A malformed inheritable ACE can advertise more subauthorities than are
present in the ACE. compare_sids() may then read past the ACE.
smb_set_ace() also clamps the copied destination SID, but used the
unchecked source SID count to compute the inherited ACE size. That could
advance the temporary inherited ACE buffer pointer and nt_size accounting
past the allocated buffer.

Fix this by validating the parent ACE SID count and SID length before
using the SID during inheritance. Compute the inherited ACE size from the
copied SID so the size matches the bounded destination SID. Reject the
inherited DACL if size accumulation would overflow smb_acl.size or the
security descriptor allocation size.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Shota Zaizen <s@zaizen.me>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   66 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 14 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1025,7 +1025,26 @@ static void smb_set_ace(struct smb_ace *
 	ace->flags = flags;
 	ace->access_req = access_req;
 	smb_copy_sid(&ace->sid, sid);
-	ace->size = cpu_to_le16(1 + 1 + 2 + 4 + 1 + 1 + 6 + (sid->num_subauth * 4));
+	ace->size = cpu_to_le16(1 + 1 + 2 + 4 + 1 + 1 + 6 +
+				(ace->sid.num_subauth * 4));
+}
+
+static int smb_append_inherited_ace(struct smb_ace **ace, int *nt_size,
+				    u16 *ace_cnt, const struct smb_sid *sid,
+				    u8 type, u8 flags, __le32 access_req)
+{
+	int ace_size;
+
+	smb_set_ace(*ace, sid, type, flags, access_req);
+	ace_size = le16_to_cpu((*ace)->size);
+	/* pdacl->size is __le16 and includes struct smb_acl. */
+	if (check_add_overflow(*nt_size, ace_size, nt_size) ||
+	    *nt_size > U16_MAX - (int)sizeof(struct smb_acl))
+		return -EINVAL;
+
+	(*ace_cnt)++;
+	*ace = (struct smb_ace *)((char *)*ace + ace_size);
+	return 0;
 }
 
 int smb_inherit_dacl(struct ksmbd_conn *conn,
@@ -1090,6 +1109,12 @@ int smb_inherit_dacl(struct ksmbd_conn *
 		if (pace_size > aces_size)
 			break;
 
+		if (parent_aces->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+		    pace_size < offsetof(struct smb_ace, sid) +
+				CIFS_SID_BASE_SIZE +
+				sizeof(__le32) * parent_aces->sid.num_subauth)
+			break;
+
 		aces_size -= pace_size;
 
 		flags = parent_aces->flags;
@@ -1119,22 +1144,24 @@ int smb_inherit_dacl(struct ksmbd_conn *
 		}
 
 		if (is_dir && creator && flags & CONTAINER_INHERIT_ACE) {
-			smb_set_ace(aces, psid, parent_aces->type, inherited_flags,
-				    parent_aces->access_req);
-			nt_size += le16_to_cpu(aces->size);
-			ace_cnt++;
-			aces = (struct smb_ace *)((char *)aces + le16_to_cpu(aces->size));
+			rc = smb_append_inherited_ace(&aces, &nt_size, &ace_cnt,
+						      psid, parent_aces->type,
+						      inherited_flags,
+						      parent_aces->access_req);
+			if (rc)
+				goto free_aces_base;
 			flags |= INHERIT_ONLY_ACE;
 			psid = creator;
 		} else if (is_dir && !(parent_aces->flags & NO_PROPAGATE_INHERIT_ACE)) {
 			psid = &parent_aces->sid;
 		}
 
-		smb_set_ace(aces, psid, parent_aces->type, flags | inherited_flags,
-			    parent_aces->access_req);
-		nt_size += le16_to_cpu(aces->size);
-		aces = (struct smb_ace *)((char *)aces + le16_to_cpu(aces->size));
-		ace_cnt++;
+		rc = smb_append_inherited_ace(&aces, &nt_size, &ace_cnt, psid,
+					      parent_aces->type,
+					      flags | inherited_flags,
+					      parent_aces->access_req);
+		if (rc)
+			goto free_aces_base;
 pass:
 		parent_aces = (struct smb_ace *)((char *)parent_aces + pace_size);
 	}
@@ -1144,7 +1171,7 @@ pass:
 		struct smb_acl *pdacl;
 		struct smb_sid *powner_sid = NULL, *pgroup_sid = NULL;
 		int powner_sid_size = 0, pgroup_sid_size = 0, pntsd_size;
-		int pntsd_alloc_size;
+		size_t pntsd_alloc_size;
 
 		if (parent_pntsd->osidoffset) {
 			powner_sid = (struct smb_sid *)((char *)parent_pntsd +
@@ -1157,8 +1184,19 @@ pass:
 			pgroup_sid_size = 1 + 1 + 6 + (pgroup_sid->num_subauth * 4);
 		}
 
-		pntsd_alloc_size = sizeof(struct smb_ntsd) + powner_sid_size +
-			pgroup_sid_size + sizeof(struct smb_acl) + nt_size;
+		if (check_add_overflow(sizeof(struct smb_ntsd),
+				       (size_t)powner_sid_size,
+				       &pntsd_alloc_size) ||
+		    check_add_overflow(pntsd_alloc_size,
+				       (size_t)pgroup_sid_size,
+				       &pntsd_alloc_size) ||
+		    check_add_overflow(pntsd_alloc_size, sizeof(struct smb_acl),
+				       &pntsd_alloc_size) ||
+		    check_add_overflow(pntsd_alloc_size, (size_t)nt_size,
+				       &pntsd_alloc_size)) {
+			rc = -EINVAL;
+			goto free_aces_base;
+		}
 
 		pntsd = kzalloc(pntsd_alloc_size, GFP_KERNEL);
 		if (!pntsd) {


