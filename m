Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624982D5C95;
	Mon, 27 Oct 2025 19:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591739; cv=none; b=npJNpvw0NqftZ3lodWWil9uoNrNeBwTRhllHqaudPnha5UyP2lMkY57E8Xs5E9x7UxPxTSvGbCn9Pc6Dn1a1cmvzNY0McxcXKgrks4I+vw2g29SEPvaGHHIqdlt25h/mRRjYjfrAgwWA2wFGqR5hEn+tlEWnYQLRgFIqBow2pgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591739; c=relaxed/simple;
	bh=nlS08Kccm7lkHMOa2kIcGaruekUmpDSFs5fkH836S6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co8hXRt4r5q2rqT4zbMmuoVQX5aEyI5RBigAwKwdjMaNX4GtQJqG8ngaIGSzx46b9fjYRsYpz8h5iJrg/+atX5JaB9z+Pbdv9VhMoSliOz4TQ06W785oKW6q6XtKN0RuzWH2LS29q4y0MAORcwClyXxhivtWp7zXrMIrvPtDLBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5xgLrte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5xgLrte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A01C4CEF1;
	Mon, 27 Oct 2025 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591739;
	bh=nlS08Kccm7lkHMOa2kIcGaruekUmpDSFs5fkH836S6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5xgLrtecgF8Yi5VwAz/WjBchHErRLC0w+F11H8PleX3AI9V5Kvfxpza7ObJRmwyt
	 bMDqgMbPvPEc9UUm7sYTgnDGZz/87UPNgDh3nQxw+Xl5mNyfLZUS+jJYReu34nkD5s
	 e3TjPcPb3oMdD9ScGiQNn/UZYzWE/9NlWQCTbZII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/332] NFSD: Minor cleanup in layoutcommit processing
Date: Mon, 27 Oct 2025 19:36:06 +0100
Message-ID: <20251027183533.124384252@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2278,18 +2278,12 @@ nfsd4_layoutcommit(struct svc_rqst *rqst
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


