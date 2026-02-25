Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B072C17A0;
	Wed, 25 Feb 2026 06:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002596; cv=none; b=OCxHL9q/hHffWtLwWih2swPueI0wGlZBHAncNSdBmpxa93YfuW4zQoWbpOjKiPKU0YC4vBtgykCiLttcsOeix6c+gKT3NqyeBJJwMXmaWu3TqrOKtHU/RxftmlCx6Rb/SbCeFZjJqhnEN7sBr6OBLmnjkNXklZsWjCUA0/ebu+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002596; c=relaxed/simple;
	bh=d3H/L1yQrHtA1qE+RYYYET0VbPVRs+S0nPfrCvCx2BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyRdun68QcI1ptDotxxeq+/pesGJpz9BQ44MsKelRijTr9PAukhrDxNqJkW1+W1dyPlKBsr/EzxQMyd9epWkX9n/BDv4mj3cOAXNp0AdCT9I/2l0qsC9v5jDhfTFmXqaIOETTDS5BxcupO9rHY5s8QAXfhgUp1tcqGNBIAxi7lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5zNEqlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5zNEqlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76D6C19422;
	Wed, 25 Feb 2026 06:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002596;
	bh=d3H/L1yQrHtA1qE+RYYYET0VbPVRs+S0nPfrCvCx2BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5zNEqlXuwgWXjKqr/c3C8x7tXP5gQqMF9YXGVsA8sac3EvBrt3yIvEXrZLOGvF2j
	 V3DzyNz7saimwUKEZ1NBwGaE23q72i7yXa/sAMaknMlYMMme+pJU0ysLs9yxzbsVSB
	 fwHIAvzYpw+wNW2ohrBFMsLmIOdNNJkQjGkt6Z6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 342/641] RDMA/mlx5: Fix ucaps init error flow
Date: Tue, 24 Feb 2026 17:21:08 -0800
Message-ID: <20260225012356.951226566@linuxfoundation.org>
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

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 6dc78c53de99e4ed9868d4f0fc6da6e46f52fe4d ]

In mlx5_ib_stage_caps_init(), if mlx5_ib_init_ucaps() fails after
mlx5_ib_init_var_table() succeeds, the VAR bitmap is leaked since
the function returns without cleanup.

Thus, cleanup the var table bitmap in case of error of initializing
ucaps before exiting, preventing the leak above.

Fixes: cf7174e8982f ("RDMA/mlx5: Create UCAP char devices for supported device capabilities")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260104-ib-core-misc-v1-3-00367f77f3a8@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fc1e86f6c4097..8f69c8c1ba54d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4462,12 +4462,16 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	    MLX5_HCA_CAP_2_GENERAL_OBJECT_TYPES_RDMA_CTRL) {
 		err = mlx5_ib_init_ucaps(dev);
 		if (err)
-			return err;
+			goto err_ucaps;
 	}
 
 	dev->ib_dev.use_cq_dim = true;
 
 	return 0;
+
+err_ucaps:
+	bitmap_free(dev->var_table.bitmap);
+	return err;
 }
 
 static const struct ib_device_ops mlx5_ib_dev_port_ops = {
-- 
2.51.0



