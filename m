Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB1719DF6F;
	Tue, 18 Jun 2024 13:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715959; cv=none; b=WxLBqc5Nw3dujQYWDtIhrso8FKVtYaVCMCpLxCq/RYy1D6F5m6lvruzyVwyOXVXjIz3y8CYZgpglglEXqzZsg1TU0a4N7HfjNBFdzFHqNqP5+A6ubjwpjCYHpPDThLZPB9TaTRUZNPe/6JIzXOyunsl17J0jFiB09DQ6x6X4gKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715959; c=relaxed/simple;
	bh=AUWigMAkjtpuho1bl7Q49/+imjE/r8qKw6IsGH1+SFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGHBFmZND7NDFlZiFt3GsKpZ+QXvtcbmQPanBM69FkXsmgYvPXH/RKFDrxO2clecbTAkp/L4SD1KquWbM80X0w8MF+odB1m1ugyB4vxpt4VuKGwf226RbqEVQUw1UXfS8e1o9udIfcuLYmMUlUmzj9VpCHvtolcW+r7YZgn3Otg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0J4S6ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0J4S6ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DC5C3277B;
	Tue, 18 Jun 2024 13:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715959;
	bh=AUWigMAkjtpuho1bl7Q49/+imjE/r8qKw6IsGH1+SFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0J4S6lscXSYlGrg0DusR+F/0aeO2smq/qw8EqfvHCCHd/l42RMoFPB71fV4H8QG+
	 Ws0ppNHUyt1Bd6W8tl/H4Y2a657kzrla2+uMumqfZ2YI/cjiybRAHfYK9ASMTwa7wh
	 D5qoLrBzWRWuXBHVjgs0+qS+zWbxCzoi4qXy2BpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 453/770] NFSD: De-duplicate net_generic(nf->nf_net, nfsd_net_id)
Date: Tue, 18 Jun 2024 14:35:06 +0200
Message-ID: <20240618123424.783606875@linuxfoundation.org>
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

[ Upstream commit 2c445a0e72cb1fbfbdb7f9473c53556ee27c1d90 ]

Since this pointer is used repeatedly, move it to a stack variable.

[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index aba9d479d0840..2e3b0bd560fcc 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1129,6 +1129,7 @@ __be32
 nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
                loff_t offset, unsigned long count, __be32 *verf)
 {
+	struct nfsd_net		*nn;
 	struct nfsd_file	*nf;
 	loff_t			end = LLONG_MAX;
 	__be32			err = nfserr_inval;
@@ -1145,6 +1146,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			NFSD_MAY_WRITE|NFSD_MAY_NOT_BREAK_LEASE, &nf);
 	if (err)
 		goto out;
+	nn = net_generic(nf->nf_net, nfsd_net_id);
 	if (EX_ISSYNC(fhp->fh_export)) {
 		errseq_t since = READ_ONCE(nf->nf_file->f_wb_err);
 		int err2;
@@ -1152,8 +1154,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
 		switch (err2) {
 		case 0:
-			nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
-						nfsd_net_id));
+			nfsd_copy_boot_verifier(verf, nn);
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
 			err = nfserrno(err2);
@@ -1162,13 +1163,11 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			err = nfserr_notsupp;
 			break;
 		default:
-			nfsd_reset_boot_verifier(net_generic(nf->nf_net,
-						 nfsd_net_id));
+			nfsd_reset_boot_verifier(nn);
 			err = nfserrno(err2);
 		}
 	} else
-		nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
-					nfsd_net_id));
+		nfsd_copy_boot_verifier(verf, nn);
 
 	nfsd_file_put(nf);
 out:
-- 
2.43.0



