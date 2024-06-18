Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3277B13AA2F;
	Tue, 18 Jun 2024 12:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714917; cv=none; b=iESvM+GKqpbABCa21mB1YL2stnVOphur1XBv710DnhXdGkTPnmn0B1wEo9Hfm5g7aS/jCwkTuwnfafIML2OEZ4CF/p8IUJewtOKuMr+ljCO/KC6biGc//I4Oi64ZGlGNcrHMjclCqLkVt1OS28PCmMHmlBuGw9oMGPF4kuEaNF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714917; c=relaxed/simple;
	bh=1bf3VHnj68brQmkf6yZI8vfwmkgi2ogXaVTVUD/s0l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGIo/aJhrJfYW8O2LBlioUSFyr0BHI9F+YvG5q5cb5kByrij/cg40WIX3kQl6MgvTgwkUXNW1S9uREerYNjN/r8ePAIc2SBseX82gT4lGUjUOy60b9hn8iAOHfBGFjf61mx5fOU1JA9Qc4MtdkCFT1t9ygNNrzx2n69B0rD1rck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N52DDXp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N52DDXp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEBDC3277B;
	Tue, 18 Jun 2024 12:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714917;
	bh=1bf3VHnj68brQmkf6yZI8vfwmkgi2ogXaVTVUD/s0l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N52DDXp1IBNF78HPJ83a0Ef0xefr2k9k/xgRl472pfRHFzjzOZzGw+NFb2WHcyjZS
	 nnBirMkmPSuzxx5TOgIbXtvrwLqQqYZc/Yqg8YbDxEAOwDihC1LvDhJA4ryjpVyNYq
	 t1DEqGsqskDnLBiTIx83lYC/42EQIqwAc1mllOc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/770] NFSD: Restore NFSv4 decodings SAVEMEM functionality
Date: Tue, 18 Jun 2024 14:29:45 +0200
Message-ID: <20240618123412.371969513@linuxfoundation.org>
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

[ Upstream commit 7b723008f9c95624c848fad661c01b06e47b20da ]

While converting the NFSv4 decoder to use xdr_stream-based XDR
processing, I removed the old SAVEMEM() macro. This macro wrapped
a bit of logic that avoided a memory allocation by recognizing when
the decoded item resides in a linear section of the Receive buffer.
In that case, it returned a pointer into that buffer instead of
allocating a bounce buffer.

The bounce buffer is necessary only when xdr_inline_decode() has
placed the decoded item in the xdr_stream's scratch buffer, which
disappears the next time xdr_inline_decode() is called with that
xdr_stream. That happens only if the data item crosses a page
boundary in the receive buffer, an exceedingly rare occurrence.

Allocating a bounce buffer every time results in a minor performance
regression that was introduced by the recent NFSv4 decoder overhaul.
Let's restore the previous behavior. On average, it saves about 1.5
kmalloc() calls per COMPOUND.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index bb037e8eb8304..8d5fdae568aeb 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -147,6 +147,25 @@ svcxdr_dupstr(struct nfsd4_compoundargs *argp, void *buf, u32 len)
 	return p;
 }
 
+static void *
+svcxdr_savemem(struct nfsd4_compoundargs *argp, __be32 *p, u32 len)
+{
+	__be32 *tmp;
+
+	/*
+	 * The location of the decoded data item is stable,
+	 * so @p is OK to use. This is the common case.
+	 */
+	if (p != argp->xdr->scratch.iov_base)
+		return p;
+
+	tmp = svcxdr_tmpalloc(argp, len);
+	if (!tmp)
+		return NULL;
+	memcpy(tmp, p, len);
+	return tmp;
+}
+
 /*
  * NFSv4 basic data type decoders
  */
@@ -183,11 +202,10 @@ nfsd4_decode_opaque(struct nfsd4_compoundargs *argp, struct xdr_netobj *o)
 	p = xdr_inline_decode(argp->xdr, len);
 	if (!p)
 		return nfserr_bad_xdr;
-	o->data = svcxdr_tmpalloc(argp, len);
+	o->data = svcxdr_savemem(argp, p, len);
 	if (!o->data)
 		return nfserr_jukebox;
 	o->len = len;
-	memcpy(o->data, p, len);
 
 	return nfs_ok;
 }
@@ -205,10 +223,9 @@ nfsd4_decode_component4(struct nfsd4_compoundargs *argp, char **namp, u32 *lenp)
 	status = check_filename((char *)p, *lenp);
 	if (status)
 		return status;
-	*namp = svcxdr_tmpalloc(argp, *lenp);
+	*namp = svcxdr_savemem(argp, p, *lenp);
 	if (!*namp)
 		return nfserr_jukebox;
-	memcpy(*namp, p, *lenp);
 
 	return nfs_ok;
 }
@@ -1200,10 +1217,9 @@ nfsd4_decode_putfh(struct nfsd4_compoundargs *argp, struct nfsd4_putfh *putfh)
 	p = xdr_inline_decode(argp->xdr, putfh->pf_fhlen);
 	if (!p)
 		return nfserr_bad_xdr;
-	putfh->pf_fhval = svcxdr_tmpalloc(argp, putfh->pf_fhlen);
+	putfh->pf_fhval = svcxdr_savemem(argp, p, putfh->pf_fhlen);
 	if (!putfh->pf_fhval)
 		return nfserr_jukebox;
-	memcpy(putfh->pf_fhval, p, putfh->pf_fhlen);
 
 	return nfs_ok;
 }
@@ -1318,24 +1334,20 @@ nfsd4_decode_setclientid(struct nfsd4_compoundargs *argp, struct nfsd4_setclient
 	p = xdr_inline_decode(argp->xdr, setclientid->se_callback_netid_len);
 	if (!p)
 		return nfserr_bad_xdr;
-	setclientid->se_callback_netid_val = svcxdr_tmpalloc(argp,
+	setclientid->se_callback_netid_val = svcxdr_savemem(argp, p,
 						setclientid->se_callback_netid_len);
 	if (!setclientid->se_callback_netid_val)
 		return nfserr_jukebox;
-	memcpy(setclientid->se_callback_netid_val, p,
-	       setclientid->se_callback_netid_len);
 
 	if (xdr_stream_decode_u32(argp->xdr, &setclientid->se_callback_addr_len) < 0)
 		return nfserr_bad_xdr;
 	p = xdr_inline_decode(argp->xdr, setclientid->se_callback_addr_len);
 	if (!p)
 		return nfserr_bad_xdr;
-	setclientid->se_callback_addr_val = svcxdr_tmpalloc(argp,
+	setclientid->se_callback_addr_val = svcxdr_savemem(argp, p,
 						setclientid->se_callback_addr_len);
 	if (!setclientid->se_callback_addr_val)
 		return nfserr_jukebox;
-	memcpy(setclientid->se_callback_addr_val, p,
-	       setclientid->se_callback_addr_len);
 	if (xdr_stream_decode_u32(argp->xdr, &setclientid->se_callback_ident) < 0)
 		return nfserr_bad_xdr;
 
@@ -1375,10 +1387,9 @@ nfsd4_decode_verify(struct nfsd4_compoundargs *argp, struct nfsd4_verify *verify
 	p = xdr_inline_decode(argp->xdr, verify->ve_attrlen);
 	if (!p)
 		return nfserr_bad_xdr;
-	verify->ve_attrval = svcxdr_tmpalloc(argp, verify->ve_attrlen);
+	verify->ve_attrval = svcxdr_savemem(argp, p, verify->ve_attrlen);
 	if (!verify->ve_attrval)
 		return nfserr_jukebox;
-	memcpy(verify->ve_attrval, p, verify->ve_attrlen);
 
 	return nfs_ok;
 }
@@ -2333,10 +2344,9 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 		p = xdr_inline_decode(argp->xdr, argp->taglen);
 		if (!p)
 			return 0;
-		argp->tag = svcxdr_tmpalloc(argp, argp->taglen);
+		argp->tag = svcxdr_savemem(argp, p, argp->taglen);
 		if (!argp->tag)
 			return 0;
-		memcpy(argp->tag, p, argp->taglen);
 		max_reply += xdr_align_size(argp->taglen);
 	}
 
-- 
2.43.0



