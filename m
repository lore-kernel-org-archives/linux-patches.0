Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0774A3B71DA;
	Sat, 12 Sep 2026 10:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209193; cv=none; b=LqIaRtcNrxFj/6QdFK82Iw0ZvNH9ZxODCSpFdRrj/2rQkjCqk6cIEC0f3wGjXLpCouHtapvLfu53NWnNS078f8jDJuqqePgvFUKBc8S691a5Ks1DQ6EXuYT+fTVdEbKIy1B4wkLsBloOpKZJihApnCQXFKX0cPai8kJbhx4GmW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209193; c=relaxed/simple;
	bh=EG3h/iTivuonZhhLf4TIt3xiwVW23MVG87OHrEwrxhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzMHcEMD5O09LWJSegaQFzi1LYmNVewTMkfK4rexT5BYqtMgylJsM9bJJ46NhNPNgJP+DuKeR31l95ZLP6qR5oegY3Tka+y/6Qrh7Ybgl1D0Zgygaj9b67ZsYNro562RzMnX3sTQFvW0GIVjfwvKqNT/8puaJ0jXw1+btxrjQ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pxq7Ujy8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pxq7Ujy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1AB1F000FF;
	Sat, 12 Sep 2026 10:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209191;
	bh=SV1MGZYKVoeA0L/Z05y6HBDVE857q114qwEywXM40DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pxq7Ujy8fvPaWk2BXxcS6rq+maWPRKxAmkhYk2mnquomZhJZ+qC1MuVRHecRc0VWZ
	 E6Up3Sk3ywh8sdfgOyFMu7R/9+7v8CN9WSk4WPK19H8LquM+oN3S/dwm28MhotXQdz
	 RDw+gGFycH03gTdGDpOUTEIL7tB7fj6TKk5I4tfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0770/1518] drm/msm/dpu: Drop sneaky dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:48:59 +0200
Message-ID: <20260912065640.852813912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 13cc658065c56..6524531bd8bdc 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -394,6 +394,10 @@ int dpu_core_perf_crtc_update(struct drm_crtc *crtc,
 
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



