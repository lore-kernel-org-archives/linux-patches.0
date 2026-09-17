Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB6D547043;
	Thu, 17 Sep 2026 18:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671597; cv=none; b=K2qnjANbN2q3Gvkpdfe4VdLcA/qkZ3zE/PCozpuFG2ui/HAp4XYWo3C16L7GfwVx+MZdoQWDReqdeg1lEEoeRLhJSYw3m0WXjW0eUSInC2HDzj9UhfPLc2nN7t5bKkZNJ91sITjTWYhlVQrqZB4yPbMb+asYPB7m/IZFdoAKF+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671597; c=relaxed/simple;
	bh=v/XN1mTG7Y+QNYx+2wRByNmYOSI4Fn6Cv/5FqgGR22M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XRbJlubg2M24G6Bfhk3yhIPFvWF3FEWywwv5C7pJBzX20bj13I6vU0//KBrC7gqpgFbNZ7GR5Fxapym9Eey2x264g4HG8m1/PGZjTeMi4+m5KhJNII+/KGGDO6zllU5RL3UZUH51ClIASdKrbX/t3lCG04urdKWneFMpI1JiHPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQUFIy4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQUFIy4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B881F000FF;
	Thu, 17 Sep 2026 18:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671595;
	bh=lAQCPw8brh+y6EXktO4TISN9voywLjbCXHxTjcjolXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQUFIy4JPPeOMvicpGBgeOEKSvMG/W4fXop1BMVmLyPinpaHYrYlhAmbrNyCh132G
	 M1G+pGXbesGRI39y5TGstXxxK9Mj/zOoagqVcjeqMPph2LyuHwdJVCeNeXnnh/C16i
	 rfouvR1TZS6HizW6FK+bJ3JXfdRcd5heqU0E5ZKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1028/1102] nfsd: fix netlink dumpit error handling for rpc_status_get
Date: Thu, 17 Sep 2026 16:16:11 +0100
Message-ID: <20260917151606.580049858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit e13d505af73a1e013aa81806652d4378b21cfca2 ]

nfsd_genl_rpc_status_compose_msg() returns -ENOBUFS on nla_put failure
without calling genlmsg_cancel(), leaving a partial message in the skb.
The caller then propagates -ENOBUFS directly, which the netlink dump
infrastructure treats as a fatal error, aborting the entire dump.

The correct netlink dump convention is:
 - Cancel any partial message with genlmsg_cancel()
 - If prior messages were added to the skb (skb->len > 0), save the
   current iterator position and return skb->len to paginate
 - Only return a negative errno when no messages fit at all

Fix compose_msg to cancel the partial message on all nla_put failure
paths, and fix the caller to paginate when possible rather than
returning a fatal error.

A second defect surfaces once pagination actually works: cb->args[1]
records the resume index within the pool named by cb->args[0], but the
inner loop applied it to every pool from cb->args[0] onward. After a
mid-pool pause, a later dump call drains the resume pool and continues
into subsequent pools within the same call, where the stale cb->args[1]
caused the first N threads of each following pool to be skipped. On
per-CPU or per-node pool configurations this silently dropped active
requests from the dump. Apply the saved thread index only to the pool
matching cb->args[0], and start every subsequent pool from thread 0.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: fold in 20/21 to avoid bisect hazard ]
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-3-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ preserved the 6.12-specific rq_saddr.sa_family access instead of upstream’s ss_family ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1527,7 +1527,7 @@ static int nfsd_genl_rpc_status_compose_
 	    nla_put_s64(skb, NFSD_A_RPC_STATUS_SERVICE_TIME,
 			ktime_to_us(genl_rqstp->rq_stime),
 			NFSD_A_RPC_STATUS_PAD))
-		return -ENOBUFS;
+		goto out_cancel;
 
 	switch (genl_rqstp->rq_saddr.ss_family) {
 	case AF_INET: {
@@ -1543,7 +1543,7 @@ static int nfsd_genl_rpc_status_compose_
 				 s_in->sin_port) ||
 		    nla_put_be16(skb, NFSD_A_RPC_STATUS_DPORT,
 				 d_in->sin_port))
-			return -ENOBUFS;
+			goto out_cancel;
 		break;
 	}
 	case AF_INET6: {
@@ -1559,7 +1559,7 @@ static int nfsd_genl_rpc_status_compose_
 				 s_in->sin6_port) ||
 		    nla_put_be16(skb, NFSD_A_RPC_STATUS_DPORT,
 				 d_in->sin6_port))
-			return -ENOBUFS;
+			goto out_cancel;
 		break;
 	}
 	}
@@ -1567,10 +1567,14 @@ static int nfsd_genl_rpc_status_compose_
 	for (i = 0; i < genl_rqstp->rq_opcnt; i++)
 		if (nla_put_u32(skb, NFSD_A_RPC_STATUS_COMPOUND_OPS,
 				genl_rqstp->rq_opnum[i]))
-			return -ENOBUFS;
+			goto out_cancel;
 
 	genlmsg_end(skb, hdr);
 	return 0;
+
+out_cancel:
+	genlmsg_cancel(skb, hdr);
+	return -ENOBUFS;
 }
 
 /**
@@ -1598,10 +1602,20 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 
 	for (i = 0; i < nn->nfsd_serv->sv_nrpools; i++) {
 		struct svc_rqst *rqstp;
+		long thread_skip = 0;
 
 		if (i < cb->args[0]) /* already consumed */
 			continue;
 
+		/*
+		 * The saved thread index only applies to the pool the dump
+		 * was resumed in. Subsequent pools must start from thread 0,
+		 * otherwise their first cb->args[1] threads are silently
+		 * skipped.
+		 */
+		if (i == cb->args[0])
+			thread_skip = cb->args[1];
+
 		rqstp_index = 0;
 		list_for_each_entry_rcu(rqstp,
 				&nn->nfsd_serv->sv_pools[i].sp_all_threads,
@@ -1609,7 +1623,7 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 			struct nfsd_genl_rqstp genl_rqstp = {};
 			unsigned int status_counter;
 
-			if (rqstp_index++ < cb->args[1]) /* already consumed */
+			if (rqstp_index++ < thread_skip) /* already consumed */
 				continue;
 			/*
 			 * Acquire rq_status_counter before parsing the rqst
@@ -1663,8 +1677,14 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 
 			ret = nfsd_genl_rpc_status_compose_msg(skb, cb,
 							       &genl_rqstp);
-			if (ret)
+			if (ret) {
+				if (skb->len) {
+					cb->args[0] = i;
+					cb->args[1] = rqstp_index - 1;
+					ret = skb->len;
+				}
 				goto out;
+			}
 		}
 	}
 


