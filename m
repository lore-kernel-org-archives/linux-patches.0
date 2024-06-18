Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B3F19D087;
	Tue, 18 Jun 2024 13:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715929; cv=none; b=EeexK45BTo2tNFGo+PwhgM0hFZdZ4GdoDHSIQX8jKaWj9unjsz6tVD5GrUG/aQ4unM5LqzoRobXsM7bXM1lQJcJRhM164eakKyxdPEznLwESL2PNvmeqR6z+cNCc2wJuuQgKrt8kzoB+c2Y3P3dPNcH5AyaavE8ZGm1EElKljq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715929; c=relaxed/simple;
	bh=KgpU5j+8vIgFbMi9+77IT35qea8gnlk3zSqr3K+lfYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwNQyY5hvLjOApeZhzzbjWUR9qXxN9KjE5+DKCTmCaYdEZGVTbO/GWMtzmp1SPofZdTFgCHfmBh1OKOTqyux46GJ0oPS+pcfcJDtcqhbrawVNxyYvzPQxJSgi9ZB6K6kwi8Q9X7ij+aNIeHeMByVqWFuT3EheMrWEYWPiBtTT5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEaFsjNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEaFsjNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D306C3277B;
	Tue, 18 Jun 2024 13:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715929;
	bh=KgpU5j+8vIgFbMi9+77IT35qea8gnlk3zSqr3K+lfYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEaFsjNqBB9K3BDTWp6CHO/Fgppxn8yrlPYcdRc0iRWs1cNxMwTM++7/50/om6Pdt
	 paTTyOuZ67Kvx1Q3CVHMfpp2inta9vCbr/+/c/A3hT5YN+m9keSE5wqEz1NCgktiZZ
	 tFfYccIQp4C7POBW8gZnSWmr/84pdmfIX9zFoUB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 447/770] NFSD: Fix zero-length NFSv3 WRITEs
Date: Tue, 18 Jun 2024 14:35:00 +0200
Message-ID: <20240618123424.547216607@linuxfoundation.org>
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

[ Upstream commit 6a2f774424bfdcc2df3e17de0cefe74a4269cad5 ]

The Linux NFS server currently responds to a zero-length NFSv3 WRITE
request with NFS3ERR_IO. It responds to a zero-length NFSv4 WRITE
with NFS4_OK and count of zero.

RFC 1813 says of the WRITE procedure's @count argument:

count
         The number of bytes of data to be written. If count is
         0, the WRITE will succeed and return a count of 0,
         barring errors due to permissions checking.

RFC 8881 has similar language for NFSv4, though NFSv4 removed the
explicit @count argument because that value is already contained in
the opaque payload array.

The synthetic client pynfs's WRT4 and WRT15 tests do emit zero-
length WRITEs to exercise this spec requirement. Commit fdec6114ee1f
("nfsd4: zero-length WRITE should succeed") addressed the same
problem there with the same fix.

But interestingly the Linux NFS client does not appear to emit zero-
length WRITEs, instead squelching them. I'm not aware of a test that
can generate such WRITEs for NFSv3, so I wrote a naive C program to
generate a zero-length WRITE and test this fix.

Fixes: 8154ef2776aa ("NFSD: Clean up legacy NFS WRITE argument XDR decoders")
Reported-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 6 +-----
 fs/nfsd/nfsproc.c  | 5 -----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index d26271c60ab44..1515c32e08db2 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -207,15 +207,11 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 	fh_copy(&resp->fh, &argp->fh);
 	resp->committed = argp->stable;
 	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
-	if (!nvecs) {
-		resp->status = nfserr_io;
-		goto out;
-	}
+
 	resp->status = nfsd_write(rqstp, &resp->fh, argp->offset,
 				  rqstp->rq_vec, nvecs, &cnt,
 				  resp->committed, resp->verf);
 	resp->count = cnt;
-out:
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 8ee329bc3815d..0a2bab7ef33c9 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -235,10 +235,6 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		argp->len, argp->offset);
 
 	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
-	if (!nvecs) {
-		resp->status = nfserr_io;
-		goto out;
-	}
 
 	resp->status = nfsd_write(rqstp, fh_copy(&resp->fh, &argp->fh),
 				  argp->offset, rqstp->rq_vec, nvecs,
@@ -247,7 +243,6 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
 		return rpc_drop_reply;
-out:
 	return rpc_success;
 }
 
-- 
2.43.0



