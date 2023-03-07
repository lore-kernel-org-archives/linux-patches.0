Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE9DBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562E9C433D2;
	Tue,  7 Mar 2023 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210167;
	bh=2yYM6HPhExIDEtr8HfCqywGTOxxhGHAQTPVu9kvfmi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVVe3Lx+wR2r46d3J8SPCuwCvHJgN0F75qbFS31euYUjc7oH1gYF/zlm7GeTYvU23
	 EtXKWazwlY0HQO7MgJw+FGk/v0CB3HZrfb+FLg3uXHu00zNLUrtkXYFytZ3mhpOFNm
	 LLKLG54prOockmqtKndVi6NwAIbRZwcD3RkAYWT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0453/1001] NFSD: fix problems with cleanup on errors in nfsd4_copy
Date: Tue,  7 Mar 2023 17:53:45 +0100
Message-Id: <20230307170041.017788756@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index b74cbc9a0e7f3..92674077fc88e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1685,9 +1685,12 @@ static void cleanup_async_copy(struct nfsd4_copy *copy)
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
 
@@ -1784,12 +1787,13 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
index c69f27d3adb79..529de327d6f93 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -992,7 +992,6 @@ static int nfs4_init_cp_state(struct nfsd_net *nn, copy_stateid_t *stid,
 
 	stid->cs_stid.si_opaque.so_clid.cl_boot = (u32)nn->boot_time;
 	stid->cs_stid.si_opaque.so_clid.cl_id = nn->s2s_cp_cl_id;
-	stid->cs_type = cs_type;
 
 	idr_preload(GFP_KERNEL);
 	spin_lock(&nn->s2s_cp_lock);
@@ -1003,6 +1002,7 @@ static int nfs4_init_cp_state(struct nfsd_net *nn, copy_stateid_t *stid,
 	idr_preload_end();
 	if (new_id < 0)
 		return 0;
+	stid->cs_type = cs_type;
 	return 1;
 }
 
@@ -1036,7 +1036,8 @@ void nfs4_free_copy_state(struct nfsd4_copy *copy)
 {
 	struct nfsd_net *nn;
 
-	WARN_ON_ONCE(copy->cp_stateid.cs_type != NFS4_COPY_STID);
+	if (copy->cp_stateid.cs_type != NFS4_COPY_STID)
+		return;
 	nn = net_generic(copy->cp_clp->net, nfsd_net_id);
 	spin_lock(&nn->s2s_cp_lock);
 	idr_remove(&nn->s2s_cp_stateids,
-- 
2.39.2



