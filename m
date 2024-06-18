Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BAD15FA87;
	Tue, 18 Jun 2024 12:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715038; cv=none; b=TSdOzk3Nb+iZ+DhFXdJc75+3UdM+/8jPQstRzlAXzvR2yOLsIFZnvko1dSDM1EoMlRVRRWr+8HRgj4Jq9ob+9i3hcJEn+pVohkWIn/hlyF7NNjlBvz6Ea1f5jvf0qr4n0PKWaTyhts5Zz6YesMR8GOMaYYzyaWJ8ltFr6zHKqiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715038; c=relaxed/simple;
	bh=gGhcsah9WGnCENUnjRrGnxtLKI+7c38oIGLeOFANVwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLcQRu7lcPtwQkXfKOFPbqndJQ3Wc7Goqb6WJVxbdXch+K8u5DtpXy/YqLbzlOzmF7GW6fSOHPV8sfHt1moVRXhJWSSvokNuA1kkFGlsozH90hhswoWa/IgPQAnuZAlSL8R/JnNV+EwhpfBUZxkwB/dyVT7BU1fjM6OVn0MzmeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut5F+M8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut5F+M8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ADAC3277B;
	Tue, 18 Jun 2024 12:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715038;
	bh=gGhcsah9WGnCENUnjRrGnxtLKI+7c38oIGLeOFANVwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ut5F+M8yN4XTuL4LRaRvdQLnr4D0oo+K6E69vEvmvBulrBqFRueoTQRVBTpMy12NA
	 JCb6m9LCm5qrk3Pah6DAhvRedRuCLFLHFxkE5cNzbAONjCStCm04i0PojJpQUufGX6
	 lvzljtniurXEvf8+vLaDsG2YrpWLyR2TQpa4fBB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/770] NFSD: Fix returned READDIR offset cookie
Date: Tue, 18 Jun 2024 14:29:54 +0200
Message-ID: <20240618123412.719128120@linuxfoundation.org>
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

[ Upstream commit 0a8f37fb34a96267c656f7254e69bb9a2fc89fe4 ]

Code inspection shows that the server's NFSv3 READDIR implementation
handles offset cookies slightly differently than the NFSv2 READDIR,
NFSv3 READDIRPLUS, and NFSv4 READDIR implementations,
and there doesn't seem to be any need for this difference.

As a clean up, I copied the logic from nfsd3_proc_readdirplus().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 71db0ed3c49ed..8cffd9852ef04 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -449,6 +449,7 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp)
 	struct nfsd3_readdirargs *argp = rqstp->rq_argp;
 	struct nfsd3_readdirres  *resp = rqstp->rq_resp;
 	int		count = 0;
+	loff_t		offset;
 	struct page	**p;
 	caddr_t		page_addr = NULL;
 
@@ -467,7 +468,9 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp)
 	resp->common.err = nfs_ok;
 	resp->buffer = argp->buffer;
 	resp->rqstp = rqstp;
-	resp->status = nfsd_readdir(rqstp, &resp->fh, (loff_t *)&argp->cookie,
+	offset = argp->cookie;
+
+	resp->status = nfsd_readdir(rqstp, &resp->fh, &offset,
 				    &resp->common, nfs3svc_encode_entry);
 	memcpy(resp->verf, argp->verf, 8);
 	count = 0;
@@ -483,8 +486,6 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp)
 	}
 	resp->count = count >> 2;
 	if (resp->offset) {
-		loff_t offset = argp->cookie;
-
 		if (unlikely(resp->offset1)) {
 			/* we ended up with offset on a page boundary */
 			*resp->offset = htonl(offset >> 32);
-- 
2.43.0



