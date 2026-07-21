Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9D544AB60;
	Tue, 21 Jul 2026 21:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669022; cv=none; b=TPfXqB09j1tVxZAkqC0pK560nQGIIPVnr+js1IXSWLc9DSAaysmVYf02nPMCtjK0iGPJg/w5HmGU0iAj7he3Rp1KhXx99TCSz4GzZmbJADiu3c0q+Owyh/iLCo3uTkqpheNqxh3Us9pwUjhkOcezAF3QgUsXFVwpZYl4WhZbzsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669022; c=relaxed/simple;
	bh=cksZK7YajvlX9FKADPyJIWxGgYnFi/7ttmCrle00/LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9Bt5T9vhJ1IfUC0Dbv6s8ycbnOZ45pINbcKolzeynHXfytZ3hA9Zq2LNsAFIf9I2AM2HpxpZwdovS4JNjWp2ftKcIt4DQJh7dpm1YW6lamWNGxxapkBgQY8rRUKapbyCzjNh42mO3yxK2bDhAk6NFZO3mgJ82/34u9OyBImuKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNA1Vmmj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNA1Vmmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33301F000E9;
	Tue, 21 Jul 2026 21:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669021;
	bh=4BsLid8PiJ/PYzD1rMSPcqJj9rgIyAwTHSpKzSbYKwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNA1VmmjS5U6VIqHpmkBvKK6vp4yY9iLUFTnc2IAfh0i8c0DOS7j0qOAGvaX2lAUx
	 yb5U4T7piqoGHB9DaFBjII/05MShs6chYzwZqMKVp0wmREKTYcoM+fgB2+RC019tRw
	 BRCMOX/GAK5t7QYCLkGk2AIRFPzPZzXsL6DVAkuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0397/1067] IB/mlx5: Dont take the rereg_mr fallback without a new translation
Date: Tue, 21 Jul 2026 17:16:38 +0200
Message-ID: <20260721152433.511855889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b81b03aa2a629e..ca8ebe5cdeebf2 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1463,7 +1463,7 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		}
 		/* DM or ODP MR's don't have a normal umem so we can't re-use it */
 		if (!mr->umem || is_odp_mr(mr) || is_dmabuf_mr(mr))
-			goto recreate;
+			return ERR_PTR(-EOPNOTSUPP);
 
 		/*
 		 * Only one active MR can refer to a umem at one time, revoke
-- 
2.53.0



