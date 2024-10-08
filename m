Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579351779B1;
	Tue,  8 Oct 2024 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391099; cv=none; b=r63ulDs4C34MNNUgeQFA1i+jg+5geBeXWZ5J5DP/LZkcwSWN77vYuyXcfmWu8GDeAsrmXCxOf+CEOMjjL3Cx+PTUcq7ngPC7KLVM+AgbwrxyJvxyhvo32LrAlOBQ+OmNW84CAvtPeK7ZBERX2dLagSgB3L9gOSc4K49CHyW0edo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391099; c=relaxed/simple;
	bh=uCOJpE28WuMBySXC+OIcHpqt8zC/Glkw+tgppbW6WMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncvwhqGX4Abf6cF3cRtjMUxgwxLRkE8eYizN/xeqDaRxF8xIqdxXnS9sUlvmijUL6jRRZHmZolBdB44e00i37V69xH2y4XIXrAkmRqd3sLADoZ9o+KFZdNxq63DPN8eFOFjTZTrdEb15EJ7n5T3yBc5btcI8ptJPr0i9PZqK7Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNI6Ofpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNI6Ofpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851EAC4CEC7;
	Tue,  8 Oct 2024 12:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391098;
	bh=uCOJpE28WuMBySXC+OIcHpqt8zC/Glkw+tgppbW6WMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNI6OfpbIu7jkmw7QZwGdH8tyTNHio6rePMcTycbEK9zD0fDgOks8Fh7dlrhWv+tV
	 lG/7fevXp0UaQvVF0Tsv9yMUwyXsykPBGB2u5e4VoIo+M/VWdmpaIlahyju1Cez7Pw
	 cgeG5mJEljmUBdMokoa+ODD9aPDN5J52VoSxWSGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 460/482] NFSD: Limit the number of concurrent async COPY operations
Date: Tue,  8 Oct 2024 14:08:43 +0200
Message-ID: <20241008115706.616353379@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit aadc3bbea163b6caaaebfdd2b6c4667fbc726752 ]

Nothing appears to limit the number of concurrent async COPY
operations that clients can start. In addition, AFAICT each async
COPY can copy an unlimited number of 4MB chunks, so can run for a
long time. Thus IMO async COPY can become a DoS vector.

Add a restriction mechanism that bounds the number of concurrent
background COPY operations. Start simple and try to be fair -- this
patch implements a per-namespace limit.

An async COPY request that occurs while this limit is exceeded gets
NFS4ERR_DELAY. The requesting client can choose to send the request
again after a delay or fall back to a traditional read/write style
copy.

If there is need to make the mechanism more sophisticated, we can
visit that in future patches.

Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/netns.h     |  1 +
 fs/nfsd/nfs4proc.c  | 11 +++++++++--
 fs/nfsd/nfs4state.c |  1 +
 fs/nfsd/xdr4.h      |  1 +
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 14ec156563209..5cae26917436c 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -148,6 +148,7 @@ struct nfsd_net {
 	u32		s2s_cp_cl_id;
 	struct idr	s2s_cp_stateids;
 	spinlock_t	s2s_cp_lock;
+	atomic_t	pending_async_copies;
 
 	/*
 	 * Version information
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 60c526adc27c6..5768b2ff1d1d1 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1279,6 +1279,7 @@ static void nfs4_put_copy(struct nfsd4_copy *copy)
 {
 	if (!refcount_dec_and_test(&copy->refcount))
 		return;
+	atomic_dec(&copy->cp_nn->pending_async_copies);
 	kfree(copy->cp_src);
 	kfree(copy);
 }
@@ -1833,10 +1834,16 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	memcpy(&copy->fh, &cstate->current_fh.fh_handle,
 		sizeof(struct knfsd_fh));
 	if (nfsd4_copy_is_async(copy)) {
-		status = nfserrno(-ENOMEM);
 		async_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
 		if (!async_copy)
 			goto out_err;
+		async_copy->cp_nn = nn;
+		/* Arbitrary cap on number of pending async copy operations */
+		if (atomic_inc_return(&nn->pending_async_copies) >
+				(int)rqstp->rq_pool->sp_nrthreads) {
+			atomic_dec(&nn->pending_async_copies);
+			goto out_err;
+		}
 		INIT_LIST_HEAD(&async_copy->copies);
 		refcount_set(&async_copy->refcount, 1);
 		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
@@ -1876,7 +1883,7 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	}
 	if (async_copy)
 		cleanup_async_copy(async_copy);
-	status = nfserrno(-ENOMEM);
+	status = nfserr_jukebox;
 	goto out;
 }
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f4eae4b65572a..3837f4e417247 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8575,6 +8575,7 @@ static int nfs4_state_create_net(struct net *net)
 	spin_lock_init(&nn->client_lock);
 	spin_lock_init(&nn->s2s_cp_lock);
 	idr_init(&nn->s2s_cp_stateids);
+	atomic_set(&nn->pending_async_copies, 0);
 
 	spin_lock_init(&nn->blocked_locks_lock);
 	INIT_LIST_HEAD(&nn->blocked_locks_lru);
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index fbdd42cde1fa5..2a21a7662e030 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -713,6 +713,7 @@ struct nfsd4_copy {
 	struct nfsd4_ssc_umount_item *ss_nsui;
 	struct nfs_fh		c_fh;
 	nfs4_stateid		stateid;
+	struct nfsd_net		*cp_nn;
 };
 
 static inline void nfsd4_copy_set_sync(struct nfsd4_copy *copy, bool sync)
-- 
2.43.0



