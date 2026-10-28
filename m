Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216842;
	b=n/zPxayZbizvHpEo3p+3uGhWpM2ze4amJzZhEQ738E0Fnz1jhQ8QAfD9ACaqZqSn81Vt
	 heIT7lEU6MJeNCEZ0GnS/AjFon/5lzSbT5JGX5H9KHO9E2fxwgWVdVVyw3Rn62cJxTDej
	 NBYbFApvjWpLB9BPbTfk34ZZJAcBL5OURz4u/3tm/jnne47PfsHM/c3ySH22ubi8Uc/bV
	 H80fG6v6v7fptDyuO7wBY5n71z2cpedOYVTCAdCnvpbLD4++4qY9rLOWrXbI7kEYt/NYg
	 l9wO7t/lbMYHJvwHfJ3ZQOO+Y/js5clxpm1efUhFevSw3stulkdiL+kW7TeHO93adZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbPlPN8VOCSJqAXVpjz5b9fBVg8ceAYvD1mK6Qbp3qc=;
	b=fHk2OliENNQ5UPZTTSZPsur55CBqdScz+up/DN/0d7tNTquFhmtz7rNLaaNEcuv/6JNB
	 7kRMKLA4eGKbapBi6ydLsL0XyUo71A817jaDp62Tc8r23wtrLtUbEixHiKHSs+oJmMqbD
	 YHaq7ALP6vCpoiYkoVUenU7inGXY/lmJtBAcpj0S3GVKKXbBvAFoIAfjjEekNYaEHw4mU
	 ddHUDhdKQlJ7PUO7xunnkHXofUTE21zztAPK7Dbdh8eq23EW7yF9drNd21TciVMElCATQ
	 plhWEnnW6tQpZBTHA0fuTjxRQpv7HJld2qVyDQsmMy+cByu5lDikwVhdowlCuzvWreg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J+HXiyi/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9E6606A31A;
	Wed, 28 Oct 2026 19:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+HXiyi/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC00E1F01825;
	Wed, 28 Oct 2026 19:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216842;
	bh=hbPlPN8VOCSJqAXVpjz5b9fBVg8ceAYvD1mK6Qbp3qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+HXiyi/lKsxoa1hAFNZpmDN4+C0NucZ7VeQ/f7KCvolF1wyv8Fs5S4le2blhgoqZ
	 yNLUzINddHIqZP7LBUJ2PjbaubR2YvtrwKHqKrlFtrmaBTVNw/fk6b+VBeBYEfAEz3
	 ADMrTMwzCH/czATvx0LC+jLH4815Q0oDkWfJV3q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Bjoern Doebel <doebel@amazon.de>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1691/1887] smb: client: fail DACL rewrite when the new DACL exceeds 64K
Date: Wed, 28 Oct 2026 18:03:07 +0100
Message-ID: <20261028170537.936242721@linuxfoundation.org>
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
---
 fs/smb/client/cifsacl.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 39179e639b943..ba93199ef7327 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1016,12 +1016,12 @@ unsigned int setup_special_user_owner_ACE(struct cifs_ace *pntace)
 static void populate_new_aces(char *nacl_base,
 		struct cifs_sid *pownersid,
 		struct cifs_sid *pgrpsid,
-		__u64 *pnmode, u32 *pnum_aces, u16 *pnsize,
+		__u64 *pnmode, u32 *pnum_aces, u32 *pnsize,
 		bool modefromsid)
 {
 	__u64 nmode;
 	u32 num_aces = 0;
-	u16 nsize = 0;
+	u32 nsize = 0;
 	__u64 user_mode;
 	__u64 group_mode;
 	__u64 other_mode;
@@ -1118,16 +1118,16 @@ static void populate_new_aces(char *nacl_base,
 	*pnsize = nsize;
 }
 
-static __u16 replace_sids_and_copy_aces(struct cifs_acl *pdacl, struct cifs_acl *pndacl,
+static int replace_sids_and_copy_aces(struct cifs_acl *pdacl, struct cifs_acl *pndacl,
 		struct cifs_sid *pownersid, struct cifs_sid *pgrpsid,
-		struct cifs_sid *pnownersid, struct cifs_sid *pngrpsid)
+		struct cifs_sid *pnownersid, struct cifs_sid *pngrpsid, u16 *pnsize)
 {
 	int i;
 	u16 size = 0;
 	struct cifs_ace *pntace = NULL;
 	char *acl_base = NULL;
 	u32 src_num_aces = 0;
-	u16 nsize = 0;
+	u32 nsize = 0;
 	struct cifs_ace *pnntace = NULL;
 	char *nacl_base = NULL;
 	u16 ace_size = 0;
@@ -1153,9 +1153,12 @@ static __u16 replace_sids_and_copy_aces(struct cifs_acl *pdacl, struct cifs_acl
 
 		size += le16_to_cpu(pntace->size);
 		nsize += ace_size;
+		if (nsize > U16_MAX)
+			return -EOVERFLOW;
 	}
 
-	return nsize;
+	*pnsize = nsize;
+	return 0;
 }
 
 static int set_chmod_dacl(struct cifs_acl *pdacl, struct cifs_acl *pndacl,
@@ -1167,7 +1170,7 @@ static int set_chmod_dacl(struct cifs_acl *pdacl, struct cifs_acl *pndacl,
 	struct cifs_ace *pntace = NULL;
 	char *acl_base = NULL;
 	u32 src_num_aces = 0;
-	u16 nsize = 0;
+	u32 nsize = 0;
 	struct cifs_ace *pnntace = NULL;
 	char *nacl_base = NULL;
 	u32 num_aces = 0;
@@ -1218,6 +1221,8 @@ static int set_chmod_dacl(struct cifs_acl *pdacl, struct cifs_acl *pndacl,
 
 		nsize += cifs_copy_ace(pnntace, pntace, NULL);
 		num_aces++;
+		if (nsize > U16_MAX)
+			return -EOVERFLOW;
 
 next_ace:
 		size += le16_to_cpu(pntace->size);
@@ -1234,6 +1239,10 @@ static int set_chmod_dacl(struct cifs_acl *pdacl, struct cifs_acl *pndacl,
 	}
 
 finalize_dacl:
+	/* The DACL size field is 16-bit on the wire, see MS-DTYP 2.4.5 */
+	if (nsize > U16_MAX)
+		return -EOVERFLOW;
+
 	pndacl->num_aces = cpu_to_le32(num_aces);
 	pndacl->size = cpu_to_le16(nsize);
 
@@ -1394,6 +1403,8 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 
 		rc = set_chmod_dacl(dacl_ptr, ndacl_ptr, owner_sid_ptr, group_sid_ptr,
 				    pnmode, mode_from_sid);
+		if (rc)
+			return rc;
 
 		sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
 		/* copy the non-dacl portion of secdesc */
@@ -1469,9 +1480,11 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 
 		if (dacloffset) {
 			/* Replace ACEs for old owner with new one */
-			size = replace_sids_and_copy_aces(dacl_ptr, ndacl_ptr,
+			rc = replace_sids_and_copy_aces(dacl_ptr, ndacl_ptr,
 					owner_sid_ptr, group_sid_ptr,
-					nowner_sid_ptr, ngroup_sid_ptr);
+					nowner_sid_ptr, ngroup_sid_ptr, &size);
+			if (rc)
+				goto chown_chgrp_exit;
 			ndacl_ptr->size = cpu_to_le16(size);
 		}
 
-- 
2.53.0



