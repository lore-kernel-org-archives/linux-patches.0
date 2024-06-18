Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D22B1AC767;
	Tue, 18 Jun 2024 13:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716679; cv=none; b=IRERmi2AUvgvIXJUwuufPVUeupwiYl/hVn6DFbZL/ZMZAL9ZqZMknW1aDDurHGEL+kZClHkhorbSHCM2JdNNwEcEZHkQiHzPF9lRHimsnXae5RxCHYnMSfM8Fg7nrE37AJX/OGmOfJ3Vxz/6Yx9MYetpvfDYT4zwgcyovhIRIJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716679; c=relaxed/simple;
	bh=/Rxckf9dLI0BHZBq7jHoJYufe4giha1vbwacyEXVHUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uic9iAiJFyaxXA0fPCB7pq4K2qmVEWi9tURqRkm0xrd0swqyw13I5XUpQAIKPS5QsPMv8rbZA51QH1/nDw1hdF7kBPON1P6JUzcmOUfw/VW3TQKjOVJ1cMOgdA3KZ7YDOR1u1TAwyCEkrULyLA9pljV1/dvo2+lF6v+PXY+HrmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeLIZFeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeLIZFeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80A9C3277B;
	Tue, 18 Jun 2024 13:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716679;
	bh=/Rxckf9dLI0BHZBq7jHoJYufe4giha1vbwacyEXVHUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeLIZFePWU6SnNbjooFgzeC+D6U0Za2yGlJdkExC9NETIIx/jt//lnkprEf93mfo2
	 Zy5NVgQB4xanPuCZhSvTQHNHonbxa75AKI6DUe9H9xzjB2wN+k8fdAJTTKas3ty0rq
	 VOVTA74qlhWvrTbx+2vzQeE0HiSFpVNieTvpr/cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 727/770] NFSD: replace delayed_work with work_struct for nfsd_client_shrinker
Date: Tue, 18 Jun 2024 14:39:40 +0200
Message-ID: <20240618123435.330539223@linuxfoundation.org>
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

[ Upstream commit 7c24fa225081f31bc6da6a355c1ba801889ab29a ]

Since nfsd4_state_shrinker_count always calls mod_delayed_work with
0 delay, we can replace delayed_work with work_struct to save some
space and overhead.

Also add the call to cancel_work after unregister the shrinker
in nfs4_state_shutdown_net.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/netns.h     | 2 +-
 fs/nfsd/nfs4state.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 8c854ba3285bb..51a4b7885cae2 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -195,7 +195,7 @@ struct nfsd_net {
 
 	atomic_t		nfsd_courtesy_clients;
 	struct shrinker		nfsd_client_shrinker;
-	struct delayed_work	nfsd_shrinker_work;
+	struct work_struct	nfsd_shrinker_work;
 };
 
 /* Simple check to find out if a given net was properly initialized */
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f2647cbc108e3..3dd64caf06158 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4410,7 +4410,7 @@ nfsd4_state_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 	if (!count)
 		count = atomic_long_read(&num_delegations);
 	if (count)
-		mod_delayed_work(laundry_wq, &nn->nfsd_shrinker_work, 0);
+		queue_work(laundry_wq, &nn->nfsd_shrinker_work);
 	return (unsigned long)count;
 }
 
@@ -6223,8 +6223,7 @@ deleg_reaper(struct nfsd_net *nn)
 static void
 nfsd4_state_shrinker_worker(struct work_struct *work)
 {
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct nfsd_net *nn = container_of(dwork, struct nfsd_net,
+	struct nfsd_net *nn = container_of(work, struct nfsd_net,
 				nfsd_shrinker_work);
 
 	courtesy_client_reaper(nn);
@@ -8066,7 +8065,7 @@ static int nfs4_state_create_net(struct net *net)
 	INIT_LIST_HEAD(&nn->blocked_locks_lru);
 
 	INIT_DELAYED_WORK(&nn->laundromat_work, laundromat_main);
-	INIT_DELAYED_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
+	INIT_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
 	get_net(net);
 
 	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
@@ -8173,6 +8172,7 @@ nfs4_state_shutdown_net(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
 	unregister_shrinker(&nn->nfsd_client_shrinker);
+	cancel_work(&nn->nfsd_shrinker_work);
 	cancel_delayed_work_sync(&nn->laundromat_work);
 	locks_end_grace(&nn->nfsd4_manager);
 
-- 
2.43.0



