Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8B97C6CA;
	Mon,  8 Apr 2024 13:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584682; cv=none; b=cH8l1VOtndgcY5o+qmpPkMpdPvKES/aT6FuL1NOX33U9puAu9xyokYN+VHGLHdEYLCihFTx6O4QFq3HwqVs4xI2VdmoyoF55yKO/XljPyBCqui59DR+pZMvDjvCUuhQu6efZMzYjwUfKAIxMKmk22+9DNR0VBb0iMDiRcSm4sMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584682; c=relaxed/simple;
	bh=ZXTev4ayTHSJQYKGuS6Oh94GJ8+V95M7ypfWSMQTvvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhkcQT4oC3NYqLzgMFP/s+f+bUXOK7Rni4fuiJHYwQ5HqMx8HhQveaardQnuGpsgoOZ72gZRknKAnmJX3CTKjN4DZTqFrQMhQWHmMaS/jB7wf/nkepp1MstCIFp1Het1hAuEsmYUohqRtcQf79pgA4UXiuPp8wUuOaJ6fz0FbPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qP+X0y+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qP+X0y+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0654FC433C7;
	Mon,  8 Apr 2024 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584682;
	bh=ZXTev4ayTHSJQYKGuS6Oh94GJ8+V95M7ypfWSMQTvvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qP+X0y+jMZptZcxjb7m8MdAzrySxnj3wrKQb0KxxL2ke4qixKsR6GrG/HMmpbY0kA
	 16FO2VmvxUfWrX9jzIYrdNH3fWRg6z2AoBIGVGzodY3OUxr7OxWEj3mOnXiQKNaQO2
	 eUUi1zDFNESQt/oLCjZrDBz+cTI0c+WumHRciba4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 514/690] NFSD: replace delayed_work with work_struct for nfsd_client_shrinker
Date: Mon,  8 Apr 2024 14:56:20 +0200
Message-ID: <20240408125418.272557376@linuxfoundation.org>
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

[ Upstream commit 7c24fa225081f31bc6da6a355c1ba801889ab29a ]

Since nfsd4_state_shrinker_count always calls mod_delayed_work with
0 delay, we can replace delayed_work with work_struct to save some
space and overhead.

Also add the call to cancel_work after unregister the shrinker
in nfs4_state_shutdown_net.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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
index ca0a1816500c3..22799f5ce686e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4411,7 +4411,7 @@ nfsd4_state_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 	if (!count)
 		count = atomic_long_read(&num_delegations);
 	if (count)
-		mod_delayed_work(laundry_wq, &nn->nfsd_shrinker_work, 0);
+		queue_work(laundry_wq, &nn->nfsd_shrinker_work);
 	return (unsigned long)count;
 }
 
@@ -6228,8 +6228,7 @@ deleg_reaper(struct nfsd_net *nn)
 static void
 nfsd4_state_shrinker_worker(struct work_struct *work)
 {
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct nfsd_net *nn = container_of(dwork, struct nfsd_net,
+	struct nfsd_net *nn = container_of(work, struct nfsd_net,
 				nfsd_shrinker_work);
 
 	courtesy_client_reaper(nn);
@@ -8057,7 +8056,7 @@ static int nfs4_state_create_net(struct net *net)
 	INIT_LIST_HEAD(&nn->blocked_locks_lru);
 
 	INIT_DELAYED_WORK(&nn->laundromat_work, laundromat_main);
-	INIT_DELAYED_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
+	INIT_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
 	get_net(net);
 
 	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
@@ -8164,6 +8163,7 @@ nfs4_state_shutdown_net(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
 	unregister_shrinker(&nn->nfsd_client_shrinker);
+	cancel_work(&nn->nfsd_shrinker_work);
 	cancel_delayed_work_sync(&nn->laundromat_work);
 	locks_end_grace(&nn->nfsd4_manager);
 
-- 
2.43.0



