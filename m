Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D942C79F0;
	Mon,  8 Apr 2024 13:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584773; cv=none; b=hluBoQvUhjImaFWOYMv6ach/Oy6Hots1l6YgF8yeEhSWHwEGPwiqoVm/W2Cc6lNvKH90QMoCrwjZcH/ZP/6yoCMCscnZCeouA0obRaqQemN4CNuXlT7xGD5SGQHt9h5hySHXhiJzIB7nOyS43Yd2+X3mHPHXxXjmouySDc53gPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584773; c=relaxed/simple;
	bh=RUb3pDVSwUIbyvo1s2Fw+G5hC5Ogq+0zi+Bj4H5HwOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dl5pgm1zecb/HLOEpWzQMh/qzGd9q/MQvuG8CN81j3R3To0IVHgzF9WtepXUTE093taf1Nfrx2rpp2HaMLeQxYaPJ5r845M1aZprPawDObXVZ8N/FJk1KnKVuXNXZHUPmP8H8cVouyUoqxM3yrkeKEwX10ZKV8v3TLflzr4oLP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzxTCzAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzxTCzAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647E3C433C7;
	Mon,  8 Apr 2024 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584773;
	bh=RUb3pDVSwUIbyvo1s2Fw+G5hC5Ogq+0zi+Bj4H5HwOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzxTCzAnMHW8Bxr8wkJTVA3BT9ZIxZPBumIHQONwQhJ5iiODhrKmjUCS0iSADYvv0
	 8AvJthe5f+x0+qDJM56x2suanjBiJje2muoA2JN4t0bfsJJ55GHoojkV4TeLN9y2w4
	 DEbVkJSjeryGbnY9hBlklVRET5eRO/dcRVKJuYY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 522/690] NFSD: fix problems with cleanup on errors in nfsd4_copy
Date: Mon,  8 Apr 2024 14:56:28 +0200
Message-ID: <20240408125418.556452100@linuxfoundation.org>
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
---
 fs/nfsd/nfs4proc.c  | 12 ++++++++----
 fs/nfsd/nfs4state.c |  5 +++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c95e7ec5fb530..ba53cd89ec62c 100644
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
index 773971a75b62d..fab5805b3ca74 100644
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



