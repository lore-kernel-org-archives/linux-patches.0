Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFE14FD294;
	Thu, 17 Sep 2026 17:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667145; cv=none; b=UY7iU6TdqgruBL1UZDlrhcwvDCh2OdvLH6uN3f9xuCoIKunnz63KyZZA3x2tPUWifOVdUXB05g1sDWKSyf6EQc54raJwx5KQazRoKlI6Lq+rchKVU7Zg2tYGn1nB82c8ADx8jseapQfAe/Qj/hldFDN0QTQy//NhaNEi1Lao/p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667145; c=relaxed/simple;
	bh=2GxI0ebK6NPhrHREXjuSNtMNv5wIiWj0QSKXePVwrfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNZttvRmBGVfEMMuEmb58WiQJGpeMy5TN2leby31AJ+OyFCkChDdTfdE8NmJY5FGEB0sc50D0NGeSYqLvuKzgtIQa2ZihDpMR0f7rKTNyDYTHQHYk+fStTgJyDwFURV++9WmTuaG2qnchv3Z4RF0W4JziCNxZTbJYB2Ho0/XKqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR/zBvqX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR/zBvqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F1E1F000FF;
	Thu, 17 Sep 2026 17:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667143;
	bh=hMobYJvddNuLRj8jb8sUVv9T8/EE4uTU0DTm/c+Q2No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NR/zBvqXsaSfFcu0q0oJ/1ai8GGpdW/eulpZjth/Lo5tZcDXsgKhSW5bSAYJdu/az
	 l/jjPEp8VOCP684JZjdYivju5LK9vRY1Gjwcx0h8El5e6IV4xD2CDObDL7nUUUTjxD
	 IsdkIo8/UortE4cfLOxEUcSHIJ+Ax0ODgatJgz7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Bjoern Doebel <doebel@amazon.de>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1244/1250] smb: client: fail DACL rewrite when the new DACL exceeds 64K
Date: Thu, 17 Sep 2026 16:17:19 +0100
Message-ID: <20260917151626.016203810@linuxfoundation.org>
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

From: Bjoern Doebel <doebel@amazon.de>

[ Upstream commit d05045177a855386bca5e1909e08d06290e6e3b3 ]

replace_sids_and_copy_aces() and set_chmod_dacl() accumulate the size of
the DACL they build in a u16. That accumulator can wrap.

validate_dacl() caps num_aces at (dacl_size - sizeof(struct smb_acl)) /
20, i.e. 3276 for a maximally sized DACL, while each rewritten ACE can
grow to sizeof(struct smb_ace) (76 bytes) once its SID is replaced with
one carrying SID_MAX_SUB_AUTHORITIES sub-authorities. The worst case is
therefore sizeof(struct smb_acl) + 3276 * 76 = 248984 bytes, far beyond
what a u16 can hold. A wraparound is reached with 863 ACEs.

After the wraparound, ndacl_ptr->size becomes meaningless and the offset
will point anywhere in the ACE array. As a result, we will see
corruption of the DACL, which then gets sent to the server. This is not
an out-of-bounds write as the allocation now covers the worst-case
expansion, so writes will always go into the buffer.

Adjust the code to use a u32 internally and return -EOVERFLOW in the
overflow case. The operation must be refused, because a DACL can only
hold 2^16-1 bytes on the wire and larger DACLs cannot be represented.

set_chmod_dacl() carries the same pattern and is fixed the same way. It
only wraps once the source DACL comes within roughly 380 bytes of the
64K ceiling, but the failure mode is identical.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Fixes: f5065508897a ("cifs: Retain old ACEs when converting between mode bits and ACL.")
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1023,13 +1023,13 @@ unsigned int setup_special_user_owner_AC
 static void populate_new_aces(char *nacl_base,
 		struct smb_sid *pownersid,
 		struct smb_sid *pgrpsid,
-		__u64 *pnmode, u16 *pnum_aces, u16 *pnsize,
+		__u64 *pnmode, u16 *pnum_aces, u32 *pnsize,
 		bool modefromsid,
 		bool posix)
 {
 	__u64 nmode;
 	u16 num_aces = 0;
-	u16 nsize = 0;
+	u32 nsize = 0;
 	__u64 user_mode;
 	__u64 group_mode;
 	__u64 other_mode;
@@ -1128,17 +1128,17 @@ set_size:
 	*pnsize = nsize;
 }
 
-static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *pndacl,
-		struct smb_sid *pownersid, struct smb_sid *pgrpsid,
-		struct smb_sid *pnownersid, struct smb_sid *pngrpsid,
-		int *aclflag)
+static int replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *pndacl,
+				      struct smb_sid *pownersid, struct smb_sid *pgrpsid,
+				      struct smb_sid *pnownersid, struct smb_sid *pngrpsid,
+				      int *aclflag, u16 *pnsize)
 {
 	int i;
 	u16 size = 0;
 	struct smb_ace *pntace = NULL;
 	char *acl_base = NULL;
 	u16 src_num_aces = 0;
-	u16 nsize = 0;
+	u32 nsize = 0;
 	struct smb_ace *pnntace = NULL;
 	char *nacl_base = NULL;
 	u16 ace_size = 0;
@@ -1167,9 +1167,12 @@ static __u16 replace_sids_and_copy_aces(
 
 		size += le16_to_cpu(pntace->size);
 		nsize += ace_size;
+		if (nsize > U16_MAX)
+			return -EOVERFLOW;
 	}
 
-	return nsize;
+	*pnsize = nsize;
+	return 0;
 }
 
 static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
@@ -1181,7 +1184,7 @@ static int set_chmod_dacl(struct smb_acl
 	struct smb_ace *pntace = NULL;
 	char *acl_base = NULL;
 	u16 src_num_aces = 0;
-	u16 nsize = 0;
+	u32 nsize = 0;
 	struct smb_ace *pnntace = NULL;
 	char *nacl_base = NULL;
 	u16 num_aces = 0;
@@ -1232,6 +1235,8 @@ static int set_chmod_dacl(struct smb_acl
 
 		nsize += cifs_copy_ace(pnntace, pntace, NULL);
 		num_aces++;
+		if (nsize > U16_MAX)
+			return -EOVERFLOW;
 
 next_ace:
 		size += le16_to_cpu(pntace->size);
@@ -1248,6 +1253,10 @@ next_ace:
 	}
 
 finalize_dacl:
+	/* The DACL size field is 16-bit on the wire, see MS-DTYP 2.4.5 */
+	if (nsize > U16_MAX)
+		return -EOVERFLOW;
+
 	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(nsize);
 
@@ -1408,6 +1417,8 @@ static int build_sec_desc(struct smb_nts
 
 		rc = set_chmod_dacl(dacl_ptr, ndacl_ptr, owner_sid_ptr, group_sid_ptr,
 				    pnmode, mode_from_sid, posix);
+		if (rc)
+			return rc;
 
 		sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
 		/* copy the non-dacl portion of secdesc */
@@ -1483,10 +1494,12 @@ static int build_sec_desc(struct smb_nts
 
 		if (dacloffset) {
 			/* Replace ACEs for old owner with new one */
-			size = replace_sids_and_copy_aces(dacl_ptr, ndacl_ptr,
-					owner_sid_ptr, group_sid_ptr,
-					nowner_sid_ptr, ngroup_sid_ptr,
-					aclflag);
+			rc = replace_sids_and_copy_aces(dacl_ptr, ndacl_ptr,
+							owner_sid_ptr, group_sid_ptr,
+							nowner_sid_ptr, ngroup_sid_ptr,
+							aclflag, &size);
+			if (rc)
+				goto chown_chgrp_exit;
 			ndacl_ptr->size = cpu_to_le16(size);
 		}
 


