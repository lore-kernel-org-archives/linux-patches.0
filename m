Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB8C23E356;
	Tue, 12 May 2026 18:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609484; cv=none; b=PnFC4JNy4SMdUY+hEadEEN/HtQ9pwLug6eaTt5gLrWZJdj8Z/HCDfW7+gtq5hDguEKz8lK9sGPuNdv9+wXCtg4WgEGwIXvCf3NRF4kMJhZSTiIfm6SuM8NRF/MGmkP4vCcz+cxKumMqmvvJYwZYrYoVoI/kPw490y5SyQePDdgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609484; c=relaxed/simple;
	bh=t5N5bKwmu5bFlZLhPt1tQtG+9P4AIZM8CRUBW6UIoD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAewJqyB5IXRG24OtJeHjvpukanZjRjYhRsqQAsONPTHCNpZ5e8HkSvjT30KbU+DtHV6Sb99XDwE0ADauPN82M4IhY2kMCFRjJeahOPyzvUsKqRKS4ZkwOImoDqbz5a1Ua4brEc57G7D7HVC8+ZjnW6wRok87j3SGOVoF27AlOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERV2oz/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERV2oz/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8925C2BCB0;
	Tue, 12 May 2026 18:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609484;
	bh=t5N5bKwmu5bFlZLhPt1tQtG+9P4AIZM8CRUBW6UIoD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERV2oz/Zad7YxWluekcN9SbWrcPOYRHqpgqaMH/PgxkGU+x6aeMtZ1BftvB2J7oud
	 LP1uh6jg9HuzejhmgwcKGGFRwz8ogOtqLMo+mWviSfGjsPsq0lxpOUvz29mDFxxKe+
	 w0ayTJ5cvmxYAyU6kByF10QwkpuBZ7O5hfzkjBzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 214/307] smb: client: validate dacloffset before building DACL pointers
Date: Tue, 12 May 2026 19:40:09 +0200
Message-ID: <20260512173944.631870319@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit f98b48151cc502ada59d9778f0112d21f2586ca3 upstream.

parse_sec_desc(), build_sec_desc(), and the chown path in
id_mode_to_cifs_acl() all add the server-supplied dacloffset to pntsd
before proving a DACL header fits inside the returned security
descriptor.

On 32-bit builds a malicious server can return dacloffset near
U32_MAX, wrap the derived DACL pointer below end_of_acl, and then slip
past the later pointer-based bounds checks. build_sec_desc() and
id_mode_to_cifs_acl() can then dereference DACL fields from the wrapped
pointer in the chmod/chown rewrite paths.

Validate dacloffset numerically before building any DACL pointer and
reuse the same helper at the three DACL entry points.

Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1264,6 +1264,17 @@ static int parse_sid(struct smb_sid *psi
 	return 0;
 }
 
+static bool dacl_offset_valid(unsigned int acl_len, __u32 dacloffset)
+{
+	if (acl_len < sizeof(struct smb_acl))
+		return false;
+
+	if (dacloffset < sizeof(struct smb_ntsd))
+		return false;
+
+	return dacloffset <= acl_len - sizeof(struct smb_acl);
+}
+
 
 /* Convert CIFS ACL to POSIX form */
 static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
@@ -1284,7 +1295,6 @@ static int parse_sec_desc(struct cifs_sb
 	group_sid_ptr = (struct smb_sid *)((char *)pntsd +
 				le32_to_cpu(pntsd->gsidoffset));
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
-	dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 	cifs_dbg(NOISY, "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
 		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
 		 le32_to_cpu(pntsd->gsidoffset),
@@ -1315,11 +1325,18 @@ static int parse_sec_desc(struct cifs_sb
 		return rc;
 	}
 
-	if (dacloffset)
+	if (dacloffset) {
+		if (!dacl_offset_valid(acl_len, dacloffset)) {
+			cifs_dbg(VFS, "Server returned illegal DACL offset\n");
+			return -EINVAL;
+		}
+
+		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 		parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
 			   group_sid_ptr, fattr, get_mode_from_special_sid);
-	else
+	} else {
 		cifs_dbg(FYI, "no ACL\n"); /* BB grant all or default perms? */
+	}
 
 	return rc;
 }
@@ -1342,6 +1359,11 @@ static int build_sec_desc(struct smb_nts
 
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	if (dacloffset) {
+		if (!dacl_offset_valid(secdesclen, dacloffset)) {
+			cifs_dbg(VFS, "Server returned illegal DACL offset\n");
+			return -EINVAL;
+		}
+
 		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 		rc = validate_dacl(dacl_ptr, end_of_acl);
 		if (rc)
@@ -1710,6 +1732,12 @@ id_mode_to_cifs_acl(struct inode *inode,
 		nsecdesclen = sizeof(struct smb_ntsd) + (sizeof(struct smb_sid) * 2);
 		dacloffset = le32_to_cpu(pntsd->dacloffset);
 		if (dacloffset) {
+			if (!dacl_offset_valid(secdesclen, dacloffset)) {
+				cifs_dbg(VFS, "Server returned illegal DACL offset\n");
+				rc = -EINVAL;
+				goto id_mode_to_cifs_acl_exit;
+			}
+
 			dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 			rc = validate_dacl(dacl_ptr, (char *)pntsd + secdesclen);
 			if (rc) {
@@ -1752,6 +1780,7 @@ id_mode_to_cifs_acl(struct inode *inode,
 		rc = ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
 		cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
 	}
+id_mode_to_cifs_acl_exit:
 	cifs_put_tlink(tlink);
 
 	kfree(pnntsd);


