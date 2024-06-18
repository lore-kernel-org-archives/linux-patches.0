Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D032513FD8C;
	Tue, 18 Jun 2024 12:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714749; cv=none; b=EXv5Jsx9fV3B7x5JR41JKcQhj4LBBvpJaOWmUykk4f7zK3pxUo9pJPHnXlGz6MqdFHOHvKBUnvCv2oF9xwJStfH1JoKdXUAsAGylU+c5eXSt8N3KqfsjVqSKnHJGx8FYkASe1Awqo7gxaJ8J5nXsx4IB7ajJYwvFO2lenh6GaJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714749; c=relaxed/simple;
	bh=ybOL7qQWcPGjwqjznbEemUzoTpruuNNV4XMD1xF22mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Otpjd2xJyCnt6u+3cHZWFn75thbclED1koJ26cYhRvmT4H1/bPzeJVNOAXukicEWsSbDI0SpN0FDvsnobBQ1qLrpfNpq9tMVuKWexHCx7qbDaTJUE65c9VlFJZWZg1jS0xYIsJwd4E7He8cNhBjDKZBpGSksHqDkjL/BFQI1kiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Boj2GX+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Boj2GX+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FB0C3277B;
	Tue, 18 Jun 2024 12:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714749;
	bh=ybOL7qQWcPGjwqjznbEemUzoTpruuNNV4XMD1xF22mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Boj2GX+zFyhsEbbw+ibwUS+idwJveux+Q0yh0eUMtECnfr4py8yq0+lJ3Zuk370+d
	 wtf9FMDyKLKDpWq66waffxm48DLiRPNM0nurdCHC12KRqIPBvj571KHPiPyd1nlQMZ
	 dX/4OZdrmkZlreb7MR8+CU+Gqg/GaVkUtscfIZZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/770] NFSD: Add helper for decoding locker4
Date: Tue, 18 Jun 2024 14:28:07 +0200
Message-ID: <20240618123408.612149453@linuxfoundation.org>
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

[ Upstream commit 8918cc0d2b72db9997390626010b182c4500d749 ]

Refactor for clarity.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c          | 64 +++++++++++++++++++++++++-------------
 include/linux/sunrpc/xdr.h | 21 +++++++++++++
 2 files changed, 64 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 63140cd4c50e4..15ed5249e2c74 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -833,6 +833,48 @@ nfsd4_decode_link(struct nfsd4_compoundargs *argp, struct nfsd4_link *link)
 	return nfsd4_decode_component4(argp, &link->li_name, &link->li_namelen);
 }
 
+static __be32
+nfsd4_decode_open_to_lock_owner4(struct nfsd4_compoundargs *argp,
+				 struct nfsd4_lock *lock)
+{
+	__be32 status;
+
+	if (xdr_stream_decode_u32(argp->xdr, &lock->lk_new_open_seqid) < 0)
+		return nfserr_bad_xdr;
+	status = nfsd4_decode_stateid4(argp, &lock->lk_new_open_stateid);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &lock->lk_new_lock_seqid) < 0)
+		return nfserr_bad_xdr;
+	return nfsd4_decode_state_owner4(argp, &lock->lk_new_clientid,
+					 &lock->lk_new_owner);
+}
+
+static __be32
+nfsd4_decode_exist_lock_owner4(struct nfsd4_compoundargs *argp,
+			       struct nfsd4_lock *lock)
+{
+	__be32 status;
+
+	status = nfsd4_decode_stateid4(argp, &lock->lk_old_lock_stateid);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &lock->lk_old_lock_seqid) < 0)
+		return nfserr_bad_xdr;
+
+	return nfs_ok;
+}
+
+static __be32
+nfsd4_decode_locker4(struct nfsd4_compoundargs *argp, struct nfsd4_lock *lock)
+{
+	if (xdr_stream_decode_bool(argp->xdr, &lock->lk_is_new) < 0)
+		return nfserr_bad_xdr;
+	if (lock->lk_is_new)
+		return nfsd4_decode_open_to_lock_owner4(argp, lock);
+	return nfsd4_decode_exist_lock_owner4(argp, lock);
+}
+
 static __be32
 nfsd4_decode_lock(struct nfsd4_compoundargs *argp, struct nfsd4_lock *lock)
 {
@@ -848,27 +890,7 @@ nfsd4_decode_lock(struct nfsd4_compoundargs *argp, struct nfsd4_lock *lock)
 	lock->lk_reclaim = be32_to_cpup(p++);
 	p = xdr_decode_hyper(p, &lock->lk_offset);
 	p = xdr_decode_hyper(p, &lock->lk_length);
-	lock->lk_is_new = be32_to_cpup(p++);
-
-	if (lock->lk_is_new) {
-		READ_BUF(4);
-		lock->lk_new_open_seqid = be32_to_cpup(p++);
-		status = nfsd4_decode_stateid(argp, &lock->lk_new_open_stateid);
-		if (status)
-			return status;
-		READ_BUF(4);
-		lock->lk_new_lock_seqid = be32_to_cpup(p++);
-		status = nfsd4_decode_state_owner4(argp, &lock->lk_new_clientid,
-						   &lock->lk_new_owner);
-		if (status)
-			return status;
-	} else {
-		status = nfsd4_decode_stateid(argp, &lock->lk_old_lock_stateid);
-		if (status)
-			return status;
-		READ_BUF(4);
-		lock->lk_old_lock_seqid = be32_to_cpup(p++);
-	}
+	status = nfsd4_decode_locker4(argp, lock);
 
 	DECODE_TAIL;
 }
diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 6b17575437474..f6569b620beab 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -548,6 +548,27 @@ static inline bool xdr_item_is_present(const __be32 *p)
 	return *p != xdr_zero;
 }
 
+/**
+ * xdr_stream_decode_bool - Decode a boolean
+ * @xdr: pointer to xdr_stream
+ * @ptr: pointer to a u32 in which to store the result
+ *
+ * Return values:
+ *   %0 on success
+ *   %-EBADMSG on XDR buffer overflow
+ */
+static inline ssize_t
+xdr_stream_decode_bool(struct xdr_stream *xdr, __u32 *ptr)
+{
+	const size_t count = sizeof(*ptr);
+	__be32 *p = xdr_inline_decode(xdr, count);
+
+	if (unlikely(!p))
+		return -EBADMSG;
+	*ptr = (*p != xdr_zero);
+	return 0;
+}
+
 /**
  * xdr_stream_decode_u32 - Decode a 32-bit integer
  * @xdr: pointer to xdr_stream
-- 
2.43.0



