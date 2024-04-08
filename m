Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D146A342;
	Mon,  8 Apr 2024 13:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584230; cv=none; b=WO0ylG9Ckw1awfJlO6kQCQASyPcXvWZYCBycBlpUI6UpJNEK6UyEhjmVLoUwfrU4joRER4o9CCOAwCL4nB9zqFzAxkmPkiRfFOe38YFlH78RbKt0cuAXVLaAw4Q1o/U2mwVj8gwIXqMZY9mfikGFiUFppD3axPzbUeaJw4VQwds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584230; c=relaxed/simple;
	bh=TxDsciJacmhxk/wai7Jcv2+bSBYbCtU+ETOP1PPvOgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqLdEj+5D8crgGAXSYD1oBQZT06NCxlPKAFQ4RtAfOMYRLDMgIBWfjCL+qvJPyIO228esNxYVwj4ql6UJz0GkZEjEi6Mg7bomWulDeowoLnT0KRdE0zvUCp2+kqTdNtde16XYrQILeZWfOrKDTj+eL8AXKKydAYnUYw2ZNC9t2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SK+FpL6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SK+FpL6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D1EC433C7;
	Mon,  8 Apr 2024 13:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584230;
	bh=TxDsciJacmhxk/wai7Jcv2+bSBYbCtU+ETOP1PPvOgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SK+FpL6fTq5ED+FvUpGgKqRlQCt3E6bPgaBdSH+LV+cBFZ45a5ZRZaaAKpp6L95bM
	 67ynN/IeqsBb90ut6jGwr+rrL92VC3V7L+1s8DUF3F9h/+s1ZCWaRTxlhqCB7Fsi8i
	 +1yjzDyviqJT94XovK4jsglbJ5D4eqcJdI02rjxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 367/690] NFSD: Remove nfsd_file::nf_hashval
Date: Mon,  8 Apr 2024 14:53:53 +0200
Message-ID: <20240408125412.862985880@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f0743c2b25c65debd4f599a7c861428cd9de5906 ]

The value in this field can always be computed from nf_inode, thus
it is no longer used.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 6 ++----
 fs/nfsd/filecache.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index dd59deec8b011..29b1f57692a60 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -167,8 +167,7 @@ nfsd_file_mark_find_or_create(struct nfsd_file *nf)
 }
 
 static struct nfsd_file *
-nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
-		struct net *net)
+nfsd_file_alloc(struct inode *inode, unsigned int may, struct net *net)
 {
 	struct nfsd_file *nf;
 
@@ -182,7 +181,6 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 		nf->nf_net = net;
 		nf->nf_flags = 0;
 		nf->nf_inode = inode;
-		nf->nf_hashval = hashval;
 		refcount_set(&nf->nf_ref, 1);
 		nf->nf_may = may & NFSD_FILE_MAY_MASK;
 		nf->nf_mark = NULL;
@@ -1005,7 +1003,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (nf)
 		goto wait_for_construction;
 
-	new = nfsd_file_alloc(inode, may_flags, hashval, net);
+	new = nfsd_file_alloc(inode, may_flags, net);
 	if (!new) {
 		status = nfserr_jukebox;
 		goto out_status;
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index c6ad5fe47f12f..82051e1b8420d 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -40,7 +40,6 @@ struct nfsd_file {
 #define NFSD_FILE_REFERENCED	(2)
 	unsigned long		nf_flags;
 	struct inode		*nf_inode;
-	unsigned int		nf_hashval;
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;
-- 
2.43.0



