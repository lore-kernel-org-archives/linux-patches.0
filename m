Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388AC7C092;
	Mon,  8 Apr 2024 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584874; cv=none; b=tzCuZMkFmTrdRlZS7AS1IlxAJZVcjaOC6IWUd8FIlMcC2JkXxHTiqqqnwQs4zkx44CYGLrZNbsUNYz5exubD1jNgfwIIOdNDMBEImc403mWJgNmceE6LOk2YbiPawLBEaGekXDilMPw38/XZWwyU+kZRPe8c36UtXfay04rGVEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584874; c=relaxed/simple;
	bh=uid/OMQJ312PcQM4dt5mc1HmzNYdV+VOSr3UmNWQkwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnbYKZ1PS2XkAru5LN58aafs4fueaJpmprArHJUkdzzdIKio/24C9DFLfF9qKlfBtnkiqLKGe/zTJ/hU0uwbR0hc5QQomloPAv6+UyrwVDn++mvzSI+d5xNbz5Aw85fyUW3/S9LQ8RWf2uddme7RYsp8Qf/iDQYkLeEx7C/nVwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+FNtqqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+FNtqqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719F8C433C7;
	Mon,  8 Apr 2024 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584873;
	bh=uid/OMQJ312PcQM4dt5mc1HmzNYdV+VOSr3UmNWQkwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+FNtqqGgQsBdUi+EgnsNVfWqohcjJJInEAhv8JhlWiiqBtlL1jGqnqhzlusDJ5Kf
	 l/kA79f9OGL9SI49p5YeDuFiVBhqo26Q/gg2qLgEHqgccSUu3FHMt5CFVKUWt4UG8e
	 /qC7oyk02FzXYAixuHycncHC4d+RQZTbr6wZ8WBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 546/690] nfsd: Simplify code around svc_exit_thread() call in nfsd()
Date: Mon,  8 Apr 2024 14:56:52 +0200
Message-ID: <20240408125419.428394000@linuxfoundation.org>
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

[ Upstream commit 18e4cf915543257eae2925671934937163f5639b ]

Previously a thread could exit asynchronously (due to a signal) so some
care was needed to hold nfsd_mutex over the last svc_put() call.  Now a
thread can only exit when svc_set_num_threads() is called, and this is
always called under nfsd_mutex.  So no care is needed.

Not only is the mutex held when a thread exits now, but the svc refcount
is elevated, so the svc_put() in svc_exit_thread() will never be a final
put, so the mutex isn't even needed at this point in the code.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfssvc.c           | 23 -----------------------
 include/linux/sunrpc/svc.h | 13 -------------
 2 files changed, 36 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 8063fab2c0279..8907dba22c3f2 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -979,31 +979,8 @@ nfsd(void *vrqstp)
 	atomic_dec(&nfsdstats.th_cnt);
 
 out:
-	/* Take an extra ref so that the svc_put in svc_exit_thread()
-	 * doesn't call svc_destroy()
-	 */
-	svc_get(nn->nfsd_serv);
-
 	/* Release the thread */
 	svc_exit_thread(rqstp);
-
-	/* We need to drop a ref, but may not drop the last reference
-	 * without holding nfsd_mutex, and we cannot wait for nfsd_mutex as that
-	 * could deadlock with nfsd_shutdown_threads() waiting for us.
-	 * So three options are:
-	 * - drop a non-final reference,
-	 * - get the mutex without waiting
-	 * - sleep briefly andd try the above again
-	 */
-	while (!svc_put_not_last(nn->nfsd_serv)) {
-		if (mutex_trylock(&nfsd_mutex)) {
-			nfsd_put(net);
-			mutex_unlock(&nfsd_mutex);
-			break;
-		}
-		msleep(20);
-	}
-
 	return 0;
 }
 
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 53405c282209f..6e48c1c88f1bb 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -123,19 +123,6 @@ static inline void svc_put(struct svc_serv *serv)
 	kref_put(&serv->sv_refcnt, svc_destroy);
 }
 
-/**
- * svc_put_not_last - decrement non-final reference count on SUNRPC serv
- * @serv:  the svc_serv to have count decremented
- *
- * Returns: %true is refcount was decremented.
- *
- * If the refcount is 1, it is not decremented and instead failure is reported.
- */
-static inline bool svc_put_not_last(struct svc_serv *serv)
-{
-	return refcount_dec_not_one(&serv->sv_refcnt.refcount);
-}
-
 /*
  * Maximum payload size supported by a kernel RPC server.
  * This is use to determine the max number of pages nfsd is
-- 
2.43.0



