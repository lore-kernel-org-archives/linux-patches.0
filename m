Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8158011705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042E4C433CA;
	Mon, 11 Sep 2023 14:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443147;
	bh=2KSkbcue2oBoTklx8jOQpBug/0YeaRCTmK49JfWh9t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qcn+mUdi9Yovmg6wFNwEc/vTrzQ6esnX7ThfRBccNAd/oCCOPU3kCGfQvE5xpfIBR
	 2Gn9k/dD1khs4c17DJWORhN7gkY/8MZypvsoY0fJghYGzk24aNoagXy9kawtaOu3RD
	 xUFZzcW5LXpiDFBm44I68touN+KcSy4j0CfP/PwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 247/737] net/mlx5: Dynamic cyclecounter shift calculation for PTP free running clock
Date: Mon, 11 Sep 2023 15:41:46 +0200
Message-ID: <20230911134657.500384220@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 84a58e60038fa0366006977dba85eae16b2e3d78 ]

Use a dynamic calculation to determine the shift value for the internal
timer cyclecounter that will lead to the highest precision frequency
adjustments. Previously used a constant for the shift value assuming all
devices supported by the driver had a nominal frequency of 1GHz. However,
there are devices that operate at different frequencies. The previous shift
value constant would break the PHC functionality for those devices.

Reported-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Closes: https://lore.kernel.org/netdev/20230815151507.3028503-1-vadfed@meta.com/
Fixes: 6a4010927562 ("net/mlx5: Update cyclecounter shift value to improve ptp free running mode precision")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Tested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20230821230554.236210-1-rrameshbabu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 32 ++++++++++++++++---
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index dba4c5e2f7667..94a1635ecdd47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -32,16 +32,13 @@
 
 #include <linux/clocksource.h>
 #include <linux/highmem.h>
+#include <linux/log2.h>
 #include <linux/ptp_clock_kernel.h>
 #include <rdma/mlx5-abi.h>
 #include "lib/eq.h"
 #include "en.h"
 #include "clock.h"
 
-enum {
-	MLX5_CYCLES_SHIFT	= 31
-};
-
 enum {
 	MLX5_PIN_MODE_IN		= 0x0,
 	MLX5_PIN_MODE_OUT		= 0x1,
@@ -93,6 +90,31 @@ static bool mlx5_modify_mtutc_allowed(struct mlx5_core_dev *mdev)
 	return MLX5_CAP_MCAM_FEATURE(mdev, ptpcyc2realtime_modify);
 }
 
+static u32 mlx5_ptp_shift_constant(u32 dev_freq_khz)
+{
+	/* Optimal shift constant leads to corrections above just 1 scaled ppm.
+	 *
+	 * Two sets of equations are needed to derive the optimal shift
+	 * constant for the cyclecounter.
+	 *
+	 *    dev_freq_khz * 1000 / 2^shift_constant = 1 scaled_ppm
+	 *    ppb = scaled_ppm * 1000 / 2^16
+	 *
+	 * Using the two equations together
+	 *
+	 *    dev_freq_khz * 1000 / 1 scaled_ppm = 2^shift_constant
+	 *    dev_freq_khz * 2^16 / 1 ppb = 2^shift_constant
+	 *    dev_freq_khz = 2^(shift_constant - 16)
+	 *
+	 * then yields
+	 *
+	 *    shift_constant = ilog2(dev_freq_khz) + 16
+	 */
+
+	return min(ilog2(dev_freq_khz) + 16,
+		   ilog2((U32_MAX / NSEC_PER_MSEC) * dev_freq_khz));
+}
+
 static bool mlx5_is_mtutc_time_adj_cap(struct mlx5_core_dev *mdev, s64 delta)
 {
 	s64 min = MLX5_MTUTC_OPERATION_ADJUST_TIME_MIN;
@@ -910,7 +932,7 @@ static void mlx5_timecounter_init(struct mlx5_core_dev *mdev)
 
 	dev_freq = MLX5_CAP_GEN(mdev, device_frequency_khz);
 	timer->cycles.read = read_internal_timer;
-	timer->cycles.shift = MLX5_CYCLES_SHIFT;
+	timer->cycles.shift = mlx5_ptp_shift_constant(dev_freq);
 	timer->cycles.mult = clocksource_khz2mult(dev_freq,
 						  timer->cycles.shift);
 	timer->nominal_c_mult = timer->cycles.mult;
-- 
2.40.1



