Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F5246C4C6;
	Tue, 21 Jul 2026 15:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649433; cv=none; b=ltUSx3I4a0DsrzDYcDn4ozkhIwgH7ujmcnY5CWH6zGl5THK6Kry3xS4fdr79XMpctTmSHCSMciOyX5suMwy78RmigDrx4fQsjsRGsB+E+d8vkC/BxkE5551iCFkztkCd//mE4kQ2mr1CxEtBV8tPjuM/Mk5UDT5E82CLMOY+5Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649433; c=relaxed/simple;
	bh=HRlOoseKRoR09BL2+3vTLmeSjP1NQQsPr54xW6lzGV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUcAzqlU35LFej/h1g1eEOkYm5xhtnvhDGWO0wE3KVbKNsWNphdkHB6Dn/slmAq4EUNZ5coYXKmUV31NLJ68WJNd4GxPnDvHbdZ4giY2YxPguEy+fC5HAmT/CA5VVOX0yT2vpk+vX7kG80SzGpu72JqTmx6emtFAW0o45Nm8wMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi3W8LJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi3W8LJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FF81F000E9;
	Tue, 21 Jul 2026 15:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649432;
	bh=rV1yxm42mgJwWiv6Rw4K4OwZW0wTCRLwr/z0g5GrVhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pi3W8LJbApCR+WwaN0e050hVQQpzN3a9OJc+4ZxRAS3+BZ1bortdRbtffEe/ClIki
	 cu1JhHXnBFIzJGYPJaY+A5Yic5csJNxQXe7cTUC0wNIId+0DWuz6NsC09eHxp30A46
	 deLJ4nnSkuEWzMfuEVfWvJo+S2CFWnoRgOqPMElk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0549/2077] IB/mlx5: Dont take the rereg_mr fallback without a new translation
Date: Tue, 21 Jul 2026 17:03:42 +0200
Message-ID: <20260721152605.760519310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index fb40b44496f47a..d70d3e3dbd1a95 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1202,7 +1202,7 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		}
 		/* DM or ODP MR's don't have a normal umem so we can't re-use it */
 		if (!mr->umem || is_odp_mr(mr) || is_dmabuf_mr(mr))
-			goto recreate;
+			return ERR_PTR(-EOPNOTSUPP);
 
 		/*
 		 * Only one active MR can refer to a umem at one time, revoke
-- 
2.53.0



