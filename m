Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F2279F0;
	Mon,  8 Apr 2024 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584679; cv=none; b=GFXjEu1cR9rld5Myx5z8JLx4zyeTaNAh2Khvy60gF556sBtz1mfnOEqw0aGGerAFkM3aBRVTk7EMCqTaMiqz8sT7d2k50KWmJa+w+RXhswRpwi/XP5tKeaQWe+HUkssJn6PvkHcfPN/pIp6yMWO1/z1sj19PMsLCT3MI+fDTZcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584679; c=relaxed/simple;
	bh=iDMOR+1l/ZrAvADaQbtXIhGF8Uo8DuWVOMewzhSTx/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/NQ2+nNr/cUeOKB8tcGBOaXNRdfgdtniKKneSDp58E/ZOvPnI84XQA4cHAs/6CvmEp4e92ODa0moHVxpe4XjvXCvG9Rt/MI8jGKYfPiC7+Rf3UiHuqGriYe7pMmO2otlJvfB3CWb62tiruLBS6Ubx2hC/pfhs4Eq76XNQHKYA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwohdbcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwohdbcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC26C433F1;
	Mon,  8 Apr 2024 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584679;
	bh=iDMOR+1l/ZrAvADaQbtXIhGF8Uo8DuWVOMewzhSTx/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwohdbcwfFQc2bBUbD6vuzKUEdKLF2aHWEfrbcOwPQLxgwKCT1ASBhDiTJOSN5e/t
	 Mnn0TSMTYyTvDWJRm3+OSPlCND+bsz354j3NlSNmDBVUtIrWgnR8tQwEyDAzuAlLY1
	 9+n+S0gEe7H1Kbt/+hoyftXqGeX6sTubDIPPVqYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 5.15 481/690] NFSD: Clean up nfs4_preprocess_stateid_op() call sites
Date: Mon,  8 Apr 2024 14:55:47 +0200
Message-ID: <20240408125417.046113843@linuxfoundation.org>
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

[ Upstream commit eeff73f7c1c583f79a401284f46c619294859310 ]

Remove the lame-duck dprintk()s around nfs4_preprocess_stateid_op()
call sites.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 6ed0baa119433..92d4eb1032ff9 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -943,12 +943,7 @@ nfsd4_read(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					&read->rd_stateid, RD_STATE,
 					&read->rd_nf, NULL);
-	if (status) {
-		dprintk("NFSD: nfsd4_read: couldn't process stateid!\n");
-		goto out;
-	}
-	status = nfs_ok;
-out:
+
 	read->rd_rqstp = rqstp;
 	read->rd_fhp = &cstate->current_fh;
 	return status;
@@ -1117,10 +1112,8 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		status = nfs4_preprocess_stateid_op(rqstp, cstate,
 				&cstate->current_fh, &setattr->sa_stateid,
 				WR_STATE, NULL, NULL);
-		if (status) {
-			dprintk("NFSD: nfsd4_setattr: couldn't process stateid!\n");
+		if (status)
 			return status;
-		}
 	}
 	err = fh_want_write(&cstate->current_fh);
 	if (err)
@@ -1168,10 +1161,8 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			       write->wr_offset, cnt);
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 						stateid, WR_STATE, &nf, NULL);
-	if (status) {
-		dprintk("NFSD: nfsd4_write: couldn't process stateid!\n");
+	if (status)
 		return status;
-	}
 
 	write->wr_how_written = write->wr_stable_how;
 
@@ -1202,17 +1193,13 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->save_fh,
 					    src_stateid, RD_STATE, src, NULL);
-	if (status) {
-		dprintk("NFSD: %s: couldn't process src stateid!\n", __func__);
+	if (status)
 		goto out;
-	}
 
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					    dst_stateid, WR_STATE, dst, NULL);
-	if (status) {
-		dprintk("NFSD: %s: couldn't process dst stateid!\n", __func__);
+	if (status)
 		goto out_put_src;
-	}
 
 	/* fix up for NFS-specific error code */
 	if (!S_ISREG(file_inode((*src)->nf_file)->i_mode) ||
@@ -1951,10 +1938,8 @@ nfsd4_fallocate(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					    &fallocate->falloc_stateid,
 					    WR_STATE, &nf, NULL);
-	if (status != nfs_ok) {
-		dprintk("NFSD: nfsd4_fallocate: couldn't process stateid!\n");
+	if (status != nfs_ok)
 		return status;
-	}
 
 	status = nfsd4_vfs_fallocate(rqstp, &cstate->current_fh, nf->nf_file,
 				     fallocate->falloc_offset,
@@ -2010,10 +1995,8 @@ nfsd4_seek(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					    &seek->seek_stateid,
 					    RD_STATE, &nf, NULL);
-	if (status) {
-		dprintk("NFSD: nfsd4_seek: couldn't process stateid!\n");
+	if (status)
 		return status;
-	}
 
 	switch (seek->seek_whence) {
 	case NFS4_CONTENT_DATA:
-- 
2.43.0



