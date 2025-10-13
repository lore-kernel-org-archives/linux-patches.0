Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834C030CD80;
	Mon, 13 Oct 2025 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368315; cv=none; b=Xb2M39t5LKVMKiTqZJDFOl8zaZBkozB+upQ83kJTpLITY+anhjoGNXMbmGALOCxQO0ig9CbkO/9LXI7/pnRMmcH0hKf7i/DckWQ2ArGRTldQMZrCLhp+4g01KJjqT9wgOsHcxp6bKlODn7FK/vunVWjeKTGGGRzAyPUynHPtvxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368315; c=relaxed/simple;
	bh=UCm4saks1B3I7gt0SDBtZVYv2GpICc24XbkXddXzdDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pOUzE9fDwNbpGv/HTfOCOXz8Cub2remnm1+Lf0PiXSm1LrDF+jCMWJukV7QZhGv/gZ3HlmG0v8bhCLDCLSJS/7PAivlWX966uDNmSLJ938OndCpa3HZGW79JM/+iNJJBdG8Eq7P6sUU7N9s6mMNgyO9+dRU+DU35cRT2JY9xY3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6yiUldn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6yiUldn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA233C4CEE7;
	Mon, 13 Oct 2025 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368315;
	bh=UCm4saks1B3I7gt0SDBtZVYv2GpICc24XbkXddXzdDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6yiUldn2fy6h5/FcAgBxo4Sekt/53pz5pw/HZF60wYo/0E/6r+Dk4B4E/CY2K1pL
	 UpWifZU1AEd+nUtnQzKXIv2ittfG2f0qZyBfM8taZm4uPTFIG16siepIBjUw9Hh/2h
	 m1G418J0/Pe+n2Y1Bk6/w8TFIYA95Y2CPPHt8wxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/262] drm/amd/pm: Adjust si_upload_smc_data register programming (v3)
Date: Mon, 13 Oct 2025 16:44:21 +0200
Message-ID: <20251013144330.411709731@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 341f2d796aeeb..a8fe6aa6845eb 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -5809,8 +5809,8 @@ static int si_upload_smc_data(struct amdgpu_device *adev)
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



