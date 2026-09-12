Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C39A400DF6;
	Sat, 12 Sep 2026 09:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203962; cv=none; b=lhWFmvPf7MkXzAl7y5JSEPV7l+Ah+AZLVsw4lfMVrEKZfz/7TqTkdQLF7C09e+73MVG6YScNpXtS6DD5inv5hM/FhnWXSe6dgbjxWYpTvCWh/QNr6+1YJa+mKP6P211pBRCNl3kH8fPksd0/INzG2e2h9IrT19ulB2ljPm0390s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203962; c=relaxed/simple;
	bh=4CqS9omgFoiRsIC/YUMv9NIZ8KgJ0uPTNVG+mnQ8+do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzKrsAb9n/nrjTsUjIlSAnC8/WmN3GJUpQKVUQ5TMQ/I1N57xA6OwnppWLzKUQ7mv0KIts4nZY5bVKl5AEuVRwr5FPNfipc7nrtXu4XRUSGHDlutMLhOHjuJBq+NYEnWrzTO2n2cv2lMSM6oukPDRa4hAUqhMMwVebwcqOLWfUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3kDkosn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3kDkosn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060381F000FF;
	Sat, 12 Sep 2026 09:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203960;
	bh=VxcfTpUkTMMy3bniRUZdsNmag3592uLuGogYNb8w0NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3kDkosncZycyTE5tAqJ8qf8Xvxp7XgPJizlR427zqN6WV8LplnQF1QvTGmO3+g48
	 PcD3keEVO+g9zlnbSeaIlPommSMCI5GyBx/vybiUR+qITRv8x/v1xk1Xtdk313tQP1
	 BK55TOIhbi5zcEoDgJKHf2nPkRp3VQsRu07I5T2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1508/1815] ksmbd: support access-based directory enumeration
Date: Sat, 12 Sep 2026 08:54:18 +0200
Message-ID: <20260912065724.399111199@linuxfoundation.org>
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

[ Upstream commit e5f42cb7577221080e4db0498d71e6db7e67f1a5 ]

SMB shares can advertise access-based directory enumeration. ksmbd does
not currently provide a share option or filter inaccessible directory
entries.

Add a hide-unreadable share flag and advertise
SMB2_SHAREFLAG_ACCESS_BASED_DIRECTORY_ENUM when it is enabled. During
QUERY_DIRECTORY, omit entries unless the connected user has
FILE_READ_DATA, FILE_READ_EA, and FILE_READ_ATTRIBUTES access according
to the Windows ACL.

Keep the existing implicit access allowances for normal CREATE
permission checks while using strict access-mask matching for directory
enumeration.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: b0148dc5625d ("ksmbd: serialize oplock close with pending break ownership")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_netlink.h |  1 +
 fs/smb/server/smb2pdu.c       | 24 +++++++++++++++++++++++-
 fs/smb/server/smbacl.c        | 13 ++++++++++---
 fs/smb/server/smbacl.h        |  3 ++-
 4 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 8ccd57fd904bc..c9e1b0b689d7f 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -377,6 +377,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_SHARE_FLAG_UPDATE				BIT(14)
 #define KSMBD_SHARE_FLAG_CROSSMNT			BIT(15)
 #define KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY	BIT(16)
+#define KSMBD_SHARE_FLAG_HIDE_UNREADABLE		BIT(17)
 
 /*
  * Tree connect request flags.
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c85879607d1cc..8ef3123655c57 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2336,6 +2336,10 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (conn->dialect == SMB311_PROT_ID &&
 	    conn->compress_algorithm != SMB3_COMPRESS_NONE)
 		rsp->ShareFlags |= cpu_to_le32(SMB2_SHAREFLAG_COMPRESS_DATA);
+	if (share && test_share_config_flag(share,
+					  KSMBD_SHARE_FLAG_HIDE_UNREADABLE))
+		rsp->ShareFlags |=
+			cpu_to_le32(SMB2_SHAREFLAG_ACCESS_BASED_DIRECTORY_ENUM);
 
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
 	if (rc) {
@@ -3607,7 +3611,7 @@ int smb2_open(struct ksmbd_work *work)
 	if (file_present && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
 		rc = smb_check_perm_dacl(conn, &path, &daccess,
 					 req->DesiredAccess,
-					 sess->user->uid);
+					 sess->user->uid, false);
 		if (rc)
 			goto err_out;
 	}
@@ -4582,6 +4586,7 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 
 	for (i = 0; i < priv->d_info->num_entry; i++) {
 		struct dentry *dent;
+		struct path path;
 
 		if (dentry_name(priv->d_info, priv->info_level))
 			return -EINVAL;
@@ -4604,6 +4609,23 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 			continue;
 		}
 
+		if (test_share_config_flag(priv->work->tcon->share_conf,
+					   KSMBD_SHARE_FLAG_HIDE_UNREADABLE)) {
+			__le32 daccess = FILE_READ_DATA_LE | FILE_READ_EA_LE |
+				FILE_READ_ATTRIBUTES_LE;
+
+			path.mnt = priv->dir_fp->filp->f_path.mnt;
+			path.dentry = dent;
+			rc = smb_check_perm_dacl(priv->work->conn, &path,
+						 &daccess, daccess,
+						 priv->work->sess->user->uid,
+						 true);
+			if (rc) {
+				dput(dent);
+				continue;
+			}
+		}
+
 		ksmbd_kstat.kstat = &kstat;
 		if (priv->info_level != FILE_NAMES_INFORMATION) {
 			rc = ksmbd_vfs_fill_dentry_attrs(priv->work,
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 0537638153325..88bf7b97042f8 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1432,7 +1432,8 @@ bool smb_inherit_flags(int flags, bool is_dir)
 }
 
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
-			__le32 *pdaccess, __le32 raw_daccess, int uid)
+			__le32 *pdaccess, __le32 raw_daccess, int uid,
+			bool strict)
 {
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	struct smb_ntsd *pntsd = NULL;
@@ -1617,8 +1618,14 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	}
 
 check_access_bits:
-	if (granted &
-	    ~(access_bits | FILE_READ_ATTRIBUTES | READ_CONTROL | WRITE_DAC | DELETE)) {
+	if (strict) {
+		access_bits &= granted;
+	} else {
+		access_bits |= FILE_READ_ATTRIBUTES | READ_CONTROL |
+			WRITE_DAC | DELETE;
+	}
+
+	if (granted & ~access_bits) {
 		ksmbd_debug(SMB, "Access denied with winACL, granted : %x, access_req : %x\n",
 			    granted, le32_to_cpu(ace->access_req));
 		rc = -EACCES;
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index bf0312bfa0405..01810c16cc046 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -95,7 +95,8 @@ bool smb_inherit_flags(int flags, bool is_dir);
 int smb_inherit_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     unsigned int uid, unsigned int gid);
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
-			__le32 *pdaccess, __le32 raw_daccess, int uid);
+			__le32 *pdaccess, __le32 raw_daccess, int uid,
+			bool strict);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
 		 bool type_check, bool get_write);
-- 
2.53.0



