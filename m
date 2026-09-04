Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D0B3D9521;
	Fri,  4 Sep 2026 05:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498712; cv=none; b=JZiw37pUZfcr/9MJ+1m7k5eQeCEcDagd26WlhbdWndp8MKn3hYY9Z4hJ3AWB5p5eY5pDzR9NydtS9L6qRtKySNoCRhMbAVCb1EbzqI/xkfqde2Oo0G8/DflR0TYKevOO9UQCKFd5+qPlXSoGNjSInjXOo/iBs+HJtYeVU58APWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498712; c=relaxed/simple;
	bh=oT74xNCvs7531Sv1KSyO0QvtYm1XRfLf/4G5eYJR3tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAlQulLihHdhzphOtv+mrGa0AFFvi7k/jrPT0R6YdI2IN5UvBUjNn0KuuP4no1JxLe4y8jQV0ABEcAXbFCj0SJ15FFnNHzG5cjX2XKB9u41UywZiDO3x4jCytmAM2mPN3bGRnvbdiflUPN2FaUlM21BW6GxL+mee1IKN8xXU3jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFafGuEo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFafGuEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14C81F00A3E;
	Fri,  4 Sep 2026 05:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498711;
	bh=O6enONspFY9QJCoR554iBuXoMj1QIMO9SAMuh2jtYHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFafGuEovuKSgZNhgwRpsqztL1NEGbjrNNeJvYc5whMBNwobsaLqYhZYwiioOJ9s3
	 mrSJcyeAUgJy4vTUeJDj0y87D/ZhFboFj3BEQT9277k5O22FevxQn5iCxyh3zfGsmS
	 jjsJ/PCnYBJyfy995dyFmLHA1VEeXfeX91zrkP8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 159/713] nfsd: widen nfsd_genl_rqstp address fields to sockaddr_storage
Date: Fri,  4 Sep 2026 06:52:07 +0200
Message-ID: <20260904045807.389340259@linuxfoundation.org>
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

commit a99d720ed2a5258564e5e9d5f39f3184a030d354 upstream.

struct nfsd_genl_rqstp declares rq_daddr and rq_saddr as plain
"struct sockaddr" (16 bytes). When an IPv6 NFS client is connected,
nfsd_genl_rpc_status_compose_msg() casts these fields to
"struct sockaddr_in6 *" (28 bytes) and reads sin6_addr at offset 8..24,
which extends 8 bytes past the end of the 16-byte sockaddr field into
the adjacent rq_flags member. The 16-byte nla_put_in6_addr then ships 8
bytes of truncated IPv6 address followed by 8 bytes of rq_flags to
userspace via the NFSD_A_RPC_STATUS_SADDR6/DADDR6 netlink attributes.

This is reachable by any unprivileged process in the network namespace
because NFSD_CMD_RPC_STATUS_GET uses GENL_CMD_CAP_DUMP without
GENL_ADMIN_PERM.

Fix by widening rq_daddr and rq_saddr to struct sockaddr_storage so the
IPv6 casts operate within bounds, copying sizeof(struct sockaddr_storage)
bytes in the memcpy calls so the full address is captured, and
zero-initializing the genl_rqstp stack variable to prevent leaking
uninitialized tail bytes through netlink.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260602-nfsd-testing-v2-5-e4ea62e3cd5c@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1418,8 +1418,8 @@ static int create_proc_exports_entry(voi
 unsigned int nfsd_net_id;
 
 struct nfsd_genl_rqstp {
-	struct sockaddr		rq_daddr;
-	struct sockaddr		rq_saddr;
+	struct sockaddr_storage	rq_daddr;
+	struct sockaddr_storage	rq_saddr;
 	unsigned long		rq_flags;
 	ktime_t			rq_stime;
 	__be32			rq_xid;
@@ -1454,7 +1454,7 @@ static int nfsd_genl_rpc_status_compose_
 			NFSD_A_RPC_STATUS_PAD))
 		return -ENOBUFS;
 
-	switch (genl_rqstp->rq_saddr.sa_family) {
+	switch (genl_rqstp->rq_saddr.ss_family) {
 	case AF_INET: {
 		const struct sockaddr_in *s_in, *d_in;
 
@@ -1531,7 +1531,7 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 		list_for_each_entry_rcu(rqstp,
 				&nn->nfsd_serv->sv_pools[i].sp_all_threads,
 				rq_all) {
-			struct nfsd_genl_rqstp genl_rqstp;
+			struct nfsd_genl_rqstp genl_rqstp = {};
 			unsigned int status_counter;
 
 			if (rqstp_index++ < cb->args[1]) /* already consumed */
@@ -1555,9 +1555,9 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 			genl_rqstp.rq_stime = rqstp->rq_stime;
 			genl_rqstp.rq_opcnt = 0;
 			memcpy(&genl_rqstp.rq_daddr, svc_daddr(rqstp),
-			       sizeof(struct sockaddr));
+			       sizeof(struct sockaddr_storage));
 			memcpy(&genl_rqstp.rq_saddr, svc_addr(rqstp),
-			       sizeof(struct sockaddr));
+			       sizeof(struct sockaddr_storage));
 
 #ifdef CONFIG_NFSD_V4
 			if (rqstp->rq_vers == NFS4_VERSION &&


