Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521CE2C21DF;
	Wed, 25 Feb 2026 06:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002612; cv=none; b=QrooqgDtMW+JcxCUziFZ1IEgYKmIuK/PCkZQJ9peqskjEzIPbc87bBerZ8dnzIgHyDeT0DHXCAoHlBSW/VqJG7GEP4dxixGLpHhArWS89bRVGZhbmguiuZFETQYLzyuLVctefQWiz9zd2r6AYQy015oWlKyO24EuaDt7958Ole4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002612; c=relaxed/simple;
	bh=xdL7xJBK5Vx/5AHw/vq9ZKSDtqyhJTuaEu16UJKsomM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7u3Xmn7+EUh5l4YvqdzeNgNQOVcAFA4PKwmS4SmytIu7c7M3hO2t22aBu15KrHC8xXEpSLnlvQS73vc+Sa2wVrTPXWOT/tk968Keqqs2QPZe+KiUg/0KkvWlWaxkJRRVHYxWEHn1xYHJjsN303df0CYD59k1Mr9pCtb04wF+dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+4Aql/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+4Aql/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7A7C116D0;
	Wed, 25 Feb 2026 06:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002612;
	bh=xdL7xJBK5Vx/5AHw/vq9ZKSDtqyhJTuaEu16UJKsomM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+4Aql/O9G/VO0uPxnr8Dqfe2i5m7Rxdy2aaJFbnuqtS1IhF0ZJhqxs7HKdiXcioN
	 /ACHhqnAano+v1Ff8Ly6bQ8fESiEb5OPLwHwkdGHYV1VwGT7+KGCzJvFQtLC+CQpan
	 Wq0ZH3O4mpv5kqVexImsujdyk6H9LfcGhOqMc4V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/641] IB/mlx5: Fix port speed query for representors
Date: Tue, 24 Feb 2026 17:21:29 -0800
Message-ID: <20260225012357.411099741@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index b6096f9126858..5899bd5cb1623 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -557,12 +557,20 @@ static int mlx5_query_port_roce(struct ib_device *device, u32 port_num,
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



