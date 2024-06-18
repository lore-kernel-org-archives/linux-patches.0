Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9477F185E4B;
	Tue, 18 Jun 2024 13:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716302; cv=none; b=APJelYmcZVpC7aLUeZ1GWiLiIdbYrFIRq4AUrMRg3YSqpCtzxn2u/aYZeKH095qHUc/nyseTeFZ0pZHBIohFmxsfYqaYWFAH1Nu/LYvunhuPl7W2/UXmUXSTFiKi12n8tEnvtbtHmU2XxCK+mY2unXrio3+EsafFfgGKEMFulPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716302; c=relaxed/simple;
	bh=gkpLuG1LryVEKysYhnxs3Z2r93/W7HwsXiJrwk8qMqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWB0apr1U6fp8pDFRoSvAfEWDinvDKKJ1WsiLGwFxNndR4XjxEn9WImu3QxaDhxZC0xYDquW388zhPRzPs2CeVzCtLsRUiovGx5mqbmSW/skS8HFX86QO7lQ87g0KB7H73bTqbP3jJ2GaoNKNDDnAS7tgqIeZTSKibHCRwL506w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWrCL65p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWrCL65p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1301AC3277B;
	Tue, 18 Jun 2024 13:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716302;
	bh=gkpLuG1LryVEKysYhnxs3Z2r93/W7HwsXiJrwk8qMqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWrCL65pO60i1jQukKvh2OyiGzvIZZ/Ruwkqu+jagsXlaYwDR4yCd0X7r1lYK2PT9
	 DXX+1rIWERdFZ00fijMXTbkROAhyRA5t2JIQKomFcjMRrwRO5czjdC4e5kaE7WXRWj
	 aFvFrFWl7lU9AmTJ/9wcTb2qdITmwpFQk+hdq5Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 600/770] NFSD: Shrink size of struct nfsd4_copy
Date: Tue, 18 Jun 2024 14:37:33 +0200
Message-ID: <20240618123430.451307295@linuxfoundation.org>
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

[ Upstream commit 87689df694916c40e8e6c179ab1c8710f65cb6c6 ]

struct nfsd4_copy is part of struct nfsd4_op, which resides in an
8-element array.

sizeof(struct nfsd4_op):
Before: /* size: 1696, cachelines: 27, members: 5 */
After:  /* size: 672, cachelines: 11, members: 5 */

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 8 ++++++--
 fs/nfsd/nfs4xdr.c  | 5 ++++-
 fs/nfsd/xdr4.h     | 2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 3ed9c36bc4078..7fb1ef7c4383e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1291,6 +1291,7 @@ void nfs4_put_copy(struct nfsd4_copy *copy)
 {
 	if (!refcount_dec_and_test(&copy->refcount))
 		return;
+	kfree(copy->cp_src);
 	kfree(copy);
 }
 
@@ -1544,7 +1545,7 @@ nfsd4_setup_inter_ssc(struct svc_rqst *rqstp,
 	if (status)
 		goto out;
 
-	status = nfsd4_interssc_connect(&copy->cp_src, rqstp, mount);
+	status = nfsd4_interssc_connect(copy->cp_src, rqstp, mount);
 	if (status)
 		goto out;
 
@@ -1751,7 +1752,7 @@ static void dup_copy_fields(struct nfsd4_copy *src, struct nfsd4_copy *dst)
 		dst->nf_src = nfsd_file_get(src->nf_src);
 
 	memcpy(&dst->cp_stateid, &src->cp_stateid, sizeof(src->cp_stateid));
-	memcpy(&dst->cp_src, &src->cp_src, sizeof(struct nl4_server));
+	memcpy(dst->cp_src, src->cp_src, sizeof(struct nl4_server));
 	memcpy(&dst->stateid, &src->stateid, sizeof(src->stateid));
 	memcpy(&dst->c_fh, &src->c_fh, sizeof(src->c_fh));
 	dst->ss_mnt = src->ss_mnt;
@@ -1845,6 +1846,9 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
index 537c358fec98c..890f1009bd4ca 100644
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
index 27f9300fadbe0..c44c76cef40cd 100644
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



