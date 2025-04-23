Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2462028C5D2;
	Wed, 23 Apr 2025 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420709; cv=none; b=tMTv7DxXEI6XiNPxE5vRNUEuEB+qTs083GUePvxhNqVJIPZfVZlSaDhanukgc4EC7RsOeOHzxQneCn1ZRLUA4tQluGztQ0QlSpvnqTXiKjnoz/3MpU+cKOQmTaIVBWEzcqYbebtcx4M5KIF4FTFceGalHM1vzDvx+vu7TuzpThE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420709; c=relaxed/simple;
	bh=RbMABq4ZzxISwfXuOTtPD1lG5iafqfC/2vXPEn1VQh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyccIVwgZeSL2Vo97VjXW70DOifmwgE/CkptRlak6KPI80XmJ3VsjllTq9RKJuRk9FO1Amg5miXLrWXJvT3IPQsEat7Uc3ITz/tMFmWtOmevuhozy2gqXmRuhAkbzljSOh0RQRrxddncsDWnTvz57CFLpQrUX8iH2TKvkfBEkx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cisOFNJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cisOFNJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DEEC4CEE2;
	Wed, 23 Apr 2025 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420708;
	bh=RbMABq4ZzxISwfXuOTtPD1lG5iafqfC/2vXPEn1VQh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cisOFNJXGFVsziMsgsRVDpWs9sc9ejrxevQteW1UWaoqNn0uWWkgTkthzD17apUje
	 iBx+TjfL0tdo+Z8vm5KWnORmiFgGPJXQz/cunN/ugoBdn10Q6Thsr5pBY3CoCAJ5/o
	 5zfSTy44dl1D0mn2wNnJOuanqxRUGL9jdio7DfXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 115/241] drm/msm/dpu: drop rogue intr_tear_rd_ptr values
Date: Wed, 23 Apr 2025 16:42:59 +0200
Message-ID: <20250423142625.273536888@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit ddfa00afae800b3dea02fa36f3f4012a8379ae58 ]

The commit 5a9d50150c2c ("drm/msm/dpu: shift IRQ indices by 1") shifted
IRQ indices by 1, making 'NO_IRQ' to be 0 rather than -1 (and allowing
to skip the definition if the IRQ is not present).
Several platform files were sketched before that commit, but got applied
afterwards. As such, they inherited historical (and currently incorrect)
setting of .intr_tear_rd_ptr = -1 for 'NO_IRQ' value.

Drop that setting for all the affected platforms.

Fixes: 62af6e1cb596 ("drm/msm/dpu: Add support for MSM8917")
Fixes: c079680bb0fa ("drm/msm/dpu: Add support for MSM8937")
Fixes: 7a6109ce1c2c ("drm/msm/dpu: Add support for MSM8953")
Fixes: daf9a92daeb8 ("drm/msm/dpu: Add support for MSM8996")
Fixes: 7204df5e7e68 ("drm/msm/dpu: add support for SDM660 and SDM630 platforms")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/647486/
Link: https://lore.kernel.org/r/20250408-dpu-drop-intr-rd-ptr-v1-1-eeac337d88f8@oss.qualcomm.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_14_msm8937.h | 2 --
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_15_msm8917.h | 1 -
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h | 3 ---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_7_msm8996.h  | 4 ----
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h   | 3 ---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h   | 2 --
 6 files changed, 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_14_msm8937.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_14_msm8937.h
index ab3dfb0b374ea..cb89d8cf300f9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_14_msm8937.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_14_msm8937.h
@@ -132,7 +132,6 @@ static const struct dpu_intf_cfg msm8937_intf[] = {
 		.prog_fetch_lines_worst_case = 14,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 26),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 27),
-		.intr_tear_rd_ptr = -1,
 	}, {
 		.name = "intf_2", .id = INTF_2,
 		.base = 0x6b000, .len = 0x268,
@@ -141,7 +140,6 @@ static const struct dpu_intf_cfg msm8937_intf[] = {
 		.prog_fetch_lines_worst_case = 14,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 28),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 29),
-		.intr_tear_rd_ptr = -1,
 	},
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_15_msm8917.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_15_msm8917.h
index 6bdaecca67614..b2a38e62d3a93 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_15_msm8917.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_15_msm8917.h
@@ -118,7 +118,6 @@ static const struct dpu_intf_cfg msm8917_intf[] = {
 		.prog_fetch_lines_worst_case = 14,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 26),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 27),
-		.intr_tear_rd_ptr = -1,
 	},
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h
index 14f36ea6ad0eb..06859984d2a5c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h
@@ -131,7 +131,6 @@ static const struct dpu_intf_cfg msm8953_intf[] = {
 		.prog_fetch_lines_worst_case = 14,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 24),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 25),
-		.intr_tear_rd_ptr = -1,
 	}, {
 		.name = "intf_1", .id = INTF_1,
 		.base = 0x6a800, .len = 0x268,
@@ -140,7 +139,6 @@ static const struct dpu_intf_cfg msm8953_intf[] = {
 		.prog_fetch_lines_worst_case = 14,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 26),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 27),
-		.intr_tear_rd_ptr = -1,
 	}, {
 		.name = "intf_2", .id = INTF_2,
 		.base = 0x6b000, .len = 0x268,
@@ -149,7 +147,6 @@ static const struct dpu_intf_cfg msm8953_intf[] = {
 		.prog_fetch_lines_worst_case = 14,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 28),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 29),
-		.intr_tear_rd_ptr = -1,
 	},
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_7_msm8996.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_7_msm8996.h
index 491f6f5827d15..153e275513c31 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_7_msm8996.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_7_msm8996.h
@@ -241,7 +241,6 @@ static const struct dpu_intf_cfg msm8996_intf[] = {
 		.prog_fetch_lines_worst_case = 25,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 24),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 25),
-		.intr_tear_rd_ptr = -1,
 	}, {
 		.name = "intf_1", .id = INTF_1,
 		.base = 0x6a800, .len = 0x268,
@@ -250,7 +249,6 @@ static const struct dpu_intf_cfg msm8996_intf[] = {
 		.prog_fetch_lines_worst_case = 25,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 26),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 27),
-		.intr_tear_rd_ptr = -1,
 	}, {
 		.name = "intf_2", .id = INTF_2,
 		.base = 0x6b000, .len = 0x268,
@@ -259,7 +257,6 @@ static const struct dpu_intf_cfg msm8996_intf[] = {
 		.prog_fetch_lines_worst_case = 25,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 28),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 29),
-		.intr_tear_rd_ptr = -1,
 	}, {
 		.name = "intf_3", .id = INTF_3,
 		.base = 0x6b800, .len = 0x268,
@@ -267,7 +264,6 @@ static const struct dpu_intf_cfg msm8996_intf[] = {
 		.prog_fetch_lines_worst_case = 25,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 30),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 31),
-		.intr_tear_rd_ptr = -1,
 	},
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h
index 424815e7fb7dd..f247625ed7e5b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h
@@ -202,7 +202,6 @@ static const struct dpu_intf_cfg sdm660_intf[] = {
 		.prog_fetch_lines_worst_case = 21,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 24),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 25),
-		.intr_tear_rd_ptr = -1,
 	}, {
 		.name = "intf_1", .id = INTF_1,
 		.base = 0x6a800, .len = 0x280,
@@ -211,7 +210,6 @@ static const struct dpu_intf_cfg sdm660_intf[] = {
 		.prog_fetch_lines_worst_case = 21,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 26),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 27),
-		.intr_tear_rd_ptr = -1,
 	}, {
 		.name = "intf_2", .id = INTF_2,
 		.base = 0x6b000, .len = 0x280,
@@ -220,7 +218,6 @@ static const struct dpu_intf_cfg sdm660_intf[] = {
 		.prog_fetch_lines_worst_case = 21,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 28),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 29),
-		.intr_tear_rd_ptr = -1,
 	},
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h
index df01227fc3646..5ddd2b3c0cd2e 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h
@@ -147,7 +147,6 @@ static const struct dpu_intf_cfg sdm630_intf[] = {
 		.prog_fetch_lines_worst_case = 21,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 24),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 25),
-		.intr_tear_rd_ptr = -1,
 	}, {
 		.name = "intf_1", .id = INTF_1,
 		.base = 0x6a800, .len = 0x280,
@@ -156,7 +155,6 @@ static const struct dpu_intf_cfg sdm630_intf[] = {
 		.prog_fetch_lines_worst_case = 21,
 		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 26),
 		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 27),
-		.intr_tear_rd_ptr = -1,
 	},
 };
 
-- 
2.39.5



