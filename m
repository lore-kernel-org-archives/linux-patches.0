Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4ED331EC7;
	Sat, 12 Sep 2026 15:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228802; cv=none; b=L5DbiZRJmHL60Om/SSeoAubiOYJBMtMvamekbyzqEjOBAhQdwIOCeFP4gZ03IT6zBJilihY2jb+C0kIKafVn3fb31WJMHRxkPHYpOXErphswFtB/kDDn9fzfxWS38TGlzhK4JcuZ6Gzdt0lqX3hnf32v2+3ukemxWeTotPn6qB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228802; c=relaxed/simple;
	bh=kRsyOgu/t781NKo+Ke0F2APmDU61+f37DGZlqBcSzvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjXZvPSbpMC83stsbHNqTj7TlSzLAJ+Uh6DFUPfhUGGbP7oc0L/6JCtpukOYGuIRTxLgr7A+skKD/KT2D3SVPUFEXWfPwfADCWjkq/HDI25ujokytUAgdCmTiUeb9v+w/3222qlsDL6NAYGPcxNhEjPRu8YiWj9Rd2mFhyUMIgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOWMfPfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOWMfPfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7591F00893;
	Sat, 12 Sep 2026 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228798;
	bh=KWSZ2HMtcOciQDf0dzZ21N62VMi3mc+4ANI8flw7yuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOWMfPfbE/zN9P6nDLjyiUIcU7H2nr9NnwIuEfkEqUKSiNB69lh2ccXfvK+NDipdu
	 kqs28NZBVpWcPL4HuTM14aFLhXzAwK3rAfwYo9n9cHvRTFnrtEItIrjlOtpc1OqA6T
	 LLw6A7p7T6MdLfX4hd4hSLDjPGltVECK+VqHFzSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0457/1191] ksmbd: fix overflow in dacloffset bounds check
Date: Sat, 12 Sep 2026 08:53:05 +0200
Message-ID: <20260912065558.500168363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit beff0bc9d69bc8e733f9bca28e2d3df5b3e10e42 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 2b2d8fbaa392e..17987e83bdd87 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1057,7 +1057,9 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	struct dentry *parent = path->dentry->d_parent;
 	struct user_namespace *user_ns = mnt_user_ns(path->mnt);
 	int inherited_flags = 0, flags = 0, i, ace_cnt = 0, nt_size = 0, pdacl_size;
-	int rc = 0, num_aces, dacloffset, pntsd_type, pntsd_size, acl_len, aces_size;
+	int rc = 0, num_aces, pntsd_type, pntsd_size, acl_len, aces_size;
+	unsigned int dacloffset;
+	size_t dacl_struct_end;
 	char *aces_base;
 	bool is_dir = S_ISDIR(d_inode(path->dentry)->i_mode);
 
@@ -1065,8 +1067,11 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
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
@@ -1269,7 +1274,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
@@ -1288,7 +1295,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 	dacl_offset = le32_to_cpu(pntsd->dacloffset);
 	if (!dacl_offset ||
-	    (dacl_offset + sizeof(struct smb_acl) > pntsd_size))
+	    check_add_overflow(dacl_offset, sizeof(struct smb_acl), &dacl_struct_end) ||
+	    dacl_struct_end > (size_t)pntsd_size)
 		goto err_out;
 
 	pdacl = (struct smb_acl *)((char *)pntsd + le32_to_cpu(pntsd->dacloffset));
-- 
2.53.0



