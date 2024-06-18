Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F46156F39;
	Tue, 18 Jun 2024 13:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715779; cv=none; b=u7uhh3ANwlN3wOH7KWsW8mjDgjDrdGTZUUrSn0aFHFn2x/MgxzJZxF0KVhJv9WC97TzgLDfp1f56fpJ5OdY+pmj+f3lLCOBjUWXsEgQC4PfD7Ft5tNWJYZ9Ji4pZTKmwliSNY/ldwAcNCjH6Ko32iowMZclFSRS65/pCAJ5KR7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715779; c=relaxed/simple;
	bh=UN1esbajrucKgstjnHTzVwFBesrEoRNfCgsV+a4+OLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWjS6Tc/RpEw4BmENUWFVzhtNA1DOwMySDAUyYeMEFiGPB9loouBbpSaIaPsWGETCkjSd3VUW/ITqN2Dof1FdhYWMrKERdolqaG6DMMCGAYyFYQTfaHzXg004MUC/US+YcuI01igxZ5PS+AHJ3DcJN4yR6u3u/jr/39B/EQaLQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLsFpM2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLsFpM2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E977C3277B;
	Tue, 18 Jun 2024 13:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715779;
	bh=UN1esbajrucKgstjnHTzVwFBesrEoRNfCgsV+a4+OLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLsFpM2WDmEZkSXoIwoYw0eYS+SKD7TkKmZY2KjSVz6Dd/1iILGjT/uk6xxmSdmNy
	 DrsXns9EAok2ugg8WGeexdD8OSiX/dC+TySRvH7fafEec8vkVFRHB+bkrJGad3AWFT
	 9GhmTXPeb4xv6YCucBckJKzo1eokC/eg0OnAnwQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 424/770] SUNRPC: use sv_lock to protect updates to sv_nrthreads.
Date: Tue, 18 Jun 2024 14:34:37 +0200
Message-ID: <20240618123423.650752362@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 2a36395fac3b72771f87c3ee4387e3a96d85a7cc ]

Using sv_lock means we don't need to hold the service mutex over these
updates.

In particular,  svc_exit_thread() no longer requires synchronisation, so
threads can exit asynchronously.

Note that we could use an atomic_t, but as there are many more read
sites than writes, that would add unnecessary noise to the code.
Some reads are already racy, and there is no need for them to not be.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 5 ++---
 net/sunrpc/svc.c | 9 +++++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 32f2c46a38323..16884a90e1ab0 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -55,9 +55,8 @@ static __be32			nfsd_init_request(struct svc_rqst *,
 						struct svc_process_info *);
 
 /*
- * nfsd_mutex protects nn->nfsd_serv -- both the pointer itself and the members
- * of the svc_serv struct. In particular, ->sv_nrthreads but also to some
- * extent ->sv_temp_socks and ->sv_permsocks.
+ * nfsd_mutex protects nn->nfsd_serv -- both the pointer itself and some members
+ * of the svc_serv struct such as ->sv_temp_socks and ->sv_permsocks.
  *
  * If (out side the lock) nn->nfsd_serv is non-NULL, then it must point to a
  * properly initialised 'struct svc_serv' with ->sv_nrthreads > 0 (unless
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 19c9d8bf77beb..283088f3215e6 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -521,7 +521,7 @@ EXPORT_SYMBOL_GPL(svc_shutdown_net);
 
 /*
  * Destroy an RPC service. Should be called with appropriate locking to
- * protect the sv_nrthreads, sv_permsocks and sv_tempsocks.
+ * protect sv_permsocks and sv_tempsocks.
  */
 void
 svc_destroy(struct kref *ref)
@@ -637,7 +637,10 @@ svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool, int node)
 		return ERR_PTR(-ENOMEM);
 
 	svc_get(serv);
-	serv->sv_nrthreads++;
+	spin_lock_bh(&serv->sv_lock);
+	serv->sv_nrthreads += 1;
+	spin_unlock_bh(&serv->sv_lock);
+
 	spin_lock_bh(&pool->sp_lock);
 	pool->sp_nrthreads++;
 	list_add_rcu(&rqstp->rq_all, &pool->sp_all_threads);
@@ -881,7 +884,9 @@ svc_exit_thread(struct svc_rqst *rqstp)
 		list_del_rcu(&rqstp->rq_all);
 	spin_unlock_bh(&pool->sp_lock);
 
+	spin_lock_bh(&serv->sv_lock);
 	serv->sv_nrthreads -= 1;
+	spin_unlock_bh(&serv->sv_lock);
 	svc_sock_update_bufs(serv);
 
 	svc_rqst_free(rqstp);
-- 
2.43.0



