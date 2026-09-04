Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1CD412294;
	Fri,  4 Sep 2026 05:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500650; cv=none; b=XbaOB5fPuXvLjc7g25wJTB1WJeIGkUqCQcapUs+JfImUgpQW7PIv0nQ0NdbBuO8j2NyG/JVGY/rJYESsTg/sY4iTSF4pUXNj4Q/AVun59lVedCClYIKk4r80dyvUKUD+Z9P6xEhq4DxUMk5pHAib9GHoCDN/bDcEixIWmALkRao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500650; c=relaxed/simple;
	bh=hC0ula4blo65GUn8OlFJJRi2VA2LHcMXeIRdrjTDrJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0VbYpwVXf18nXrRT0MfLFsIwo2S7zlazp3sf0UoKFznGjl1oTUxcKoe7O365kdIP5kjyXko8i+Bf8XvpeIRGQQMm4QPrsdoQbxP51MWcTrpdqznr6VBkgyoa73xl3rlafSmhm4ZtnXojvJjp3fa94cWycY9uZWTs83Obu14Qsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPoMI8Oj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPoMI8Oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B42E1F00A3E;
	Fri,  4 Sep 2026 05:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500648;
	bh=kC765BJ+ksfqFg8tTdjtdquUb88sRWHyebAN7VMBLag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPoMI8OjHlbgwRA5krCbwlFCTL85mOAM4vvRgPolQKCEz03iDMdynMNLAPSO6Ft5b
	 zLu1deZWG8M8WnE9tdX0ufu3qOVocdtZ5bMC7c+ItqI0pWIIuYjeAs/s8lOtfQXTFV
	 gim3oZQuapWqMzQs5xcjqRZB4EAcQY7Do4vfIoBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 132/552] nfsd: fix netlink dumpit error handling for rpc_status_get
Date: Fri,  4 Sep 2026 06:54:49 +0200
Message-ID: <20260904045751.339615625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1431,7 +1431,7 @@ static int nfsd_genl_rpc_status_compose_
 	    nla_put_s64(skb, NFSD_A_RPC_STATUS_SERVICE_TIME,
 			ktime_to_us(genl_rqstp->rq_stime),
 			NFSD_A_RPC_STATUS_PAD))
-		return -ENOBUFS;
+		goto out_cancel;
 
 	switch (genl_rqstp->rq_saddr.sa_family) {
 	case AF_INET: {
@@ -1447,7 +1447,7 @@ static int nfsd_genl_rpc_status_compose_
 				 s_in->sin_port) ||
 		    nla_put_be16(skb, NFSD_A_RPC_STATUS_DPORT,
 				 d_in->sin_port))
-			return -ENOBUFS;
+			goto out_cancel;
 		break;
 	}
 	case AF_INET6: {
@@ -1463,7 +1463,7 @@ static int nfsd_genl_rpc_status_compose_
 				 s_in->sin6_port) ||
 		    nla_put_be16(skb, NFSD_A_RPC_STATUS_DPORT,
 				 d_in->sin6_port))
-			return -ENOBUFS;
+			goto out_cancel;
 		break;
 	}
 	}
@@ -1471,10 +1471,14 @@ static int nfsd_genl_rpc_status_compose_
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
@@ -1502,10 +1506,20 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 
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
@@ -1513,7 +1527,7 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 			struct nfsd_genl_rqstp genl_rqstp;
 			unsigned int status_counter;
 
-			if (rqstp_index++ < cb->args[1]) /* already consumed */
+			if (rqstp_index++ < thread_skip) /* already consumed */
 				continue;
 			/*
 			 * Acquire rq_status_counter before parsing the rqst
@@ -1567,8 +1581,14 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 
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
 


