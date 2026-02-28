Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487F4345736
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301848; cv=none; b=d/fthMclTWIJaJgr8nCC5iM3HYme12Btb2CYms+Cwsa69Xp+KmQoG6JTdcArntaar03CcSKAeNfX41WzPdV8gMjpyysPrmSCG/ZlTB33V06XOCIC5O+aNPxZj0fIpREOmgZTcgbK5il0DjcuFecPL2xaqRFrnvOo4olmSynVAmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301848; c=relaxed/simple;
	bh=HF3chHnrKdKEYbpsPKv5L5AZMviwClalfG1YdXFvt1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddBeWjwFHsAo2Gd5xcEcf4nuGuvQrxLhvkSZtPdeZ3pu4zV0xQ04SRlGAT+np1i1SVsJQxJw/Cgx4cri/Vl1xQsp8PgkbUjU1lUFtMN+VS2LQ//uddxK2kRFPU3V/LrdXANwxUIbyBHU8JJGBFyX8od48INxteePh2+lwDCjvMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcuM2Y/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcuM2Y/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F160C116D0;
	Sat, 28 Feb 2026 18:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301848;
	bh=HF3chHnrKdKEYbpsPKv5L5AZMviwClalfG1YdXFvt1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcuM2Y/myIWPrN0LnKq6C8QLucBAYsKiVFhtS+YQOHFBwoUxWTkTFZ6XcRZDt9VEO
	 W2VUTjRkvD8D8Vfc996uzyNRgbrvThBKAI/7IrYgtJFGXM9Q5ujoN+YbIF0n234NRR
	 YQCRb/8i4bhGuxxjRyf7slK5uq0a7xWvWRoPJ5yfTHMM20oqXZ5zx0c2g4l0DJShuF
	 Vv5as+WgSkpKBqXMWwnl1MbJ4Vfg5tK1iAJwMoXcVLKuriY6YngVhkqlcQSng/lbjG
	 OnErs3PYjeoK5Vt97RHGDsa6biVPNKqPLISz7r+FT5vzUCsaBtdjH5CUvn6+oySPsO
	 BRsKtU4MCvvEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Or Har-Toov <ohartoov@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 268/385] IB/mlx5: Fix port speed query for representors
Date: Sat, 28 Feb 2026 12:58:10 -0500
Message-ID: <20260228180011.1568201-268-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 18ea78e2ae83d1d86a72d21d9511927e57e2c0e1 ]

When querying speed information for a representor in switchdev mode,
the code previously used the first device in the eswitch, which may not
match the device that actually owns the representor. In setups such as
multi-port eswitch or LAG, this led to incorrect port attributes being
reported.

Fix this by retrieving the correct core device from the representor's
eswitch before querying its port attributes.

Fixes: 27f9e0ccb6da ("net/mlx5: Lag, Add single RDMA device in multiport mode")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260115-port-speed-query-fix-v2-1-3bde6a3c78e7@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 10bda03eb3388..8b2e13f1a2159 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -539,12 +539,20 @@ static int mlx5_query_port_roce(struct ib_device *device, u32 port_num,
 	 * of an error it will still be zeroed out.
 	 * Use native port in case of reps
 	 */
-	if (dev->is_rep)
-		err = mlx5_query_port_ptys(mdev, out, sizeof(out), MLX5_PTYS_EN,
-					   1, 0);
-	else
-		err = mlx5_query_port_ptys(mdev, out, sizeof(out), MLX5_PTYS_EN,
-					   mdev_port_num, 0);
+	if (dev->is_rep) {
+		struct mlx5_eswitch_rep *rep;
+
+		rep = dev->port[port_num - 1].rep;
+		if (rep) {
+			mdev = mlx5_eswitch_get_core_dev(rep->esw);
+			WARN_ON(!mdev);
+		}
+		mdev_port_num = 1;
+	}
+
+	err = mlx5_query_port_ptys(mdev, out, sizeof(out), MLX5_PTYS_EN,
+				   mdev_port_num, 0);
+
 	if (err)
 		goto out;
 	ext = !!MLX5_GET_ETH_PROTO(ptys_reg, out, true, eth_proto_capability);
-- 
2.51.0

