Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A1015A843;
	Tue, 18 Jun 2024 13:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716703; cv=none; b=lf5wI46kGpClWEbh6VL2+DCl6S8yWnASCiadP/k4waLDEq7if5kO9pLFh5wZH1vN8/QOquMOGMY99VMTWFm9ssvdJTXSobEYoHQ61JGc6n25bKoPwPlY+T3JXPSMPTLx4SXMV+jz/BsR6LGtFl94vA/CsOHAV3miWaa0q/QODxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716703; c=relaxed/simple;
	bh=xImMXkpqpxXGRuMhPo+GvlMJko/Qq9Ps1APa0B0WGFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4eNZjc2x6Tsz7jHWY7dhWNKhxGf0lwJL0RwFcFT5bd1FAGyyZsDQt7zZkUHuJRqN2Ty4JjywmL8UwarbsdUnS3zrjalhn8hz9xJHn/v6NouE7JUuIo+8BwRTQKEYvpdRQZnZQSGLE7/zUEgPRmUaq2Vlq/ANkyGDvkQCPwh+yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwQKDiUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwQKDiUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6917C4AF48;
	Tue, 18 Jun 2024 13:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716703;
	bh=xImMXkpqpxXGRuMhPo+GvlMJko/Qq9Ps1APa0B0WGFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwQKDiUh17ImTcs6eAKiFH5wS3m+vvg2uG2ienA/cwsmhq6Qb2zA3m3GL4Pd2kRvt
	 TbFLYzPnfl8nwK0qZOLuXy9CHFfcss/iav9zGznuYaHuxB49FEKSm/+PxBH4+AeTNj
	 88U1inZ/DbPU1rkEZuRCc8RLE3BwpSn4MtTV0CCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 735/770] NFSD: fix problems with cleanup on errors in nfsd4_copy
Date: Tue, 18 Jun 2024 14:39:48 +0200
Message-ID: <20240618123435.637262072@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 81e722978ad21072470b73d8f6a50ad62c7d5b7d ]

When nfsd4_copy fails to allocate memory for async_copy->cp_src, or
nfs4_init_copy_state fails, it calls cleanup_async_copy to do the
cleanup for the async_copy which causes page fault since async_copy
is not yet initialized.

This patche rearranges the order of initializing the fields in
async_copy and adds checks in cleanup_async_copy to skip un-initialized
fields.

Fixes: ce0887ac96d3 ("NFSD add nfs4 inter ssc to nfsd4_copy")
Fixes: 87689df69491 ("NFSD: Shrink size of struct nfsd4_copy")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c  | 12 ++++++++----
 fs/nfsd/nfs4state.c |  5 +++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index fe20fd0933355..9c51c10bcf080 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1687,9 +1687,12 @@ static void cleanup_async_copy(struct nfsd4_copy *copy)
 {
 	nfs4_free_copy_state(copy);
 	release_copy_files(copy);
-	spin_lock(&copy->cp_clp->async_lock);
-	list_del(&copy->copies);
-	spin_unlock(&copy->cp_clp->async_lock);
+	if (copy->cp_clp) {
+		spin_lock(&copy->cp_clp->async_lock);
+		if (!list_empty(&copy->copies))
+			list_del_init(&copy->copies);
+		spin_unlock(&copy->cp_clp->async_lock);
+	}
 	nfs4_put_copy(copy);
 }
 
@@ -1786,12 +1789,13 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		async_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
 		if (!async_copy)
 			goto out_err;
+		INIT_LIST_HEAD(&async_copy->copies);
+		refcount_set(&async_copy->refcount, 1);
 		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
 		if (!async_copy->cp_src)
 			goto out_err;
 		if (!nfs4_init_copy_state(nn, copy))
 			goto out_err;
-		refcount_set(&async_copy->refcount, 1);
 		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid.cs_stid,
 			sizeof(copy->cp_res.cb_stateid));
 		dup_copy_fields(copy, async_copy);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f57137ef306bd..507dd2b11856b 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -990,7 +990,6 @@ static int nfs4_init_cp_state(struct nfsd_net *nn, copy_stateid_t *stid,
 
 	stid->cs_stid.si_opaque.so_clid.cl_boot = (u32)nn->boot_time;
 	stid->cs_stid.si_opaque.so_clid.cl_id = nn->s2s_cp_cl_id;
-	stid->cs_type = cs_type;
 
 	idr_preload(GFP_KERNEL);
 	spin_lock(&nn->s2s_cp_lock);
@@ -1001,6 +1000,7 @@ static int nfs4_init_cp_state(struct nfsd_net *nn, copy_stateid_t *stid,
 	idr_preload_end();
 	if (new_id < 0)
 		return 0;
+	stid->cs_type = cs_type;
 	return 1;
 }
 
@@ -1034,7 +1034,8 @@ void nfs4_free_copy_state(struct nfsd4_copy *copy)
 {
 	struct nfsd_net *nn;
 
-	WARN_ON_ONCE(copy->cp_stateid.cs_type != NFS4_COPY_STID);
+	if (copy->cp_stateid.cs_type != NFS4_COPY_STID)
+		return;
 	nn = net_generic(copy->cp_clp->net, nfsd_net_id);
 	spin_lock(&nn->s2s_cp_lock);
 	idr_remove(&nn->s2s_cp_stateids,
-- 
2.43.0



