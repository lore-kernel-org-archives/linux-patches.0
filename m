Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D80E26B0B3;
	Tue,  8 Apr 2025 12:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116469; cv=none; b=ii8I0MqmCgoeLTZugLiS/dirQ5lHn9kGdrf/O9UHqorK2E6y+1Sg76m/dCJG24djCfjNGMl4Mjz4FzL9FtD70nGEpRhNfjyBja2bIm2MmHTHnLxLivO/KTuAap6mUeNQf7vjss3H8zbssNRBPmnkI1YOZmzy5vzwmjvi0xjT4+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116469; c=relaxed/simple;
	bh=DjqKq2iy1w+gDd4FoOSEG5ZWmlT5u0IuoTKkzM+sgZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgd0ZYS+eQZDx6BKQUEWC2Ec/4VxeDBsEcxkFm+uLT4KL0kIfLVPxeyxoRfFqwLfGl5ZAiHGOC5pg4Sqxa9EP3BKjf4N+5fWeja4QYFhhK8I60YMfHcG6+FeQXyCC1YpRA9cEREBaOL1vbNdj69hIag+om9HDsgzgUilUcOyI+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8AcDPPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8AcDPPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFDCC4CEE5;
	Tue,  8 Apr 2025 12:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116468;
	bh=DjqKq2iy1w+gDd4FoOSEG5ZWmlT5u0IuoTKkzM+sgZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8AcDPPQQ8iWA9xdq989Zktwbq01boe41EvYZGk6w5c1bpPJogf8zi813zugYn5YU
	 Tkx/6qyGVMMcvAA+BLu12FDnFuE8QNSyMF7dd5OyzcK9BnN/B9z/B6ETxZ62AkGS64
	 tDQe5YbG+Lpce3d4VNnqwL6aVKKH9V5UpUho8ubA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/423] clk: qcom: gcc-sm8650: Do not turn off USB GDSCs during gdsc_disable()
Date: Tue,  8 Apr 2025 12:47:57 +0200
Message-ID: <20250408104849.252289689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 8b75c2973997e66fd897b7e87b5ba2f3d683e94b ]

With PWRSTS_OFF_ON, USB GDSCs are turned off during gdsc_disable(). This
can happen during scenarios such as system suspend and breaks the resume
of USB controller from suspend.

So use PWRSTS_RET_ON to indicate the GDSC driver to not turn off the GDSCs
during gdsc_disable() and allow the hardware to transition the GDSCs to
retention when the parent domain enters low power state during system
suspend.

Fixes: c58225b7e3d7 ("clk: qcom: add the SM8650 Global Clock Controller driver, part 1")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250305-topic-sm8650-upstream-fix-usb-suspend-v1-1-649036ab0557@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8650.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8650.c b/drivers/clk/qcom/gcc-sm8650.c
index 9dd5c48f33bed..fa1672c4e7d81 100644
--- a/drivers/clk/qcom/gcc-sm8650.c
+++ b/drivers/clk/qcom/gcc-sm8650.c
@@ -3497,7 +3497,7 @@ static struct gdsc usb30_prim_gdsc = {
 	.pd = {
 		.name = "usb30_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -3506,7 +3506,7 @@ static struct gdsc usb3_phy_gdsc = {
 	.pd = {
 		.name = "usb3_phy_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
-- 
2.39.5



