Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303123EC684;
	Fri,  4 Sep 2026 05:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498774; cv=none; b=VvFEkVzH9AUEr8Rny8BFxSK2wjHSGxVhnqRKFC+eQW1hPEeiH+qDMJU0gdTYxAosc90ws1xYpNZSFaQ4PMYulX2rRr9RElvxtFaIJZf2Z7mHVp63rCL9S8l1PwbfO3Ah9WMvr/MA7Rzw2UK2nL2J7J5QSxVwsPS1in+kEI8yNhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498774; c=relaxed/simple;
	bh=P0Ybt8JyG/GuLLixPIe/rFcm1t/mwb1Re6sj/En5MWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t59u6sWnW4Sxk6NWnMVIgIditWubLxjflXVaO6vZlpY65ZKqef+dXb4NkS1X3pZ7Amq/e9dQsFbku0VkgcUT7zzs85s9ptqMaIJrw891R0H1yX7JM+H6qybWGEr3uHrLmeLc6yAjGdpwD4Gc43dVnCXAK7kxZ62MKCAILslf/vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWsff2gM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWsff2gM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AF51F00A3D;
	Fri,  4 Sep 2026 05:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498773;
	bh=wxwJAmBzmRjwtLWShmjBOJklmEskoC7Cg0jQtC7SDVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWsff2gM05gcYgUFI5AXjK6uZ2pklTi5/WZq1lBYAhzmy/a9VIcIuiHizxntmqudr
	 XLn0GwQD8KO0qLyMj+vVJe4TiEHK5GbEIiWGqWgqiqiTM3a+akY5Ox3T9AiMh/EfxG
	 RFic9duCkuJ95Ohxy2YO91sbuXTd5tDmfRpm/YAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 183/713] nfsd: fix netlink dumpit error handling for rpc_status_get
Date: Fri,  4 Sep 2026 06:52:31 +0200
Message-ID: <20260904045807.919524694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit e13d505af73a1e013aa81806652d4378b21cfca2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1452,7 +1452,7 @@ static int nfsd_genl_rpc_status_compose_
 	    nla_put_s64(skb, NFSD_A_RPC_STATUS_SERVICE_TIME,
 			ktime_to_us(genl_rqstp->rq_stime),
 			NFSD_A_RPC_STATUS_PAD))
-		return -ENOBUFS;
+		goto out_cancel;
 
 	switch (genl_rqstp->rq_saddr.ss_family) {
 	case AF_INET: {
@@ -1468,7 +1468,7 @@ static int nfsd_genl_rpc_status_compose_
 				 s_in->sin_port) ||
 		    nla_put_be16(skb, NFSD_A_RPC_STATUS_DPORT,
 				 d_in->sin_port))
-			return -ENOBUFS;
+			goto out_cancel;
 		break;
 	}
 	case AF_INET6: {
@@ -1484,7 +1484,7 @@ static int nfsd_genl_rpc_status_compose_
 				 s_in->sin6_port) ||
 		    nla_put_be16(skb, NFSD_A_RPC_STATUS_DPORT,
 				 d_in->sin6_port))
-			return -ENOBUFS;
+			goto out_cancel;
 		break;
 	}
 	}
@@ -1492,10 +1492,14 @@ static int nfsd_genl_rpc_status_compose_
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
@@ -1523,10 +1527,20 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 
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
@@ -1534,7 +1548,7 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 			struct nfsd_genl_rqstp genl_rqstp = {};
 			unsigned int status_counter;
 
-			if (rqstp_index++ < cb->args[1]) /* already consumed */
+			if (rqstp_index++ < thread_skip) /* already consumed */
 				continue;
 			/*
 			 * Acquire rq_status_counter before parsing the rqst
@@ -1588,8 +1602,14 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 
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
 


