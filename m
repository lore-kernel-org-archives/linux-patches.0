Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CD42701B6;
	Tue, 21 Oct 2025 20:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076990; cv=none; b=DFrHvWZc6Cx8nLxGSt/tZ+9ues1PYI7JoYVD12Hz+JcvfCB+eETdBAs/LjVR1jOts3osFN/uMjPPNoOQijzoIDkYcVUuP28/B5ES29k9y+fk5ovIxInzQgWvYq/1gRlA/JD5FGpYFezyf+yF192VPIyQXKTee/nw9Km2R/tD4JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076990; c=relaxed/simple;
	bh=HR1SATF196vk2Z1e/xQoYA1ZcMRvMaqnbFV9fhZeLhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9HWDrC2N58f41vzco066qtgr3LKDDFAf3i2vLKlL7k5LxWyQffUdE4LcVDBrR0RU3c2xQGzBrz2OvbVSib4/6s47VWcUnCo6XUcEGr2G5mhIVVIkB0/XVj0mWF5YiUzt8HVrkN9xN90Q628gg4xFxLaKMZEPV1kQb/LDtmuEDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcGk/YnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcGk/YnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F7FC4CEF1;
	Tue, 21 Oct 2025 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076990;
	bh=HR1SATF196vk2Z1e/xQoYA1ZcMRvMaqnbFV9fhZeLhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcGk/YnWWLW541sau3/wwAor1GXPSI2b//P3GFTPEblQWYnMj8MhclWbxpSQXS4Tq
	 JjDDljRLQxyxmiIW2Sw7mac6MClyuFi8E/xsAfz07+ni+agxzba0KqH8caOxSBoPlG
	 TN2nldB1HGHB7uxtzMXB9ESitI7A7ceBI/cZjP3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/136] nfsd: Use correct error code when decoding extents
Date: Tue, 21 Oct 2025 21:51:30 +0200
Message-ID: <20251021195038.414076889@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 26d05e1c37d276905bc921384b5a75158fca284b ]

Update error codes in decoding functions of block and scsi layout
drivers to match the core nfsd code. NFS4ERR_EINVAL means that the
server was able to decode the request, but the decoded values are
invalid. Use NFS4ERR_BADXDR instead to indicate a decoding error.
And ENOMEM is changed to nfs code NFS4ERR_DELAY.

Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: d68886bae76a ("NFSD: Fix last write offset handling in layoutcommit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/blocklayout.c    |   20 +++++++------
 fs/nfsd/blocklayoutxdr.c |   71 +++++++++++++++++++++++++++++++++++++----------
 fs/nfsd/blocklayoutxdr.h |    8 ++---
 fs/nfsd/nfsd.h           |    1 
 4 files changed, 73 insertions(+), 27 deletions(-)

--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -178,11 +178,13 @@ nfsd4_block_proc_layoutcommit(struct ino
 {
 	struct iomap *iomaps;
 	int nr_iomaps;
+	__be32 nfserr;
 
-	nr_iomaps = nfsd4_block_decode_layoutupdate(lcp->lc_up_layout,
-			lcp->lc_up_len, &iomaps, i_blocksize(inode));
-	if (nr_iomaps < 0)
-		return nfserrno(nr_iomaps);
+	nfserr = nfsd4_block_decode_layoutupdate(lcp->lc_up_layout,
+			lcp->lc_up_len, &iomaps, &nr_iomaps,
+			i_blocksize(inode));
+	if (nfserr != nfs_ok)
+		return nfserr;
 
 	return nfsd4_block_commit_blocks(inode, lcp, iomaps, nr_iomaps);
 }
@@ -316,11 +318,13 @@ nfsd4_scsi_proc_layoutcommit(struct inod
 {
 	struct iomap *iomaps;
 	int nr_iomaps;
+	__be32 nfserr;
 
-	nr_iomaps = nfsd4_scsi_decode_layoutupdate(lcp->lc_up_layout,
-			lcp->lc_up_len, &iomaps, i_blocksize(inode));
-	if (nr_iomaps < 0)
-		return nfserrno(nr_iomaps);
+	nfserr = nfsd4_scsi_decode_layoutupdate(lcp->lc_up_layout,
+			lcp->lc_up_len, &iomaps, &nr_iomaps,
+			i_blocksize(inode));
+	if (nfserr != nfs_ok)
+		return nfserr;
 
 	return nfsd4_block_commit_blocks(inode, lcp, iomaps, nr_iomaps);
 }
--- a/fs/nfsd/blocklayoutxdr.c
+++ b/fs/nfsd/blocklayoutxdr.c
@@ -112,34 +112,54 @@ nfsd4_block_encode_getdeviceinfo(struct
 	return 0;
 }
 
-int
+/**
+ * nfsd4_block_decode_layoutupdate - decode the block layout extent array
+ * @p: pointer to the xdr data
+ * @len: number of bytes to decode
+ * @iomapp: pointer to store the decoded extent array
+ * @nr_iomapsp: pointer to store the number of extents
+ * @block_size: alignment of extent offset and length
+ *
+ * This function decodes the opaque field of the layoutupdate4 structure
+ * in a layoutcommit request for the block layout driver. The field is
+ * actually an array of extents sent by the client. It also checks that
+ * the file offset, storage offset and length of each extent are aligned
+ * by @block_size.
+ *
+ * Return values:
+ *   %nfs_ok: Successful decoding, @iomapp and @nr_iomapsp are valid
+ *   %nfserr_bad_xdr: The encoded array in @p is invalid
+ *   %nfserr_inval: An unaligned extent found
+ *   %nfserr_delay: Failed to allocate memory for @iomapp
+ */
+__be32
 nfsd4_block_decode_layoutupdate(__be32 *p, u32 len, struct iomap **iomapp,
-		u32 block_size)
+		int *nr_iomapsp, u32 block_size)
 {
 	struct iomap *iomaps;
 	u32 nr_iomaps, i;
 
 	if (len < sizeof(u32)) {
 		dprintk("%s: extent array too small: %u\n", __func__, len);
-		return -EINVAL;
+		return nfserr_bad_xdr;
 	}
 	len -= sizeof(u32);
 	if (len % PNFS_BLOCK_EXTENT_SIZE) {
 		dprintk("%s: extent array invalid: %u\n", __func__, len);
-		return -EINVAL;
+		return nfserr_bad_xdr;
 	}
 
 	nr_iomaps = be32_to_cpup(p++);
 	if (nr_iomaps != len / PNFS_BLOCK_EXTENT_SIZE) {
 		dprintk("%s: extent array size mismatch: %u/%u\n",
 			__func__, len, nr_iomaps);
-		return -EINVAL;
+		return nfserr_bad_xdr;
 	}
 
 	iomaps = kcalloc(nr_iomaps, sizeof(*iomaps), GFP_KERNEL);
 	if (!iomaps) {
 		dprintk("%s: failed to allocate extent array\n", __func__);
-		return -ENOMEM;
+		return nfserr_delay;
 	}
 
 	for (i = 0; i < nr_iomaps; i++) {
@@ -178,22 +198,42 @@ nfsd4_block_decode_layoutupdate(__be32 *
 	}
 
 	*iomapp = iomaps;
-	return nr_iomaps;
+	*nr_iomapsp = nr_iomaps;
+	return nfs_ok;
 fail:
 	kfree(iomaps);
-	return -EINVAL;
+	return nfserr_inval;
 }
 
-int
+/**
+ * nfsd4_scsi_decode_layoutupdate - decode the scsi layout extent array
+ * @p: pointer to the xdr data
+ * @len: number of bytes to decode
+ * @iomapp: pointer to store the decoded extent array
+ * @nr_iomapsp: pointer to store the number of extents
+ * @block_size: alignment of extent offset and length
+ *
+ * This function decodes the opaque field of the layoutupdate4 structure
+ * in a layoutcommit request for the scsi layout driver. The field is
+ * actually an array of extents sent by the client. It also checks that
+ * the offset and length of each extent are aligned by @block_size.
+ *
+ * Return values:
+ *   %nfs_ok: Successful decoding, @iomapp and @nr_iomapsp are valid
+ *   %nfserr_bad_xdr: The encoded array in @p is invalid
+ *   %nfserr_inval: An unaligned extent found
+ *   %nfserr_delay: Failed to allocate memory for @iomapp
+ */
+__be32
 nfsd4_scsi_decode_layoutupdate(__be32 *p, u32 len, struct iomap **iomapp,
-		u32 block_size)
+		int *nr_iomapsp, u32 block_size)
 {
 	struct iomap *iomaps;
 	u32 nr_iomaps, expected, i;
 
 	if (len < sizeof(u32)) {
 		dprintk("%s: extent array too small: %u\n", __func__, len);
-		return -EINVAL;
+		return nfserr_bad_xdr;
 	}
 
 	nr_iomaps = be32_to_cpup(p++);
@@ -201,13 +241,13 @@ nfsd4_scsi_decode_layoutupdate(__be32 *p
 	if (len != expected) {
 		dprintk("%s: extent array size mismatch: %u/%u\n",
 			__func__, len, expected);
-		return -EINVAL;
+		return nfserr_bad_xdr;
 	}
 
 	iomaps = kcalloc(nr_iomaps, sizeof(*iomaps), GFP_KERNEL);
 	if (!iomaps) {
 		dprintk("%s: failed to allocate extent array\n", __func__);
-		return -ENOMEM;
+		return nfserr_delay;
 	}
 
 	for (i = 0; i < nr_iomaps; i++) {
@@ -229,8 +269,9 @@ nfsd4_scsi_decode_layoutupdate(__be32 *p
 	}
 
 	*iomapp = iomaps;
-	return nr_iomaps;
+	*nr_iomapsp = nr_iomaps;
+	return nfs_ok;
 fail:
 	kfree(iomaps);
-	return -EINVAL;
+	return nfserr_inval;
 }
--- a/fs/nfsd/blocklayoutxdr.h
+++ b/fs/nfsd/blocklayoutxdr.h
@@ -54,9 +54,9 @@ __be32 nfsd4_block_encode_getdeviceinfo(
 		const struct nfsd4_getdeviceinfo *gdp);
 __be32 nfsd4_block_encode_layoutget(struct xdr_stream *xdr,
 		const struct nfsd4_layoutget *lgp);
-int nfsd4_block_decode_layoutupdate(__be32 *p, u32 len, struct iomap **iomapp,
-		u32 block_size);
-int nfsd4_scsi_decode_layoutupdate(__be32 *p, u32 len, struct iomap **iomapp,
-		u32 block_size);
+__be32 nfsd4_block_decode_layoutupdate(__be32 *p, u32 len,
+		struct iomap **iomapp, int *nr_iomapsp, u32 block_size);
+__be32 nfsd4_scsi_decode_layoutupdate(__be32 *p, u32 len,
+		struct iomap **iomapp, int *nr_iomapsp, u32 block_size);
 
 #endif /* _NFSD_BLOCKLAYOUTXDR_H */
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -286,6 +286,7 @@ void		nfsd_lockd_shutdown(void);
 #define	nfserr_cb_path_down	cpu_to_be32(NFSERR_CB_PATH_DOWN)
 #define	nfserr_locked		cpu_to_be32(NFSERR_LOCKED)
 #define	nfserr_wrongsec		cpu_to_be32(NFSERR_WRONGSEC)
+#define nfserr_delay			cpu_to_be32(NFS4ERR_DELAY)
 #define nfserr_badiomode		cpu_to_be32(NFS4ERR_BADIOMODE)
 #define nfserr_badlayout		cpu_to_be32(NFS4ERR_BADLAYOUT)
 #define nfserr_bad_session_digest	cpu_to_be32(NFS4ERR_BAD_SESSION_DIGEST)


