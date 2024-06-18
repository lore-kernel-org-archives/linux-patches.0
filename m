Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552D715DBC7;
	Tue, 18 Jun 2024 12:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714852; cv=none; b=CqvnsxYAHeNRVrMIwc4frVlqVnGmzJrTtH3gKucQZjnRQP2W/vzMk4d9zKGEAfrL8UrB+U6eedSDlEgwVvXxLGuBa97uc3S5A4JRg1gwKtfxpoI+42JNLaNBGPCXYAsr9TsCfSH3a/cH7KswqMFPhTjPOjtxXuzhJ6R2X/7lg+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714852; c=relaxed/simple;
	bh=Cv0ky0u87I/D0yqavfUHKeX82ul/E0QAwfdTK745038=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adFVO6QOWnvSiQG1mte+Livzo5n9Zyo1mHuD29ikSHhO/YhJwrnAljERcLzvQJ5qfFcqlKGVPj+7iVnMk09sO7EIxjqjr6cQjXoPUHGSzjjEyMhhu1lWPxnJN5//EpXIymg5mtshu2VB7YqyiJkEJGiFEwp0sDgRz+00CtD8ULY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YHaL4ak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YHaL4ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D14C3277B;
	Tue, 18 Jun 2024 12:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714852;
	bh=Cv0ky0u87I/D0yqavfUHKeX82ul/E0QAwfdTK745038=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YHaL4aku4swmt+VnBhU9jZs7TPP+bNInJXhVeULvml73WEOcaoJfjTlJU4pl7acx
	 23iM5Z7qt2Mg+hYJKjbKu9RWSzuZgRfxPhQAtTl1gyIM3cegXie0QDzZXbxglUBC8X
	 xzWXHFBwQ5hqJn8sFlRgg+1AH7jmln8Jtyf5IyIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/770] NFSD: Add a helper to decode channel_attrs4
Date: Tue, 18 Jun 2024 14:28:41 +0200
Message-ID: <20240618123409.908824725@linuxfoundation.org>
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

[ Upstream commit 3a3f1fbacb0960b628e5a9f07c78287312f7a99d ]

De-duplicate some code.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 71 +++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index e06e657c3d91c..716a16961ff48 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1614,6 +1614,38 @@ nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 	return nfsd4_decode_nfs_impl_id4(argp, exid);
 }
 
+static __be32
+nfsd4_decode_channel_attrs4(struct nfsd4_compoundargs *argp,
+			    struct nfsd4_channel_attrs *ca)
+{
+	__be32 *p;
+
+	p = xdr_inline_decode(argp->xdr, XDR_UNIT * 7);
+	if (!p)
+		return nfserr_bad_xdr;
+
+	/* headerpadsz is ignored */
+	p++;
+	ca->maxreq_sz = be32_to_cpup(p++);
+	ca->maxresp_sz = be32_to_cpup(p++);
+	ca->maxresp_cached = be32_to_cpup(p++);
+	ca->maxops = be32_to_cpup(p++);
+	ca->maxreqs = be32_to_cpup(p++);
+	ca->nr_rdma_attrs = be32_to_cpup(p);
+	switch (ca->nr_rdma_attrs) {
+	case 0:
+		break;
+	case 1:
+		if (xdr_stream_decode_u32(argp->xdr, &ca->rdma_attrs) < 0)
+			return nfserr_bad_xdr;
+		break;
+	default:
+		return nfserr_bad_xdr;
+	}
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 			    struct nfsd4_create_session *sess)
@@ -1625,39 +1657,12 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 	sess->seqid = be32_to_cpup(p++);
 	sess->flags = be32_to_cpup(p++);
 
-	/* Fore channel attrs */
-	READ_BUF(28);
-	p++; /* headerpadsz is always 0 */
-	sess->fore_channel.maxreq_sz = be32_to_cpup(p++);
-	sess->fore_channel.maxresp_sz = be32_to_cpup(p++);
-	sess->fore_channel.maxresp_cached = be32_to_cpup(p++);
-	sess->fore_channel.maxops = be32_to_cpup(p++);
-	sess->fore_channel.maxreqs = be32_to_cpup(p++);
-	sess->fore_channel.nr_rdma_attrs = be32_to_cpup(p++);
-	if (sess->fore_channel.nr_rdma_attrs == 1) {
-		READ_BUF(4);
-		sess->fore_channel.rdma_attrs = be32_to_cpup(p++);
-	} else if (sess->fore_channel.nr_rdma_attrs > 1) {
-		dprintk("Too many fore channel attr bitmaps!\n");
-		goto xdr_error;
-	}
-
-	/* Back channel attrs */
-	READ_BUF(28);
-	p++; /* headerpadsz is always 0 */
-	sess->back_channel.maxreq_sz = be32_to_cpup(p++);
-	sess->back_channel.maxresp_sz = be32_to_cpup(p++);
-	sess->back_channel.maxresp_cached = be32_to_cpup(p++);
-	sess->back_channel.maxops = be32_to_cpup(p++);
-	sess->back_channel.maxreqs = be32_to_cpup(p++);
-	sess->back_channel.nr_rdma_attrs = be32_to_cpup(p++);
-	if (sess->back_channel.nr_rdma_attrs == 1) {
-		READ_BUF(4);
-		sess->back_channel.rdma_attrs = be32_to_cpup(p++);
-	} else if (sess->back_channel.nr_rdma_attrs > 1) {
-		dprintk("Too many back channel attr bitmaps!\n");
-		goto xdr_error;
-	}
+	status = nfsd4_decode_channel_attrs4(argp, &sess->fore_channel);
+	if (status)
+		return status;
+	status = nfsd4_decode_channel_attrs4(argp, &sess->back_channel);
+	if (status)
+		return status;
 
 	READ_BUF(4);
 	sess->callback_prog = be32_to_cpup(p++);
-- 
2.43.0



