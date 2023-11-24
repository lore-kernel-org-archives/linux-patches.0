Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C3C39FE3;
	Fri, 24 Nov 2023 18:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaDNcJKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE94C433C8;
	Fri, 24 Nov 2023 18:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849588;
	bh=r53A8FG+gbbJArRsk/feOryTVyF1QNVwrf97LWQDu9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaDNcJKz17H+Y+gW6CtSYZVYcq/mGUnxiNUQv9r4DtZNnPxtCVqJ/JZYNP/6rTSz8
	 GNo5/Y6hsrvA7Pp2/A8ovuQKwWZldidwfP25PB1yoBiBrqKYudqG30zhzgVFlJe1tn
	 VE7PPajzgG2v5sU4r4D7Ac6t1BxKgFsz7xDHX4wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/530] net/mlx5: Decouple PHC .adjtime and .adjphase implementations
Date: Fri, 24 Nov 2023 17:46:23 +0000
Message-ID: <20231124172034.670578991@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit fd64fd13c49a53012ce9170449dcd9eb71c11284 ]

When running a phase adjustment operation, the free running clock should
not be modified at all. The phase control keyword is intended to trigger an
internal servo on the device that will converge to the provided delta. A
free running counter cannot implement phase adjustment.

Fixes: 8e11a68e2e8a ("net/mlx5: Add adjphase function to support hardware-only offset control")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20231114215846.5902-5-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index aa29f09e83564..0c83ef174275a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -384,7 +384,12 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 static int mlx5_ptp_adjphase(struct ptp_clock_info *ptp, s32 delta)
 {
-	return mlx5_ptp_adjtime(ptp, delta);
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
+	struct mlx5_core_dev *mdev;
+
+	mdev = container_of(clock, struct mlx5_core_dev, clock);
+
+	return mlx5_ptp_adjtime_real_time(mdev, delta);
 }
 
 static int mlx5_ptp_freq_adj_real_time(struct mlx5_core_dev *mdev, long scaled_ppm)
-- 
2.42.0



