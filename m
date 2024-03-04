Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55206200D4;
	Mon,  4 Mar 2024 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589021; cv=none; b=iFGElF/5bnMGvBngf7/okpna0SIsEpK3ryV7tHI6WCBf7QfM5EhwYdkRPeN/xjw0cHtLcouaeEme2PErLM579a2HNdMc+lVVK1uVH4AvZ1VVZPhzU3FY8oKczpyZN9TrBHYfm4qDNlHyEEuzQT4Y959Vy8V9FycsUdgmf44PBi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589021; c=relaxed/simple;
	bh=cQA4LgngIn0yF0RMOvgSQvD+Wa9uIjTC5YCwHK67+9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcisTmErrHPDgy0ej019tyDsxrmPklAGEFp5PXMDcO1NblgCH2PFndA2tBKP5fbUmt6NljwwW5Ug/CM4Gk15qiG6G2djx6jfFmfwJ70wMaUOusFGOzzUEuzEdnSbOCtlntJrmy7aJxFqoX2Jwz+Jyp/IYlSheeLTiegpswd5iRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RK1dup4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RK1dup4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1303C433C7;
	Mon,  4 Mar 2024 21:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589021;
	bh=cQA4LgngIn0yF0RMOvgSQvD+Wa9uIjTC5YCwHK67+9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RK1dup4FdlpKmSA//vUkSCMCVlJ7pkGJ54PnTDCEcWv9mRJ/tnyOYW/wrP2c7wyOy
	 +MfzyT0gU+yIPrK8ZYe1zdEMsLBE9tPrRbmNfb+PSq7MKE1ASvqzuth7iMgH39Rt1O
	 hH47NX7lx3BCepclQq6mh7lwj8N80yzK3tmQodCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 170/215] NFSD: refactoring courtesy_client_reaper to a generic low memory shrinker
Date: Mon,  4 Mar 2024 21:23:53 +0000
Message-ID: <20240304211602.345616117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit a1049eb47f20b9eabf9afb218578fff16b4baca6 ]

Refactoring courtesy_client_reaper to generic low memory
shrinker so it can be used for other purposes.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4362,7 +4362,7 @@ out:
 }
 
 static unsigned long
-nfsd_courtesy_client_count(struct shrinker *shrink, struct shrink_control *sc)
+nfsd4_state_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	int cnt;
 	struct nfsd_net *nn = container_of(shrink,
@@ -4375,7 +4375,7 @@ nfsd_courtesy_client_count(struct shrink
 }
 
 static unsigned long
-nfsd_courtesy_client_scan(struct shrinker *shrink, struct shrink_control *sc)
+nfsd4_state_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	return SHRINK_STOP;
 }
@@ -4402,8 +4402,8 @@ nfsd4_init_leases_net(struct nfsd_net *n
 	nn->nfs4_max_clients = max_t(int, max_clients, NFS4_CLIENTS_PER_GB);
 
 	atomic_set(&nn->nfsd_courtesy_clients, 0);
-	nn->nfsd_client_shrinker.scan_objects = nfsd_courtesy_client_scan;
-	nn->nfsd_client_shrinker.count_objects = nfsd_courtesy_client_count;
+	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
+	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
 	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
 	return register_shrinker(&nn->nfsd_client_shrinker, "nfsd-client");
 }
@@ -6171,17 +6171,24 @@ laundromat_main(struct work_struct *laun
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
@@ -8007,7 +8014,7 @@ static int nfs4_state_create_net(struct
 	INIT_LIST_HEAD(&nn->blocked_locks_lru);
 
 	INIT_DELAYED_WORK(&nn->laundromat_work, laundromat_main);
-	INIT_DELAYED_WORK(&nn->nfsd_shrinker_work, courtesy_client_reaper);
+	INIT_DELAYED_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
 	get_net(net);
 
 	return 0;


