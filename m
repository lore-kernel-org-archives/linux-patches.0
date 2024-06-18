Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510E815B99B;
	Tue, 18 Jun 2024 12:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715322; cv=none; b=WI7gKV5/qxDMWxOXHg5so7S3uzmr3M/463Au9WMgbSIxhs/ezaRox1CDbjfNkZl9E2KQ1i/KyPlHUBpN60sbbvmEtZrxk/sqLmwK1alKwcPEpRoIxnAUXlAFdsYC2Lqp1H96TMcrTYtjeIX4EYvRCYwKivADhsEw4XiSu9wl3hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715322; c=relaxed/simple;
	bh=ldSXVDkmjj49vfhcClZmrGIXfT+LUGFUWIG7nEUK+NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upETE8Q5hP5e0UxM3PDWu80PmBndsFQgYUCD0WmuCtO84L1OgPLxrV68/bITt14cMqNjvkndEyNSZ0JzFwA1oH7wXszCl8qng3w6kNK/vf85/VYGsKrGkqHpRdbMu+jELKmFjLCnt/i8SjGLiV8UhGv+IcHh4yAb1qftd/jvyzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKOfNSwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKOfNSwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C255EC3277B;
	Tue, 18 Jun 2024 12:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715322;
	bh=ldSXVDkmjj49vfhcClZmrGIXfT+LUGFUWIG7nEUK+NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKOfNSwP3PJF/aVgYu7M7+ncvJpIP8aXrrXYR0Rq9QIoJcpeOV7WCxtfuLLec+Xdm
	 VEyQq4edpqC3CBL5gf8gSdVR52LBdfEYRWf0bG6Dpv2MFiLgLKN4Xo7r4RAM5ejMFU
	 s5nQDcZw8xkus7zTb0M/DH/oK97Rl/nwbpBOKWgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/770] NFSD: Add nfsd_clid_cred_mismatch tracepoint
Date: Tue, 18 Jun 2024 14:32:02 +0200
Message-ID: <20240618123417.655742832@linuxfoundation.org>
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

[ Upstream commit 27787733ef44332fce749aa853f2749d141982b0 ]

Record when a client tries to establish a lease record but uses an
unexpected credential. This is often a sign of a configuration
problem.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 14 ++++++++++----
 fs/nfsd/trace.h     | 28 ++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index ea68dc157ada1..2e18b1ad889d7 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3203,6 +3203,7 @@ nfsd4_exchange_id(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		if (!creds_match) { /* case 3 */
 			if (client_has_state(conf)) {
 				status = nfserr_clid_inuse;
+				trace_nfsd_clid_cred_mismatch(conf, rqstp);
 				goto out;
 			}
 			goto out_new;
@@ -3447,9 +3448,10 @@ nfsd4_create_session(struct svc_rqst *rqstp,
 			goto out_free_conn;
 		}
 	} else if (unconf) {
+		status = nfserr_clid_inuse;
 		if (!same_creds(&unconf->cl_cred, &rqstp->rq_cred) ||
 		    !rpc_cmp_addr(sa, (struct sockaddr *) &unconf->cl_addr)) {
-			status = nfserr_clid_inuse;
+			trace_nfsd_clid_cred_mismatch(unconf, rqstp);
 			goto out_free_conn;
 		}
 		status = nfserr_wrong_cred;
@@ -4008,7 +4010,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		if (clp_used_exchangeid(conf))
 			goto out;
 		if (!same_creds(&conf->cl_cred, &rqstp->rq_cred)) {
-			trace_nfsd_clid_inuse_err(conf);
+			trace_nfsd_clid_cred_mismatch(conf, rqstp);
 			goto out;
 		}
 	}
@@ -4066,10 +4068,14 @@ nfsd4_setclientid_confirm(struct svc_rqst *rqstp,
 	 * Nevertheless, RFC 7530 recommends INUSE for this case:
 	 */
 	status = nfserr_clid_inuse;
-	if (unconf && !same_creds(&unconf->cl_cred, &rqstp->rq_cred))
+	if (unconf && !same_creds(&unconf->cl_cred, &rqstp->rq_cred)) {
+		trace_nfsd_clid_cred_mismatch(unconf, rqstp);
 		goto out;
-	if (conf && !same_creds(&conf->cl_cred, &rqstp->rq_cred))
+	}
+	if (conf && !same_creds(&conf->cl_cred, &rqstp->rq_cred)) {
+		trace_nfsd_clid_cred_mismatch(conf, rqstp);
 		goto out;
+	}
 	/* cases below refer to rfc 3530 section 14.2.34: */
 	if (!unconf || !same_verf(&confirm, &unconf->cl_confirm)) {
 		if (conf && same_verf(&confirm, &conf->cl_confirm)) {
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 3ec6d38fa5318..bec85fc8be01a 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -536,6 +536,34 @@ DEFINE_EVENT(nfsd_net_class, nfsd_##name, \
 DEFINE_NET_EVENT(grace_start);
 DEFINE_NET_EVENT(grace_complete);
 
+TRACE_EVENT(nfsd_clid_cred_mismatch,
+	TP_PROTO(
+		const struct nfs4_client *clp,
+		const struct svc_rqst *rqstp
+	),
+	TP_ARGS(clp, rqstp),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(unsigned long, cl_flavor)
+		__field(unsigned long, new_flavor)
+		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+	),
+	TP_fast_assign(
+		__entry->cl_boot = clp->cl_clientid.cl_boot;
+		__entry->cl_id = clp->cl_clientid.cl_id;
+		__entry->cl_flavor = clp->cl_cred.cr_flavor;
+		__entry->new_flavor = rqstp->rq_cred.cr_flavor;
+		memcpy(__entry->addr, &rqstp->rq_xprt->xpt_remote,
+			sizeof(struct sockaddr_in6));
+	),
+	TP_printk("client %08x:%08x flavor=%s, conflict=%s from addr=%pISpc",
+		__entry->cl_boot, __entry->cl_id,
+		show_nfsd_authflavor(__entry->cl_flavor),
+		show_nfsd_authflavor(__entry->new_flavor), __entry->addr
+	)
+)
+
 TRACE_EVENT(nfsd_clid_inuse_err,
 	TP_PROTO(const struct nfs4_client *clp),
 	TP_ARGS(clp),
-- 
2.43.0



