Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849931AD3EE;
	Tue, 18 Jun 2024 13:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716780; cv=none; b=B+sywFCQeQ6EHAyKtEu3oDRshTndmtYvt3C9Y9joZGGE9EaQsYZw0qXRGl7qpuHUarALJQKA8Tifx7XSZ8pdfUvDmDEQwFaWyOCpWi+6FNesoPsi+p0JhN+6CCwsw5H9iajRu0wuNElcfcSeX547Gt+toOJvldt3GmfxrU2CuZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716780; c=relaxed/simple;
	bh=dPCLlqyWDebKbiKY13A+ywDSoOFBOmBvpvHmk8Jmaco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyfKEKteyuSgZyPNovAgVwnlA79KeejQ6Zdc7hF4fEZJMCcjLU+RDZK+2zg4GTuvc+ow2ZjLjBjLS4cYODkACz93oFC6FyuVOKblsh+naXeSSeg5d7hx4z5zifd6WE4Ni8jv+Rbj2XKwbizrzLlfL5Fheqil+McSTJh0gkLCd54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYd7RBbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYd7RBbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3940C3277B;
	Tue, 18 Jun 2024 13:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716780;
	bh=dPCLlqyWDebKbiKY13A+ywDSoOFBOmBvpvHmk8Jmaco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYd7RBbjK8Gr3VOPCdU15BFYyXzbcfIBd+TiOJXlVWNUyif/m8geS6Y84+bOZJtvu
	 lSpEuAoh9EOJqK7K3FbpT+Vq9qdA1pwRRdNiYdKMvnm0JOmFU71WRQpkHY4cMG2zNf
	 skjHqZZ+pRFLxtQAvJ/TokGC4I1N52QJXW5naO6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 761/770] nfsd: Simplify code around svc_exit_thread() call in nfsd()
Date: Tue, 18 Jun 2024 14:40:14 +0200
Message-ID: <20240618123436.646158137@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 5cf6543d3c8e5..1cf7a7799cc04 100644
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



