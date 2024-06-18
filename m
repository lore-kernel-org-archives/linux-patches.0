Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C22C181CE9;
	Tue, 18 Jun 2024 12:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715574; cv=none; b=R/ALcv7ACgaFjd6PKndVxJVk5QJhqe5lWhEAEl5wUWCFFkdRtI0TdcGE7pMXrFtJTcibWpcK2dyJqQB6UCYzdhcVo5EnF2tQRHhWTY+SYQRKtij7rsStV+CEXp3X1AqClrWJlWVCw4/QyTLQaJV/eXmfpPxvkqNBpR3lh6VMQTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715574; c=relaxed/simple;
	bh=HH0xMVj3EJsKqjsPm3HMfe/CViLX7BNnbAp/ApmJEPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwDFU2ty21pkBb+1ii0sTNL9EnkQ8cJh+tcBpAtRueo2l5v6N3lDjzVW/bndMqR3d4uPKE8hPPGDrCk/0G17M3t1P6mm931R0KxG6AFAMmvL1HbKJenT5aPzKQGliUJyc3f9XDEjanfYpfgV+wOxHHD1dnya5VybZqp4UtQNDNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmrC5V+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmrC5V+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17ACC3277B;
	Tue, 18 Jun 2024 12:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715574;
	bh=HH0xMVj3EJsKqjsPm3HMfe/CViLX7BNnbAp/ApmJEPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmrC5V+oFjK0YdCPlmBrOHzqeji1P0jxA+O18MAvrIXtH557bUN6xnX5vfKipgmL9
	 K9PAk0RBV2hp9NCpFSlsptesa905jAGlNvx0YZXD2KSQ/FJR2atRyy181lEOxWdk58
	 8shBg4D+wcMan3zefX6Ibc4YL74W/k3OONfNu074=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/770] SUNRPC: Eliminate the RQ_AUTHERR flag
Date: Tue, 18 Jun 2024 14:33:28 +0200
Message-ID: <20240618123420.972042439@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 9082e1d914f8b27114352b1940bbcc7522f682e7 ]

Now that there is an alternate method for returning an auth_stat
value, replace the RQ_AUTHERR flag with use of that new method.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c         |  3 ++-
 include/linux/sunrpc/svc.h    |  2 --
 include/trace/events/sunrpc.h |  3 +--
 net/sunrpc/svc.c              | 24 ++++--------------------
 4 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index f9dfd4e712a30..0559e8b6a8ec4 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -984,7 +984,8 @@ static __be32 nfs4_callback_compound(struct svc_rqst *rqstp)
 
 out_invalidcred:
 	pr_warn_ratelimited("NFS: NFSv4 callback contains invalid cred\n");
-	return svc_return_autherr(rqstp, rpc_autherr_badcred);
+	rqstp->rq_auth_stat = rpc_autherr_badcred;
+	return rpc_success;
 }
 
 /*
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 7b7bd8a0a6fbd..dd3daadbc0e5c 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -277,7 +277,6 @@ struct svc_rqst {
 #define	RQ_VICTIM	(5)			/* about to be shut down */
 #define	RQ_BUSY		(6)			/* request is busy */
 #define	RQ_DATA		(7)			/* request has data */
-#define RQ_AUTHERR	(8)			/* Request status is auth error */
 	unsigned long		rq_flags;	/* flags field */
 	ktime_t			rq_qtime;	/* enqueue time */
 
@@ -537,7 +536,6 @@ unsigned int	   svc_fill_write_vector(struct svc_rqst *rqstp,
 char		  *svc_fill_symlink_pathname(struct svc_rqst *rqstp,
 					     struct kvec *first, void *p,
 					     size_t total);
-__be32		   svc_return_autherr(struct svc_rqst *rqstp, __be32 auth_err);
 __be32		   svc_generic_init_request(struct svc_rqst *rqstp,
 					    const struct svc_program *progp,
 					    struct svc_process_info *procinfo);
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 0cb9e182a1b1e..fce071f39f51f 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1480,8 +1480,7 @@ DEFINE_SVCXDRBUF_EVENT(sendto);
 	svc_rqst_flag(SPLICE_OK)					\
 	svc_rqst_flag(VICTIM)						\
 	svc_rqst_flag(BUSY)						\
-	svc_rqst_flag(DATA)						\
-	svc_rqst_flag_end(AUTHERR)
+	svc_rqst_flag_end(DATA)
 
 #undef svc_rqst_flag
 #undef svc_rqst_flag_end
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index f036507275338..0d3c3ca2830a8 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1187,22 +1187,6 @@ void svc_printk(struct svc_rqst *rqstp, const char *fmt, ...)
 static __printf(2,3) void svc_printk(struct svc_rqst *rqstp, const char *fmt, ...) {}
 #endif
 
-__be32
-svc_return_autherr(struct svc_rqst *rqstp, __be32 auth_err)
-{
-	set_bit(RQ_AUTHERR, &rqstp->rq_flags);
-	return auth_err;
-}
-EXPORT_SYMBOL_GPL(svc_return_autherr);
-
-static __be32
-svc_get_autherr(struct svc_rqst *rqstp, __be32 *statp)
-{
-	if (test_and_clear_bit(RQ_AUTHERR, &rqstp->rq_flags))
-		return *statp;
-	return rpc_auth_ok;
-}
-
 static int
 svc_generic_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 {
@@ -1226,7 +1210,7 @@ svc_generic_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	    test_bit(RQ_DROPME, &rqstp->rq_flags))
 		return 0;
 
-	if (test_bit(RQ_AUTHERR, &rqstp->rq_flags))
+	if (rqstp->rq_auth_stat != rpc_auth_ok)
 		return 1;
 
 	if (*statp != rpc_success)
@@ -1412,15 +1396,15 @@ svc_process_common(struct svc_rqst *rqstp, struct kvec *argv, struct kvec *resv)
 			goto release_dropit;
 		if (*statp == rpc_garbage_args)
 			goto err_garbage;
-		rqstp->rq_auth_stat = svc_get_autherr(rqstp, statp);
-		if (rqstp->rq_auth_stat != rpc_auth_ok)
-			goto err_release_bad_auth;
 	} else {
 		dprintk("svc: calling dispatcher\n");
 		if (!process.dispatch(rqstp, statp))
 			goto release_dropit; /* Release reply info */
 	}
 
+	if (rqstp->rq_auth_stat != rpc_auth_ok)
+		goto err_release_bad_auth;
+
 	/* Check RPC status result */
 	if (*statp != rpc_success)
 		resv->iov_len = ((void*)statp)  - resv->iov_base + 4;
-- 
2.43.0



