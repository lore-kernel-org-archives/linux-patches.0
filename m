Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7E13C76AF;
	Tue, 16 Jun 2026 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632466; cv=none; b=h0Be5VQnpJ5f/25f//KgkSdO+U0Y5wOWcxHNJn1Uhf9BlMRhjnCYFFCcpBwLDWONP3qoSJVlTg5OB4raa5Z7j1s78Umby20SVAvuAjNoNVpg87WxVLYFk5eWE4Rp5ysKekALAf3566Eg08Lb0YYNJq4dMT3meP5aDQyt0noPoQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632466; c=relaxed/simple;
	bh=J5XsPx+IJ9sRWwkWHM8mtr/rsqKAleJzmAYfa6+H6gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTW0CorKw01O6lkbcfS9Ee+QkmSvggFJsbg9aASrxjtFUq+NVhzSe/T4Kg9FHVEUWOrNd3+Zs+t3FOw7aej+F/G/ukgRRFerhjd0TfQ2ZOU3VRRx2io6JkYIGNeKwaemM1ovKSay0nU3U6YA2sPPwjEPdDYE5HqLwasmY4rfcDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmRUYCGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmRUYCGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193191F000E9;
	Tue, 16 Jun 2026 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632464;
	bh=7Sj4kF3tB6olfJYwnswg5Rp28RpMl8B6g6dFnHt9ugk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmRUYCGPjnYU2hTvfFAarXBHWLx/9jzlv/QwgXB/tCLrYyHH+qmfD1Ze9vg0mu6C3
	 MWfl6p9kGeVYEDs1MCG4cGY/LFNmaUwznA7bz3Q3L6p4SjQkGD58tUZandvtOQFY1G
	 NKczgrDsjzwocZlvGqCY6TxLvG9R0tCUBsH7LUr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 417/522] smb: client: validate dacloffset before building DACL pointers
Date: Tue, 16 Jun 2026 20:29:24 +0530
Message-ID: <20260616145145.526900189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit f98b48151cc502ada59d9778f0112d21f2586ca3 ]

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
[ renamed smb_ntsd/smb_acl structs to cifs_ntsd/cifs_acl and kept existing inline ACL size check instead of using missing validate_dacl() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1254,6 +1254,17 @@ static int parse_sid(struct cifs_sid *ps
 	return 0;
 }
 
+static bool dacl_offset_valid(unsigned int acl_len, __u32 dacloffset)
+{
+	if (acl_len < sizeof(struct cifs_acl))
+		return false;
+
+	if (dacloffset < sizeof(struct cifs_ntsd))
+		return false;
+
+	return dacloffset <= acl_len - sizeof(struct cifs_acl);
+}
+
 
 /* Convert CIFS ACL to POSIX form */
 static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
@@ -1274,7 +1285,6 @@ static int parse_sec_desc(struct cifs_sb
 	group_sid_ptr = (struct cifs_sid *)((char *)pntsd +
 				le32_to_cpu(pntsd->gsidoffset));
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
-	dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
 	cifs_dbg(NOISY, "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
 		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
 		 le32_to_cpu(pntsd->gsidoffset),
@@ -1305,11 +1315,18 @@ static int parse_sec_desc(struct cifs_sb
 		return rc;
 	}
 
-	if (dacloffset)
+	if (dacloffset) {
+		if (!dacl_offset_valid(acl_len, dacloffset)) {
+			cifs_dbg(VFS, "Server returned illegal DACL offset\n");
+			return -EINVAL;
+		}
+
+		dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
 		parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
 			   group_sid_ptr, fattr, get_mode_from_special_sid);
-	else
+	} else {
 		cifs_dbg(FYI, "no ACL\n"); /* BB grant all or default perms? */
+	}
 
 	return rc;
 }
@@ -1332,6 +1349,11 @@ static int build_sec_desc(struct cifs_nt
 
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	if (dacloffset) {
+		if (!dacl_offset_valid(secdesclen, dacloffset)) {
+			cifs_dbg(VFS, "Server returned illegal DACL offset\n");
+			return -EINVAL;
+		}
+
 		dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
 		rc = validate_dacl(dacl_ptr, end_of_acl);
 		if (rc)
@@ -1698,6 +1720,12 @@ id_mode_to_cifs_acl(struct inode *inode,
 		nsecdesclen = sizeof(struct cifs_ntsd) + (sizeof(struct cifs_sid) * 2);
 		dacloffset = le32_to_cpu(pntsd->dacloffset);
 		if (dacloffset) {
+			if (!dacl_offset_valid(secdesclen, dacloffset)) {
+				cifs_dbg(VFS, "Server returned illegal DACL offset\n");
+				rc = -EINVAL;
+				goto id_mode_to_cifs_acl_exit;
+			}
+
 			dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
 			rc = validate_dacl(dacl_ptr, (char *)pntsd + secdesclen);
 			if (rc) {
@@ -1740,6 +1768,7 @@ id_mode_to_cifs_acl(struct inode *inode,
 		rc = ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
 		cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
 	}
+id_mode_to_cifs_acl_exit:
 	cifs_put_tlink(tlink);
 
 	kfree(pnntsd);


