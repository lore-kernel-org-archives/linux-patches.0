Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2887771753;
	Mon,  8 Apr 2024 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583955; cv=none; b=VdzpCteKiZmnDzvuVuiMGA0gZwJuqVt2CYJpYmxxVDpJ8voPo9pkjPqeXTke78vy16SByda81mNZUnUsqG2FELZwabcpOFbcGMNBUtes8tzI77RuvBx8wJgLIDko1TgoqGkXJopvaFzN0y4ccofOY0y93tcy60sOage/Lh90O+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583955; c=relaxed/simple;
	bh=6X1Dedy6Ju8ohZ0KGBRarU7uLRfNnxYbPf/vdVHByFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfHZMxEwyVenJzH2H5noO+9KhfAulKL36oyndcn3nTSDBqyZc5Iyvxriu3xvELu+a2zfFbR1oL8C7mRCEhAXL3I/vmX0KFntijL1T3yefK+1CNfpdSO1af4hf7y6aoVTz7kyOaViduCki0G06ZK9u24JF3lbbI5Bu2Go96cWnmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKoMcVgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKoMcVgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DFEC433C7;
	Mon,  8 Apr 2024 13:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583955;
	bh=6X1Dedy6Ju8ohZ0KGBRarU7uLRfNnxYbPf/vdVHByFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKoMcVgZpzOVkRqrtmrWtafmguG6iSYtQugpyqxLax8HfKIIGNY7QtIh8QGyr7ADx
	 MO2N66a7pSsQ5Q2wUni8MMcdB/xnVTnu17Q8qm7yyvIpyK6qdp8r2G2WUpb2/j4ZTK
	 2LvUO6kxjr0KjmACDZGTKIXOiVJ9jyNFVKjvlAqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 306/690] NFSD: Clean up nfsd_splice_actor()
Date: Mon,  8 Apr 2024 14:52:52 +0200
Message-ID: <20240408125410.678925597@linuxfoundation.org>
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

[ Upstream commit 91e23b1c39820bfed642119ff6b6ef9f43cf09ce ]

nfsd_splice_actor() checks that the page being spliced does not
match the previous element in the svc_rqst::rq_pages array. We
believe this is to prevent a double put_page() in cases where the
READ payload is partially contained in the xdr_buf's head buffer.

However, the NFSD READ proc functions no longer place any part of
the READ payload in the head buffer, in order to properly support
NFS/RDMA READ with Write chunks. Therefore, simplify the logic in
nfsd_splice_actor() to remove this unnecessary check.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 00e956bdefaae..541f39ab450ce 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -856,17 +856,11 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 		  struct splice_desc *sd)
 {
 	struct svc_rqst *rqstp = sd->u.data;
-	struct page **pp = rqstp->rq_next_page;
-	struct page *page = buf->page;
 
-	if (rqstp->rq_res.page_len == 0) {
-		svc_rqst_replace_page(rqstp, page);
+	svc_rqst_replace_page(rqstp, buf->page);
+	if (rqstp->rq_res.page_len == 0)
 		rqstp->rq_res.page_base = buf->offset;
-	} else if (page != pp[-1]) {
-		svc_rqst_replace_page(rqstp, page);
-	}
 	rqstp->rq_res.page_len += sd->len;
-
 	return sd->len;
 }
 
-- 
2.43.0



