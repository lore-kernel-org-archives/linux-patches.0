Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44732333441;
	Wed, 20 May 2026 18:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301939; cv=none; b=QWUElxGOBhqrC8DpQGp+I/k8xYikdqXnJ1o7ZqFG/wDdlxpjX8HY70Tjubn46Jp27VkIxkibn9qiqKMIrLA/8Iz+RjdAdlXT/gmVms8ZlIYPDU0egJFS/Oj1K75BuE3pvy/QdIIDuGiktLB37cFgf4xDIE5Nw+gu8dNhXADTjLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301939; c=relaxed/simple;
	bh=2SkxW0X0Xm+p9hJk88Z0kWQg7S0pKyzOMOgDgMuZcqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFWTEbdWQSmbgmPeqdlLYzZdz+0PIQV8Wfgjj7ntAkJiIYdyn11B0ESPNcT7lUQykWnP/KomzueIzkwT2p0l181pU275lCAudVfW623+iI6hTtBCF+Tr2QyD9OV/lUcheqOnmOZ4TMwyM3MB7Dc25F9yKMVjP/GtTgtxher7tv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UM22Q8Tc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UM22Q8Tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BAD1F000E9;
	Wed, 20 May 2026 18:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301937;
	bh=z+/ZB1eFABty94ATjNNfoaww+I5HnEYVAUMBn2e0ziw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UM22Q8TcXFMHLmVezLG5A+82sF7nqAsz4tbbKk6spcFTYwi34sJPQp9gEROIBv0r3
	 lTZOx/Jv3Xygof8gyqzsooqB+3b+CHLt9QrRX8riFyoUnzm4GcxXyq3ky4tsbHQHzI
	 Zc36YOwHa9AnU25Vhex35+FxD2HKLjDVAEXavKQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/508] net/mlx5e: IPsec, fix ASO poll timeout with read_poll_timeout_atomic()
Date: Wed, 20 May 2026 18:18:18 +0200
Message-ID: <20260520162100.233057849@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit edccdd1eb94712da97a6ce71123ec27890add754 ]

The do-while poll loop uses jiffies for its timeout:
  expires = jiffies + msecs_to_jiffies(10);

jiffies is sampled at an arbitrary point within the current tick, so the
first partial tick contributes anywhere from a full tick down to nearly
zero real time. For small msecs_to_jiffies() results this is
significant, the effective poll window can be much shorter than the
requested 10ms, and in the worst case the loop exits after a single
iteration (e.g., when HZ=100), well before the device has delivered the
CQE.

Replace the loop with read_poll_timeout_atomic(), which counts elapsed
time via udelay() accounting rather than jiffies, guaranteeing the full
poll window regardless of HZ.

Additionally, read_poll_timeout_atomic() executes the poll operation one
more time after the timeout has expired, giving the CQE a final chance
to be detected. The old do-while loop could exit without a final poll if
the timeout expired during the udelay() between iterations.

Fixes: 76e463f6508b ("net/mlx5e: Overcome slow response for first IPsec ASO WQE")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260409202852.158059-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c      | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index fd03aa4f47b5a..004cf295eb249 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2017, Mellanox Technologies inc. All rights reserved. */
 
+#include <linux/iopoll.h>
+
 #include "mlx5_core.h"
 #include "en.h"
 #include "ipsec.h"
@@ -591,7 +593,6 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 	struct mlx5_wqe_aso_ctrl_seg *ctrl;
 	struct mlx5e_hw_objs *res;
 	struct mlx5_aso_wqe *wqe;
-	unsigned long expires;
 	u8 ds_cnt;
 	int ret;
 
@@ -613,13 +614,8 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 	mlx5e_ipsec_aso_copy(ctrl, data);
 
 	mlx5_aso_post_wqe(aso->aso, false, &wqe->ctrl);
-	expires = jiffies + msecs_to_jiffies(10);
-	do {
-		ret = mlx5_aso_poll_cq(aso->aso, false);
-		if (ret)
-			/* We are in atomic context */
-			udelay(10);
-	} while (ret && time_is_after_jiffies(expires));
+	read_poll_timeout_atomic(mlx5_aso_poll_cq, ret, !ret, 10,
+				 10 * USEC_PER_MSEC, false, aso->aso, false);
 	if (!ret)
 		memcpy(sa_entry->ctx, aso->ctx, MLX5_ST_SZ_BYTES(ipsec_aso));
 	spin_unlock_bh(&aso->lock);
-- 
2.53.0



