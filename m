Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693068249F;
	Tue, 18 Jun 2024 12:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714714; cv=none; b=epXQVsq4tuK0BXdKChCcB5RyJVH1m4SbvVBkOIXnHqyIZ04rB033l5ighZ2/1D/GWicfajW9XYEOM1k1lJx8EEz+NphsYClkjnB5/uPAIyT+dCC/R0UDV9OC1WdQ5PBrVeZh/kpk6ZN+YQStfpovQWlDymaMOLVcxEo6BlojuOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714714; c=relaxed/simple;
	bh=jqATcKQsC0v2yaBsUzDsAu5QeKo9LptPLtgJhiykQ5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnunAC8KCKlY0TJs65Z8ayCOaHxmjYp3NtycKSdqURxBqrOxdCrTZW9PlEf6ov6Jz7FCrhVwb4fE9dWSR5m8sXHcuLtDjzhbBDSQPDIWHt2j0274xcWcX7tgml6ntxOZYkDbQoWb5NjKj95Jv+3ZJrg1nP097Ky5c8jmUwZ4Uf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMAl7MTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMAl7MTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9350FC3277B;
	Tue, 18 Jun 2024 12:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714714;
	bh=jqATcKQsC0v2yaBsUzDsAu5QeKo9LptPLtgJhiykQ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMAl7MTgDH0troHrCb7boQRr4qWoyy9+NaxjzjpkJFtvP2hm+pwaqLtrM0eKn+Z0D
	 rJ7Ka+tMhybrHKfvcbbWtsq6QMwjWbTF8uLTDPrF9FFO2ZJCkPJ+uwaZFUpwEYkDc3
	 8B+P09V36ayumyJbWbZJ8s0EylA46gJzLwhHhFkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/770] NFSD: Replace READ* macros in nfsd4_decode_bind_conn_to_session()
Date: Tue, 18 Jun 2024 14:28:36 +0200
Message-ID: <20240618123409.716742100@linuxfoundation.org>
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

[ Upstream commit 571e0451c4de0a545960ffaea16d969931afc563 ]

A dedicated sessionid4 decoder is introduced that will be used by
other operation decoders in subsequent patches.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index efd1504cd02b6..5dad32ab02ec4 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -664,6 +664,19 @@ nfsd4_decode_state_owner4(struct nfsd4_compoundargs *argp,
 	return nfsd4_decode_opaque(argp, owner);
 }
 
+static __be32
+nfsd4_decode_sessionid4(struct nfsd4_compoundargs *argp,
+			struct nfs4_sessionid *sessionid)
+{
+	__be32 *p;
+
+	p = xdr_inline_decode(argp->xdr, NFS4_MAX_SESSIONID_LEN);
+	if (!p)
+		return nfserr_bad_xdr;
+	memcpy(sessionid->data, p, sizeof(sessionid->data));
+	return nfs_ok;
+}
+
 /* Defined in Appendix A of RFC 5531 */
 static __be32
 nfsd4_decode_authsys_parms(struct nfsd4_compoundargs *argp,
@@ -788,18 +801,6 @@ nfsd4_decode_access(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
-static __be32 nfsd4_decode_bind_conn_to_session(struct nfsd4_compoundargs *argp, struct nfsd4_bind_conn_to_session *bcts)
-{
-	DECODE_HEAD;
-
-	READ_BUF(NFS4_MAX_SESSIONID_LEN + 8);
-	COPYMEM(bcts->sessionid.data, NFS4_MAX_SESSIONID_LEN);
-	bcts->dir = be32_to_cpup(p++);
-	/* XXX: skipping ctsa_use_conn_in_rdma_mode.  Perhaps Tom Tucker
-	 * could help us figure out we should be using it. */
-	DECODE_TAIL;
-}
-
 static __be32
 nfsd4_decode_close(struct nfsd4_compoundargs *argp, struct nfsd4_close *close)
 {
@@ -1479,6 +1480,22 @@ static __be32 nfsd4_decode_backchannel_ctl(struct nfsd4_compoundargs *argp, stru
 	return nfsd4_decode_cb_sec(argp, &bc->bc_cb_sec);
 }
 
+static __be32 nfsd4_decode_bind_conn_to_session(struct nfsd4_compoundargs *argp, struct nfsd4_bind_conn_to_session *bcts)
+{
+	u32 use_conn_in_rdma_mode;
+	__be32 status;
+
+	status = nfsd4_decode_sessionid4(argp, &bcts->sessionid);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &bcts->dir) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &use_conn_in_rdma_mode) < 0)
+		return nfserr_bad_xdr;
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 			 struct nfsd4_exchange_id *exid)
-- 
2.43.0



