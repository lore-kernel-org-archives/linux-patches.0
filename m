Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B4E13792B;
	Tue, 18 Jun 2024 13:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716555; cv=none; b=hm1GiXU0l3N0ZHU1+7LIIqtDV8rhK/txsX9dsVf5y7k4fyIy9PAtE+DyPP4gGPY54n1DznIkAA4egevt73m5nBmpGwkY9+PpXk0OF7Ja6q8mvZ6OGAu0tA5I69i0StWZWMQfEImgdPWusSciji+ihx9yXQEvn+A0tM9BITRjULE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716555; c=relaxed/simple;
	bh=URqp7q1xIkkJz9MsLok+N646uC6c62gdvSNBd8va8U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhSZK8VY6e1fGUyhjmBuLOGw1PsbdlmD80sqEgqSXMay7Fkd683Tr2bgJ7Xz3zcM8cEwKfLfz0YYdqrriqJ36USm4f8+jh+8AjvtlG4TBsPRfam/JM9T5URUu6kv4ATjxg/MzZBBJuURiu6qdLGLs6o02fKtsOBEqf7hKKzINkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdZ5Z5Ig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdZ5Z5Ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB149C3277B;
	Tue, 18 Jun 2024 13:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716555;
	bh=URqp7q1xIkkJz9MsLok+N646uC6c62gdvSNBd8va8U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdZ5Z5Ig1JeZIrP44jhO9iO9tuFJ8dFbMRMs5QMzbTZmNda1NzE6aJe+bu47k2dpb
	 FDXa0HH2OX5BQ8lpCRMdVoh0LXKiP2e2CL3c1BAgoh4LoaQvfAJHh2Y/ySZzQ3wK80
	 4pUu2gb15ammnIQ+A8P8pKtNdC0kAzAdKr9ARm2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 652/770] NFSD: Use xdr_inline_decode() to decode NFSv3 symlinks
Date: Tue, 18 Jun 2024 14:38:25 +0200
Message-ID: <20240618123432.456323637@linuxfoundation.org>
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

[ Upstream commit c3d2a04f05c590303c125a176e6e43df4a436fdb ]

Replace the check for buffer over/underflow with a helper that is
commonly used for this purpose. The helper also sets xdr->nwords
correctly after successfully linearizing the symlink argument into
the stream's scratch buffer.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 0293b8d65f10f..71e32cf288854 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -616,8 +616,6 @@ nfs3svc_decode_symlinkargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 {
 	struct nfsd3_symlinkargs *args = rqstp->rq_argp;
 	struct kvec *head = rqstp->rq_arg.head;
-	struct kvec *tail = rqstp->rq_arg.tail;
-	size_t remaining;
 
 	if (!svcxdr_decode_diropargs3(xdr, &args->ffh, &args->fname, &args->flen))
 		return false;
@@ -626,16 +624,10 @@ nfs3svc_decode_symlinkargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 	if (xdr_stream_decode_u32(xdr, &args->tlen) < 0)
 		return false;
 
-	/* request sanity */
-	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
-	remaining -= xdr_stream_pos(xdr);
-	if (remaining < xdr_align_size(args->tlen))
-		return false;
-
-	args->first.iov_base = xdr->p;
+	/* symlink_data */
 	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
-
-	return true;
+	args->first.iov_base = xdr_inline_decode(xdr, args->tlen);
+	return args->first.iov_base != NULL;
 }
 
 bool
-- 
2.43.0



