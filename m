Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEC41AA7AE;
	Wed, 20 Nov 2024 13:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107611; cv=none; b=TSRN8aThdrsTzFrq3Kl/X/Gq/fT/FLIPbW/rMKR/VMSoEo0ic7aJW1aAw5JtQIJc4tqSnY+Als8a9G4R+g3wAHKJ5wmILCvT33eJ0zsdGXL1eMv41641fajmpLn+4EFJBgWsJ4D2iaT4Wl35Cl0lndDuWrah2ARk5cUsYj0Cn2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107611; c=relaxed/simple;
	bh=KxSCAcVius1Oo+nGvjesezURmQmiJcdsws4CDgL45PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1VZ0i/4u00n0XCdDSA4D8FFUqfFj/mDgYusTwjUKOmVmhy2n3Ps8SZJXjSCBtiDTcA2MJlERx/kcfEj5s7qd06H90KcMzc180XT8dSW1rmS1iKGSF2YQhe3M4G6dfrsRYcFKVDTg8Up3eYBlmEA5anggI0vn0ztCsw3RHbj2LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAEoq3Tn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAEoq3Tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5336C4CECD;
	Wed, 20 Nov 2024 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107611;
	bh=KxSCAcVius1Oo+nGvjesezURmQmiJcdsws4CDgL45PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAEoq3Tn2UWq3UPECy12+/hehfXdRXYyAd79lOd7ZmMK+xCpnJ8lzOny5FS0gpDap
	 N6xCZOMqzRB22r5osd8n8gNwoo8PLKFxAaatKZyHhxf/1QZxEIuHbM3vAOOZs0urX5
	 rrNIDebHbAzHipycFYV8IyHDyQ7yQq8bIGP4cxy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 63/82] NFSD: Limit the number of concurrent async COPY operations
Date: Wed, 20 Nov 2024 13:57:13 +0100
Message-ID: <20241120125631.031921375@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Link: https://nvd.nist.gov/vuln/detail/CVE-2024-49974
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/netns.h     |    1 +
 fs/nfsd/nfs4proc.c  |   11 +++++++++--
 fs/nfsd/nfs4state.c |    1 +
 fs/nfsd/xdr4.h      |    1 +
 4 files changed, 12 insertions(+), 2 deletions(-)

--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -153,6 +153,7 @@ struct nfsd_net {
 	u32		s2s_cp_cl_id;
 	struct idr	s2s_cp_stateids;
 	spinlock_t	s2s_cp_lock;
+	atomic_t	pending_async_copies;
 
 	/*
 	 * Version information
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1273,6 +1273,7 @@ static void nfs4_put_copy(struct nfsd4_c
 {
 	if (!refcount_dec_and_test(&copy->refcount))
 		return;
+	atomic_dec(&copy->cp_nn->pending_async_copies);
 	kfree(copy->cp_src);
 	kfree(copy);
 }
@@ -1811,10 +1812,16 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
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
@@ -1853,7 +1860,7 @@ out_err:
 	}
 	if (async_copy)
 		cleanup_async_copy(async_copy);
-	status = nfserrno(-ENOMEM);
+	status = nfserr_jukebox;
 	goto out;
 }
 
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8142,6 +8142,7 @@ static int nfs4_state_create_net(struct
 	spin_lock_init(&nn->client_lock);
 	spin_lock_init(&nn->s2s_cp_lock);
 	idr_init(&nn->s2s_cp_stateids);
+	atomic_set(&nn->pending_async_copies, 0);
 
 	spin_lock_init(&nn->blocked_locks_lock);
 	INIT_LIST_HEAD(&nn->blocked_locks_lru);
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -574,6 +574,7 @@ struct nfsd4_copy {
 	struct nfsd4_ssc_umount_item *ss_nsui;
 	struct nfs_fh		c_fh;
 	nfs4_stateid		stateid;
+	struct nfsd_net		*cp_nn;
 };
 
 static inline void nfsd4_copy_set_sync(struct nfsd4_copy *copy, bool sync)


