Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0729A1C7B97;
	Tue, 27 Aug 2024 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772684; cv=none; b=KSB1bvAJy2sdQZ14qnHW5Kq6iFQZcQEXo+UTlPthrpOwjVborDngfGzyYbNj5NWLssCvnjhARSkYJy1YXigxkKKkFB8OTZR0o/CH+N2T9TbdPyAkmjGsIzz4CPU6jIOQI7wxok588Y3I5DTng5zbU51YJP5w6eXKougMRw81IRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772684; c=relaxed/simple;
	bh=Lq+KSAcRZ5WXEbmipjcTCPIr+/hY+fIN+EbCYNhERoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pv6s5/Jrq7ngBW2BHdQMiQq7QYfKEkbvyvW1AXla1Pi2ddyZJc0F7RU1Tz1K+W6xIfXTsNSvbWzvAPJ0twfzCUP+8dX2RtoSA5yMoNI/TDghfAEKdD6Wo7PdukgmHx4TfUK7i81qaduFUGQIeYlrwd9sVqh6WJSH4Awk3Hvh/hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOnNoS7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOnNoS7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A92C4DDF0;
	Tue, 27 Aug 2024 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772683;
	bh=Lq+KSAcRZ5WXEbmipjcTCPIr+/hY+fIN+EbCYNhERoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOnNoS7eZXYAKIjb4qjquTLZ2POnpN1ftmTzGRZGK+DPv7K/COZCvsGinCnmr1I4K
	 Z22OnlLXxxabAhwYbkiX1/h8J00CHG0gyfRt+9Pk6TjF8CKCc3T5VptM1hfQNXSzUu
	 g1JAs48Nz4vjyuSkdBdCU169ikgW7rRUGoH9jUC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 288/321] nfsd: Simplify code around svc_exit_thread() call in nfsd()
Date: Tue, 27 Aug 2024 16:39:56 +0200
Message-ID: <20240827143849.211262411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c           |   23 -----------------------
 include/linux/sunrpc/svc.h |   13 -------------
 2 files changed, 36 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -983,31 +983,8 @@ nfsd(void *vrqstp)
 	atomic_dec(&nfsd_th_cnt);
 
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
 
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -123,19 +123,6 @@ static inline void svc_put(struct svc_se
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


