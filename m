Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2A0243376;
	Wed, 25 Feb 2026 01:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983589; cv=none; b=WDe4FYOref2YOQUT/DaXa/M52x7b42XRBb4rS4FvT2IpbkVHasJUw3b7hw+OprWs7VeOPoMM90V9tHWysd17Wcizs5BsnrLDrtWxD+UXczWO68SAKQjjg0QcT0NhXDJUA0z32VvVD+MmwTYz0jMzEOACwGYtXrV2rX9Sb/50tEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983589; c=relaxed/simple;
	bh=KOpsJregEoTeYoCiIMeIZnI6QHHRzfWMvj9mY2IQY8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2BEcaCOS0gjlOp6K0yvj/TMUI9t3kgyz9HjxqHPjNeK6zWmIQzwkd/7A0FUFJR0oErsCZkBBDGyoSAtrTQo90IKVeEhuM80OqAxDdyH/wvG02/5I8wGYR7TJOPqVm358pJ+/FLVZNUdjz7YwMiuFjTpZjHDL5KC7DpSofV6Kyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s65tRFoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s65tRFoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7918C116D0;
	Wed, 25 Feb 2026 01:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983589;
	bh=KOpsJregEoTeYoCiIMeIZnI6QHHRzfWMvj9mY2IQY8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s65tRFoA+Ytr3AsEIwDZGSOOhSlNqa8p5ba/QOOAgoV5c90HLclIWF+nnGtJ/FvrQ
	 GpCauDDqYGjnEZwTKTl4iGeJluptWnPOjpXE3yy4DBxH83rgdzTqh53sagLkerAQO3
	 QkFQhw/YcxbMvlpp2E50wmtKnwMN1fYs5IjJ75t4=
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
Subject: [PATCH 6.19 687/781] net/mlx5: Fix misidentification of write combining CQE during poll loop
Date: Tue, 24 Feb 2026 17:23:16 -0800
Message-ID: <20260225012416.620193383@linuxfoundation.org>
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

[ Upstream commit d451994ebc7d4392610bd4b2ab339b255deb4143 ]

The write combining completion poll loop uses usleep_range() which can
sleep much longer than requested due to scheduler latency. Under load,
we witnessed a 20ms+ delay until the process was rescheduled, causing
the jiffies based timeout to expire while the thread is sleeping.

The original do-while loop structure (poll, sleep, check timeout) would
exit without a final poll when waking after timeout, missing a CQE that
arrived during sleep.

Instead of the open-coded while loop, use the kernel's poll_timeout_us()
which always performs an additional check after the sleep expiration,
and is less error-prone.

Note: poll_timeout_us() doesn't accept a sleep range, by passing 10
sleep_us the sleep range effectively changes from 2-10 to 3-10 usecs.

Fixes: d98995b4bf98 ("net/mlx5: Reimplement write combining test")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <Jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260218072904.1764634-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/wc.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wc.c b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
index 815a7c97d6b09..04d03be1bb775 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/mlx5/transobj.h>
 #include "lib/clock.h"
 #include "mlx5_core.h"
@@ -15,7 +16,7 @@
 #define TEST_WC_NUM_WQES 255
 #define TEST_WC_LOG_CQ_SZ (order_base_2(TEST_WC_NUM_WQES))
 #define TEST_WC_SQ_LOG_WQ_SZ TEST_WC_LOG_CQ_SZ
-#define TEST_WC_POLLING_MAX_TIME_JIFFIES msecs_to_jiffies(100)
+#define TEST_WC_POLLING_MAX_TIME_USEC (100 * USEC_PER_MSEC)
 
 struct mlx5_wc_cq {
 	/* data path - accessed per cqe */
@@ -359,7 +360,6 @@ static int mlx5_wc_poll_cq(struct mlx5_wc_sq *sq)
 static void mlx5_core_test_wc(struct mlx5_core_dev *mdev)
 {
 	unsigned int offset = 0;
-	unsigned long expires;
 	struct mlx5_wc_sq *sq;
 	int i, err;
 
@@ -389,13 +389,9 @@ static void mlx5_core_test_wc(struct mlx5_core_dev *mdev)
 
 	mlx5_wc_post_nop(sq, &offset, true);
 
-	expires = jiffies + TEST_WC_POLLING_MAX_TIME_JIFFIES;
-	do {
-		err = mlx5_wc_poll_cq(sq);
-		if (err)
-			usleep_range(2, 10);
-	} while (mdev->wc_state == MLX5_WC_STATE_UNINITIALIZED &&
-		 time_is_after_jiffies(expires));
+	poll_timeout_us(mlx5_wc_poll_cq(sq),
+			mdev->wc_state != MLX5_WC_STATE_UNINITIALIZED, 10,
+			TEST_WC_POLLING_MAX_TIME_USEC, false);
 
 	mlx5_wc_destroy_sq(sq);
 
-- 
2.51.0



