Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE082264AB;
	Sat, 12 Sep 2026 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230502; cv=none; b=FqwqpsUJLnXWtapyTvQ0z3BtR6ovs5o7ZRzcfofOF+K/DAXEYEOh6t6ND6Qa7yRCSC3gWejq6vi0VPoehRXrK6OU/aiMfMDpuCAlrQDm9iSm98qeFgQoQnvt8vN/7HwMvwHsq/Iz/4Cn/5YI7m0VDEEW0Quo09Wx2+7RPjfjQ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230502; c=relaxed/simple;
	bh=4InSlYK8atmZCH6IEAd/aZkZ+uaCCXEXKhBpVxEGYOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw+vlFDvrSkU0LGMOqjeNNCkxwwei1nQFY0vso8Qtqin8q2A3FA5V3GJj/uoXW2q0kXBWzH2zjgmbiwsVpXtIq1yF4OQBlfuEDqGgz2euolAPbsoQJq3j8cdZqkNOTBnHqVxP6To6uY8JY9tuLygcXjeLAM+/KaLvrOOjQcIzsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeJtaINH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeJtaINH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C791F000FF;
	Sat, 12 Sep 2026 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230501;
	bh=rkH/h5dqZ8gHmXVyYr7507BXOeIq40/3NhOWoZ5tLj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LeJtaINH3PafF89w313bFRrx7CMpVvN/S/Q5EZ7i0590weom8O/ZcsJZ7oZHvcu1C
	 pvNZG98XKRPnysJmG4ori3o8h4GyZ2FZ9da7YmxJTTiiq5P9jYAyIY0D1Q7m04Kbap
	 itFk73XkBu6XpQIU+LaaFGGxy55vxtUZFfVsKsNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0807/1191] drm/msm/dsi: Drop dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:58:55 +0200
Message-ID: <20260912065606.396765292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 80f121fb22b97..335c15e430b73 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -555,8 +555,6 @@ int dsi_link_clk_enable_v2(struct msm_dsi_host *msm_host)
 
 void dsi_link_clk_disable_6g(struct msm_dsi_host *msm_host)
 {
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(&msm_host->pdev->dev, 0);
 	clk_disable_unprepare(msm_host->esc_clk);
 	clk_disable_unprepare(msm_host->pixel_clk);
 	clk_disable_unprepare(msm_host->byte_intf_clk);
-- 
2.53.0



