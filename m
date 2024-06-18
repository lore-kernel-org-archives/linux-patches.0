Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1484152E00;
	Tue, 18 Jun 2024 12:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715204; cv=none; b=GW29WKsxcBIgEQw1nEuKHnQ5blVvEPj1/QHSxeiEhRuGRBUQKMViuELkIiQ08z8HlN4wgjWXbLF0dwSWNZ2fh441sscEQyr9FHrKmO8LkNFAG2vLHo5onI3shQpRtj7ioNn8veds1Xakssmtenvv0Rsu7Hid0YykQjcQvtXBM3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715204; c=relaxed/simple;
	bh=aT8AN9tMupG7ZW5DnLgZkcD33BsqAC7+BYMOefIihk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJM2D/PIDpd/Ke0Yh7s83TS1qiIZnBABPFk+sTYOV6QeryEHvY9hJALA2Y/bIDpR6OOQP2dwHtGEGeSAPky29TvOQ1tbP33Ah2hlPMOPE19WnLmBYAsQ8nMB2UAi0ws5KEE1N5IUuP5zb3wxlAyYhjraakGn0vEynHp7+qjOweo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbtqXdqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbtqXdqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDEDC3277B;
	Tue, 18 Jun 2024 12:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715203;
	bh=aT8AN9tMupG7ZW5DnLgZkcD33BsqAC7+BYMOefIihk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbtqXdqmuddfL7qfx9eofuwGuDCpIMt8K/Xx/4HwprKMuZ/CMa76IvGVv67ikn0+f
	 JJpAWmkIVKVsrNCelU99p41f7Mp0nH4W8JlWQNF3u2H9wKzaTScUk9nVfux04JsOhK
	 1VE+yX2BCQ7szZ7MnGQXGUANvoArFNloYvuAg9eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/770] NFSD: Add an xdr_stream-based encoder for NFSv2/3 ACLs
Date: Tue, 18 Jun 2024 14:31:22 +0200
Message-ID: <20240618123416.120785001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8edc0648880a151026fe625fa1b76772b5766f68 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs_common/nfsacl.c | 71 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/nfsacl.h |  3 ++
 2 files changed, 74 insertions(+)

diff --git a/fs/nfs_common/nfsacl.c b/fs/nfs_common/nfsacl.c
index 79c563c1a5e84..5a5bd85d08f8c 100644
--- a/fs/nfs_common/nfsacl.c
+++ b/fs/nfs_common/nfsacl.c
@@ -136,6 +136,77 @@ int nfsacl_encode(struct xdr_buf *buf, unsigned int base, struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(nfsacl_encode);
 
+/**
+ * nfs_stream_encode_acl - Encode an NFSv3 ACL
+ *
+ * @xdr: an xdr_stream positioned to receive an encoded ACL
+ * @inode: inode of file whose ACL this is
+ * @acl: posix_acl to encode
+ * @encode_entries: whether to encode ACEs as well
+ * @typeflag: ACL type: NFS_ACL_DEFAULT or zero
+ *
+ * Return values:
+ *   %false: The ACL could not be encoded
+ *   %true: @xdr is advanced to the next available position
+ */
+bool nfs_stream_encode_acl(struct xdr_stream *xdr, struct inode *inode,
+			   struct posix_acl *acl, int encode_entries,
+			   int typeflag)
+{
+	const size_t elem_size = XDR_UNIT * 3;
+	u32 entries = (acl && acl->a_count) ? max_t(int, acl->a_count, 4) : 0;
+	struct nfsacl_encode_desc nfsacl_desc = {
+		.desc = {
+			.elem_size = elem_size,
+			.array_len = encode_entries ? entries : 0,
+			.xcode = xdr_nfsace_encode,
+		},
+		.acl = acl,
+		.typeflag = typeflag,
+		.uid = inode->i_uid,
+		.gid = inode->i_gid,
+	};
+	struct nfsacl_simple_acl aclbuf;
+	unsigned int base;
+	int err;
+
+	if (entries > NFS_ACL_MAX_ENTRIES)
+		return false;
+	if (xdr_stream_encode_u32(xdr, entries) < 0)
+		return false;
+
+	if (encode_entries && acl && acl->a_count == 3) {
+		struct posix_acl *acl2 = &aclbuf.acl;
+
+		/* Avoid the use of posix_acl_alloc().  nfsacl_encode() is
+		 * invoked in contexts where a memory allocation failure is
+		 * fatal.  Fortunately this fake ACL is small enough to
+		 * construct on the stack. */
+		posix_acl_init(acl2, 4);
+
+		/* Insert entries in canonical order: other orders seem
+		 to confuse Solaris VxFS. */
+		acl2->a_entries[0] = acl->a_entries[0];  /* ACL_USER_OBJ */
+		acl2->a_entries[1] = acl->a_entries[1];  /* ACL_GROUP_OBJ */
+		acl2->a_entries[2] = acl->a_entries[1];  /* ACL_MASK */
+		acl2->a_entries[2].e_tag = ACL_MASK;
+		acl2->a_entries[3] = acl->a_entries[2];  /* ACL_OTHER */
+		nfsacl_desc.acl = acl2;
+	}
+
+	base = xdr_stream_pos(xdr);
+	if (!xdr_reserve_space(xdr, XDR_UNIT +
+			       elem_size * nfsacl_desc.desc.array_len))
+		return false;
+	err = xdr_encode_array2(xdr->buf, base, &nfsacl_desc.desc);
+	if (err)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(nfs_stream_encode_acl);
+
+
 struct nfsacl_decode_desc {
 	struct xdr_array2_desc desc;
 	unsigned int count;
diff --git a/include/linux/nfsacl.h b/include/linux/nfsacl.h
index 0ba99c5136491..8e76a79cdc6ae 100644
--- a/include/linux/nfsacl.h
+++ b/include/linux/nfsacl.h
@@ -41,5 +41,8 @@ nfsacl_decode(struct xdr_buf *buf, unsigned int base, unsigned int *aclcnt,
 extern bool
 nfs_stream_decode_acl(struct xdr_stream *xdr, unsigned int *aclcnt,
 		      struct posix_acl **pacl);
+extern bool
+nfs_stream_encode_acl(struct xdr_stream *xdr, struct inode *inode,
+		      struct posix_acl *acl, int encode_entries, int typeflag);
 
 #endif  /* __LINUX_NFSACL_H */
-- 
2.43.0



