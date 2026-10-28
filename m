Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215352;
	b=Jzorz3UJn1psaTMeKcy82L+aou26kdQkGEawtNbBxJsOCCjFhkVWUR5YlWUR4EJFtMWN
	 rxwYZcR/eV86PFBZqGBmzRIGgZwIlg6XBY17tqdIe5lb+pRyaF54Cu4vyoiP8y//ztMxi
	 PSoxYat/cLcUfVNQ5obv415C6eBHHlI2HZSEPFb4cMlUaW0LEtXczeBAPW/m26/Vj0esX
	 QSH48c89bjLkzA5xFKIJAgZkjXxJHo5bvQfxYnLhKGyKGvgrxmoI5P9u2ML7gUy62yapo
	 Kt1W7IlkISfyLwgCEnCkcOjEwWLbIN6wbbgopax/4kJePglVR75YyAC4yEoKeHm3vWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nSSzKtaxmHQ0gO6ezJuHhAxcd6fqZoDNhOzXqa7VC7A=;
	b=S67dHhPigDsM/2cMeUJI8DIrPSrD+hp5/yZ0qVOhpRWUeVnlPrrVBcyeEZfEoFBqdew0
	 YF41ACKM4HG6WfgZAf+YloFJJxO4o/MVxcYiTh2OLbJp1VH2sWTnGH4Zqxw9hhkheeVIB
	 T+vCdPG65ARlomEw/Vy6ojz1MZnixAwdtgVIKUbUiVSdjl4OaTc2+NWSM4yvSSEB5UrCv
	 JRO04tcf0hEVSWavmtzofCl8BgiHpjWhuPyCAeR+Kwu2krECk13SQ42MVQQCzFfL3Hv9R
	 lh4De2pG3tNAXTCj/O609ogvjuPquW1NsfOmq1jI6EMiSoc/QgfG6R8inS6rk0BP3lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=feeHz3wp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C700606A31C;
	Wed, 28 Oct 2026 19:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=feeHz3wp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBE31F01825;
	Wed, 28 Oct 2026 19:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215352;
	bh=nSSzKtaxmHQ0gO6ezJuHhAxcd6fqZoDNhOzXqa7VC7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=feeHz3wpnalvpivosYClpRmNLVJ38n2hNNdZ7bzF7zNTULG5yFo/nU2ZrsuAR5Wr4
	 cfy+9GICa/VOWbumOOLbaxTWslzNhQZJIl/RJquDLhe+m6maMxTWXl2zWdjPJmveor
	 f7cr3HQYrJCvE82yodIiGiXmo5+ZAH8KiyCvhFXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyi Liu <moss80199@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1138/1887] ksmbd: validate SID in parent security descriptor during ACL inheritance
Date: Wed, 28 Oct 2026 17:53:54 +0100
Message-ID: <20261028170525.303624871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a338884d2115f..c8f50de252042 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1127,6 +1127,40 @@ static int smb_append_inherited_ace(struct smb_ace **ace, int *nt_size,
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
@@ -1139,27 +1173,27 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	struct dentry *parent = path->dentry->d_parent;
 	struct user_namespace *user_ns = mnt_user_ns(path->mnt);
 	int inherited_flags = 0, flags = 0, i, ace_cnt = 0, nt_size = 0, pdacl_size;
-	int rc = 0, num_aces, pntsd_type, pntsd_size, acl_len, aces_size;
+	int rc = 0, num_aces, pntsd_type, ppntsd_size, acl_len, aces_size;
 	unsigned int dacloffset;
 	size_t dacl_struct_end;
 	char *aces_base;
 	bool is_dir = S_ISDIR(d_inode(path->dentry)->i_mode);
 
-	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, user_ns,
+	ppntsd_size = ksmbd_vfs_get_sd_xattr(conn, user_ns,
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
 	num_aces = le32_to_cpu(parent_pdacl->num_aces);
 	pntsd_type = le16_to_cpu(parent_pntsd->type);
 	pdacl_size = le16_to_cpu(parent_pdacl->size);
@@ -1273,19 +1307,19 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
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



