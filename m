Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A9327587D;
	Tue, 21 Oct 2025 20:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077560; cv=none; b=qoomDUHzrZaE+PRygqcWctkTCDAHaChCtOJZ3lMRk09Q1x+Pd7TM6ypd5toDB/QSdJP7I+ocmf7n6R38aM4YdKRDkhV3EsmkoylOOp7jGISeFMO3g8TbBXoR9MFgCH6HnLmKY1X9Jd0+NWFjubMEuPwEnqWP0MGsWl7ikn9HQi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077560; c=relaxed/simple;
	bh=1GrkfA3zyQCQbvrdadoE+eqKG/x5ctC3hB0BE05OIvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvobbAcUciKBQYl6pqWtS9sRvNyN86pTVRea0Vij2uPoYJ6YiO4PM2gSF29BdDZj/ZHjq1rPb7h+JQ7IPzuvtoMsLtwq5vOlYkz8RhOlek453I6g4BOSo8ANhhEvuY2PKbwEI9DPuELytaRQ3lnFhaIZw8+rz88BfISelHg8mtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZx9bkL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZx9bkL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB68C4CEF1;
	Tue, 21 Oct 2025 20:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077559;
	bh=1GrkfA3zyQCQbvrdadoE+eqKG/x5ctC3hB0BE05OIvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZx9bkL2FtLRN8ZtWZghUMP1TiRQiHo9gu3AkIFZzumln9cvBSH2fRV21m8pI2wFV
	 5c6Mjd7CA/uBRjPuP3L71me9RpJ9vZgMaWZZMbsvN3i6HbpOi7Ld7Z0zLmIrBs22m9
	 TY3Iy4le5OHwMOPDUhMBgSjiklOB20hs8bOZwizM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 144/159] NFSD: Minor cleanup in layoutcommit processing
Date: Tue, 21 Oct 2025 21:52:01 +0200
Message-ID: <20251021195046.630593583@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 274365a51d88658fb51cca637ba579034e90a799 ]

Remove dprintk in nfsd4_layoutcommit. These are not needed
in day to day usage, and the information is also available
in Wireshark when capturing NFS traffic.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: d68886bae76a ("NFSD: Fix last write offset handling in layoutcommit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2521,18 +2521,12 @@ nfsd4_layoutcommit(struct svc_rqst *rqst
 	inode = d_inode(current_fh->fh_dentry);
 
 	nfserr = nfserr_inval;
-	if (new_size <= seg->offset) {
-		dprintk("pnfsd: last write before layout segment\n");
+	if (new_size <= seg->offset)
 		goto out;
-	}
-	if (new_size > seg->offset + seg->length) {
-		dprintk("pnfsd: last write beyond layout segment\n");
+	if (new_size > seg->offset + seg->length)
 		goto out;
-	}
-	if (!lcp->lc_newoffset && new_size > i_size_read(inode)) {
-		dprintk("pnfsd: layoutcommit beyond EOF\n");
+	if (!lcp->lc_newoffset && new_size > i_size_read(inode))
 		goto out;
-	}
 
 	nfserr = nfsd4_preprocess_layout_stateid(rqstp, cstate, &lcp->lc_sid,
 						false, lcp->lc_layout_type,


