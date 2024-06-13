Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC721DFD8;
	Thu, 13 Jun 2024 12:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282082; cv=none; b=nuvfo98M5kYIOVAGCLq5JrDerBsIACQ+EU5SXHSud4BxfgC4BHCruFDTCm+tAko3Kl2yH8usePMez2tXZ03rBQ06Jo7Vh7Yr/rMvF4c1a6oAbLpPsOpzjmZKDKXbueUsvaCPs8tYusdpT5HKg7WIYNMKgjwV9HgvbUOGGjbEiGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282082; c=relaxed/simple;
	bh=sKUAzMYn0vSOL/uwxcRHPfjCUF+zGHL8zrk0eezIf6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVHC5LNS79szocpQXthN9tqhDRzAjhkpXdCDjArvGEJdBrF03Y1LDb45EdJPO3VMdT3iWbj7lbKEyJEUngwn+pU9Ed5XgtilDMxD4/GJ/+24ZATkm5kBJBWSvlpo6liCCHXhOcyoqimo2s5K0e7vjJK65aPINLfNegtPUBliiqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJffbDj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJffbDj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E78C2BBFC;
	Thu, 13 Jun 2024 12:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282082;
	bh=sKUAzMYn0vSOL/uwxcRHPfjCUF+zGHL8zrk0eezIf6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJffbDj4iriSRsFMXt6Dz6LCd8lpQ7pfUx4r3Qdq6jqi7WIjwhtN8MhyLDuauqlLn
	 I3Nq9yQKs6meNSHIEfmmHuWsekLFcIFGdAm1u9QXI5M4pm6RGBN/ZFxfbKdYzeLy4N
	 OSk8+eqaYes5w2UoZTvWDBXusRzNAEPI02kZSEeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/402] RDMA/mlx5: Adding remote atomic access flag to updatable flags
Date: Thu, 13 Jun 2024 13:31:46 +0200
Message-ID: <20240613113307.948090790@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 2ca7e93bc963d9ec2f5c24d117176851454967af ]

Currently IB_ACCESS_REMOTE_ATOMIC is blocked from being updated via UMR
although in some cases it should be possible. These cases are checked in
mlx5r_umr_can_reconfig function.

Fixes: ef3642c4f54d ("RDMA/mlx5: Fix error unwinds for rereg_mr")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Link: https://lore.kernel.org/r/24dac73e2fa48cb806f33a932d97f3e402a5ea2c.1712140377.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index cf203f879d340..191078b6e9129 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1687,7 +1687,8 @@ static bool can_use_umr_rereg_access(struct mlx5_ib_dev *dev,
 	unsigned int diffs = current_access_flags ^ target_access_flags;
 
 	if (diffs & ~(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE |
-		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING))
+		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING |
+		      IB_ACCESS_REMOTE_ATOMIC))
 		return false;
 	return mlx5_ib_can_reconfig_with_umr(dev, current_access_flags,
 					     target_access_flags);
-- 
2.43.0



