Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC77F219E0;
	Mon, 23 Jun 2025 13:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684363; cv=none; b=QrGQ+OjnRU64vCSnW+ETYhZpD46DlyvJDXBUOPdiwIBtdL4qsQ/aWhJBZJ6FR/tR1FqlLDqWmxYe3Nfsf4AwKMJCCSZS556TAT5RkJaBGwrvifk/AtsB5nqz8LDVx+0Rznpz2s3SgGQudInMHBPhfvdX02YQz5IL624M3z788dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684363; c=relaxed/simple;
	bh=QcAJOvGr1RsbKRBGLpsEds7+v7OUkARjxoLnLVL8Ovg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtE2gfpnX0MArAg08NEuU6ZVKxM1N+0BtmvRrli8MVXDA3Qt+9A6HbqJoeyhYtSW1o0kSOf5tOC4FGfh2OtnbRLzaaR/ebKmE5w0lm+cX2oXLUJyNd4gSadur+mprf0QGGbWdoySh26YdjRbb8SDGiCbZ6tlGUcbWzI9I+Ybwkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uus22f3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uus22f3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAD9C4CEEA;
	Mon, 23 Jun 2025 13:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684363;
	bh=QcAJOvGr1RsbKRBGLpsEds7+v7OUkARjxoLnLVL8Ovg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uus22f3AFsF5GVfu6FLC8mCvTIeVS2IBB9HruEOaJXmcrIU9Al+Ikvn3sxZk7ETzo
	 yWRwFaqeRKpRd47WfbB8bUQxg5BaDWgV65AVz/gfZu6p5oJGX2zsEc2SCf2c6GPePe
	 hd4ekvuMKqabQin1XiSuREUf4Fer/8dCCkByKi8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roland Mainz <roland.mainz@nrubsig.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.15 041/592] NFSD: Implement FATTR4_CLONE_BLKSIZE attribute
Date: Mon, 23 Jun 2025 14:59:59 +0200
Message-ID: <20250623130701.221502414@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit d6ca7d2643eebe09cf46840bdc7d68b6e07aba77 upstream.

RFC 7862 states that if an NFS server implements a CLONE operation,
it MUST also implement FATTR4_CLONE_BLKSIZE. NFSD implements CLONE,
but does not implement FATTR4_CLONE_BLKSIZE.

Note that in Section 12.2, RFC 7862 claims that
FATTR4_CLONE_BLKSIZE is RECOMMENDED, not REQUIRED. Likely this is
because a minor version is not permitted to add a REQUIRED
attribute. Confusing.

We assume this attribute reports a block size as a count of bytes,
as RFC 7862 does not specify a unit.

Reported-by: Roland Mainz <roland.mainz@nrubsig.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Roland Mainz <roland.mainz@nrubsig.org>
Cc: stable@vger.kernel.org # v6.7+
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3391,6 +3391,23 @@ static __be32 nfsd4_encode_fattr4_suppat
 	return nfsd4_encode_bitmap4(xdr, supp[0], supp[1], supp[2]);
 }
 
+/*
+ * Copied from generic_remap_checks/generic_remap_file_range_prep.
+ *
+ * These generic functions use the file system's s_blocksize, but
+ * individual file systems aren't required to use
+ * generic_remap_file_range_prep. Until there is a mechanism for
+ * determining a particular file system's (or file's) clone block
+ * size, this is the best NFSD can do.
+ */
+static __be32 nfsd4_encode_fattr4_clone_blksize(struct xdr_stream *xdr,
+						const struct nfsd4_fattr_args *args)
+{
+	struct inode *inode = d_inode(args->dentry);
+
+	return nfsd4_encode_uint32_t(xdr, inode->i_sb->s_blocksize);
+}
+
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 static __be32 nfsd4_encode_fattr4_sec_label(struct xdr_stream *xdr,
 					    const struct nfsd4_fattr_args *args)
@@ -3545,7 +3562,7 @@ static const nfsd4_enc_attr nfsd4_enc_fa
 	[FATTR4_MODE_SET_MASKED]	= nfsd4_encode_fattr4__noop,
 	[FATTR4_SUPPATTR_EXCLCREAT]	= nfsd4_encode_fattr4_suppattr_exclcreat,
 	[FATTR4_FS_CHARSET_CAP]		= nfsd4_encode_fattr4__noop,
-	[FATTR4_CLONE_BLKSIZE]		= nfsd4_encode_fattr4__noop,
+	[FATTR4_CLONE_BLKSIZE]		= nfsd4_encode_fattr4_clone_blksize,
 	[FATTR4_SPACE_FREED]		= nfsd4_encode_fattr4__noop,
 	[FATTR4_CHANGE_ATTR_TYPE]	= nfsd4_encode_fattr4__noop,
 


