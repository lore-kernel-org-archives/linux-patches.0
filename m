Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345EB14A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9EEC433C9;
	Thu, 24 Aug 2023 17:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897408;
	bh=AW06W62LVAZzXBqOE9EVs+qFErFEsR98R6Tst48pN7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7SBD/m4cUvvAFMcQwpSFuJlIUX47/OYFW+yxrRLUMLtXcuIQP1EKjVwMr25P/mEA
	 WnWorpqlFW67osk/qoXVVbB9fnY4IDBhbD47KiQv7VCpMEps6aeAsKHdCDskKyGNaA
	 1pcCiDxlx/ATUfhAjcJR9GhedxxJyGWY9INBatm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eran Ben Elisha <eranbe@mellanox.com>,
	Aya Levin <ayal@nvidia.com>,
	Moshe Shemesh <moshe@mellanox.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/135] net/mlx5: Refactor init clock function
Date: Thu, 24 Aug 2023 19:07:56 +0200
Message-ID: <20230824170617.285410950@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit 1436de0b991548fd859a00c889b8c4dcbbb5f463 ]

Function mlx5_init_clock() is responsible for internal PTP related metadata
initializations. Break mlx5_init_clock() to sub functions, each takes care
of its own logic.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: d00620762565 ("net/mlx5: Skip clock update work when device is in error state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 76 +++++++++++++------
 1 file changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 44a434b1178b5..3fbceb4af54e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -591,20 +591,12 @@ static int mlx5_pps_event(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-void mlx5_init_clock(struct mlx5_core_dev *mdev)
+static void mlx5_timecounter_init(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_clock *clock = &mdev->clock;
-	u64 overflow_cycles;
-	u64 ns;
-	u64 frac = 0;
 	u32 dev_freq;
 
 	dev_freq = MLX5_CAP_GEN(mdev, device_frequency_khz);
-	if (!dev_freq) {
-		mlx5_core_warn(mdev, "invalid device_frequency_khz, aborting HW clock init\n");
-		return;
-	}
-	seqlock_init(&clock->lock);
 	clock->cycles.read = read_internal_timer;
 	clock->cycles.shift = MLX5_CYCLES_SHIFT;
 	clock->cycles.mult = clocksource_khz2mult(dev_freq,
@@ -614,6 +606,15 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 
 	timecounter_init(&clock->tc, &clock->cycles,
 			 ktime_to_ns(ktime_get_real()));
+}
+
+static void mlx5_init_overflow_period(struct mlx5_clock *clock)
+{
+	struct mlx5_core_dev *mdev = container_of(clock, struct mlx5_core_dev, clock);
+	struct mlx5_ib_clock_info *clock_info = mdev->clock_info;
+	u64 overflow_cycles;
+	u64 frac = 0;
+	u64 ns;
 
 	/* Calculate period in seconds to call the overflow watchdog - to make
 	 * sure counter is checked at least twice every wrap around.
@@ -630,24 +631,53 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 	do_div(ns, NSEC_PER_SEC / HZ);
 	clock->overflow_period = ns;
 
-	mdev->clock_info =
-		(struct mlx5_ib_clock_info *)get_zeroed_page(GFP_KERNEL);
-	if (mdev->clock_info) {
-		mdev->clock_info->nsec = clock->tc.nsec;
-		mdev->clock_info->cycles = clock->tc.cycle_last;
-		mdev->clock_info->mask = clock->cycles.mask;
-		mdev->clock_info->mult = clock->nominal_c_mult;
-		mdev->clock_info->shift = clock->cycles.shift;
-		mdev->clock_info->frac = clock->tc.frac;
-		mdev->clock_info->overflow_period = clock->overflow_period;
-	}
-
-	INIT_WORK(&clock->pps_info.out_work, mlx5_pps_out);
 	INIT_DELAYED_WORK(&clock->overflow_work, mlx5_timestamp_overflow);
 	if (clock->overflow_period)
 		schedule_delayed_work(&clock->overflow_work, 0);
 	else
-		mlx5_core_warn(mdev, "invalid overflow period, overflow_work is not scheduled\n");
+		mlx5_core_warn(mdev,
+			       "invalid overflow period, overflow_work is not scheduled\n");
+
+	if (clock_info)
+		clock_info->overflow_period = clock->overflow_period;
+}
+
+static void mlx5_init_clock_info(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_clock *clock = &mdev->clock;
+	struct mlx5_ib_clock_info *info;
+
+	mdev->clock_info = (struct mlx5_ib_clock_info *)get_zeroed_page(GFP_KERNEL);
+	if (!mdev->clock_info) {
+		mlx5_core_warn(mdev, "Failed to allocate IB clock info page\n");
+		return;
+	}
+
+	info = mdev->clock_info;
+
+	info->nsec = clock->tc.nsec;
+	info->cycles = clock->tc.cycle_last;
+	info->mask = clock->cycles.mask;
+	info->mult = clock->nominal_c_mult;
+	info->shift = clock->cycles.shift;
+	info->frac = clock->tc.frac;
+}
+
+void mlx5_init_clock(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_clock *clock = &mdev->clock;
+
+	if (!MLX5_CAP_GEN(mdev, device_frequency_khz)) {
+		mlx5_core_warn(mdev, "invalid device_frequency_khz, aborting HW clock init\n");
+		return;
+	}
+
+	seqlock_init(&clock->lock);
+
+	mlx5_timecounter_init(mdev);
+	mlx5_init_clock_info(mdev);
+	mlx5_init_overflow_period(clock);
+	INIT_WORK(&clock->pps_info.out_work, mlx5_pps_out);
 
 	/* Configure the PHC */
 	clock->ptp_info = mlx5_ptp_clock_info;
-- 
2.40.1



