Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F3A13B7AE;
	Thu, 23 May 2024 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470662; cv=none; b=aCsNTHkgLdKpaRLzvt8oq31UxzdhK26BxINTqdov4i5ZKFqrs3XznFUd0ieEmOxq3VS+BirNFzREKz7LqM0BRDmSlKI8SdI8jK66tNtcREQMpqTKV9rIhPAbhFrtYlx6Mp5CxuS5cTKxICRKR0sHVRxATkK4sTmiKj76uPu2/PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470662; c=relaxed/simple;
	bh=fBQTXv/2V5fuBrKrYoE2bD3dnNnlzFgOMYzoDWzuuzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwBiw/dJSjJXEc4l54QhNGTnelgcZbwXyk9VYu3w4/mzSukvyzvP93DjLkCGG2K3kqmyCg2V5b/NtmvYB9WnUIY9ApIsYTwZ4RcGDKRIGtnG3quRw1PruLemqvtekUm79nELVN5M8++0ecZLlBorskp3TALp2yJzPxGkg+VOt+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcRNbzQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcRNbzQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE3BC32781;
	Thu, 23 May 2024 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470662;
	bh=fBQTXv/2V5fuBrKrYoE2bD3dnNnlzFgOMYzoDWzuuzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcRNbzQQRRUV5YnOAPPQNFZdck1kT07pDiSCdrHFK5jS0uS/xqKzuIF32wOEhrRqT
	 C0j7n9d7a4ddvCfwQo4bJDEk0WVLNvKqsFc9+KsRZWftHIhu5Ht+NEwwjxBgvpD11K
	 bPkXzAv3PSt7EPGpeaWH3OZmxN0RL+rs+Sm3jS1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/102] smb: client: retry compound request without reusing lease
Date: Thu, 23 May 2024 15:13:09 +0200
Message-ID: <20240523130344.127635533@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meetakshi Setiya <msetiya@microsoft.com>

[ Upstream commit 71f15c90e785d1de4bcd65a279e7256684c25c0d ]

There is a shortcoming in the current implementation of the file
lease mechanism exposed when the lease keys were attempted to be
reused for unlink, rename and set_path_size operations for a client. As
per MS-SMB2, lease keys are associated with the file name. Linux smb
client maintains lease keys with the inode. If the file has any hardlinks,
it is possible that the lease for a file be wrongly reused for an
operation on the hardlink or vice versa. In these cases, the mentioned
compound operations fail with STATUS_INVALID_PARAMETER.
This patch adds a fallback to the old mechanism of not sending any
lease with these compound operations if the request with lease key fails
with STATUS_INVALID_PARAMETER.
Resending the same request without lease key should not hurt any
functionality, but might impact performance especially in cases where
the error is not because of the usage of wrong lease key and we might
end up doing an extra roundtrip.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 41 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 0b7b083352919..add90eb8fc165 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -154,6 +154,17 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* if there is an existing lease, reuse it */
+
+	/*
+	 * note: files with hardlinks cause unexpected behaviour. As per MS-SMB2,
+	 * lease keys are associated with the filepath. We are maintaining lease keys
+	 * with the inode on the client. If the file has hardlinks, it is possible
+	 * that the lease for a file be reused for an operation on its hardlink or
+	 * vice versa.
+	 * As a workaround, send request using an existing lease key and if the server
+	 * returns STATUS_INVALID_PARAMETER, which maps to EINVAL, send the request
+	 * again without the lease.
+	 */
 	if (dentry) {
 		inode = d_inode(dentry);
 		if (CIFS_I(inode)->lease_granted && server->ops->get_lease_key) {
@@ -874,11 +885,20 @@ int
 smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	    struct cifs_sb_info *cifs_sb, struct dentry *dentry)
 {
-	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
+	int rc = smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
 				ACL_NO_MODE, NULL,
 				&(int){SMB2_OP_DELETE}, 1,
 				NULL, NULL, NULL, dentry);
+	if (rc == -EINVAL) {
+		cifs_dbg(FYI, "invalid lease key, resending request without lease");
+		rc = smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
+				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
+				ACL_NO_MODE, NULL,
+				&(int){SMB2_OP_DELETE}, 1,
+				NULL, NULL, NULL, NULL);
+	}
+	return rc;
 }
 
 static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
@@ -919,8 +939,14 @@ int smb2_rename_path(const unsigned int xid,
 	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
-	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
+	int rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  co, DELETE, SMB2_OP_RENAME, cfile, source_dentry);
+	if (rc == -EINVAL) {
+		cifs_dbg(FYI, "invalid lease key, resending request without lease");
+		rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
+				  co, DELETE, SMB2_OP_RENAME, cfile, NULL);
+	}
+	return rc;
 }
 
 int smb2_create_hardlink(const unsigned int xid,
@@ -949,11 +975,20 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 	in_iov.iov_base = &eof;
 	in_iov.iov_len = sizeof(eof);
 	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
-	return smb2_compound_op(xid, tcon, cifs_sb, full_path,
+	int rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				FILE_WRITE_DATA, FILE_OPEN,
 				0, ACL_NO_MODE, &in_iov,
 				&(int){SMB2_OP_SET_EOF}, 1,
 				cfile, NULL, NULL, dentry);
+	if (rc == -EINVAL) {
+		cifs_dbg(FYI, "invalid lease key, resending request without lease");
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+				FILE_WRITE_DATA, FILE_OPEN,
+				0, ACL_NO_MODE, &in_iov,
+				&(int){SMB2_OP_SET_EOF}, 1,
+				cfile, NULL, NULL, NULL);
+	}
+	return rc;
 }
 
 int
-- 
2.43.0



