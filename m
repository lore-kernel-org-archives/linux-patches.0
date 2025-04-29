Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FFA24A07B;
	Tue, 29 Apr 2025 17:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947675; cv=none; b=ZZzg8m9WkTQItP8C7CVbzt4qxHwyvzUv+BxTNXYAbwulbBWTU1GalhIPyD+zN7TBpS0QZ7oHTQRfzXH3L1zk4MoiKtkmtWgxdu673TX6bGVQKs8vIVwuJgiiJ8AedHoWWwWYz1/ws9OzjbUsS2DKJdwNQInnDsK0qCGvyNg1XAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947675; c=relaxed/simple;
	bh=YYjN2cqQnnPjmG5/Et03wK/qfGw3f7CNa765I2TU2NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/tWJC6mpHQveC+frc4Jxj4lB9csXkzlJQ5OwDLxFCzt52+/VW8NfCPiRwL3MP1HyJ7CC93nl9kbMYA33H/XoN30PNTKtYkFJQirdvGCjjDm6XjIj4KrnlL9XPhiZGjJRQdpboZ4Lq1APe862CI7XxluqJterWk6QzCwCO1S0pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkiJlnIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkiJlnIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D265EC4CEE9;
	Tue, 29 Apr 2025 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947675;
	bh=YYjN2cqQnnPjmG5/Et03wK/qfGw3f7CNa765I2TU2NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkiJlnIjKzPopkdTa17jSElR2S7PeCWH1mKokyS5bNwbhan3fm9mpavO+j3o7Y3Qg
	 g3/PfrJ5cmhXha/HD/UvafHRrOGO7X8bTRYO+BMfoP19nw2cWHxfCXbz7eGsOEmkou
	 9yIpXG1u3f+yJXeX4GLRr35PLErBuz4i8M7Aux7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/280] scsi: ufs: exynos: Add gs101_ufs_drv_init() hook and enable WriteBooster
Date: Tue, 29 Apr 2025 18:39:43 +0200
Message-ID: <20250429161116.844193868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit 9cc4a4a5767756b1ebe45a76c4673432545ea70e ]

Factor out the common code into a new exynos_ufs_shareability() function
and provide a dedicated gs101_drv_init() hook.

This allows us to enable WriteBooster capability (UFSHCD_CAP_WB_EN) in a
way that doesn't effect other SoCs supported in this driver.

WriteBooster improves write speeds by enabling a pseudo SLC cache. Using
the 'fio seqwrite' test we can achieve speeds of 945MB/s with this
feature enabled (until the cache is exhausted) before dropping back to
~260MB/s (which are the speeds we see without the WriteBooster feature
enabled).

Assuming the UFSHCD_CAP_WB_EN capability is set by the host then
WriteBooster can also be enabled and disabled via sysfs so it is
possible for the system to only enable it when extra write performance
is required.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20241031150033.3440894-10-peter.griffin@linaro.org
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 68f5ef7eebf0 ("scsi: ufs: exynos: Move UFS shareability value to drvdata")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 8adf11f37c0d7..149c8127cf556 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -198,7 +198,7 @@ static inline void exynos_ufs_ungate_clks(struct exynos_ufs *ufs)
 	exynos_ufs_ctrl_clkstop(ufs, false);
 }
 
-static int exynosauto_ufs_drv_init(struct exynos_ufs *ufs)
+static int exynos_ufs_shareability(struct exynos_ufs *ufs)
 {
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
 
@@ -214,6 +214,21 @@ static int exynosauto_ufs_drv_init(struct exynos_ufs *ufs)
 	return 0;
 }
 
+static int gs101_ufs_drv_init(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	/* Enable WriteBooster */
+	hba->caps |= UFSHCD_CAP_WB_EN;
+
+	return exynos_ufs_shareability(ufs);
+}
+
+static int exynosauto_ufs_drv_init(struct exynos_ufs *ufs)
+{
+	return exynos_ufs_shareability(ufs);
+}
+
 static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -2128,7 +2143,7 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
 				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_UFSPR_SECURE |
 				  EXYNOS_UFS_OPT_TIMER_TICK_SELECT,
-	.drv_init		= exynosauto_ufs_drv_init,
+	.drv_init		= gs101_ufs_drv_init,
 	.pre_link		= gs101_ufs_pre_link,
 	.post_link		= gs101_ufs_post_link,
 	.pre_pwr_change		= gs101_ufs_pre_pwr_change,
-- 
2.39.5



