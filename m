Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF27A13AD12;
	Tue, 18 Jun 2024 12:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715023; cv=none; b=EibxzPk3SelHPYj3JxiAsde5Z4PqR2DSn+1tZniWyWLH2pr9UmLX7EfEre4cbeHe+aurAE8m1/FbP3XQR11Mc80AbjSZJVrgyfhiQKiDBUZRw79SI5EeIi5Tk/Ye/ZwkE7nppwitXH4k31WfN11TA3uhvR7vCLOTYEjwulKw1+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715023; c=relaxed/simple;
	bh=z9k78VW6olLWWnRXaYJ0547BN+lM27YnQwnfp274fuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diFEDubZHei7yS6ySTCJ0bY6BHnbJqAo3MIwTwTgmrnOb7JoEXJCzz/RxdakjzHQEvkA6QxAdL/ZeK/iIRLDE1HGBaeAIhljjtnQtEts/yTxvPyl8xM06+6o0uOShXACiFvyq0z3Nl8DlzQxWdpBCTveXLGsR+4CCTxJwy8jbc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyouW+na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyouW+na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE16C3277B;
	Tue, 18 Jun 2024 12:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715023;
	bh=z9k78VW6olLWWnRXaYJ0547BN+lM27YnQwnfp274fuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyouW+naliiDib49BHq9Z54JxMnX4LwhxkSItwfbrgxpG+s3pMZT8Uywf+qAtYGu6
	 tkQvq7cu11IPD3/QQBOgJsmtQgVHIuhwwJUa7VDn1EbyLIv8ZUBbApBvdVhDj0b5jt
	 nbhf15uBqvFpM+HwO8TP7Rtxs00KSQQIadyUcS7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/770] NFSD: Add an xdr_stream-based decoder for NFSv2/3 ACLs
Date: Tue, 18 Jun 2024 14:30:20 +0200
Message-ID: <20240618123413.719641716@linuxfoundation.org>
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

[ Upstream commit 6bb844b4eb6e3b109a2fdaffb60e6da722dc4356 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs_common/nfsacl.c | 52 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/nfsacl.h |  3 +++
 2 files changed, 55 insertions(+)

diff --git a/fs/nfs_common/nfsacl.c b/fs/nfs_common/nfsacl.c
index d056ad2fdefd6..79c563c1a5e84 100644
--- a/fs/nfs_common/nfsacl.c
+++ b/fs/nfs_common/nfsacl.c
@@ -295,3 +295,55 @@ int nfsacl_decode(struct xdr_buf *buf, unsigned int base, unsigned int *aclcnt,
 		   nfsacl_desc.desc.array_len;
 }
 EXPORT_SYMBOL_GPL(nfsacl_decode);
+
+/**
+ * nfs_stream_decode_acl - Decode an NFSv3 ACL
+ *
+ * @xdr: an xdr_stream positioned at an encoded ACL
+ * @aclcnt: OUT: count of ACEs in decoded posix_acl
+ * @pacl: OUT: a dynamically-allocated buffer containing the decoded posix_acl
+ *
+ * Return values:
+ *   %false: The encoded ACL is not valid
+ *   %true: @pacl contains a decoded ACL, and @xdr is advanced
+ *
+ * On a successful return, caller must release *pacl using posix_acl_release().
+ */
+bool nfs_stream_decode_acl(struct xdr_stream *xdr, unsigned int *aclcnt,
+			   struct posix_acl **pacl)
+{
+	const size_t elem_size = XDR_UNIT * 3;
+	struct nfsacl_decode_desc nfsacl_desc = {
+		.desc = {
+			.elem_size = elem_size,
+			.xcode = pacl ? xdr_nfsace_decode : NULL,
+		},
+	};
+	unsigned int base;
+	u32 entries;
+
+	if (xdr_stream_decode_u32(xdr, &entries) < 0)
+		return false;
+	if (entries > NFS_ACL_MAX_ENTRIES)
+		return false;
+
+	base = xdr_stream_pos(xdr);
+	if (!xdr_inline_decode(xdr, XDR_UNIT + elem_size * entries))
+		return false;
+	nfsacl_desc.desc.array_maxlen = entries;
+	if (xdr_decode_array2(xdr->buf, base, &nfsacl_desc.desc))
+		return false;
+
+	if (pacl) {
+		if (entries != nfsacl_desc.desc.array_len ||
+		    posix_acl_from_nfsacl(nfsacl_desc.acl) != 0) {
+			posix_acl_release(nfsacl_desc.acl);
+			return false;
+		}
+		*pacl = nfsacl_desc.acl;
+	}
+	if (aclcnt)
+		*aclcnt = entries;
+	return true;
+}
+EXPORT_SYMBOL_GPL(nfs_stream_decode_acl);
diff --git a/include/linux/nfsacl.h b/include/linux/nfsacl.h
index 103d446953234..0ba99c5136491 100644
--- a/include/linux/nfsacl.h
+++ b/include/linux/nfsacl.h
@@ -38,5 +38,8 @@ nfsacl_encode(struct xdr_buf *buf, unsigned int base, struct inode *inode,
 extern int
 nfsacl_decode(struct xdr_buf *buf, unsigned int base, unsigned int *aclcnt,
 	      struct posix_acl **pacl);
+extern bool
+nfs_stream_decode_acl(struct xdr_stream *xdr, unsigned int *aclcnt,
+		      struct posix_acl **pacl);
 
 #endif  /* __LINUX_NFSACL_H */
-- 
2.43.0



