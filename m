Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0185A248881;
	Wed, 25 Feb 2026 01:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983588; cv=none; b=gZF9tb96Th+IqJszny6ME5ATJRFm/E4s/lDrMJM3NSmmDF5t6WT5PSoMZ7uzj/ydLKDcLe+5Gg0Ucqo0e0xSxT+UvxyW9D4NaxThQa1ibyapUNhNxy7txwYcETjd4PrCOOP/sM7MkcT26WAvWu7tPLzxFRtdo+KD8074jR1G7yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983588; c=relaxed/simple;
	bh=8h7sTfDkpni79F9xB+fUCf0ZbnHhSjlF8ZqTwiVk7qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk1MEveWknAo9XEL3nfcYz+6gEqy/Ta6AYOyNZyJyBKEdb1gkpnTCLfB7TNiEziBJS2YnNx9eK/nAsXfDN4VAgx1hqIUKqRoiZO0vILzcownppfF81aV/Em5ApAIpjuTf32R0+J35Oha86wuUHwU1tY1J1hE+i1w+rw/x7qJrrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1c/PBodE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1c/PBodE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF65C116D0;
	Wed, 25 Feb 2026 01:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983587;
	bh=8h7sTfDkpni79F9xB+fUCf0ZbnHhSjlF8ZqTwiVk7qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1c/PBodE/aphGfVkLPxRIH/v6ts5GSNdeb8jdHGMkwOFyDWXrhGBzqECtxS4t6mK2
	 N2ZO+02q2cmTYDTb21gPW4BexbfHQymLxBth3p6WV3MxcuBmpd1arIe0uQgqxl7fhE
	 LKX+36xxvkBApsQ6c75ttHDeKl+ajRlWWWiDnuUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jacob Keller <Jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 686/781] net/mlx5e: Fix misidentification of ASO CQE during poll loop
Date: Tue, 24 Feb 2026 17:23:15 -0800
Message-ID: <20260225012416.597114594@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit ae3cb71e6c4dbda0c0b7c10475b744377813c7bd ]

The ASO completion poll loop uses usleep_range() which can sleep much
longer than requested due to scheduler latency. Under load, we witnessed
a 20ms+ delay until the process was rescheduled, causing the jiffies
based timeout to expire while the thread is sleeping.

The original do-while loop structure (poll, sleep, check timeout) would
exit without a final poll when waking after timeout, missing a CQE that
arrived during sleep.

Instead of the open-coded while loop, use the kernel's
read_poll_timeout() which always performs an additional check after the
sleep expiration, and is less error-prone.

Note: read_poll_timeout() doesn't accept a sleep range, by passing 10
sleep_us the sleep range effectively changes from 2-10 to 3-10 usecs.

Fixes: 739cfa34518e ("net/mlx5: Make ASO poll CQ usable in atomic context")
Fixes: 7e3fce82d945 ("net/mlx5e: Overcome slow response for first macsec ASO WQE")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <Jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260218072904.1764634-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c  | 10 +++-------
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 10 +++-------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index 7819fb2972802..d5d9146efca67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
+#include <linux/iopoll.h>
 #include <linux/math64.h>
 #include "lib/aso.h"
 #include "en/tc/post_act.h"
@@ -115,7 +116,6 @@ mlx5e_tc_meter_modify(struct mlx5_core_dev *mdev,
 	struct mlx5e_flow_meters *flow_meters;
 	u8 cir_man, cir_exp, cbs_man, cbs_exp;
 	struct mlx5_aso_wqe *aso_wqe;
-	unsigned long expires;
 	struct mlx5_aso *aso;
 	u64 rate, burst;
 	u8 ds_cnt;
@@ -187,12 +187,8 @@ mlx5e_tc_meter_modify(struct mlx5_core_dev *mdev,
 	mlx5_aso_post_wqe(aso, true, &aso_wqe->ctrl);
 
 	/* With newer FW, the wait for the first ASO WQE is more than 2us, put the wait 10ms. */
-	expires = jiffies + msecs_to_jiffies(10);
-	do {
-		err = mlx5_aso_poll_cq(aso, true);
-		if (err)
-			usleep_range(2, 10);
-	} while (err && time_is_after_jiffies(expires));
+	read_poll_timeout(mlx5_aso_poll_cq, err, !err, 10, 10 * USEC_PER_MSEC,
+			  false, aso, true);
 	mutex_unlock(&flow_meters->aso_lock);
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 528b04d4de416..641cd3a2cdfab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -5,6 +5,7 @@
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/xarray.h>
 #include <linux/if_vlan.h>
+#include <linux/iopoll.h>
 
 #include "en.h"
 #include "lib/aso.h"
@@ -1397,7 +1398,6 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	struct mlx5e_macsec_aso *aso;
 	struct mlx5_aso_wqe *aso_wqe;
 	struct mlx5_aso *maso;
-	unsigned long expires;
 	int err;
 
 	aso = &macsec->aso;
@@ -1411,12 +1411,8 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	macsec_aso_build_wqe_ctrl_seg(aso, &aso_wqe->aso_ctrl, NULL);
 
 	mlx5_aso_post_wqe(maso, false, &aso_wqe->ctrl);
-	expires = jiffies + msecs_to_jiffies(10);
-	do {
-		err = mlx5_aso_poll_cq(maso, false);
-		if (err)
-			usleep_range(2, 10);
-	} while (err && time_is_after_jiffies(expires));
+	read_poll_timeout(mlx5_aso_poll_cq, err, !err, 10, 10 * USEC_PER_MSEC,
+			  false, maso, false);
 
 	if (err)
 		goto err_out;
-- 
2.51.0



