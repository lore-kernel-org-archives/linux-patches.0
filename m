Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ED819B580;
	Thu,  6 Jun 2024 14:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683392; cv=none; b=ZcN3EW3+rmQVx6G2DI08rd7Nblpg3wtgqRXi2ojZ1cL5E6uCRahJTPaGs5d/PWshMqMt8d490ZonPZH5Li5xBKwwCKe6crDOet/z/l5nTn40wWS34unTUsUHLt0wg8BlYJ7cPFz1A8FlTSflY7pIZN1sGC9l1y4uvO72lj39CZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683392; c=relaxed/simple;
	bh=2PCQ0+LHajb7NCg8Rz0HR5zzGI3cvUN3+DfkTibFf94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enI9StSOfN0NwJ5vfcKu4XPO2JPTtbXAxE5aHK+PCKqb/kwjjKzol0VqnEGuC+lv6eKdpBvmfJ1i6ywlHmuuLsstnZ7VEsxcmPVg6++rjyLIGsKKXL0PJhX/ZHWMR7o+bjRTKf6F4soSbH+gVhmnWg+S9dU8frez+VlpsBxyEOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG6Q9WKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG6Q9WKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D75C2BD10;
	Thu,  6 Jun 2024 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683391;
	bh=2PCQ0+LHajb7NCg8Rz0HR5zzGI3cvUN3+DfkTibFf94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WG6Q9WKSEXtCOukE7LVVNVw9AZLlhHJ4N7TZV9ssLcJNRcsvP4P32+AmG4JyNooDP
	 lmW9uXxWHndyvpyESoloRrlNCFdlufiWzthhhGqTz+EUtrUlb/IFDdroDTfaHGkGbc
	 08OynuLYrB1rAuZ7PaVdco0+wjDBgMAPvBXeAE1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 336/744] RDMA/mlx5: Adding remote atomic access flag to updatable flags
Date: Thu,  6 Jun 2024 16:00:08 +0200
Message-ID: <20240606131743.234829387@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e0629898c3c06..46847249b4677 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1594,7 +1594,8 @@ static bool can_use_umr_rereg_access(struct mlx5_ib_dev *dev,
 	unsigned int diffs = current_access_flags ^ target_access_flags;
 
 	if (diffs & ~(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE |
-		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING))
+		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING |
+		      IB_ACCESS_REMOTE_ATOMIC))
 		return false;
 	return mlx5r_umr_can_reconfig(dev, current_access_flags,
 				      target_access_flags);
-- 
2.43.0



