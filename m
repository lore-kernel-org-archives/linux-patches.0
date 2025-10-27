Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0CE32B991;
	Mon, 27 Oct 2025 19:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592036; cv=none; b=Sl7rxxnr6mGlzoyw7kGBDcpipRVvGzDrX0NaUkRegUqBrm421CvVIyGlJT7S/ILM5sIWPlZhi68y7sfw7TWTRnsRPsDxVdWZkN0E61UnU6xTmX4fZ66TbXkzQhP4tA9CWeEcQNjdK/BUMwt2e+F+4rrOv6pfW20wRHyhOwZD4y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592036; c=relaxed/simple;
	bh=a8LA1nPT1q4xYMaxockvmEPLg740j9h50EeJ52sYME4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZVsrx/PpeU0qpGVA3F6MnBG8AXsVVpnWatjjOl+yjx+CDDLrL0PsIP65H38IzUfcB+vABQ4MmizQ5MQUF6qr7kisUo65Ej5YGV9ugjfLPZ2rQ093q/SEyUcFtrmTaYBO4i+aBbdlVmFggXhLS8YsFjMrlCe1+vxlsDeHJm5IUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibO4gnqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibO4gnqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603B2C4CEF1;
	Mon, 27 Oct 2025 19:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592036;
	bh=a8LA1nPT1q4xYMaxockvmEPLg740j9h50EeJ52sYME4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibO4gnqqVwLIde06LePYUmwph2De5C1JQrJOVyuEnVGyi0+cqxWEOlDHK/k0M3aZw
	 4hpzMP9RuZtHV4Fqj+mUnhGW5oHEq7ey28M8NHLDTBFPw9aPPugMhGm6fnxm+sMdNI
	 DGTXvyUpkUVO1AjVltk9RxrR3x1gBQMtK+ILL/gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/123] NFSD: Minor cleanup in layoutcommit processing
Date: Mon, 27 Oct 2025 19:36:13 +0100
Message-ID: <20251027183448.876893314@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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


