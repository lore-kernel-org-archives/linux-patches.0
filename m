Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6A113AD0F;
	Tue, 18 Jun 2024 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714991; cv=none; b=ZSb1q8fg1FoCcpzNnrtiBksxW4FAQKPvbaDU8XlM3h7p7+RBcNd+U08FcswaVwx4bR5TZjCiA0YV2l6TSde5WVcIL9zRBQL3G4GsVrXBzdQU299eqWaSM8b2Paa3Ql7hRRxAddzaVpZbg+xM25SLY01rjyrJq64IFG8eK0NR5WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714991; c=relaxed/simple;
	bh=xKdfQgRA132rKlWw+6EsI2oUDucV87EoLtOskDZNZGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/UIXaBBJjtrQT0Ujs5pS/lTFXh3itcxsPdZRzZ1Xg2xrdTW0VbSOk/XMchOA3X7jshPvlbo7Gw8CNsc662sU9+2+DPKuBw48K/Xx2QwnpXHO0qCQELDWsTKdXkY4lraxn5TSd/TAQt0AO6D7/PgrTQ7hGU2pqsFbDxrfoRpW8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wx/eh/4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wx/eh/4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37A4C3277B;
	Tue, 18 Jun 2024 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714991;
	bh=xKdfQgRA132rKlWw+6EsI2oUDucV87EoLtOskDZNZGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wx/eh/4fiPnqCC5hrjiRO8ESPRpoMR83VtkWKr7equQnwhL4fCCg/xXLc1kQt53rq
	 JbfZ5XelFESnOQhesvwigedcU4hWBbEcycdXymxip0v72ujcMS2uMcXeIOfqTqnM1m
	 T1fgMMnMVJqHmD5xqTQf//s90WR5/N4DYB7ukseM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/770] NFSD: Add helper to set up the pages where the dirlist is encoded, again
Date: Tue, 18 Jun 2024 14:30:10 +0200
Message-ID: <20240618123413.337245425@linuxfoundation.org>
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

[ Upstream commit 788cd46ecf83ee2d561cb4e754e276dc8089b787 ]

Add a helper similar to nfsd3_init_dirlist_pages().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 29 ++++++++++++++++++-----------
 fs/nfsd/nfsxdr.c  |  2 --
 fs/nfsd/xdr.h     |  1 -
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 6352da0168e04..a628ea4d66ead 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -553,6 +553,20 @@ nfsd_proc_rmdir(struct svc_rqst *rqstp)
 	return rpc_success;
 }
 
+static void nfsd_init_dirlist_pages(struct svc_rqst *rqstp,
+				    struct nfsd_readdirres *resp,
+				    int count)
+{
+	count = min_t(u32, count, PAGE_SIZE);
+
+	/* Convert byte count to number of words (i.e. >> 2),
+	 * and reserve room for the NULL ptr & eof flag (-2 words) */
+	resp->buflen = (count >> 2) - 2;
+
+	resp->buffer = page_address(*rqstp->rq_next_page);
+	rqstp->rq_next_page++;
+}
+
 /*
  * Read a portion of a directory.
  */
@@ -561,31 +575,24 @@ nfsd_proc_readdir(struct svc_rqst *rqstp)
 {
 	struct nfsd_readdirargs *argp = rqstp->rq_argp;
 	struct nfsd_readdirres *resp = rqstp->rq_resp;
-	int		count;
 	loff_t		offset;
+	__be32		*buffer;
 
 	dprintk("nfsd: READDIR  %s %d bytes at %d\n",
 		SVCFH_fmt(&argp->fh),		
 		argp->count, argp->cookie);
 
-	/* Shrink to the client read size */
-	count = (argp->count >> 2) - 2;
-
-	/* Make sure we've room for the NULL ptr & eof flag */
-	count -= 2;
-	if (count < 0)
-		count = 0;
+	nfsd_init_dirlist_pages(rqstp, resp, argp->count);
+	buffer = resp->buffer;
 
-	resp->buffer = argp->buffer;
 	resp->offset = NULL;
-	resp->buflen = count;
 	resp->common.err = nfs_ok;
 	/* Read directory and encode entries on the fly */
 	offset = argp->cookie;
 	resp->status = nfsd_readdir(rqstp, &argp->fh, &offset,
 				    &resp->common, nfssvc_encode_entry);
 
-	resp->count = resp->buffer - argp->buffer;
+	resp->count = resp->buffer - buffer;
 	if (resp->offset)
 		*resp->offset = htonl(offset);
 
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 02dd9888d93b2..3d72334e16733 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -388,8 +388,6 @@ nfssvc_decode_readdirargs(struct svc_rqst *rqstp, __be32 *p)
 		return 0;
 	args->cookie = ntohl(*p++);
 	args->count  = ntohl(*p++);
-	args->count  = min_t(u32, args->count, PAGE_SIZE);
-	args->buffer = page_address(*(rqstp->rq_next_page++));
 
 	return xdr_argsize_check(rqstp, p);
 }
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index 1338551de828e..ff68643504c3c 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -73,7 +73,6 @@ struct nfsd_readdirargs {
 	struct svc_fh		fh;
 	__u32			cookie;
 	__u32			count;
-	__be32 *		buffer;
 };
 
 struct nfsd_stat {
-- 
2.43.0



