Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099263603DB;
	Sat, 12 Sep 2026 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230498; cv=none; b=UPFsayQxDYNGDOVir19f/EJvscHgeNegeFpQg6rTLpGpcwW6KGULIcF2r1/EE51r1eGL6fKa0PQQpR9y3V2k+CgMXttKRl85QctvWB4d8WHCPL2mrSEa1A50aC1VHimKkwySKisvk63QwFkBu+VBWY1cmGO7KTFSD0vNHPOXVdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230498; c=relaxed/simple;
	bh=3yFTSQ9V8Er19c51RQpC9lX/J+tyPdXqEM6/olxGBqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0v44sFerP7d0k7JEWltWbS2Mz7a5v6kjmXzVkPuGBgfSzrc8J+mw103rrhFLDKFM6+4ZwBdQAyTimLeq++MF39uC0/ElFBEX6X19gfrt4QJPtSR9rKaK4XEHk0QuexChRBU5yNKpEvUZiG/jAoU6Di3f0LTg91nfe0+DOPnQd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sryi/o3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sryi/o3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014301F000FF;
	Sat, 12 Sep 2026 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230496;
	bh=Q1J/h3PsRgkKuPTvnKbDngqF3z6DCW+z4ekNhSER1aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sryi/o3J5mxtPaUWXfJVzNp7nVMYIYt0NkugrvxhWhrwX9WCqVsk3A7NNMl4zWuNa
	 YVxQwy2GEvnJghbGou+KAr8aoJ1i+cC0oT+d9/ecy/OZJwzI3/nou0jEx4/hvua7nw
	 +0E/XZ9P/d+hHL/PrvdGtbBk7f5FjVrO50UIbzkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0806/1191] drm/msm/dpu: Drop sneaky dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:58:54 +0200
Message-ID: <20260912065606.375330828@linuxfoundation.org>
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
index 72f043732f939..7f7557e17fafb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -394,6 +394,10 @@ int dpu_core_perf_crtc_update(struct drm_crtc *crtc,
 
 		trace_dpu_core_perf_update_clk(kms->dev, stop_req, clk_rate);
 
+		/* If we're going offline, PM callbacks will disable the clocks instead */
+		if (!clk_rate)
+			return 0;
+
 		clk_rate = min(clk_rate, kms->perf.max_core_clk_rate);
 		ret = dev_pm_opp_set_rate(&kms->pdev->dev, clk_rate);
 		if (ret) {
-- 
2.53.0



