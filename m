Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CC32FF642;
	Mon, 13 Oct 2025 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368320; cv=none; b=JUdejLCiMNdVEiqVJLJFKSL2FoAyoO/Ff19EFGsAcJuglU7FkyAXN9h8BdJewYZ+239n8skdcOnYQ2MX5z1keP7MRP8O1iUJUNTKP5az4DYfBfXS+aeG0DEV36lY6AtwazAJAG8qwM9jF4tndYWC9DrqFjlzHlIDqYUrL2Jwf1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368320; c=relaxed/simple;
	bh=MEoJA228dxQU7hernWcMiEBX/8nIC+n0GQC21M4n6PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DyKErdjSOld2uCj+/CWAxvAz9DqRVTP8GgQFUQ+xJjUxkLsacH01ASq/8it6DXFrvhi/gQIoz/FaW2qHBfG2PfwINXwOyLU8iOsU/OoSEggIieD/i+rCEWbaC9PagI+Ns9KvGZ9moDKLAiyrDKe0cxq+huOkvPfbsgBATSX00cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0AEsRj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0AEsRj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49077C4CEFE;
	Mon, 13 Oct 2025 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368320;
	bh=MEoJA228dxQU7hernWcMiEBX/8nIC+n0GQC21M4n6PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0AEsRj18HNfr5VaNBzzV2s+Qij4gyLTlBzLmoqI7a3Z9j24DYnUi7VGXTubRO8tE
	 Q7LA+c8Hgnv8+vGAOQqYKnTlVjHPsiCRu6tXUumxiErkNDd066fSNYyuhdVpcSDqLD
	 qDR7/b5Gcp3D08txPjOb91+8YwBQfGJdoVU1cbuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/262] drm/amd/pm: Disable MCLK switching with non-DC at 120 Hz+ (v2)
Date: Mon, 13 Oct 2025 16:44:23 +0200
Message-ID: <20251013144330.483163724@linuxfoundation.org>
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

[ Upstream commit ed3803533c7bf7df88bc3fc9f70bd317e1228ea8 ]

According to pp_pm_compute_clocks the non-DC display code
has "issues with mclk switching with refresh rates over 120 hz".
The workaround is to disable MCLK switching in this case.

Do the same for legacy DPM.

Fixes: 6ddbd37f1074 ("drm/amd/pm: optimize the amdgpu_pm_compute_clocks() implementations")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c
index 42efe838fa85c..2d2d2d5e67634 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c
@@ -66,6 +66,13 @@ u32 amdgpu_dpm_get_vblank_time(struct amdgpu_device *adev)
 					(amdgpu_crtc->v_border * 2));
 
 				vblank_time_us = vblank_in_pixels * 1000 / amdgpu_crtc->hw_mode.clock;
+
+				/* we have issues with mclk switching with
+				 * refresh rates over 120 hz on the non-DC code.
+				 */
+				if (drm_mode_vrefresh(&amdgpu_crtc->hw_mode) > 120)
+					vblank_time_us = 0;
+
 				break;
 			}
 		}
-- 
2.51.0



