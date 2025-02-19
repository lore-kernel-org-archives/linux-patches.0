Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8304E1E1A08;
	Wed, 19 Feb 2025 08:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954608; cv=none; b=Lfe5xdiWZmjh71UJXrwdlNCVmTD6ZyYgbjlQz97lEmtdghN8KOcdz7CTmCtkpt1/u3BSNxbOGNulTQJJ4n3Nc4kUgRjP6EV1SFUzY9SoRg/tOsOM9xNVXXE+Dhi0jvnSjq34FGghVGGiQgC/mwlfpXT4FXgCM6LYQmtJth4m/Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954608; c=relaxed/simple;
	bh=Ul9v0zM1X0XzRoZCoFO2jGjkQYAwRrufBLXnSBPvHOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSOfM1EvkBniLJ8u73AtoqZeM2grzIHsvU+VKekK5nsUnOy8R3VbzeiQ4ATAoa4b8Cq2kmRV8Z6oDSZSZU4ukOdvV3YRHNfT7UFo/fCDWT4M17WuX0g30eHvp9wVvpgNnt8SoCmkrO8THaHLJ+oxASAKih+QGPobOYjZ3rGW4L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5oh0fTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5oh0fTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B85C4CED1;
	Wed, 19 Feb 2025 08:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954608;
	bh=Ul9v0zM1X0XzRoZCoFO2jGjkQYAwRrufBLXnSBPvHOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5oh0fTZbZlyeW1iW4uRAv8zgPO/TQaGzTra+DfCmZ21mvyJFuV3toWUYdC0LImUw
	 EDb/m8hHBoEXpErNb7H579/nKypv+9nQqmv4nz5cQ++aZfXfCbrhXhIn5EAW7dcGwc
	 0FPfSA9Ou6ChogyGr7+hP4sTrd6gzLoZIxDZmbQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.13 257/274] drm/msm/dpu: fix x1e80100 intf_6 underrun/vsync interrupt
Date: Wed, 19 Feb 2025 09:28:31 +0100
Message-ID: <20250219082619.640789306@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit ce55101e6ba188296dbdb9506665d26f23110292 upstream.

The IRQ indexes for the intf_6 underrun/vsync interrupts are swapped.
DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 16) is the actual underrun interrupt and
DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 17) is the vsync interrupt.

This causes timeout errors when using the DP2 controller, e.g.
  [dpu error]enc37 frame done timeout
  *ERROR* irq timeout id=37, intf_mode=INTF_MODE_VIDEO intf=6 wb=-1, pp=2, intr=0
  *ERROR* wait disable failed: id:37 intf:6 ret:-110

Correct them to fix these errors and make DP2 work properly.

Cc: stable@vger.kernel.org
Fixes: e3b1f369db5a ("drm/msm/dpu: Add X1E80100 support")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/624681/
Link: https://lore.kernel.org/r/20241115-x1e80100-dp2-fix-v1-1-727b9fe6f390@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h
@@ -391,8 +391,8 @@ static const struct dpu_intf_cfg x1e8010
 		.type = INTF_DP,
 		.controller_id = MSM_DP_CONTROLLER_2,
 		.prog_fetch_lines_worst_case = 24,
-		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 17),
-		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 16),
+		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 16),
+		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 17),
 	}, {
 		.name = "intf_7", .id = INTF_7,
 		.base = 0x3b000, .len = 0x280,


