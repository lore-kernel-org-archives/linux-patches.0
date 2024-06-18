Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4348E1891C9;
	Tue, 18 Jun 2024 13:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715659; cv=none; b=HmUHCtnxq7DJ7WFyVpJiQtVvV01g054gw/REqJxw6/M+mwopYMzbIeYsBH+wB/gRu+u5gl2ECR45sUkUbKFAAJIxXcDjDFqDB9mJOoIjVaIMzyCAzMgFUeCw+J3jBdGN6BmT6qgOdi3dsKXP0Z6j43/oWKWi8ase/V00TtmJTvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715659; c=relaxed/simple;
	bh=mq+vbKRrKg9O9NfYpQFvuGPqTH6mYxk0g9ikLAzhP2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTeFldH+eA3DzNul2AMly9V/scwTiYFeNDFRzOhCteWPLOt9E+gll2gg8o6U1H4CETqvWLszb5idtgLVNDcNsI7dKsErJbUzqiGRpz2qlhHEP9nK3/lfxAfzE3HoMB46tpJL9Og8LgJ5X0p2P7RrggNOcvnkRfLye0zoAHayxFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1b6tFRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1b6tFRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E5C3277B;
	Tue, 18 Jun 2024 13:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715659;
	bh=mq+vbKRrKg9O9NfYpQFvuGPqTH6mYxk0g9ikLAzhP2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1b6tFRfaUz5Fq6CB/hlrQVxYcNeNUxDjHlx3M/rVjWoHxsC+R5qw5AEdicI8cpmf
	 6seBlNBr9xDM3xsZJHbo8CYZ3qoTDcCeW5IR9dV1dJ/cmaKuYehtQHtO2BoNkBWrKx
	 g5V69nQQ8hIQDzu0Q1t+nQxaQUxaaxh5HKynBzAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/770] NFSD: Batch release pages during splice read
Date: Tue, 18 Jun 2024 14:33:15 +0200
Message-ID: <20240618123420.466515510@linuxfoundation.org>
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

[ Upstream commit 496d83cf0f2fa70cfe256c2499e2d3523d3868f3 ]

Large splice reads call put_page() repeatedly. put_page() is
relatively expensive to call, so replace it with the new
svc_rqst_replace_page() helper to help amortize that cost.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 8520a2fc92dee..05b5f7e241e70 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -856,15 +856,10 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct page *page = buf->page;
 
 	if (rqstp->rq_res.page_len == 0) {
-		get_page(page);
-		put_page(*rqstp->rq_next_page);
-		*(rqstp->rq_next_page++) = page;
+		svc_rqst_replace_page(rqstp, page);
 		rqstp->rq_res.page_base = buf->offset;
 	} else if (page != pp[-1]) {
-		get_page(page);
-		if (*rqstp->rq_next_page)
-			put_page(*rqstp->rq_next_page);
-		*(rqstp->rq_next_page++) = page;
+		svc_rqst_replace_page(rqstp, page);
 	}
 	rqstp->rq_res.page_len += sd->len;
 
-- 
2.43.0



