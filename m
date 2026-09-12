Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CD321D00A;
	Sat, 12 Sep 2026 12:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216883; cv=none; b=oL1H52kPcS63fA4uhu9KefbpTfrrrXvG8IUJgP3qr7zgY8yLx3Y6Fndc0W5WnHpIiwH1LARFpvrGoVaa725GcfCMVVAwzECY6P/jjH21ppt8L4J1VD+Mkgy2LTxfnOOVFyGMmUWRKJxzxyshtUrbAacqRBKnb4VM5/w2Tji5Bk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216883; c=relaxed/simple;
	bh=PzfVgHKUvBso7FbrEf+eIVqb7oipVqFG+SajFw1PT/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZOi1v9tlEca+XpOzqliDnO7IP4HCvc4v08P6vfTQhXm3Z5wQqxVbzWUf87otm+VWRWf91nqrRpx4OlWLDbGi4jx49v/wFea0j6avUIgX6ROVpTff3xvzbsGM4zA7cyBibMtvZDA524uvt5/utpBRO3wQeoZBlG3iq7vfyLCFxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0sLn1nG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0sLn1nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389D91F000FF;
	Sat, 12 Sep 2026 12:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216882;
	bh=ny5NVUORwt3JXPPuCRVovgZbUhtkwVstTa84O+vgJHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0sLn1nGOaLmirNYyxmzwFIZ3P6YsNU7I7DsBV4CX8GHykN3vwTB/cDTI2ZKkx+as
	 OvLAeHbjbQpYnaqdjgi+NyvbJAGkV/42hIvPlbXzl/lKNsTxDoqZ8nTzq8xG98qyb8
	 STmSxRqJmNFHvAz8U91XMtrDaTJKds/+IQdG0jFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0826/1376] drm/msm/dsi: Drop dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:54:12 +0200
Message-ID: <20260912065625.955418540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index ab97de31af5ff..77173183509f1 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -499,8 +499,6 @@ int dsi_link_clk_enable_v2(struct msm_dsi_host *msm_host)
 
 void dsi_link_clk_disable_6g(struct msm_dsi_host *msm_host)
 {
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(&msm_host->pdev->dev, 0);
 	clk_disable_unprepare(msm_host->esc_clk);
 	clk_disable_unprepare(msm_host->pixel_clk);
 	clk_disable_unprepare(msm_host->byte_intf_clk);
-- 
2.53.0



