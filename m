Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E354331A68;
	Mon, 27 Oct 2025 18:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590917; cv=none; b=CPlrFHEIj5epniK+MT727JLtrwkrkvrxYCGvbh2ZwZ59/JxveCJf1BNTTZHb0eSO8XdeqS5QFLCso1dV5j1pFaaGP4qDVNQlBOaOeFx4dHkzx/lxSVTxnfhfiLJUl3Ke339LLD6+TG+Fc22VVTN+TFAf1Unk73e2ZVnhwpv6BWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590917; c=relaxed/simple;
	bh=AsZv0047e03XXlzPXKnmOalI3A13YUuKH9+u3jmthtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwORI65/LAHXlzUaI2Ja6jjgaWKliBN3RF97fluIE12dTdMEalTk46J1tUyJN+3g/RN4qCqBhzBdET9HT4aSGQQVw/A2nbUHsOZcFRjfpE1EZAOkzl5svTePbiit/yLEApw6+PZ7lK2OhfTQ2utuWqBTJE+GDKljpqwym/6Rh8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uE3i2top; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uE3i2top"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04E8C16AAE;
	Mon, 27 Oct 2025 18:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590917;
	bh=AsZv0047e03XXlzPXKnmOalI3A13YUuKH9+u3jmthtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uE3i2toprGNIeM7JuegkgstTJpKnOgMUx0CSv4Lb1RiKSoLCvftm54UUQWivVK6pO
	 lY7foggyFm32WK5H5Y0b+4tiSgoqnXyOljXX8uokO/c0pcq6LxW4v5RIon+3uVeUlk
	 RKifwajT0/uiLYwUOxB5ixeogcKN9G9EPJNNeQGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Evtushenko <koevtushenko@yandex.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 222/224] NFSD: Fix last write offset handling in layoutcommit
Date: Mon, 27 Oct 2025 19:36:08 +0100
Message-ID: <20251027183514.666719119@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit d68886bae76a4b9b3484d23e5b7df086f940fa38 ]

The data type of loca_last_write_offset is newoffset4 and is switched
on a boolean value, no_newoffset, that indicates if a previous write
occurred or not. If no_newoffset is FALSE, an offset is not given.
This means that client does not try to update the file size. Thus,
server should not try to calculate new file size and check if it fits
into the segment range. See RFC 8881, section 12.5.4.2.

Sometimes the current incorrect logic may cause clients to hang when
trying to sync an inode. If layoutcommit fails, the client marks the
inode as dirty again.

Fixes: 9cf514ccfacb ("nfsd: implement pNFS operations")
Cc: stable@vger.kernel.org
Co-developed-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ replaced inode_get_mtime() with inode->i_mtime and removed rqstp parameter from proc_layoutcommit() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/blocklayout.c |    5 ++---
 fs/nfsd/nfs4proc.c    |   30 +++++++++++++++---------------
 2 files changed, 17 insertions(+), 18 deletions(-)

--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -120,7 +120,6 @@ static __be32
 nfsd4_block_commit_blocks(struct inode *inode, struct nfsd4_layoutcommit *lcp,
 		struct iomap *iomaps, int nr_iomaps)
 {
-	loff_t new_size = lcp->lc_last_wr + 1;
 	struct iattr iattr = { .ia_valid = 0 };
 	int error;
 
@@ -130,9 +129,9 @@ nfsd4_block_commit_blocks(struct inode *
 	iattr.ia_valid |= ATTR_ATIME | ATTR_CTIME | ATTR_MTIME;
 	iattr.ia_atime = iattr.ia_ctime = iattr.ia_mtime = lcp->lc_mtime;
 
-	if (new_size > i_size_read(inode)) {
+	if (lcp->lc_size_chg) {
 		iattr.ia_valid |= ATTR_SIZE;
-		iattr.ia_size = new_size;
+		iattr.ia_size = lcp->lc_newsize;
 	}
 
 	error = inode->i_sb->s_export_op->commit_blocks(inode, iomaps,
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1701,7 +1701,6 @@ nfsd4_layoutcommit(struct svc_rqst *rqst
 	const struct nfsd4_layout_seg *seg = &lcp->lc_seg;
 	struct svc_fh *current_fh = &cstate->current_fh;
 	const struct nfsd4_layout_ops *ops;
-	loff_t new_size = lcp->lc_last_wr + 1;
 	struct inode *inode;
 	struct nfs4_layout_stateid *ls;
 	__be32 nfserr;
@@ -1716,13 +1715,21 @@ nfsd4_layoutcommit(struct svc_rqst *rqst
 		goto out;
 	inode = d_inode(current_fh->fh_dentry);
 
-	nfserr = nfserr_inval;
-	if (new_size <= seg->offset)
-		goto out;
-	if (new_size > seg->offset + seg->length)
-		goto out;
-	if (!lcp->lc_newoffset && new_size > i_size_read(inode))
-		goto out;
+	lcp->lc_size_chg = false;
+	if (lcp->lc_newoffset) {
+		loff_t new_size = lcp->lc_last_wr + 1;
+
+		nfserr = nfserr_inval;
+		if (new_size <= seg->offset)
+			goto out;
+		if (new_size > seg->offset + seg->length)
+			goto out;
+
+		if (new_size > i_size_read(inode)) {
+			lcp->lc_size_chg = true;
+			lcp->lc_newsize = new_size;
+		}
+	}
 
 	nfserr = nfsd4_preprocess_layout_stateid(rqstp, cstate, &lcp->lc_sid,
 						false, lcp->lc_layout_type,
@@ -1738,13 +1745,6 @@ nfsd4_layoutcommit(struct svc_rqst *rqst
 	/* LAYOUTCOMMIT does not require any serialization */
 	mutex_unlock(&ls->ls_mutex);
 
-	if (new_size > i_size_read(inode)) {
-		lcp->lc_size_chg = 1;
-		lcp->lc_newsize = new_size;
-	} else {
-		lcp->lc_size_chg = 0;
-	}
-
 	nfserr = ops->proc_layoutcommit(inode, lcp);
 	nfs4_put_stid(&ls->ls_stid);
 out:


