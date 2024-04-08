Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE070524AF;
	Mon,  8 Apr 2024 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584389; cv=none; b=mJFx+6BD1vxAFB+u+UQ079GmNzLrp+nsJ8artUIcwvdL98A8DJWIQO7Rgt0GBcwuF4aKGiDDlXA8jUmJk5Cl3fGiEZjm/wvKgY1juWrUzFxfVNEkdVT+GLA3OA70NMz/gea6eMnfLqY41liDqneDyBiWbH5c4u2aVxsuVlJo5sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584389; c=relaxed/simple;
	bh=W3B9KNZ1H0D45coES5yApFeHoOw/ZZtMaqFGZmBJvCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8T7zhjYFkwt49LP0NgBaBWWb/jkD82KeL/pZ5QBy7C7vABok6ZiCjdJIx/9WG8rIWqMNktZFkBWQ+2UyOBFOrW34fOV3urgkHXI5TjgNws6px1QqqHf/JjFXWCXccSw6l/+WgfQ0us9AheNObTx0Eplz+YiRR52IW7+Ai7/nTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aShFpwir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aShFpwir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42103C433F1;
	Mon,  8 Apr 2024 13:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584389;
	bh=W3B9KNZ1H0D45coES5yApFeHoOw/ZZtMaqFGZmBJvCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aShFpwirNiOj5LmgToZzdP56Yj/FAbYa8sAhkkD5MJNKk9Y5SscD/DUiiFAg5rrRu
	 yzh0u7dl+UPj6lU1e8wlU6AP/qZu/8Rd+5UvAam2RVi1VR6kmtRb8YldAy+28M4VKV
	 hq01UxL8CaRTZKKT638RHAe0AP+9nrFIDbirdvFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 390/690] NFSD: Shrink size of struct nfsd4_copy_notify
Date: Mon,  8 Apr 2024 14:54:16 +0200
Message-ID: <20240408125413.669754388@linuxfoundation.org>
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

[ Upstream commit 09426ef2a64ee189ca1e3298f1e874842dbf35ea ]

struct nfsd4_copy_notify is part of struct nfsd4_op, which resides
in an 8-element array.

sizeof(struct nfsd4_op):
Before: /* size: 2208, cachelines: 35, members: 5 */
After:  /* size: 1696, cachelines: 27, members: 5 */

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c |  4 ++--
 fs/nfsd/nfs4xdr.c  | 12 ++++++++++--
 fs/nfsd/xdr4.h     |  4 ++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 5dce18fe99085..80ec51a89d5b5 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1947,9 +1947,9 @@ nfsd4_copy_notify(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	/* For now, only return one server address in cpn_src, the
 	 * address used by the client to connect to this server.
 	 */
-	cn->cpn_src.nl4_type = NL4_NETADDR;
+	cn->cpn_src->nl4_type = NL4_NETADDR;
 	status = nfsd4_set_netaddr((struct sockaddr *)&rqstp->rq_daddr,
-				 &cn->cpn_src.u.nl4_addr);
+				 &cn->cpn_src->u.nl4_addr);
 	WARN_ON_ONCE(status);
 	if (status) {
 		nfs4_put_cpntf_state(nn, cps);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index fb891249694c3..515edc1b662e1 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1952,10 +1952,17 @@ nfsd4_decode_copy_notify(struct nfsd4_compoundargs *argp,
 {
 	__be32 status;
 
+	cn->cpn_src = svcxdr_tmpalloc(argp, sizeof(*cn->cpn_src));
+	if (cn->cpn_src == NULL)
+		return nfserr_jukebox;
+	cn->cpn_dst = svcxdr_tmpalloc(argp, sizeof(*cn->cpn_dst));
+	if (cn->cpn_dst == NULL)
+		return nfserr_jukebox;
+
 	status = nfsd4_decode_stateid4(argp, &cn->cpn_src_stateid);
 	if (status)
 		return status;
-	return nfsd4_decode_nl4_server(argp, &cn->cpn_dst);
+	return nfsd4_decode_nl4_server(argp, cn->cpn_dst);
 }
 
 static __be32
@@ -4903,7 +4910,8 @@ nfsd4_encode_copy_notify(struct nfsd4_compoundres *resp, __be32 nfserr,
 
 	*p++ = cpu_to_be32(1);
 
-	return nfsd42_encode_nl4_server(resp, &cn->cpn_src);
+	nfserr = nfsd42_encode_nl4_server(resp, cn->cpn_src);
+	return nfserr;
 }
 
 static __be32
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 0737f81c1004e..6673c2980c77e 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -595,13 +595,13 @@ struct nfsd4_offload_status {
 struct nfsd4_copy_notify {
 	/* request */
 	stateid_t		cpn_src_stateid;
-	struct nl4_server	cpn_dst;
+	struct nl4_server	*cpn_dst;
 
 	/* response */
 	stateid_t		cpn_cnr_stateid;
 	u64			cpn_sec;
 	u32			cpn_nsec;
-	struct nl4_server	cpn_src;
+	struct nl4_server	*cpn_src;
 };
 
 struct nfsd4_op {
-- 
2.43.0



