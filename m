Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CF26EB72;
	Mon,  8 Apr 2024 13:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584448; cv=none; b=DNJTie650HSO9pQJ3/CD9u8lhX54POllBgEq7z1IG2JOKWf0jfqV438i8hcgPLp5oE7Jsv1+aCOpLXIxFqaxQY3A49ZvHIOO7qrLlxh+hEU7o1iUeU4kG17Y+wfzsdHfclRuBAbdqP8k/AWgxWuCWOzmgdZ71/oXF9qGGpfNXyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584448; c=relaxed/simple;
	bh=l9W/71XjqxwHNzU/5a6ey4AaM1QVTcAgBBfohX5V0TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk1XImIRN3kblzuHGfrhGDAVK/fl0sLq6WKL2Os1Krh7a1Cg/2ojKWq/vh6DYApiQerLsC32nfo2HB25Y4J7eSKbszk+ov7A5Qdfkt0Tw43gIHCbS3RvRrx3NnZ9IC7imFhjkP1FHL0NbUefls1GVTK7iErk3seJ5JaAuq/AnKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiJYo+xP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiJYo+xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEF4C433C7;
	Mon,  8 Apr 2024 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584448;
	bh=l9W/71XjqxwHNzU/5a6ey4AaM1QVTcAgBBfohX5V0TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiJYo+xPEbR3RcqiRxUUMp6n7jPW48Gayn9bNDlNKMy1fTseIlNKFnQB3lWNnIFw8
	 0V++NEHe7eRKHhLeMwtWHKBuOo/cvuW6duzCKjrLBGZGd/XLE3cuLR+jjrVlW+kNQk
	 wqoR9aDjX218x1KA6RNWnwkjyQh9RinB+0VIHlwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 441/690] NFSD: Clean up nfs4svc_encode_compoundres()
Date: Mon,  8 Apr 2024 14:55:07 +0200
Message-ID: <20240408125415.621729411@linuxfoundation.org>
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

[ Upsteam commit 9993a66317fc9951322483a9edbfae95a640b210 ]

In today's Linux NFS server implementation, the NFS dispatcher
initializes each XDR result stream, and the NFSv4 .pc_func and
.pc_encode methods all use xdr_stream-based encoding. This keeps
rq_res.len automatically updated. There is no longer a need for
the WARN_ON_ONCE() check in nfs4svc_encode_compoundres().

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 6c43cf52a885f..76028a5c81d1d 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5470,12 +5470,8 @@ bool
 nfs4svc_encode_compoundres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 {
 	struct nfsd4_compoundres *resp = rqstp->rq_resp;
-	struct xdr_buf *buf = xdr->buf;
 	__be32 *p;
 
-	WARN_ON_ONCE(buf->len != buf->head[0].iov_len + buf->page_len +
-				 buf->tail[0].iov_len);
-
 	/*
 	 * Send buffer space for the following items is reserved
 	 * at the top of nfsd4_proc_compound().
-- 
2.43.0



