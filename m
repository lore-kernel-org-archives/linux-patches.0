Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069081B47D5;
	Tue, 18 Jun 2024 12:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714572; cv=none; b=YzMxkmqLkyTUeZRdAbIkXmoz3xWzAm9og4XS9Xxuzn4/3mN7G9ks1LReMqda9svIfAHRKx9jjWYOOziRDAT2Bm7W2M5eILnKsRxwjeVjw7sC1Hm7Wtw3ao+cT4WSUxFVm37jcsfYCUS9NSPnrujerce8/CM0i405kZ3dAhXpRIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714572; c=relaxed/simple;
	bh=70uFZU1EwISEtbayQ7JHk3wrj5QNBrpm1TgpOb+pZCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZY92+1nAZsanPAhAE0cN8MIeHphh/ItVADvzKpXnZvC+7igmf0XWOQUkqrYCSftJD56diTJ4+AV62seIG8wQb4jBf36CaeyZl6FOGRO9SAuhxVAjhOWtmPrZVwtlERO0k1SjvIg9zGekIylp4ml7DWL7NduGMKjEYvYY7xwmCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEipmrYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEipmrYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39171C3277B;
	Tue, 18 Jun 2024 12:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714571;
	bh=70uFZU1EwISEtbayQ7JHk3wrj5QNBrpm1TgpOb+pZCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEipmrYJM9MhPZ32G64Dc0G1o2+hRvbDUmPs2wBb4GyOjmoSZdaLSM7Evj1TDVmdM
	 rzmRsQlPL4Mc6/RV7DavEraWsYxnrM4f2ZJhw2aN1QfjWT+IWxT+ow7jGFFoFIgm7u
	 oP/IxPUSogS6AayuUH81o3FIEWRW3QL9uAaTMceU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/770] NFSD: Replace READ* macros in nfsd4_decode_close()
Date: Tue, 18 Jun 2024 14:27:49 +0200
Message-ID: <20240618123407.923691730@linuxfoundation.org>
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

[ Upstream commit d3d2f38154571e70d5806b5c5264bf61c101ea15 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index f3d54af9de92a..ca02478534931 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -439,6 +439,19 @@ nfsd4_decode_stateid(struct nfsd4_compoundargs *argp, stateid_t *sid)
 	DECODE_TAIL;
 }
 
+static __be32
+nfsd4_decode_stateid4(struct nfsd4_compoundargs *argp, stateid_t *sid)
+{
+	__be32 *p;
+
+	p = xdr_inline_decode(argp->xdr, NFS4_STATEID_SIZE);
+	if (!p)
+		return nfserr_bad_xdr;
+	sid->si_generation = be32_to_cpup(p++);
+	memcpy(&sid->si_opaque, p, sizeof(sid->si_opaque));
+	return nfs_ok;
+}
+
 static __be32 nfsd4_decode_cb_sec(struct nfsd4_compoundargs *argp, struct nfsd4_cb_sec *cbs)
 {
 	DECODE_HEAD;
@@ -559,13 +572,9 @@ static __be32 nfsd4_decode_bind_conn_to_session(struct nfsd4_compoundargs *argp,
 static __be32
 nfsd4_decode_close(struct nfsd4_compoundargs *argp, struct nfsd4_close *close)
 {
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	close->cl_seqid = be32_to_cpup(p++);
-	return nfsd4_decode_stateid(argp, &close->cl_stateid);
-
-	DECODE_TAIL;
+	if (xdr_stream_decode_u32(argp->xdr, &close->cl_seqid) < 0)
+		return nfserr_bad_xdr;
+	return nfsd4_decode_stateid4(argp, &close->cl_stateid);
 }
 
 
-- 
2.43.0



