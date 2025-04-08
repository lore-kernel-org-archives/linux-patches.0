Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC34227BB6;
	Tue,  8 Apr 2025 11:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112171; cv=none; b=TBgloI5pgF08ON8+lD/dT921C2nJKm5a5hk8UY2ZDhb4a8UvDhlA18P2LN+kG+uASh7ks0r/+VfIIb6DPtBOTLF6FEwhhJwYhu+/TVKggArCXe0Oj3sBjn3JviyiUHboYW9cBc9lNQNUPHWO6OyGyR6o5Fz1W67jltMUPaPUyLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112171; c=relaxed/simple;
	bh=6XRXn9FjuoSf86RbOuaVS9Jfr5xIsQULPVPZR7F+iIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe4GDfsYeMqFNRexxhHJ4Y96Y5QkpLfZJKIO1kOpFtTvapbrFdm4PL3K4M+aeuQgjsF5BAzJqi4o0rR28LMwrwlJrKVMeHtqiGCCScJKio7e2igZazA4LrOroIBokwYr+BIGj+1gOQNT3ow0y8/w37OmoIA0hWx7xXf8GPDT2yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g93ZuKHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g93ZuKHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078B1C4CEEB;
	Tue,  8 Apr 2025 11:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112171;
	bh=6XRXn9FjuoSf86RbOuaVS9Jfr5xIsQULPVPZR7F+iIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g93ZuKHJi7UkRrnc775PvGBdkP4Dgd9povjI2wwN9T6o/2qU2VB4+5A3BIc+CghSE
	 psmMD66XWcnft3jiTfWkay9ZXuTLyEzQsoa9i23hPMJQXkKyxdGj7XMP/38/W03ONU
	 pY684fWJ8HsDHlukzMuu9eR8PjiQM+7bdwEofCEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 702/731] ksmbd: fix overflow in dacloffset bounds check
Date: Tue,  8 Apr 2025 12:49:59 +0200
Message-ID: <20250408104930.597476084@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit beff0bc9d69bc8e733f9bca28e2d3df5b3e10e42 upstream.

The dacloffset field was originally typed as int and used in an
unchecked addition, which could overflow and bypass the existing
bounds check in both smb_check_perm_dacl() and smb_inherit_dacl().

This could result in out-of-bounds memory access and a kernel crash
when dereferencing the DACL pointer.

This patch converts dacloffset to unsigned int and uses
check_add_overflow() to validate access to the DACL.

Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1026,7 +1026,9 @@ int smb_inherit_dacl(struct ksmbd_conn *
 	struct dentry *parent = path->dentry->d_parent;
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	int inherited_flags = 0, flags = 0, i, nt_size = 0, pdacl_size;
-	int rc = 0, dacloffset, pntsd_type, pntsd_size, acl_len, aces_size;
+	int rc = 0, pntsd_type, pntsd_size, acl_len, aces_size;
+	unsigned int dacloffset;
+	size_t dacl_struct_end;
 	u16 num_aces, ace_cnt = 0;
 	char *aces_base;
 	bool is_dir = S_ISDIR(d_inode(path->dentry)->i_mode);
@@ -1035,8 +1037,11 @@ int smb_inherit_dacl(struct ksmbd_conn *
 					    parent, &parent_pntsd);
 	if (pntsd_size <= 0)
 		return -ENOENT;
+
 	dacloffset = le32_to_cpu(parent_pntsd->dacloffset);
-	if (!dacloffset || (dacloffset + sizeof(struct smb_acl) > pntsd_size)) {
+	if (!dacloffset ||
+	    check_add_overflow(dacloffset, sizeof(struct smb_acl), &dacl_struct_end) ||
+	    dacl_struct_end > (size_t)pntsd_size) {
 		rc = -EINVAL;
 		goto free_parent_pntsd;
 	}
@@ -1240,7 +1245,9 @@ int smb_check_perm_dacl(struct ksmbd_con
 	struct smb_ntsd *pntsd = NULL;
 	struct smb_acl *pdacl;
 	struct posix_acl *posix_acls;
-	int rc = 0, pntsd_size, acl_size, aces_size, pdacl_size, dacl_offset;
+	int rc = 0, pntsd_size, acl_size, aces_size, pdacl_size;
+	unsigned int dacl_offset;
+	size_t dacl_struct_end;
 	struct smb_sid sid;
 	int granted = le32_to_cpu(*pdaccess & ~FILE_MAXIMAL_ACCESS_LE);
 	struct smb_ace *ace;
@@ -1259,7 +1266,8 @@ int smb_check_perm_dacl(struct ksmbd_con
 
 	dacl_offset = le32_to_cpu(pntsd->dacloffset);
 	if (!dacl_offset ||
-	    (dacl_offset + sizeof(struct smb_acl) > pntsd_size))
+	    check_add_overflow(dacl_offset, sizeof(struct smb_acl), &dacl_struct_end) ||
+	    dacl_struct_end > (size_t)pntsd_size)
 		goto err_out;
 
 	pdacl = (struct smb_acl *)((char *)pntsd + le32_to_cpu(pntsd->dacloffset));


