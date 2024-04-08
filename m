Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1507CF39;
	Mon,  8 Apr 2024 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583294; cv=none; b=mHpvu5Y4m7+BU6ZpPmjFY2MT8zFaROCLCPQLjAp0PjYRsxBacvJaPdjanLZl/refsrRIXV6AcYYkAK0wsc3/t32Or/pEmBBsdzzv0fYQYo4aAcvubxgZLQNe3SL9JKCgBUHXzh/A0Br6mFZeKYKiQRS0FWXabwrQistkPIZiWig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583294; c=relaxed/simple;
	bh=L5RpJcHwsu+kPsnvbYI7scbphDlpF7z5jH+G9jY99cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wwji+cSLR7Jea+OHiwXp7LrA4GBQV48QbMO1Ayv8cHwFa/NOG6u/ZM+GaMsrkIA9ZJZtR0xTv8ts8EM9fwb5+jgVi2B4CUJXPqKbBbFv1WLs05+MT9Sxqc7JWDc1bIr4yBxQ9qdJ9Sx2ve6QQxMO4qhf4uJbJX/x14EoMCv7VqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0n+dQhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0n+dQhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD9EC433F1;
	Mon,  8 Apr 2024 13:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583293;
	bh=L5RpJcHwsu+kPsnvbYI7scbphDlpF7z5jH+G9jY99cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0n+dQhJ8R949hlbtBZhfwUTImG6fDXAMJNxbvlyGwPN/glGTy/YzACAPd7Kwir5h
	 Z/Ng0pr7BFNzD30FSSeC5kMx38n9rtFN68mZXRSOi9cJjXjXzhYcvUPmK+dq6auTNG
	 OlhGNsABjfiXRGc+Uv9wfdyNn+FGUBlHoGPzxPis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 231/690] SUNRPC: use sv_lock to protect updates to sv_nrthreads.
Date: Mon,  8 Apr 2024 14:51:37 +0200
Message-ID: <20240408125407.986854671@linuxfoundation.org>
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
index 6cde8c87e5733..c8a0649e5cdf1 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -523,7 +523,7 @@ EXPORT_SYMBOL_GPL(svc_shutdown_net);
 
 /*
  * Destroy an RPC service. Should be called with appropriate locking to
- * protect the sv_nrthreads, sv_permsocks and sv_tempsocks.
+ * protect sv_permsocks and sv_tempsocks.
  */
 void
 svc_destroy(struct kref *ref)
@@ -639,7 +639,10 @@ svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool, int node)
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
@@ -884,7 +887,9 @@ svc_exit_thread(struct svc_rqst *rqstp)
 		list_del_rcu(&rqstp->rq_all);
 	spin_unlock_bh(&pool->sp_lock);
 
+	spin_lock_bh(&serv->sv_lock);
 	serv->sv_nrthreads -= 1;
+	spin_unlock_bh(&serv->sv_lock);
 	svc_sock_update_bufs(serv);
 
 	svc_rqst_free(rqstp);
-- 
2.43.0



