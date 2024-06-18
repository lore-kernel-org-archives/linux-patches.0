Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B031B4C29;
	Tue, 18 Jun 2024 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714574; cv=none; b=k2aeomYvEHoAnl23epicujMs+c/hak8sYUjKKKf4xHhVv+9iC/TWoJPYU+iRH9k48WFZG97ofL2NSD0APwLkm7sCS8j0hEmMlboH7ppCvtx9RqZJLH2OkTiAwVWZfcSfvKmKBCuF5del8N7+G7JInAOT5aCdZVoH9ziLt5nDXpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714574; c=relaxed/simple;
	bh=HZwDUV8tbLtBso336iQsMHIMFlZNXOhS6Uior9vXjtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=droiHVr9pdUIMDt0R3GWN+1CI8ZbYxYiDxQ0m80Olco96oRKCHexuP087+xMfY5VsjYmJqAf9JdTtAokw2wmtBTblo7BZhfEB0PU3N5fbC+2WXmmQrnYE3tQmGsJ8x41yLvcLF3jfX8L302zbFFmBThmhD4H3TT7uvjyVYSzSA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHZ84bFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHZ84bFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1F1C4AF49;
	Tue, 18 Jun 2024 12:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714574;
	bh=HZwDUV8tbLtBso336iQsMHIMFlZNXOhS6Uior9vXjtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHZ84bFN+YLP0dAgIzUsUgoSYkaWbmutqqby88w84yB/COH4LSxufL048iqtJ5XtG
	 u/5Ci0yf898e00at+RBp1GwBqqBk46WgRA28LXGzSGabydUXhkc1eqrB0j6GEYd5IK
	 blh/VmaPulNONClPl4vcG52MJsULZ/qKCLe+JSpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/770] NFSD: Replace READ* macros in nfsd4_decode_commit()
Date: Tue, 18 Jun 2024 14:27:50 +0200
Message-ID: <20240618123407.962825778@linuxfoundation.org>
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

[ Upstream commit cbd9abb3706e96563b36af67595707a7054ab693 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c          | 12 +++++-------
 include/linux/sunrpc/xdr.h | 21 +++++++++++++++++++++
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ca02478534931..8251b905d5479 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -581,13 +581,11 @@ nfsd4_decode_close(struct nfsd4_compoundargs *argp, struct nfsd4_close *close)
 static __be32
 nfsd4_decode_commit(struct nfsd4_compoundargs *argp, struct nfsd4_commit *commit)
 {
-	DECODE_HEAD;
-
-	READ_BUF(12);
-	p = xdr_decode_hyper(p, &commit->co_offset);
-	commit->co_count = be32_to_cpup(p++);
-
-	DECODE_TAIL;
+	if (xdr_stream_decode_u64(argp->xdr, &commit->co_offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &commit->co_count) < 0)
+		return nfserr_bad_xdr;
+	return nfs_ok;
 }
 
 static __be32
diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index c03f7bf585c96..6b17575437474 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -569,6 +569,27 @@ xdr_stream_decode_u32(struct xdr_stream *xdr, __u32 *ptr)
 	return 0;
 }
 
+/**
+ * xdr_stream_decode_u64 - Decode a 64-bit integer
+ * @xdr: pointer to xdr_stream
+ * @ptr: location to store 64-bit integer
+ *
+ * Return values:
+ *   %0 on success
+ *   %-EBADMSG on XDR buffer overflow
+ */
+static inline ssize_t
+xdr_stream_decode_u64(struct xdr_stream *xdr, __u64 *ptr)
+{
+	const size_t count = sizeof(*ptr);
+	__be32 *p = xdr_inline_decode(xdr, count);
+
+	if (unlikely(!p))
+		return -EBADMSG;
+	xdr_decode_hyper(p, ptr);
+	return 0;
+}
+
 /**
  * xdr_stream_decode_opaque_fixed - Decode fixed length opaque xdr data
  * @xdr: pointer to xdr_stream
-- 
2.43.0



