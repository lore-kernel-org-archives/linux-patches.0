Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5583815DF;
	Sat, 12 Sep 2026 18:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238064; cv=none; b=kC8UkFJR5R3aNPgvS1X4pvPg4vT7jaSRzYkz1bNj0NQz7O5kwmViUULRO/1pykxYXYfs2n5aid4ONeucx981kveIAVcMIPzsb+yNVMVJmZRmiQEEekF6LQa7VeukuZ2vqz7sMDCOJ+0W/c8PSR+4Nwebf4EvXrW0ammTHq2uV3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238064; c=relaxed/simple;
	bh=Muiuk3sSoS5PY3iSPRNpdK/lLLXhdUfAit5sdnKGFvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSTemKQefzfoC6gxLMZ0zHjvHMRU1Z1dAGepSE2f8JGOoDWY2zCptNn85kDtrBuQqX2OQkNgKpgOPs2VDJSjO1JUSXKwwKxHXQD+GlfFSSlvRGLkFlE8HGrj5Xnl+49OHS+Mfh3zx+g20OfTAQSYOiuNX529KGTq7OSWCYigJiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3DfGGrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3DfGGrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20F81F000FF;
	Sat, 12 Sep 2026 18:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238063;
	bh=7YbDtp07SvgMPJqMKEAYFp7W+5nTEt+hpdg73WXcTB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3DfGGrU/k/3i3SOOWvYQQH/jT6qWtuYR/Ry1aG0X8Mav9L2g7I3DGk9bVDb8wBEd
	 7+NSlKkghyuxV3CTt3YxatvD7pt78d9Z4foMo1IHyxEf6fnA334opovK/5E6rMZRE5
	 HBGijwNO/NvNrDeGbiqr+gb02Ua6KIAwW0hFhRhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 385/935] ksmbd: fix overflow in dacloffset bounds check
Date: Sat, 12 Sep 2026 08:56:55 +0200
Message-ID: <20260912065535.651692708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/smbacl.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index cf5361b63c7db..0697574017e9d 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/mnt_idmapping.h>
+#include <linux/overflow.h>
 
 #include "smbacl.h"
 #include "smb_common.h"
@@ -1008,7 +1009,9 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	struct dentry *parent = path->dentry->d_parent;
 	struct user_namespace *user_ns = mnt_user_ns(path->mnt);
 	int inherited_flags = 0, flags = 0, i, ace_cnt = 0, nt_size = 0, pdacl_size;
-	int rc = 0, num_aces, dacloffset, pntsd_type, pntsd_size, acl_len, aces_size;
+	int rc = 0, num_aces, pntsd_type, pntsd_size, acl_len, aces_size;
+	unsigned int dacloffset;
+	size_t dacl_struct_end;
 	char *aces_base;
 	bool is_dir = S_ISDIR(d_inode(path->dentry)->i_mode);
 
@@ -1016,8 +1019,11 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
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
@@ -1220,7 +1226,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
@@ -1239,7 +1247,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 	dacl_offset = le32_to_cpu(pntsd->dacloffset);
 	if (!dacl_offset ||
-	    (dacl_offset + sizeof(struct smb_acl) > pntsd_size))
+	    check_add_overflow(dacl_offset, sizeof(struct smb_acl), &dacl_struct_end) ||
+	    dacl_struct_end > (size_t)pntsd_size)
 		goto err_out;
 
 	pdacl = (struct smb_acl *)((char *)pntsd + le32_to_cpu(pntsd->dacloffset));
-- 
2.53.0



