Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334AA1428EC;
	Tue, 18 Jun 2024 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716577; cv=none; b=NsWro4xnHekS3VkngXDXE5CBPQNpjRWF5G9KUUBZx98uxsrJ1Vz5sU6Ji5N9+SiphI7tXcQZpvyxYmux5dNzzHRwMMz8q/0WK2qLe0jltPQ4CvayIrVw6UlXFgXjvgSx5Xof7kF18Iww8dz1SnAeUptirJMU0YVev/xY1w5Fqrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716577; c=relaxed/simple;
	bh=gIpQKtMuZ6AFFVqvxafl71ZQPkcjWXoYeXR90xXw/u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/DiHp00DTg3VQdfvdStK+HoWXK4mA0R1sI6zv+s9hVcQuaQcDOyTL/pDXxswpfHcM5YP0XIMlEGO+j3fSBBM/hsmsscO1C7BW8GYW+QdzgIC98bvlHCigosj7emEu2sJOUaHbGcjvboYTBjiW5fW/Z2WYz5EF/7bFDWYb4bA0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vphCb83t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vphCb83t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C650C3277B;
	Tue, 18 Jun 2024 13:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716575;
	bh=gIpQKtMuZ6AFFVqvxafl71ZQPkcjWXoYeXR90xXw/u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vphCb83tU2zcRRux4Gjj31qyk1VnS4HDmDo0BZOmrIEHBOCBCy/71jMyGnIhaVdvG
	 DMLOB2R+iLgPEwsfMsZakrZaUHaAMqMVjUlffY103qapNZ48XrFkBLc5xHOUoFTZ5V
	 aWW9AXW9IIEfshP8Ua7zOIxMfOaAC670ircPM6JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 684/770] NFSD: Finish converting the NFSv2 GETACL result encoder
Date: Tue, 18 Jun 2024 14:38:57 +0200
Message-ID: <20240618123433.681764915@linuxfoundation.org>
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

[ Upstream commit ea5021e911d3479346a75ac9b7d9dcd751b0fb99 ]

The xdr_stream conversion inadvertently left some code that set the
page_len of the send buffer. The XDR stream encoders should handle
this automatically now.

This oversight adds garbage past the end of the Reply message.
Clients typically ignore the garbage, but NFSD does not need to send
it, as it leaks stale memory contents onto the wire.

Fixes: f8cba47344f7 ("NFSD: Update the NFSv2 GETACL result encoder to use struct xdr_stream")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index f8179fc8c9bdf..9adf672dedbdd 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -244,7 +244,6 @@ nfsaclsvc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 	struct nfsd3_getaclres *resp = rqstp->rq_resp;
 	struct dentry *dentry = resp->fh.fh_dentry;
 	struct inode *inode;
-	int w;
 
 	if (!svcxdr_encode_stat(xdr, resp->status))
 		return false;
@@ -258,15 +257,6 @@ nfsaclsvc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 	if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
 		return false;
 
-	rqstp->rq_res.page_len = w = nfsacl_size(
-		(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
-		(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
-	while (w > 0) {
-		if (!*(rqstp->rq_next_page++))
-			return true;
-		w -= PAGE_SIZE;
-	}
-
 	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_access,
 				   resp->mask & NFS_ACL, 0))
 		return false;
-- 
2.43.0



