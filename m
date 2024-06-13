Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25036143C46;
	Thu, 13 Jun 2024 12:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281375; cv=none; b=sM+yIAllfZHGeoxEOOuKA1f/swqeJ7FBbT0RhkY/OF9gSQAP1VdMboAZInht2N6fn6PsL9eAoM5/zwyoqG8+pa6kzMz1eBvE4avN46QCy+ht9TZ7S0Vez27PxvKSJDy1Hf9f9L12ITUHSaZ7iq361du6taf0gFdT0XrEkvCJSSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281375; c=relaxed/simple;
	bh=47YV7xC5p8KLML9oIDMLbay1LeAzWdmLynj8kVpgcu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2gzH9vBIh2vA2eux5vWnFcz1/IKWJxiIn2EEsVk6+2V8S9LuNytlhk7DtvlXHuJhhZbH+hmxgD8AJ5+wEDdQ2QUrQi868G7nO8XxQ+FpJ/XCVOwcrzDdyiD7Gv8cj0DHDq6bF6wXqVbgYpOm27neGighZEjGI/ktIA5ZPz6nCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bR7CyoiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bR7CyoiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D33EC2BBFC;
	Thu, 13 Jun 2024 12:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281375;
	bh=47YV7xC5p8KLML9oIDMLbay1LeAzWdmLynj8kVpgcu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bR7CyoiH41kOyZzPAD1vHxxF49wrDlWACaM2EVPwpg2izGw+imZYx9ziG7jasc7cy
	 FyrALaQFmiCZ418uFDwyqoEEY6OA36rVB4E7CkJAfDYx0MkMa0ehzPyl3p59JprLti
	 ga44A/rNu0+OBDemMlCgwjZVXAohbtyuN0ptEsMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/317] drm/msm/dpu: Always flush the slave INTF on the CTL
Date: Thu, 13 Jun 2024 13:33:41 +0200
Message-ID: <20240613113255.408698188@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 2b938c3ab0a69ec6ea587bbf6fc2aec3db4a8736 ]

As we can clearly see in a downstream kernel [1], flushing the slave INTF
is skipped /only if/ the PPSPLIT topology is active.

However, when DPU was originally submitted to mainline PPSPLIT was no
longer part of it (seems to have been ripped out before submission), but
this clause was incorrectly ported from the original SDE driver.  Given
that there is no support for PPSPLIT (currently), flushing the slave
INTF should /never/ be skipped (as the `if (ppsplit && !master) goto
skip;` clause downstream never becomes true).

[1]: https://git.codelinaro.org/clo/la/platform/vendor/opensource/display-drivers/-/blob/display-kernel.lnx.5.4.r1-rel/msm/sde/sde_encoder_phys_cmd.c?ref_type=heads#L1131-1139

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/589901/
Link: https://lore.kernel.org/r/20240417-drm-msm-initial-dualpipe-dsc-fixes-v1-3-78ae3ee9a697@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
index 8493d68ad8417..e1a97c10c0e41 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -448,9 +448,6 @@ static void dpu_encoder_phys_cmd_enable_helper(
 
 	_dpu_encoder_phys_cmd_pingpong_config(phys_enc);
 
-	if (!dpu_encoder_phys_cmd_is_master(phys_enc))
-		return;
-
 	ctl = phys_enc->hw_ctl;
 	ctl->ops.get_bitmask_intf(ctl, &flush_mask, phys_enc->intf_idx);
 	ctl->ops.update_pending_flush(ctl, flush_mask);
-- 
2.43.0



