Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92C71EB5A;
	Mon,  4 Mar 2024 21:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589106; cv=none; b=jLf8DrjLaNL97nvQnlC4zldC1oxK8xEoGRJZ2fGZp60lHmQzQVDksdZHAzSQPYwlA0CgHVmyAMPDOXWS1oZ2d7kxSPoPWMsKwjGsDcY0NVb/wXWBXQW+R+PnORQWk0i1gAvhPMMIp06hvQq3XCnWpZKqIB+xzxOJQpEyGaCeCA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589106; c=relaxed/simple;
	bh=BA8f4gXCSHtwoSWjh6WaE2L9XDjcmXSMYKq1B586Ak0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2INrE3YmDYWChpanDElCwywL9uw6cUYa21t3GNZcThwH3XtQa47QdLle34aHCtzO6AolobZE5enM0rg3hVFI9pz9Ar+k8q8uyUkqhSis2ppYdJNWTkqzR1z63YRXtWjK7SxAzyjbJqlRutapOFhRHMvKejxCxi+DjYXT/fMCvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTcQ9pRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTcQ9pRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A6DC433C7;
	Mon,  4 Mar 2024 21:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589106;
	bh=BA8f4gXCSHtwoSWjh6WaE2L9XDjcmXSMYKq1B586Ak0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTcQ9pRXTY9Dfnxkt+fxrpejlleQ4JKG5xc2HYNQTIkY0GLELycLQo8HNWn/z/vdJ
	 fc1IQvcNls/iqKcbkAVfW2lFary1AofTDo20xcS3QDK/VheOnzuDAS6Ho123yuZCVX
	 DVE/MT6oQTD8G+Dwh7qoUHWYrAdYKFTjnTDpVQX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 178/215] NFSD: replace delayed_work with work_struct for nfsd_client_shrinker
Date: Mon,  4 Mar 2024 21:24:01 +0000
Message-ID: <20240304211602.585865779@linuxfoundation.org>
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

[ Upstream commit 7c24fa225081f31bc6da6a355c1ba801889ab29a ]

Since nfsd4_state_shrinker_count always calls mod_delayed_work with
0 delay, we can replace delayed_work with work_struct to save some
space and overhead.

Also add the call to cancel_work after unregister the shrinker
in nfs4_state_shutdown_net.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/netns.h     |    2 +-
 fs/nfsd/nfs4state.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -195,7 +195,7 @@ struct nfsd_net {
 
 	atomic_t		nfsd_courtesy_clients;
 	struct shrinker		nfsd_client_shrinker;
-	struct delayed_work	nfsd_shrinker_work;
+	struct work_struct	nfsd_shrinker_work;
 };
 
 /* Simple check to find out if a given net was properly initialized */
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4412,7 +4412,7 @@ nfsd4_state_shrinker_count(struct shrink
 	if (!count)
 		count = atomic_long_read(&num_delegations);
 	if (count)
-		mod_delayed_work(laundry_wq, &nn->nfsd_shrinker_work, 0);
+		queue_work(laundry_wq, &nn->nfsd_shrinker_work);
 	return (unsigned long)count;
 }
 
@@ -6253,8 +6253,7 @@ deleg_reaper(struct nfsd_net *nn)
 static void
 nfsd4_state_shrinker_worker(struct work_struct *work)
 {
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct nfsd_net *nn = container_of(dwork, struct nfsd_net,
+	struct nfsd_net *nn = container_of(work, struct nfsd_net,
 				nfsd_shrinker_work);
 
 	courtesy_client_reaper(nn);
@@ -8086,7 +8085,7 @@ static int nfs4_state_create_net(struct
 	INIT_LIST_HEAD(&nn->blocked_locks_lru);
 
 	INIT_DELAYED_WORK(&nn->laundromat_work, laundromat_main);
-	INIT_DELAYED_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
+	INIT_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
 	get_net(net);
 
 	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
@@ -8193,6 +8192,7 @@ nfs4_state_shutdown_net(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
 	unregister_shrinker(&nn->nfsd_client_shrinker);
+	cancel_work(&nn->nfsd_shrinker_work);
 	cancel_delayed_work_sync(&nn->laundromat_work);
 	locks_end_grace(&nn->nfsd4_manager);
 


