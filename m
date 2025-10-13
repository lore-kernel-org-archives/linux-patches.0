Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5761430BF7F;
	Mon, 13 Oct 2025 15:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369654; cv=none; b=PDcPKVUsorlerbdRvbJR3T+6rKCgQadG9hwVkgqBqBuZu0E18w9pDcxZAFwDEFBAAwt5udWb9ft/Lpi6oDbSO2Xbf7N2mEkboIZox0ur2RojaEcfPbob/B3qTWn3elljr09vz7m86VCaDfpNk6IfQgtFTT9mD1LzkA7kMSC1u5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369654; c=relaxed/simple;
	bh=iNXS4o4IkYNWC1VzeGoac9tVj1laaa198UomfsXv6lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dRL6Y5s/dvapDN0pSfu4oY8dvoJ6rUeeXmEEU6SbIPHPnxxxQlO8IdVJPDwMCxLqvCx5qKwNJMKY49ew+A+fyMVHhIgrloO4Zr714mChCat5Edsl2kF6sNgqnfUi0COY2fBF/vUF2Pus0mKroQGdCJwgTDzhjRUWO4UQ4gg9QkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvN5UmE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvN5UmE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B9AC4CEE7;
	Mon, 13 Oct 2025 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369654;
	bh=iNXS4o4IkYNWC1VzeGoac9tVj1laaa198UomfsXv6lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvN5UmE2t/Cuog0a5xWemTeDEVge4qreHq5/N5wJ96AX2pfful+3CHCSsgeLY3e35
	 0F64GZJBfwmdYSlhmOh/ocQhxwci5SNRF8SWzrTQzq2rpYO3yuu9xIi8UW9WHxmIK4
	 bRgX2zH0eNbqYCrLyNc+1jWcqHKfUwPhQM4zSnfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 305/563] drm/amd/pm: Adjust si_upload_smc_data register programming (v3)
Date: Mon, 13 Oct 2025 16:42:46 +0200
Message-ID: <20251013144422.315006281@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit ce025130127437dc884c84c254170e27b2ce9309 ]

Based on some comments in dm_pp_display_configuration
above the crtc_index and line_time fields, these values
are programmed to the SMC to work around an SMC hang
when it switches MCLK.

According to Alex, the Windows driver programs them to:
mclk_change_block_cp_min = 200 / line_time
mclk_change_block_cp_max = 100 / line_time
Let's use the same for the sake of consistency.

Previously we used the watermark values, but it seemed buggy
as the code was mixing up low/high and A/B watermarks, and
was not saving a low watermark value on DCE 6, so
mclk_change_block_cp_max would be always zero previously.

Split this change off from the previous si_upload_smc_data
to make it easier to bisect, in case it causes any issues.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index 6736c592dfdc6..fb008c5980d67 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -5833,8 +5833,8 @@ static int si_upload_smc_data(struct amdgpu_device *adev)
 		crtc_index = amdgpu_crtc->crtc_id;
 
 		if (amdgpu_crtc->line_time) {
-			mclk_change_block_cp_min = amdgpu_crtc->wm_high / amdgpu_crtc->line_time;
-			mclk_change_block_cp_max = amdgpu_crtc->wm_low / amdgpu_crtc->line_time;
+			mclk_change_block_cp_min = 200 / amdgpu_crtc->line_time;
+			mclk_change_block_cp_max = 100 / amdgpu_crtc->line_time;
 		}
 	}
 
-- 
2.51.0



