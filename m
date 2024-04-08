Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A154D6FE35;
	Mon,  8 Apr 2024 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584401; cv=none; b=nrjye/Kjy18I0Ymrw3LPW606/uSb6R+fD782Rb/HGJ28OJNCLkVyQyB66qBVeXP34WYGwO6BoIJeMNFWH3l2St2oHg4PS3PaLZhM6dvb2pqAW76pvcMLqLtSru69Qco6tlwklze1D2hpS4khu8W3GLlNbuQs0WT+OQ5HN2MQXfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584401; c=relaxed/simple;
	bh=AlCK3fTTw8XotgRJ7O98dvURdeTcr0t4fDM1gtSKI9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b65XTlO7nR9ZHX5237/VjnF9cMfaL9jtRbPF9MZojhobBej3hfAzO1pklSPkS1ibi52v5grzzNm9nbQkzKNWkvrn7S20WB68kk5z1nipgx5XjlVBOFRHXEX4HZ5Gb5Zq3nbAviuKRw4cYjlkVLZgdvbaEBHmIjNwUdptwISpIBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOLjO7s/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOLjO7s/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B97C433F1;
	Mon,  8 Apr 2024 13:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584401;
	bh=AlCK3fTTw8XotgRJ7O98dvURdeTcr0t4fDM1gtSKI9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOLjO7s/Jj0NzUyeCgVEFpXZm7cntiKL4RBnn0IArZzSBlUIEVJ5ttjHPMSuttFAK
	 9/5CRxc7jlyoDWnD2qWX3hL3SgWi3asrdZikcjPtgykhMQo0H2ZbsTsICVOOxyt5rV
	 jMn+xWkIs6zKqgrX2Vy28cfK5n9tB7D45az2srAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 426/690] NFSD: Replace dprintk() call site in fh_verify()
Date: Mon,  8 Apr 2024 14:54:52 +0200
Message-ID: <20240408125415.030889346@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 948755efc951de75c87d4fa916d9d36b58299295 ]

Record permission errors in the trace log. Note that the new trace
event is conditional, so it will only record non-zero return values
from nfsd_permission().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsfh.c |  8 +-------
 fs/nfsd/trace.h | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index a5b71526cee0f..d73434200df98 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -392,13 +392,7 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type, int access)
 skip_pseudoflavor_check:
 	/* Finally, check access permissions. */
 	error = nfsd_permission(rqstp, exp, dentry, access);
-
-	if (error) {
-		dprintk("fh_verify: %pd2 permission failure, "
-			"acc=%x, error=%d\n",
-			dentry,
-			access, ntohl(error));
-	}
+	trace_nfsd_fh_verify_err(rqstp, fhp, type, access, error);
 out:
 	if (error == nfserr_stale)
 		nfsd_stats_fh_stale_inc(exp);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index c824ab30a758e..297bf9ddc5090 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -195,7 +195,7 @@ TRACE_EVENT(nfsd_fh_verify,
 		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
 		__field(u32, xid)
 		__field(u32, fh_hash)
-		__field(void *, inode)
+		__field(const void *, inode)
 		__field(unsigned long, type)
 		__field(unsigned long, access)
 	),
@@ -211,13 +211,55 @@ TRACE_EVENT(nfsd_fh_verify,
 		__entry->type = type;
 		__entry->access = access;
 	),
-	TP_printk("xid=0x%08x fh_hash=0x%08x inode=%p type=%s access=%s",
-		__entry->xid, __entry->fh_hash, __entry->inode,
+	TP_printk("xid=0x%08x fh_hash=0x%08x type=%s access=%s",
+		__entry->xid, __entry->fh_hash,
 		show_fs_file_type(__entry->type),
 		show_nfsd_may_flags(__entry->access)
 	)
 );
 
+TRACE_EVENT_CONDITION(nfsd_fh_verify_err,
+	TP_PROTO(
+		const struct svc_rqst *rqstp,
+		const struct svc_fh *fhp,
+		umode_t type,
+		int access,
+		__be32 error
+	),
+	TP_ARGS(rqstp, fhp, type, access, error),
+	TP_CONDITION(error),
+	TP_STRUCT__entry(
+		__field(unsigned int, netns_ino)
+		__sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
+		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
+		__field(u32, xid)
+		__field(u32, fh_hash)
+		__field(const void *, inode)
+		__field(unsigned long, type)
+		__field(unsigned long, access)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->netns_ino = SVC_NET(rqstp)->ns.inum;
+		__assign_sockaddr(server, &rqstp->rq_xprt->xpt_local,
+		       rqstp->rq_xprt->xpt_locallen);
+		__assign_sockaddr(client, &rqstp->rq_xprt->xpt_remote,
+				  rqstp->rq_xprt->xpt_remotelen);
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+		__entry->fh_hash = knfsd_fh_hash(&fhp->fh_handle);
+		__entry->inode = d_inode(fhp->fh_dentry);
+		__entry->type = type;
+		__entry->access = access;
+		__entry->error = be32_to_cpu(error);
+	),
+	TP_printk("xid=0x%08x fh_hash=0x%08x type=%s access=%s error=%d",
+		__entry->xid, __entry->fh_hash,
+		show_fs_file_type(__entry->type),
+		show_nfsd_may_flags(__entry->access),
+		__entry->error
+	)
+);
+
 DECLARE_EVENT_CLASS(nfsd_fh_err_class,
 	TP_PROTO(struct svc_rqst *rqstp,
 		 struct svc_fh	*fhp,
-- 
2.43.0



