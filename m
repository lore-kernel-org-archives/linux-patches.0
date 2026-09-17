Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF26D4F5DF8;
	Thu, 17 Sep 2026 17:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667142; cv=none; b=r+qct1Ce/BiAICg7yZnz2K+u/VZ/D3yXOn3CqWUbkdbeB/Efroke8ZGpfm1gPtxs89Dvdp69PGmmV99PdUVzNeS16RE4IxOPGWbwbSAAc6Ci16SzH4B6Ng+KhIO5LZlp24lyZdAZrsOS6zuS90DrEt+RuHqJA2CE+h5oJJwNgi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667142; c=relaxed/simple;
	bh=JW3dJLHlVyzn8os3yw8g5p3qrpmgw/h51w+3AzPNlQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7Zk4HwspbeVXWBymWDaQHJtImU0yceG07dcB4Wi6X3SJ+P6UeGVsQBQyy77Plr4Q8wryZFXBrE45E3fq49JjhSkU4cOHbQOaKKvN0IWkZ+2C+LJSjljTHB1c+D4fK4v9QT4T6SdIY1Ba/qKuriNcIhgKu3Dn/8azdby3mBu2MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rd19BqZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rd19BqZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA0C1F000FF;
	Thu, 17 Sep 2026 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667140;
	bh=99X2618x/Hrv2PVYthw+LhwLc4gmAkfYz5utcj9EFNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rd19BqZsJO6QWqai1HZJI4VF2d5bsXnqgtM33PIZOirMuO97XMouTQMn///mVTHkZ
	 KbFv14EBBeUig0rQdMJet1KDoKnvbCGiIJakSdxyq36LkM8sJ6Cs71r5B5m32wC7V7
	 K5yTa3dOgOHjqZvsmEkekMUPHoJ/cGak+IFybv0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1243/1250] smb/client: fix security flag calculation when setting security descriptors
Date: Thu, 17 Sep 2026 16:17:18 +0100
Message-ID: <20260917151625.986467835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Ralph Boehme <slow@samba.org>

[ Upstream commit 4939889c985da68936090cc013e58c28b7bff34f ]

In id_mode_to_cifs_acl(), aclflag was initialized to CIFS_ACL_DACL by default.
This forced the client to request setting the DACL even when only an ownership
(chown) or group (chgrp) change was being performed.

Let build_sec_desc() do the proper flag calculation by initializing aclflag
to 0. build_sec_desc() sets the appropriate bits (CIFS_ACL_OWNER, CIFS_ACL_GROUP,
or CIFS_ACL_DACL) depending on what actually changed. During ownership transfer,
CIFS_ACL_DACL is only set if replace_sids_and_copy_aces() actually replaces the
SIDs inside any of the DACL's ACEs.

If build_sec_desc() results in aclflag being 0 (meaning no changes were mapped),
exit early to avoid sending an empty security descriptor update to the server.

Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: d05045177a85 ("smb: client: fail DACL rewrite when the new DACL exceeds 64K")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1130,7 +1130,8 @@ set_size:
 
 static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *pndacl,
 		struct smb_sid *pownersid, struct smb_sid *pgrpsid,
-		struct smb_sid *pnownersid, struct smb_sid *pngrpsid)
+		struct smb_sid *pnownersid, struct smb_sid *pngrpsid,
+		int *aclflag)
 {
 	int i;
 	u16 size = 0;
@@ -1154,12 +1155,15 @@ static __u16 replace_sids_and_copy_aces(
 		pntace = (struct smb_ace *) (acl_base + size);
 		pnntace = (struct smb_ace *) (nacl_base + nsize);
 
-		if (pnownersid && compare_sids(&pntace->sid, pownersid) == 0)
+		if (pnownersid && compare_sids(&pntace->sid, pownersid) == 0) {
 			ace_size = cifs_copy_ace(pnntace, pntace, pnownersid);
-		else if (pngrpsid && compare_sids(&pntace->sid, pgrpsid) == 0)
+			*aclflag |= CIFS_ACL_DACL;
+		} else if (pngrpsid && compare_sids(&pntace->sid, pgrpsid) == 0) {
 			ace_size = cifs_copy_ace(pnntace, pntace, pngrpsid);
-		else
+			*aclflag |= CIFS_ACL_DACL;
+		} else {
 			ace_size = cifs_copy_ace(pnntace, pntace, NULL);
+		}
 
 		size += le16_to_cpu(pntace->size);
 		nsize += ace_size;
@@ -1481,7 +1485,8 @@ static int build_sec_desc(struct smb_nts
 			/* Replace ACEs for old owner with new one */
 			size = replace_sids_and_copy_aces(dacl_ptr, ndacl_ptr,
 					owner_sid_ptr, group_sid_ptr,
-					nowner_sid_ptr, ngroup_sid_ptr);
+					nowner_sid_ptr, ngroup_sid_ptr,
+					aclflag);
 			ndacl_ptr->size = cpu_to_le16(size);
 		}
 
@@ -1696,7 +1701,7 @@ id_mode_to_cifs_acl(struct inode *inode,
 			kuid_t uid, kgid_t gid)
 {
 	int rc = 0;
-	int aclflag = CIFS_ACL_DACL; /* default flag to set */
+	int aclflag = 0;
 	__u32 secdesclen = 0;
 	__u32 nsecdesclen = 0;
 	__u32 dacloffset = 0;
@@ -1802,6 +1807,11 @@ id_mode_to_cifs_acl(struct inode *inode,
 	if (rc != 0)
 		goto id_mode_to_cifs_acl_exit;
 
+	if (aclflag == 0) {
+		cifs_dbg(FYI, "set_cifs_acl aclflag=0, no change mapped\n");
+		goto id_mode_to_cifs_acl_exit;
+	}
+
 	if (ops->set_acl == NULL) {
 		rc = -EOPNOTSUPP;
 		goto id_mode_to_cifs_acl_exit;


