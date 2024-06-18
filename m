Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81C013C675;
	Tue, 18 Jun 2024 12:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714684; cv=none; b=Lj/q5lidEk0AHtaG7zuwnCBe2WVsXv6T5WcT6qG7KUorF3t6obwJOrv3HkRrCq0xOomMPUHjtOhIDnlYwoq55M4APtiKOIE2hQlzH8l9mc0RVADM1ckTfK2YzMgRv4QhnTx3Bldl6SapodiPodEADw+PhoD7n5JctbT80rVtD9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714684; c=relaxed/simple;
	bh=+qWRx6P87GtLjt+IlBNOxz9wwPxQlE2FWzDZl+M0OaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hri8eatNvWuu2e3YhC6gZOogCywT4Yjujz+OGltGSAHFKz7zhuqZ1TVpb3gLjsnTUheZ4GAEN7uDTJHdRfAOPa6/4W62dWfuSVQPxZipyxJA6kv0t6ulXsbN3cJ49kES5AYCmYApimGbTxOuw/1Jr120+nCAFMUd5u7I+ZSvJ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UA39wsFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UA39wsFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2746CC4AF1D;
	Tue, 18 Jun 2024 12:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714684;
	bh=+qWRx6P87GtLjt+IlBNOxz9wwPxQlE2FWzDZl+M0OaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA39wsFxzvYsaJn4EyXijG7Wvl7/LaCr3lcckO5skk5dLcGxMNH1/OUnySGXhkWkA
	 +W4CrVeCfMovJy/BVsuyBCN5LFXjg1a1YruYuKbBYL++0C3LuK/iSqrxiWaOczP98V
	 he5TXFArFWRNqt0Yb5bS3jYqrUi8mj4gAgpuiJts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/770] NFSD: Replace READ* macros in nfsd4_decode_lockt()
Date: Tue, 18 Jun 2024 14:28:09 +0200
Message-ID: <20240618123408.687470579@linuxfoundation.org>
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

[ Upstream commit 0a146f04aa0fa7a57aaed3913d1c2732b3853f31 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b50d2987bb6e8..4f2680650a567 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -894,20 +894,16 @@ nfsd4_decode_lock(struct nfsd4_compoundargs *argp, struct nfsd4_lock *lock)
 static __be32
 nfsd4_decode_lockt(struct nfsd4_compoundargs *argp, struct nfsd4_lockt *lockt)
 {
-	DECODE_HEAD;
-		        
-	READ_BUF(32);
-	lockt->lt_type = be32_to_cpup(p++);
-	if((lockt->lt_type < NFS4_READ_LT) || (lockt->lt_type > NFS4_WRITEW_LT))
-		goto xdr_error;
-	p = xdr_decode_hyper(p, &lockt->lt_offset);
-	p = xdr_decode_hyper(p, &lockt->lt_length);
-	COPYMEM(&lockt->lt_clientid, 8);
-	lockt->lt_owner.len = be32_to_cpup(p++);
-	READ_BUF(lockt->lt_owner.len);
-	READMEM(lockt->lt_owner.data, lockt->lt_owner.len);
-
-	DECODE_TAIL;
+	if (xdr_stream_decode_u32(argp->xdr, &lockt->lt_type) < 0)
+		return nfserr_bad_xdr;
+	if ((lockt->lt_type < NFS4_READ_LT) || (lockt->lt_type > NFS4_WRITEW_LT))
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &lockt->lt_offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &lockt->lt_length) < 0)
+		return nfserr_bad_xdr;
+	return nfsd4_decode_state_owner4(argp, &lockt->lt_clientid,
+					 &lockt->lt_owner);
 }
 
 static __be32
-- 
2.43.0



