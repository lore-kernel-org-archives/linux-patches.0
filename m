Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D268F13D8BC;
	Tue, 18 Jun 2024 12:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715188; cv=none; b=j1kUVjlQHUw2cZhy5oLwKYXzUXjXBAGMb5lxrY9dnMVeYa6ldMTGtnwOlLvDYyOtxiKUNksnqvd1TkWX7UvegTDr6OgTO0dSx/4pS//Mhbgpr7pISantpKczpLj8IHndhoPX/MeWsmkPoah0dWypLmu2dUvH3nlVBCOCqmjC+b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715188; c=relaxed/simple;
	bh=LiTX5GPb4BW5f7+O+2mcGHbPlppqgrPAvzVlP5IzeK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhQrLwew9nlV/ha20DgjyaMvJTzpSe70LEUAisj6hOcNzXTvYhVvgFPe1jR38qoWKbtqTVCdA6ASp4ZgdB2+DA26KcWqv8aIkh+3ykfQSRc1UHS1ulFoVUzCxZpY9Ux+x8GMbvMQq2O3GiTR8h06Z8fuDcWOVXDPM24vK+Wtc3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zF/Qa1BJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zF/Qa1BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591A1C3277B;
	Tue, 18 Jun 2024 12:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715188;
	bh=LiTX5GPb4BW5f7+O+2mcGHbPlppqgrPAvzVlP5IzeK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zF/Qa1BJi4/B2ZZHVaPMsNYIvqCFNrIwDXHMgmwQH7zO1Rg73Mr5khhDTq0VXQAkW
	 jEKF7z+P3AHNwCG9EJab5TPddbTzgP/dM6LWhbt9t4qgkV6aAuQNDtL0HuL8x4DAKq
	 fp7AH1GK7xXJ3FIymJTVzsfYBlfwlHzvYTxrkEXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/770] NFSD: Count bytes instead of pages in the NFSv2 READDIR encoder
Date: Tue, 18 Jun 2024 14:31:18 +0200
Message-ID: <20240618123415.967355498@linuxfoundation.org>
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

[ Upstream commit 8141d6a2bb6c655ff0c0b81ced80d9025f03e926 ]

Clean up: Counting the bytes used by each returned directory entry
seems less brittle to me than trying to measure consumed pages after
the fact.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 4 ----
 fs/nfsd/nfsxdr.c  | 3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 2d3d7cdffd52f..23b2a900cb79d 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -578,14 +578,12 @@ nfsd_proc_readdir(struct svc_rqst *rqstp)
 	struct nfsd_readdirargs *argp = rqstp->rq_argp;
 	struct nfsd_readdirres *resp = rqstp->rq_resp;
 	loff_t		offset;
-	__be32		*buffer;
 
 	dprintk("nfsd: READDIR  %s %d bytes at %d\n",
 		SVCFH_fmt(&argp->fh),		
 		argp->count, argp->cookie);
 
 	nfsd_init_dirlist_pages(rqstp, resp, argp->count);
-	buffer = resp->buffer;
 
 	resp->offset = NULL;
 	resp->common.err = nfs_ok;
@@ -593,8 +591,6 @@ nfsd_proc_readdir(struct svc_rqst *rqstp)
 	offset = argp->cookie;
 	resp->status = nfsd_readdir(rqstp, &argp->fh, &offset,
 				    &resp->common, nfssvc_encode_entry);
-
-	resp->count = resp->buffer - buffer;
 	nfssvc_encode_nfscookie(resp, offset);
 
 	fh_put(&argp->fh);
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index a87b21cfe0d03..8ae23ed6dc5db 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -584,7 +584,7 @@ nfssvc_encode_readdirres(struct svc_rqst *rqstp, __be32 *p)
 	p = resp->buffer;
 	*p++ = 0;			/* no more entries */
 	*p++ = htonl((resp->common.err == nfserr_eof));
-	rqstp->rq_res.page_len = (((unsigned long)p-1) & ~PAGE_MASK)+1;
+	rqstp->rq_res.page_len = resp->count << 2;
 
 	return 1;
 }
@@ -667,6 +667,7 @@ nfssvc_encode_entry(void *ccdv, const char *name,
 	cd->offset = p;			/* remember pointer */
 	*p++ = htonl(~0U);		/* offset of next entry */
 
+	cd->count += p - cd->buffer;
 	cd->buflen = buflen;
 	cd->buffer = p;
 	cd->common.err = nfs_ok;
-- 
2.43.0



