Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C111A3F076C;
	Wed,  4 Feb 2026 15:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219310; cv=none; b=AxUaNEHK3okDGz5dLcJN74iCsxJOAOUWdpBlWiQThH6iEC8T0UvtJcOTU9vO+etoc00UlHkWGm0Szlgzy+slBIg0ocYrhpcZ0zeHwOp5XTdtupHOTJGx+OgAHt/ZHyPXBFW/VScLw9WnYUIzBy9sSDZXErUtoYl1H/9UuRU53zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219310; c=relaxed/simple;
	bh=FWtSHNZ16WuwizBP16mIc9b5oUkq/ovx/5wkfl0oEkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdZKDB2VAz0Fb8Qgj4vY3+rf7OVSbtRLy4hxVwkh56bx5LIwIPzMVtjUAi1mzdturLtOjY0M3Yz8TYs+gYrn8NW6/8B9QL5MuQw+WdcDfhHtnBd/cmQllFp29JiMfwnlO+6Izb83PAzabhwBXM3cXDylEU1mtoIE3tM3JN8lNUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAliCEiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAliCEiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B80C4CEF7;
	Wed,  4 Feb 2026 15:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219310;
	bh=FWtSHNZ16WuwizBP16mIc9b5oUkq/ovx/5wkfl0oEkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAliCEiqn+ij8pFis2ZrKWkWY5Y9JkNgvZXKeK5vKHQi8xay5K4vYHHEGPwbqNxR9
	 KwCI+N6nQPbfxU/YILJ0UuRWM14xuEZBIfit7+4TTlMujPyXTugTOK7iNgqEvV+2yz
	 hE/fqAV8Z7Y9vyZtlSwlshiQ5dbpliKXgUI9OrxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.18 103/122] drm/msm/a6xx: fix bogus hwcg register updates
Date: Wed,  4 Feb 2026 15:41:25 +0100
Message-ID: <20260204143855.558139635@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit dedb897f11c5d7e32c0e0a0eff7cec23a8047167 upstream.

The hw clock gating register sequence consists of register value pairs
that are written to the GPU during initialisation.

The a690 hwcg sequence has two GMU registers in it that used to amount
to random writes in the GPU mapping, but since commit 188db3d7fe66
("drm/msm/a6xx: Rebase GMU register offsets") they trigger a fault as
the updated offsets now lie outside the mapping. This in turn breaks
boot of machines like the Lenovo ThinkPad X13s.

Note that the updates of these GMU registers is already taken care of
properly since commit 40c297eb245b ("drm/msm/a6xx: Set GMU CGC
properties on a6xx too"), but for some reason these two entries were
left in the table.

Fixes: 5e7665b5e484 ("drm/msm/adreno: Add Adreno A690 support")
Cc: stable@vger.kernel.org	# 6.5
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Fixes: 188db3d7fe66 ("drm/msm/a6xx: Rebase GMU register offsets")
Patchwork: https://patchwork.freedesktop.org/patch/695778/
Message-ID: <20251221164552.19990-1-johan@kernel.org>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
(cherry picked from commit dcbd2f8280eea2c965453ed8c3c69d6f121e950b)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -501,8 +501,6 @@ static const struct adreno_reglist a690_
 	{REG_A6XX_RBBM_CLOCK_CNTL_GMU_GX, 0x00000222},
 	{REG_A6XX_RBBM_CLOCK_DELAY_GMU_GX, 0x00000111},
 	{REG_A6XX_RBBM_CLOCK_HYST_GMU_GX, 0x00000555},
-	{REG_A6XX_GPU_GMU_AO_GMU_CGC_DELAY_CNTL, 0x10111},
-	{REG_A6XX_GPU_GMU_AO_GMU_CGC_HYST_CNTL, 0x5555},
 	{}
 };
 


