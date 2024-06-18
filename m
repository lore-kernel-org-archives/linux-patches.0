Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7A519CD1B;
	Tue, 18 Jun 2024 13:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715903; cv=none; b=f1xL++SLXxxZg+KuuntA0EwXpHf9Tvd14Tlv36klmpZJa573vIDHVGVIW0dB5zWtuWaabMo1x5XseXIKs1BqGW/s14Qua8SZdsfyEFyjr33H8vHQbgucH/saInzUQdc0AKkup5UAe7bC7vPUUo9bOdwFnuwwTprm0juDGqzOzCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715903; c=relaxed/simple;
	bh=/W+jpRtMt+cwVOi1A8hrdEVIlsugg6eP6bMfY9/GyVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lw5TclKKqsxJwnHUcK/zKK51HSpff9vfer/A5DOnkIJ+Qjc1gm9JG+1c2HxewmoF1VhH83yi9HQRRLFHl9UDExES5Wjkuc6j7OesLfGie+hp5udHeTUjfzf3yRilJ9qGELA+ueVNv2Dr6qR3kOTW+W7q8JcUZ8HBVHbEa5nuDWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSOiDQgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSOiDQgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC44C3277B;
	Tue, 18 Jun 2024 13:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715903;
	bh=/W+jpRtMt+cwVOi1A8hrdEVIlsugg6eP6bMfY9/GyVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSOiDQgi14Kq9du8GluTW5sXaJVUcQTHM2Ef3pUmYF66GuUoLwukEdjMAkjzfzN6+
	 j8J6OhnVSHSEPFd/x5fc5rUHhJOWhTlz7s+/RGD3Kf9JRodC4KhyXr0yrFQ6FVfsoa
	 uFzr1snO/E71yGC5SAPLegjhe414KQVtWBRlLAGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 465/770] NFSD: Fix the behavior of READ near OFFSET_MAX
Date: Tue, 18 Jun 2024 14:35:18 +0200
Message-ID: <20240618123425.263130608@linuxfoundation.org>
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

[ Upstream commit 0cb4d23ae08c48f6bf3c29a8e5c4a74b8388b960 ]

Dan Aloni reports:
> Due to commit 8cfb9015280d ("NFS: Always provide aligned buffers to
> the RPC read layers") on the client, a read of 0xfff is aligned up
> to server rsize of 0x1000.
>
> As a result, in a test where the server has a file of size
> 0x7fffffffffffffff, and the client tries to read from the offset
> 0x7ffffffffffff000, the read causes loff_t overflow in the server
> and it returns an NFS code of EINVAL to the client. The client as
> a result indefinitely retries the request.

The Linux NFS client does not handle NFS?ERR_INVAL, even though all
NFS specifications permit servers to return that status code for a
READ.

Instead of NFS?ERR_INVAL, have out-of-range READ requests succeed
and return a short result. Set the EOF flag in the result to prevent
the client from retrying the READ request. This behavior appears to
be consistent with Solaris NFS servers.

Note that NFSv3 and NFSv4 use u64 offset values on the wire. These
must be converted to loff_t internally before use -- an implicit
type cast is not adequate for this purpose. Otherwise VFS checks
against sb->s_maxbytes do not work properly.

Reported-by: Dan Aloni <dan.aloni@vastdata.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 8 ++++++--
 fs/nfsd/nfs4proc.c | 8 ++++++--
 fs/nfsd/nfs4xdr.c  | 8 ++------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 1515c32e08db2..b540489ea240d 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -150,13 +150,17 @@ nfsd3_proc_read(struct svc_rqst *rqstp)
 	unsigned int len;
 	int v;
 
-	argp->count = min_t(u32, argp->count, max_blocksize);
-
 	dprintk("nfsd: READ(3) %s %lu bytes at %Lu\n",
 				SVCFH_fmt(&argp->fh),
 				(unsigned long) argp->count,
 				(unsigned long long) argp->offset);
 
+	argp->count = min_t(u32, argp->count, max_blocksize);
+	if (argp->offset > (u64)OFFSET_MAX)
+		argp->offset = (u64)OFFSET_MAX;
+	if (argp->offset + argp->count > (u64)OFFSET_MAX)
+		argp->count = (u64)OFFSET_MAX - argp->offset;
+
 	v = 0;
 	len = argp->count;
 	resp->pages = rqstp->rq_next_page;
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 451190813302e..f3d6bd2bfa4f7 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -782,12 +782,16 @@ nfsd4_read(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	__be32 status;
 
 	read->rd_nf = NULL;
-	if (read->rd_offset >= OFFSET_MAX)
-		return nfserr_inval;
 
 	trace_nfsd_read_start(rqstp, &cstate->current_fh,
 			      read->rd_offset, read->rd_length);
 
+	read->rd_length = min_t(u32, read->rd_length, svc_max_payload(rqstp));
+	if (read->rd_offset > (u64)OFFSET_MAX)
+		read->rd_offset = (u64)OFFSET_MAX;
+	if (read->rd_offset + read->rd_length > (u64)OFFSET_MAX)
+		read->rd_length = (u64)OFFSET_MAX - read->rd_offset;
+
 	/*
 	 * If we do a zero copy read, then a client will see read data
 	 * that reflects the state of the file *after* performing the
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index adf97d72bda80..be0995bb9459a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3997,10 +3997,8 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	}
 	xdr_commit_encode(xdr);
 
-	maxcount = svc_max_payload(resp->rqstp);
-	maxcount = min_t(unsigned long, maxcount,
+	maxcount = min_t(unsigned long, read->rd_length,
 			 (xdr->buf->buflen - xdr->buf->len));
-	maxcount = min_t(unsigned long, maxcount, read->rd_length);
 
 	if (file->f_op->splice_read &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags))
@@ -4834,10 +4832,8 @@ nfsd4_encode_read_plus(struct nfsd4_compoundres *resp, __be32 nfserr,
 		return nfserr_resource;
 	xdr_commit_encode(xdr);
 
-	maxcount = svc_max_payload(resp->rqstp);
-	maxcount = min_t(unsigned long, maxcount,
+	maxcount = min_t(unsigned long, read->rd_length,
 			 (xdr->buf->buflen - xdr->buf->len));
-	maxcount = min_t(unsigned long, maxcount, read->rd_length);
 	count    = maxcount;
 
 	eof = read->rd_offset >= i_size_read(file_inode(file));
-- 
2.43.0



