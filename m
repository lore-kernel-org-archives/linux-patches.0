Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE857A15C;
	Mon,  8 Apr 2024 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584630; cv=none; b=UceaKaDuKiyT0nPYssZkzFL6oYSvhT/MkpsF647v4PtoztAYMlz/kWTtqZ23pbMClL41pUH/L47bkPAabiZVgMqFG2TGbqF8JQn/l49Khz+WZjzKt/OQNZ2rmJLTIT5x2ynJQ/jB6k4aWErnChgH2ov6HZ7sa7oAG7sBG1QWN3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584630; c=relaxed/simple;
	bh=mg1+uRuyH95TNu3B17bRv5+vdo07kqA8L+GCJHa34X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKHvGBUWYxcMM9Tcxxmv6KkNoPJ/iYQNOsBel2UN3+VX9bNCra5JeXhPK/pY/mgWrgbuQLj0F248xvmcqrqSyYjZr8jb3+aLpdQsH9fWSCeEdmcxgAbg8qY89bwLaV5h2Lm42O3YugUGGJgwnrA/KHSKIqR0t3RmuKE7FvGc/Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGYcBLuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGYcBLuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9897C433C7;
	Mon,  8 Apr 2024 13:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584629;
	bh=mg1+uRuyH95TNu3B17bRv5+vdo07kqA8L+GCJHa34X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGYcBLuCD5V7+IEQl+d5bqeCBroNkISBkxnj5TSBeBVjUqEvWOg7ZvnvSfw8GSDbd
	 0BXfnEBRiq4XRepjC2FPQYrUCOkY28BxTjeWpvbl+6QovQ/pPCgs3Jl5pPnno4WpNL
	 3kunW4H/jdrmHLl7z+RIILeyy4b/1XMIIaLQ5aIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 503/690] NFSD: refactoring courtesy_client_reaper to a generic low memory shrinker
Date: Mon,  8 Apr 2024 14:56:09 +0200
Message-ID: <20240408125417.857334279@linuxfoundation.org>
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

[ Upstream commit a1049eb47f20b9eabf9afb218578fff16b4baca6 ]

Refactoring courtesy_client_reaper to generic low memory
shrinker so it can be used for other purposes.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 524865c7211ef..34ae4a3d86f3e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4361,7 +4361,7 @@ nfsd4_init_slabs(void)
 }
 
 static unsigned long
-nfsd_courtesy_client_count(struct shrinker *shrink, struct shrink_control *sc)
+nfsd4_state_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	int cnt;
 	struct nfsd_net *nn = container_of(shrink,
@@ -4374,7 +4374,7 @@ nfsd_courtesy_client_count(struct shrinker *shrink, struct shrink_control *sc)
 }
 
 static unsigned long
-nfsd_courtesy_client_scan(struct shrinker *shrink, struct shrink_control *sc)
+nfsd4_state_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	return SHRINK_STOP;
 }
@@ -4401,8 +4401,8 @@ nfsd4_init_leases_net(struct nfsd_net *nn)
 	nn->nfs4_max_clients = max_t(int, max_clients, NFS4_CLIENTS_PER_GB);
 
 	atomic_set(&nn->nfsd_courtesy_clients, 0);
-	nn->nfsd_client_shrinker.scan_objects = nfsd_courtesy_client_scan;
-	nn->nfsd_client_shrinker.count_objects = nfsd_courtesy_client_count;
+	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
+	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
 	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
 	return register_shrinker(&nn->nfsd_client_shrinker);
 }
@@ -6151,17 +6151,24 @@ laundromat_main(struct work_struct *laundry)
 }
 
 static void
-courtesy_client_reaper(struct work_struct *reaper)
+courtesy_client_reaper(struct nfsd_net *nn)
 {
 	struct list_head reaplist;
-	struct delayed_work *dwork = to_delayed_work(reaper);
-	struct nfsd_net *nn = container_of(dwork, struct nfsd_net,
-					nfsd_shrinker_work);
 
 	nfs4_get_courtesy_client_reaplist(nn, &reaplist);
 	nfs4_process_client_reaplist(&reaplist);
 }
 
+static void
+nfsd4_state_shrinker_worker(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct nfsd_net *nn = container_of(dwork, struct nfsd_net,
+				nfsd_shrinker_work);
+
+	courtesy_client_reaper(nn);
+}
+
 static inline __be32 nfs4_check_fh(struct svc_fh *fhp, struct nfs4_stid *stp)
 {
 	if (!fh_match(&fhp->fh_handle, &stp->sc_file->fi_fhandle))
@@ -7983,7 +7990,7 @@ static int nfs4_state_create_net(struct net *net)
 	INIT_LIST_HEAD(&nn->blocked_locks_lru);
 
 	INIT_DELAYED_WORK(&nn->laundromat_work, laundromat_main);
-	INIT_DELAYED_WORK(&nn->nfsd_shrinker_work, courtesy_client_reaper);
+	INIT_DELAYED_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
 	get_net(net);
 
 	return 0;
-- 
2.43.0



