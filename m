Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A54158D7F;
	Tue, 18 Jun 2024 13:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716335; cv=none; b=MvPnpUTtQxRi1JnMjmvT5yf9/nKlK3MI1J3qZkSP2ellvMd34d0nWfLpypPRYgR5kZVODPI7xM+olfqpHoGhv477KdIaEdx74x+SUlpa44C/3c0+NYo+SyusiRQx9RnApqflotDiYMba7sxz6PIGujroG4H1YC9mHxX5XeK789U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716335; c=relaxed/simple;
	bh=iCpE5bn0pfwesb9CX58hPviRsStcKpLQk/+9r39B0SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrOo5P9C4FsxJOuX3pr05l4UdJeSh9jl6JRV3PudO6e87X0ArIvM16P2hbAaF9k9AOdQbjcgpWx/bECPU1e6Oa4CufUSKPpY+qb5qGo4QZKwKloh7cFZ8D2o9eFmiKl3FPfRYkQgQZJoVNoufcKMSlTA+sxeBT32xnukVmpoQ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTn8E6Ix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTn8E6Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729EDC4AF1D;
	Tue, 18 Jun 2024 13:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716334;
	bh=iCpE5bn0pfwesb9CX58hPviRsStcKpLQk/+9r39B0SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTn8E6IxVQ5puUp0/O+gNxzvkzcHmwQNB2o7lXlYL9zs62XnOuKURc/cTboCXHKEo
	 6qmB30rf3BClA4m5UzJUwAgvdXRqMxR96aqGm9+fbsKzfv5uk9p3TWRU+K9j8BeUlQ
	 qFKXIug4q6GflPOS1vZaGMjdpWBt2kMEexcPgFz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 610/770] NFSD: drop fh argument from alloc_init_deleg
Date: Tue, 18 Jun 2024 14:37:43 +0200
Message-ID: <20240618123430.836154621@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit bbf936edd543e7220f60f9cbd6933b916550396d ]

Currently, we pass the fh of the opened file down through several
functions so that alloc_init_deleg can pass it to delegation_blocked.
The filehandle of the open file is available in the nfs4_file however,
so there's no need to pass it in a separate argument.

Drop the argument from alloc_init_deleg, nfs4_open_delegation and
nfs4_set_delegation.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 1babc08fcb88f..194d8aeb1fd46 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1143,7 +1143,6 @@ static void block_delegations(struct knfsd_fh *fh)
 
 static struct nfs4_delegation *
 alloc_init_deleg(struct nfs4_client *clp, struct nfs4_file *fp,
-		 struct svc_fh *current_fh,
 		 struct nfs4_clnt_odstate *odstate)
 {
 	struct nfs4_delegation *dp;
@@ -1153,7 +1152,7 @@ alloc_init_deleg(struct nfs4_client *clp, struct nfs4_file *fp,
 	n = atomic_long_inc_return(&num_delegations);
 	if (n < 0 || n > max_delegations)
 		goto out_dec;
-	if (delegation_blocked(&current_fh->fh_handle))
+	if (delegation_blocked(&fp->fi_fhandle))
 		goto out_dec;
 	dp = delegstateid(nfs4_alloc_stid(clp, deleg_slab, nfs4_free_deleg));
 	if (dp == NULL)
@@ -5307,7 +5306,7 @@ static int nfsd4_check_conflicting_opens(struct nfs4_client *clp,
 }
 
 static struct nfs4_delegation *
-nfs4_set_delegation(struct nfs4_client *clp, struct svc_fh *fh,
+nfs4_set_delegation(struct nfs4_client *clp,
 		    struct nfs4_file *fp, struct nfs4_clnt_odstate *odstate)
 {
 	int status = 0;
@@ -5352,7 +5351,7 @@ nfs4_set_delegation(struct nfs4_client *clp, struct svc_fh *fh,
 		return ERR_PTR(status);
 
 	status = -ENOMEM;
-	dp = alloc_init_deleg(clp, fp, fh, odstate);
+	dp = alloc_init_deleg(clp, fp, odstate);
 	if (!dp)
 		goto out_delegees;
 
@@ -5420,8 +5419,7 @@ static void nfsd4_open_deleg_none_ext(struct nfsd4_open *open, int status)
  * proper support for them.
  */
 static void
-nfs4_open_delegation(struct svc_fh *fh, struct nfsd4_open *open,
-			struct nfs4_ol_stateid *stp)
+nfs4_open_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp)
 {
 	struct nfs4_delegation *dp;
 	struct nfs4_openowner *oo = openowner(stp->st_stateowner);
@@ -5453,7 +5451,7 @@ nfs4_open_delegation(struct svc_fh *fh, struct nfsd4_open *open,
 		default:
 			goto out_no_deleg;
 	}
-	dp = nfs4_set_delegation(clp, fh, stp->st_stid.sc_file, stp->st_clnt_odstate);
+	dp = nfs4_set_delegation(clp, stp->st_stid.sc_file, stp->st_clnt_odstate);
 	if (IS_ERR(dp))
 		goto out_no_deleg;
 
@@ -5585,7 +5583,7 @@ nfsd4_process_open2(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nf
 	* Attempt to hand out a delegation. No error return, because the
 	* OPEN succeeds even if we fail.
 	*/
-	nfs4_open_delegation(current_fh, open, stp);
+	nfs4_open_delegation(open, stp);
 nodeleg:
 	status = nfs_ok;
 	trace_nfsd_open(&stp->st_stid.sc_stateid);
-- 
2.43.0



