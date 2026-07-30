Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA38C19CD1D;
	Thu, 30 Jul 2026 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426045; cv=none; b=Lis8CaZD2yIbqZiwFVP403YPNz/aP92C1JH7gGHxyYnZ6oaqsqS1hPak7UXO4Bl7rcVALT/jyjYnjWHhiINkCGzgBt2M0FIRN7VQ+c04vWZ9BCZHi+qIBP8GHrxB7yaxNzbLTHStdr+zqM47eqUst5dTPdmo+oLLGRN5pl9NdG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426045; c=relaxed/simple;
	bh=/x9UUUQoQ1PzqZmnqlzNYfB8+nzyZXZzA44VZaPjFww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chUKjNPlmV4+7MUC8zKiugpwcHCDjcV6cL0k60ZO7ULmLabMRoG1El0ge/5Asy3uCVvm0qBYDYZ6w2n3bimzwyHEXegHlxHHIoxWTdIDJ7GYVrmKFQa3R8jrJJyvyOflMQ9tv8kXsk7qzIxFbHHaoQ06tfobp8kP9zqmhNsHwjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14aSftAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14aSftAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE0E1F000E9;
	Thu, 30 Jul 2026 15:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426043;
	bh=Y04nD4Vk8eNEc/03TI8yERunwZ8Sb6/Wra/yxTeUMyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14aSftADEo86MXLuBdRl5x8ieDb8kuDoDAyAJRip2hqMPE3GouD2/T3lSTS3rSMBi
	 yqgXFn39XTmjKudmRxWWam1W8yY4teNyyfBzEvgYPUk58OlXjU5sj0q5J9t61C1jx9
	 G3bktPryJQjnZwvyDufzqz9FXW2PvZFCj7zjdx40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/602] net/mlx5: DPLL, Add clock quality level op implementation
Date: Thu, 30 Jul 2026 16:10:29 +0200
Message-ID: <20260730141440.952213984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit e2017f27b6f888fb4ebc5c9a6d984bbf2f8b99ff ]

Use MSECQ register to query clock quality from firmware. Implement the
dpll op and fill-up the quality level value properly.

Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20241030081157.966604-3-jiri@resnulli.us
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 11c057d23465 ("net/mlx5: Fix MCIA register buffer overflow on 32 dword reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/dpll.c    | 81 +++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dpll.c b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
index 904e08de852eac..31142f6cc37293 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
@@ -166,9 +166,90 @@ static int mlx5_dpll_device_mode_get(const struct dpll_device *dpll,
 	return 0;
 }
 
+enum {
+	MLX5_DPLL_SSM_CODE_PRC = 0b0010,
+	MLX5_DPLL_SSM_CODE_SSU_A = 0b0100,
+	MLX5_DPLL_SSM_CODE_SSU_B = 0b1000,
+	MLX5_DPLL_SSM_CODE_EEC1 = 0b1011,
+	MLX5_DPLL_SSM_CODE_PRTC = 0b0010,
+	MLX5_DPLL_SSM_CODE_EPRTC = 0b0010,
+	MLX5_DPLL_SSM_CODE_EEEC = 0b1011,
+	MLX5_DPLL_SSM_CODE_EPRC = 0b0010,
+};
+
+enum {
+	MLX5_DPLL_ENHANCED_SSM_CODE_PRC = 0xff,
+	MLX5_DPLL_ENHANCED_SSM_CODE_SSU_A = 0xff,
+	MLX5_DPLL_ENHANCED_SSM_CODE_SSU_B = 0xff,
+	MLX5_DPLL_ENHANCED_SSM_CODE_EEC1 = 0xff,
+	MLX5_DPLL_ENHANCED_SSM_CODE_PRTC = 0x20,
+	MLX5_DPLL_ENHANCED_SSM_CODE_EPRTC = 0x21,
+	MLX5_DPLL_ENHANCED_SSM_CODE_EEEC = 0x22,
+	MLX5_DPLL_ENHANCED_SSM_CODE_EPRC = 0x23,
+};
+
+#define __MLX5_DPLL_SSM_COMBINED_CODE(ssm_code, enhanced_ssm_code)		\
+	((ssm_code) | ((enhanced_ssm_code) << 8))
+
+#define MLX5_DPLL_SSM_COMBINED_CODE(type)					\
+	__MLX5_DPLL_SSM_COMBINED_CODE(MLX5_DPLL_SSM_CODE_##type,		\
+				      MLX5_DPLL_ENHANCED_SSM_CODE_##type)
+
+static int mlx5_dpll_clock_quality_level_get(const struct dpll_device *dpll,
+					     void *priv, unsigned long *qls,
+					     struct netlink_ext_ack *extack)
+{
+	u8 network_option, ssm_code, enhanced_ssm_code;
+	u32 out[MLX5_ST_SZ_DW(msecq_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(msecq_reg)] = {};
+	struct mlx5_dpll *mdpll = priv;
+	int err;
+
+	err = mlx5_core_access_reg(mdpll->mdev, in, sizeof(in),
+				   out, sizeof(out), MLX5_REG_MSECQ, 0, 0);
+	if (err)
+		return err;
+	network_option = MLX5_GET(msecq_reg, out, network_option);
+	if (network_option != 1)
+		goto errout;
+	ssm_code = MLX5_GET(msecq_reg, out, local_ssm_code);
+	enhanced_ssm_code = MLX5_GET(msecq_reg, out, local_enhanced_ssm_code);
+
+	switch (__MLX5_DPLL_SSM_COMBINED_CODE(ssm_code, enhanced_ssm_code)) {
+	case MLX5_DPLL_SSM_COMBINED_CODE(PRC):
+		__set_bit(DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_PRC, qls);
+		return 0;
+	case MLX5_DPLL_SSM_COMBINED_CODE(SSU_A):
+		__set_bit(DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_SSU_A, qls);
+		return 0;
+	case MLX5_DPLL_SSM_COMBINED_CODE(SSU_B):
+		__set_bit(DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_SSU_B, qls);
+		return 0;
+	case MLX5_DPLL_SSM_COMBINED_CODE(EEC1):
+		__set_bit(DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EEC1, qls);
+		return 0;
+	case MLX5_DPLL_SSM_COMBINED_CODE(PRTC):
+		__set_bit(DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_PRTC, qls);
+		return 0;
+	case MLX5_DPLL_SSM_COMBINED_CODE(EPRTC):
+		__set_bit(DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EPRTC, qls);
+		return 0;
+	case MLX5_DPLL_SSM_COMBINED_CODE(EEEC):
+		__set_bit(DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EEEC, qls);
+		return 0;
+	case MLX5_DPLL_SSM_COMBINED_CODE(EPRC):
+		__set_bit(DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EPRC, qls);
+		return 0;
+	}
+errout:
+	NL_SET_ERR_MSG_MOD(extack, "Invalid clock quality level obtained from firmware\n");
+	return -EINVAL;
+}
+
 static const struct dpll_device_ops mlx5_dpll_device_ops = {
 	.lock_status_get = mlx5_dpll_device_lock_status_get,
 	.mode_get = mlx5_dpll_device_mode_get,
+	.clock_quality_level_get = mlx5_dpll_clock_quality_level_get,
 };
 
 static int mlx5_dpll_pin_direction_get(const struct dpll_pin *pin,
-- 
2.53.0



