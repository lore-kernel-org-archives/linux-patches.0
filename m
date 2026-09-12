Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296B0345EB9;
	Sat, 12 Sep 2026 18:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239373; cv=none; b=NwLVkTT1/XHgBMbh7Seae0caTei18gPmu+awgmMXXnf+WAn49M7FntNLUziyk3pZNyYzxoGxe/+H3qMhRPpf7NjgfJ43hb3PlW3L3UizCQrqwexO9mUG0LGWhvAPjWV/EgtlVJEszCyHiij9SlygkRwjGbovgVN15O5K3Xmk98U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239373; c=relaxed/simple;
	bh=Eiya882sWU+76gBf7t6PxDqVeSgyeCHhAcsYMXLH6Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOw+PwxCOc9LDxxALhTEp9NRwOUD4Kze8MTQ0rInBVaMkT7fz9jR66jvNBmYcwRUN8AXn0wZ2GQ33LjQAWYd22DkZm2whNc0Hb6W4JRPdR7aF2NmflRN06gIOjigR9d6Hgg7mGGBbnb0ecqBrBi4HhQDmfKENU7sBWAxGqePCcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcd1L1YS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcd1L1YS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18851F000FF;
	Sat, 12 Sep 2026 18:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239372;
	bh=ejlqBBvZCntidco4qg3YSdpbHncP/QaDBYRQUnisWxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcd1L1YS58HdvgygaAdturnjKxrdGCrklKkGy3igvJXYP9m83ppbjE/BVlvs/Mmcc
	 mZbMA3kn+8e7FkpoXKBOKsMDdl8pjrIOzW13u5cE/cAROixKl0AvWvY8D+ho4nG47y
	 AJOSn6bwnvnU6JSWJxUiyvx3OXMeK+AMZJ6EQOzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 651/935] drm/msm/dsi: Drop dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 09:01:21 +0200
Message-ID: <20260912065541.773464792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 06b7ba206561619bb34116f49e0ef26b867ce3aa ]

dev_pm_opp_set_rate(0) removes the vote specified in required-opps but
does not actually park the clock, making it run without the necessary
power backing. Drop the explicit call to it.

Every call site of ops->link_clk_disable() is followed by
pm_runtime_put(), so the power vote will be rescinded if deemed safe.

Fixes: 32d3e0feccfe ("drm/msm: dsi: Use OPP API to set clk/perf state")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/742783/
Link: https://lore.kernel.org/r/20260728-topic-dpu_power-v1-3-e7783b859a70@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 00dd0cf9e3111..dcee10eaa70ed 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -656,8 +656,6 @@ int dsi_link_clk_enable_v2(struct msm_dsi_host *msm_host)
 
 void dsi_link_clk_disable_6g(struct msm_dsi_host *msm_host)
 {
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(&msm_host->pdev->dev, 0);
 	clk_disable_unprepare(msm_host->esc_clk);
 	clk_disable_unprepare(msm_host->pixel_clk);
 	if (msm_host->byte_intf_clk)
-- 
2.53.0



