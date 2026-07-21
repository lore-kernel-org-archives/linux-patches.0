Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA350415F23;
	Tue, 21 Jul 2026 22:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671731; cv=none; b=F+xW2BWpZIc1ER1lYxTmRfQm8/9iuxl51LANBcCoJ2VziFCbXMRAWrkCMG5lLVdGZs+C9R0DsjIK3psoDuaE/xNbH7OsHhZAOQxQG5YnRqf74pqZ1zA/AH4UUS9sB5v7W+3vmdKPCRhRlSydvatcOQmYnuD333YZmSfLhs02aeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671731; c=relaxed/simple;
	bh=SnHDP6T99GkP058S2Fdyb9UEe6gwcydECQpjqmz6rGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0KSlBm//uo9/MjNUxCJcI7EfA2WY0g1eLf8QZPwoTECmKRzL6gWj/42dyWN/wsqOoFmvWEn4e+MGIx6WuJRPEVZJzTIPIfFdagfO3tPQUy0rryi9bYOQWhuQKS3mgQpptL5Av/UkHFXSs6Wya3UztcdrSXvaIn0romWFc0AJpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urDDgNN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urDDgNN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E0B1F000E9;
	Tue, 21 Jul 2026 22:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671730;
	bh=6jo2cx1848QXq63Yz8vCKgO7Owx5V5+QzEjonLkIxzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urDDgNN23H/UD/RIRcVLHqm+bjLXfdUe7K6+yNYfw3+FRrSIS70axD1vG6SOS6cMl
	 RAWegCJR8dufFNfMLGgtVlxoJ8Ez8Z6NKtu9XewDkydaS/9Tbab+xCsNfEUjXITF8f
	 KzjoKTwogvekd4KWxRDfCGgxNc7BmJ0YVQpk7Y+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/843] IB/mlx5: Dont take the rereg_mr fallback without a new translation
Date: Tue, 21 Jul 2026 17:19:09 +0200
Message-ID: <20260721152413.085305695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 55d339d200c908de83a408d023cfb7be779b0dd7 ]

Jumping to mlx5_ib_reg_user_mr() without IB_MR_REREG_TRANS set will use
garbage values for start, length, and iova. Recovering the original mr
parameters for ODP and DMABUF to properly recreate it is too hard in this
flow, so just fail it.

Fixes: ef3642c4f54d ("RDMA/mlx5: Fix error unwinds for rereg_mr")
Link: https://patch.msgid.link/r/1-v1-29ebd2c229b5+fd5-ib_mr_pd_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index adbd1509306a99..fca92b5128c660 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1828,7 +1828,7 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		}
 		/* DM or ODP MR's don't have a normal umem so we can't re-use it */
 		if (!mr->umem || is_odp_mr(mr) || is_dmabuf_mr(mr))
-			goto recreate;
+			return ERR_PTR(-EOPNOTSUPP);
 
 		/*
 		 * Only one active MR can refer to a umem at one time, revoke
-- 
2.53.0



