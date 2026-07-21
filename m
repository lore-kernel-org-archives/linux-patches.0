Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDF2374E6C;
	Tue, 21 Jul 2026 17:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656533; cv=none; b=i5blxoSR+o9lOR+jZqUHjXGLEY113wjbMPHPtDTTx9WpA2oniDRZ533sIa9+lzD5b276woN1mN0V2gAKCNNWnsbMvnmckZFPEn3G3ROYTc7HDu+XG8qp9TaAhoNk+zeGkRXlbZptB7lC49rDqG1JeZvuLRXYlE2rBYEsaZAZ8zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656533; c=relaxed/simple;
	bh=EPDiX76tDnOrnteQNl/Ga2n4gJfz4R9w80LnrhBj010=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkTsF77Zesxa782Z9GVUYDu83uZcO/NpUlTmLMaFLhrsUOardi2W5A8T2rOYFWQD7Gvv8A67c17hvtyB9gAPmNIJjRYorX+YTFVO6pHZK3k91Jz5WdTLrMjKTjNN4b7exj73h+OjruS6Hputi0hVCrXa6bk2ggylaqVrZQkJYAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7+cMuEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7+cMuEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848E81F00A3A;
	Tue, 21 Jul 2026 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656532;
	bh=hfq3wFBcnsk+uj7QLpubKEG/4/lpJqFJszzc89uouyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7+cMuEiONAIjIVoA8lkAY7oiWOXEdPdn1lTj+CGiadAiyFhlbN5YrAnvSqv+FVnm
	 xDT4/XAgo9RagJ29j1zEo1FdUrUWStKRk4lO3L7ViQk/9Gu3TCuPeZXh9ykAAyVbde
	 8q+BoUDT/H+Nah4QyK1qSFuHB0md/JqzEucI7GaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0380/1611] IB/mlx5: Dont take the rereg_mr fallback without a new translation
Date: Tue, 21 Jul 2026 17:08:16 +0200
Message-ID: <20260721152523.747581175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 47f720c0be59ac..374e40758359db 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1918,7 +1918,7 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		}
 		/* DM or ODP MR's don't have a normal umem so we can't re-use it */
 		if (!mr->umem || is_odp_mr(mr) || is_dmabuf_mr(mr))
-			goto recreate;
+			return ERR_PTR(-EOPNOTSUPP);
 
 		/*
 		 * Only one active MR can refer to a umem at one time, revoke
-- 
2.53.0



