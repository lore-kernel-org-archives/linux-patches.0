Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12CB415F0E;
	Tue, 21 Jul 2026 19:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661970; cv=none; b=FU3BI07/9eJCdkoAxMc4m2QhtsfdWjslosRu3xBQFRpvHHZeg/bz3426nKJ8jIy/1u3dCYXtwUkRMdt+8H29EtfNgzgNdIO9/G66/xHxmtQ1kb1oaSyHrAaRuv8znza7m7HkKrly7K2bRJ8KgHb9Osxz+xz0zbBpkowZvu5Qtf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661970; c=relaxed/simple;
	bh=OlRAgP9shExFWgVg8ofqfbM7fhrpCxrQrY/4RmFs578=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+8FqNUbZOuRYKYMqJgZWuQOwosF7wc++sMvuGoxI9I6fE32ZnOCt0/7TqX/9NOSmy11dyw2NRk4mG8N7vNM2gTnDgVqwtshuLvcIHzDWu8kXZpjOJBM4mgzNJY01/2n9ZLpgiT1fQVe4xSIwF2R8KlW+6lt0BgjuR4nEe2pK84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bv632GeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bv632GeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019301F000E9;
	Tue, 21 Jul 2026 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661969;
	bh=s0o5cnIrqJSi72zAIAt4mBstCmVSVVSFverCXFAbK4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bv632GeJHiR8tbIYYOMmz/DvDHn4oI1M+FOkI8Sn2AggVMKEkHacj1IaBpMuJrUNp
	 uA8AXBYoaNNYIK06G/S8VM/oIpM7FAWgghPO+sgwR+abvjZbNfbgDZztatWfrCs7zl
	 GSUC2Eec9+sVs+StHmXt+HezGTSYgMgYHaJQrqw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0266/1276] IB/mlx5: Dont take the rereg_mr fallback without a new translation
Date: Tue, 21 Jul 2026 17:11:49 +0200
Message-ID: <20260721152452.033614304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c8238db895bf16..25079fa7a8c5be 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1852,7 +1852,7 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		}
 		/* DM or ODP MR's don't have a normal umem so we can't re-use it */
 		if (!mr->umem || is_odp_mr(mr) || is_dmabuf_mr(mr))
-			goto recreate;
+			return ERR_PTR(-EOPNOTSUPP);
 
 		/*
 		 * Only one active MR can refer to a umem at one time, revoke
-- 
2.53.0



