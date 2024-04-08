Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981926EB72;
	Mon,  8 Apr 2024 13:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584442; cv=none; b=Nowl4THUzaDkNkgPN7aYyjcKjWTnN/TTNv7qPXmQGnbSAY1O9PnxZfhF/ov6FgKzApRWnTY0LfiKmdUqrMXUyIiPlfM9wYqdS4wRViF5i5pGfKorQUIuWTgIGrX8GXj9GZEAdK94xNh7wYxiPQpQ0QKRO/0qseI3psHUgw8FdXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584442; c=relaxed/simple;
	bh=4z3LdOBE9gId0FfmkVwECJPmyFvdfDz4/HXkg2ANNYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx2b+ZKfk72OkV+Q795EGN8RcXKejCHZc3LR7C7MJsB9k3DMBONFHde6adXxnfwJXdP+G2zjyrd3EDb0VyD8Jx5EbMob1R780lZzBp9JCxWfoERzxzLTkPTWEmHJO7wWXBwhWRY6DqxXpVrAX8DjFvGcI2ee9nDpDVvEZSH5qC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B85xK/h7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B85xK/h7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15996C433C7;
	Mon,  8 Apr 2024 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584442;
	bh=4z3LdOBE9gId0FfmkVwECJPmyFvdfDz4/HXkg2ANNYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B85xK/h71tUJYJ76X/mYj0NKtJEl4s5hzHfYR+Gz+9C+lo2JKWky2wKkGPE5VUF5X
	 ZCfSpXOKslyxLvjsguVtMdRFjlD1vnm2H8IrbHyEHgfCVjKj6xX7wWDiIGqLsOoT2a
	 U9RIg+5L33a5BQL6EypZtapxr99Mt8nBnICP/o9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 439/690] NFSD: Use xdr_inline_decode() to decode NFSv3 symlinks
Date: Mon,  8 Apr 2024 14:55:05 +0200
Message-ID: <20240408125415.542682325@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c3d2a04f05c590303c125a176e6e43df4a436fdb ]

Replace the check for buffer over/underflow with a helper that is
commonly used for this purpose. The helper also sets xdr->nwords
correctly after successfully linearizing the symlink argument into
the stream's scratch buffer.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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



