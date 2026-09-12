Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9669A39AD2A;
	Sat, 12 Sep 2026 12:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216878; cv=none; b=QENDrxiSTKaCytic2J3I7AeP0B4r0oBYoBBTcPzWJqfzCud4UEhwAl1GdQjA9K/UKU/B1TB+t+2Yg7RllZUBvB8paHHHEA3FytiLAWhrrv3pXz1Va6HmKzs/eEciBrXZP10c5cOFqAoJMfhKtosSIy78N+IX6aFwzbmPTnBThjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216878; c=relaxed/simple;
	bh=OpjwRmWFyLyJc8ab1gO03kGFDcB6CqTXEiIXnMH3ALo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cdh6wM4MoJ6rLaUWccQzGYJ3Vm1hPgGkI36z9WZBZagqMn7PgqJuvi4JwwN18z5dtl8FOvFymuny0KqMDKJK7cWoIGAqrSihsx/CqxHi0rG2KSlGsOubTTnByDPy+FyQ2cDdhuBrUtS47EKR5MlyFHDcz1Q6d8Ka+DU4T9j+Pnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIeEXTuR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIeEXTuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E53E1F000FF;
	Sat, 12 Sep 2026 12:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216877;
	bh=uoAlVNoJOMlqnygAsMx6pAabqAHwzvCxumEdlmYASNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIeEXTuRDREMyS5g+M+xNZn1c9YSqPv9EVsW7Oi9fpZiOR4aSdKoHQCVJZ+YSG/MT
	 QCjQjYYT0IfK1+I13SMxc2fLBm2+3kfFxX7T+15rB9foB/Z9Uw9xUSfXimz9g3NzN7
	 ZxyhIT2tgnYWDx3eYacFFs6fkduq17w6HMUuSQ1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0825/1376] drm/msm/dpu: Drop sneaky dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:54:11 +0200
Message-ID: <20260912065625.933396035@linuxfoundation.org>
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

[ Upstream commit 811c38907eab0f66c22c5e5708e6f8eab14d76fa ]

dev_pm_opp_set_rate(0) removes the vote specified in required-opps but
does not actually park the clock, making it run without the necessary
power backing. Prevent that from happening when
_dpu_core_perf_get_core_clk_rate() returns 0.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/742779/
Link: https://lore.kernel.org/r/20260728-topic-dpu_power-v1-1-e7783b859a70@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 260accc151d4b..d29df73c02c5f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -383,6 +383,10 @@ int dpu_core_perf_crtc_update(struct drm_crtc *crtc,
 
 		trace_dpu_core_perf_update_clk(kms->dev, !crtc->enabled, clk_rate);
 
+		/* If we're going offline, PM callbacks will disable the clocks instead */
+		if (!clk_rate)
+			return 0;
+
 		clk_rate = min(clk_rate, kms->perf.max_core_clk_rate);
 		ret = dev_pm_opp_set_rate(&kms->pdev->dev, clk_rate);
 		if (ret) {
-- 
2.53.0



