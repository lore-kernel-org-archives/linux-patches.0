Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D22320C012;
	Wed, 25 Feb 2026 01:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983338; cv=none; b=c9Ua/nkqZ+DGdHAGxMl0FKfAuT4+cAO5Kn3T2EfycSVUUA0EywZ+4yyNGDogGi687g+p1VbCtk7+ORQkfDW7kixXJHStAKiwpImpdMlyr8oH/PxTv2Re6jNpt+DQtUfOIXOMvzgWJgiosQN4yL2Ro//QaUPLXl0aWlM4hX78Yxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983338; c=relaxed/simple;
	bh=pqCifMnBRNcAZlTZJ1NL4tBn7L//PdAFwlZ99jP4KRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVl/3LnDJK/OY7hm3v14+iCvO/tFmuAHWSDdmPm+ttfBXYduWLCzWTw6EmUwIx6DdK5NuMmPex2XZzDhY0ELU32PJNM2lD6lYTduEvgWnXlbtjloeNCmWHIB9wCDdw25gqghlDq9TfTaZuRINd+ssUWL+mVSxW6LgZMrHMIkJfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8B12thM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8B12thM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24A7C19423;
	Wed, 25 Feb 2026 01:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983337;
	bh=pqCifMnBRNcAZlTZJ1NL4tBn7L//PdAFwlZ99jP4KRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8B12thMJ6uqlCgMQ+Pkk/HEZt8t4FRUSP4qnk0thDUXqj0p3y4sUYDmFSbg/CbR8
	 5C2otHiWsvhcS/5/XqHTDnatd0rFzacDByh4C/lXvuCWESvs7t6Fs1D5eOwOpNP85F
	 77N0HfSDvhROJoXWtjGZJNF1GrfC4IYMdD7QR3ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 467/781] IB/mlx5: Fix port speed query for representors
Date: Tue, 24 Feb 2026 17:19:36 -0800
Message-ID: <20260225012411.275401037@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3485a9a3d75e0..9997479410005 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -561,12 +561,20 @@ static int mlx5_query_port_roce(struct ib_device *device, u32 port_num,
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



