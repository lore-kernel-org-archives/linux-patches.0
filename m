Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD6B3ED3B8;
	Wed, 20 May 2026 16:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296122; cv=none; b=b4YfQuuJnq0tQ598LxxBNC1Ss9Tid45k67AshHbZsnaXC7+HpJhTVQPU/uD+NBUhZkrV0CVTCus3RqKkUim57gurkZlFOge65I6u8AYMHSi72wz9vI0e53mUoAgb394YqgYkEv5ksllHW67kVLA8ry/3A8ML8iK+mYIEG3hUUkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296122; c=relaxed/simple;
	bh=wyr/a1lZoNfIz6EyojVVpEIf2ywylrD25JHEYynes6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBantQxMKaBiTxEexaSvBiWbQaqdFs4phQOZLbmQMQZd/2H8bcbDe56sWZ/Xp0V8OfBtW9u1PUEVUSVWlGMXSAXe3uGisjmyzAXMa407eNLqNb0X4bM9xItm4ZPoTXY66dhUGC0e1GkEsqrxJOTM+osj18iQtobuvsKVbEmQ3c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfOSjOmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfOSjOmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700B81F00893;
	Wed, 20 May 2026 16:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296120;
	bh=jZXOY5GcslNwHsOR/HpqM0rPnlosgTex/BsiazOUZSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfOSjOmKi/mVoTmpyvEpf/9dI85fBv1Df+CXfdxUDehcIwOPX07EQzOm2oTOjNSMq
	 TtxGM0CJtnvPtifs+fn8gQ/vwUo6PgPmrugyPWyT7hq8IyUJyknhJ4sK09kc3j2gLP
	 POE59EQV2Xb6qLAaa7ORLR3eIBuNVkOAJLi02RHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0678/1146] nfsd: use dynamic allocation for oversized NFSv4.0 replay cache
Date: Wed, 20 May 2026 18:15:28 +0200
Message-ID: <20260520162203.531077622@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 116b6b7acdd82605ed530232cd7509d1b5282f5c ]

Commit 1e8e9913672a ("nfsd: fix heap overflow in NFSv4.0 LOCK
replay cache") capped the replay cache copy at NFSD4_REPLAY_ISIZE
to prevent a heap overflow, but set rp_buflen to zero when the
encoded response exceeded the inline buffer. A retransmitted LOCK
reaching the replay path then produced only a status code with no
operation body, resulting in a malformed XDR response.

When the encoded response exceeds the 112-byte inline rp_ibuf, a
buffer is kmalloc'd to hold it. If the allocation fails, rp_buflen
remains zero, preserving the behavior from the capped-copy fix.
The buffer is freed when the stateowner is released or when a
subsequent operation's response fits in the inline buffer.

Fixes: 1e8e9913672a ("nfsd: fix heap overflow in NFSv4.0 LOCK replay cache")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 16 ++++++++++++++++
 fs/nfsd/nfs4xdr.c   | 23 ++++++++++++++++-------
 fs/nfsd/state.h     | 12 +++++++-----
 3 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 1f49637dfc96f..f932a165f5b9b 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1495,8 +1495,24 @@ release_all_access(struct nfs4_ol_stateid *stp)
 	}
 }
 
+/**
+ * nfs4_replay_free_cache - release dynamically allocated replay buffer
+ * @rp: replay cache to reset
+ *
+ * If @rp->rp_buf points to a kmalloc'd buffer, free it and reset
+ * rp_buf to the inline rp_ibuf. Always zeroes rp_buflen.
+ */
+void nfs4_replay_free_cache(struct nfs4_replay *rp)
+{
+	if (rp->rp_buf != rp->rp_ibuf)
+		kfree(rp->rp_buf);
+	rp->rp_buf = rp->rp_ibuf;
+	rp->rp_buflen = 0;
+}
+
 static inline void nfs4_free_stateowner(struct nfs4_stateowner *sop)
 {
+	nfs4_replay_free_cache(&sop->so_replay);
 	kfree(sop->so_owner.data);
 	sop->so_ops->so_free(sop);
 }
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9d234913100b9..ef663331063b1 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -6281,14 +6281,23 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 		int len = xdr->buf->len - (op_status_offset + XDR_UNIT);
 
 		so->so_replay.rp_status = op->status;
-		if (len <= NFSD4_REPLAY_ISIZE) {
-			so->so_replay.rp_buflen = len;
-			read_bytes_from_xdr_buf(xdr->buf,
-						op_status_offset + XDR_UNIT,
-						so->so_replay.rp_buf, len);
-		} else {
-			so->so_replay.rp_buflen = 0;
+		if (len > NFSD4_REPLAY_ISIZE) {
+			char *buf = kmalloc(len, GFP_KERNEL);
+
+			nfs4_replay_free_cache(&so->so_replay);
+			if (buf) {
+				so->so_replay.rp_buf = buf;
+			} else {
+				/* rp_buflen already zeroed; skip caching */
+				goto status;
+			}
+		} else if (so->so_replay.rp_buf != so->so_replay.rp_ibuf) {
+			nfs4_replay_free_cache(&so->so_replay);
 		}
+		so->so_replay.rp_buflen = len;
+		read_bytes_from_xdr_buf(xdr->buf,
+					op_status_offset + XDR_UNIT,
+					so->so_replay.rp_buf, len);
 	}
 status:
 	op->status = nfsd4_map_status(op->status,
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index c0ca115c3b74b..2c836984ad0f1 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -549,10 +549,10 @@ struct nfs4_client_reclaim {
  *   ~32(deleg. ace) = 112 bytes
  *
  * Some responses can exceed this. A LOCK denial includes the conflicting
- * lock owner, which can be up to 1024 bytes (NFS4_OPAQUE_LIMIT). Responses
- * larger than REPLAY_ISIZE are not cached in rp_ibuf; only rp_status is
- * saved. Enlarging this constant increases the size of every
- * nfs4_stateowner.
+ * lock owner, which can be up to 1024 bytes (NFS4_OPAQUE_LIMIT). When a
+ * response exceeds REPLAY_ISIZE, a buffer is dynamically allocated. If
+ * that allocation fails, only rp_status is saved. Enlarging this constant
+ * increases the size of every nfs4_stateowner.
  */
 
 #define NFSD4_REPLAY_ISIZE       112 
@@ -564,12 +564,14 @@ struct nfs4_client_reclaim {
 struct nfs4_replay {
 	__be32			rp_status;
 	unsigned int		rp_buflen;
-	char			*rp_buf;
+	char			*rp_buf; /* rp_ibuf or kmalloc'd */
 	struct knfsd_fh		rp_openfh;
 	int			rp_locked;
 	char			rp_ibuf[NFSD4_REPLAY_ISIZE];
 };
 
+extern void nfs4_replay_free_cache(struct nfs4_replay *rp);
+
 struct nfs4_stateowner;
 
 struct nfs4_stateowner_operations {
-- 
2.53.0



