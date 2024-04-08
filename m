Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAF96A352;
	Mon,  8 Apr 2024 13:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584297; cv=none; b=LCgcKXg8L9oL7D+yP9su3sBimDiKIzOses9Y8Y9iU/DjC+nxay0UlUI8fuB96JR1QEFYBP2qd46Y65Vjit/io32uPbWTcNU+Pgxj/d8EO/+4Lkkq8qoYvg1aedTzGyP9BiimqsgTtA6eVuisAD36dKOuwqQGonI2lvbuJ23HwTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584297; c=relaxed/simple;
	bh=lgrA8UkB0u/0aCySqAFOySav8mJD0G87MQZB0BYDf8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqFToezlsMLriX93/6rrXPj7IhA6JtJ7Uzg48aTzlkfFkCxLzwpx8gU7euQ2AFYMb835O/OQVVr20V/mh+b/5J71dagbiZoUindaaSo8yVrh4q8+dSY1Kyoqa1lQAm0L8XtKQGPykAZoV6LskZxoAjzKj/N7YJeUF9A17n0r87M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwvxTxSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwvxTxSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED300C433C7;
	Mon,  8 Apr 2024 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584297;
	bh=lgrA8UkB0u/0aCySqAFOySav8mJD0G87MQZB0BYDf8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwvxTxSXMskKUNFDUDQ+Wr1bif+wNGuYHxicw+llBh2jjFYFmJXDINzpxr8a/GPux
	 45bEMoL9B2GhFsX/c9SrkpooNhBw6Y9hR+MldJ+MNuis96r5ixwR27CiNIqBLZz463
	 2XeSd603TSMadnyYxSZz7cf6+AVuP5isx51kc/VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 391/690] NFSD: Shrink size of struct nfsd4_copy
Date: Mon,  8 Apr 2024 14:54:17 +0200
Message-ID: <20240408125413.700475728@linuxfoundation.org>
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

[ Upstream commit 87689df694916c40e8e6c179ab1c8710f65cb6c6 ]

struct nfsd4_copy is part of struct nfsd4_op, which resides in an
8-element array.

sizeof(struct nfsd4_op):
Before: /* size: 1696, cachelines: 27, members: 5 */
After:  /* size: 672, cachelines: 11, members: 5 */

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 8 ++++++--
 fs/nfsd/nfs4xdr.c  | 5 ++++-
 fs/nfsd/xdr4.h     | 2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 80ec51a89d5b5..f0722d4ed0810 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1291,6 +1291,7 @@ void nfs4_put_copy(struct nfsd4_copy *copy)
 {
 	if (!refcount_dec_and_test(&copy->refcount))
 		return;
+	kfree(copy->cp_src);
 	kfree(copy);
 }
 
@@ -1545,7 +1546,7 @@ nfsd4_setup_inter_ssc(struct svc_rqst *rqstp,
 	if (status)
 		goto out;
 
-	status = nfsd4_interssc_connect(&copy->cp_src, rqstp, mount);
+	status = nfsd4_interssc_connect(copy->cp_src, rqstp, mount);
 	if (status)
 		goto out;
 
@@ -1753,7 +1754,7 @@ static void dup_copy_fields(struct nfsd4_copy *src, struct nfsd4_copy *dst)
 		dst->nf_src = nfsd_file_get(src->nf_src);
 
 	memcpy(&dst->cp_stateid, &src->cp_stateid, sizeof(src->cp_stateid));
-	memcpy(&dst->cp_src, &src->cp_src, sizeof(struct nl4_server));
+	memcpy(dst->cp_src, src->cp_src, sizeof(struct nl4_server));
 	memcpy(&dst->stateid, &src->stateid, sizeof(src->stateid));
 	memcpy(&dst->c_fh, &src->c_fh, sizeof(src->c_fh));
 	dst->ss_mnt = src->ss_mnt;
@@ -1847,6 +1848,9 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		async_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
 		if (!async_copy)
 			goto out_err;
+		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
+		if (!async_copy->cp_src)
+			goto out_err;
 		if (!nfs4_init_copy_state(nn, copy))
 			goto out_err;
 		refcount_set(&async_copy->refcount, 1);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 515edc1b662e1..dad744d44b0a2 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1920,6 +1920,9 @@ nfsd4_decode_copy(struct nfsd4_compoundargs *argp, struct nfsd4_copy *copy)
 
 	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
 		return nfserr_bad_xdr;
+	copy->cp_src = svcxdr_tmpalloc(argp, sizeof(*copy->cp_src));
+	if (copy->cp_src == NULL)
+		return nfserr_jukebox;
 	copy->cp_intra = false;
 	if (count == 0) { /* intra-server copy */
 		copy->cp_intra = true;
@@ -1927,7 +1930,7 @@ nfsd4_decode_copy(struct nfsd4_compoundargs *argp, struct nfsd4_copy *copy)
 	}
 
 	/* decode all the supplied server addresses but use only the first */
-	status = nfsd4_decode_nl4_server(argp, &copy->cp_src);
+	status = nfsd4_decode_nl4_server(argp, copy->cp_src);
 	if (status)
 		return status;
 
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 6673c2980c77e..ed90843a55293 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -540,7 +540,7 @@ struct nfsd4_copy {
 	u64			cp_src_pos;
 	u64			cp_dst_pos;
 	u64			cp_count;
-	struct nl4_server	cp_src;
+	struct nl4_server	*cp_src;
 	bool			cp_intra;
 
 	/* both */
-- 
2.43.0



