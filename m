Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084AF309F12;
	Mon, 13 Oct 2025 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367147; cv=none; b=pE8DFpD0gbu5w1FHj3TSa6w+FmQDJuux5H7+SrXczvJ9uKf65o7Kc2seUMT95u6KCVlXq6l+cP1jqRM+ij3l1F369aIB6aV95SveA+vAxybhNT8Htsq/WNsceedldtUZJvh6ioWuvFT7NAhKcaROFHRDhx3wOf1d09uclvReVqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367147; c=relaxed/simple;
	bh=LPJpApwL/Apm6K0cyXnM0wPBOZ8I0BYJsdWRO4ioUek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JeLJvAgO/R+Ggl4Z/6i1wGrClcN0VX8dLsWrGwzjVMZmROZ4aQN0PnuRPm+xe8znQ1I3FzU35riJkgmktFsBkolFfcZ22Yd5dcRhC7TzYPHi24i7QxxE+IcVltb84mjHJW7MABX5A7jpq9zO/GUxencPrL4d1ePxqNeszOont8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKCwRSQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKCwRSQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802F2C4CEE7;
	Mon, 13 Oct 2025 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367146;
	bh=LPJpApwL/Apm6K0cyXnM0wPBOZ8I0BYJsdWRO4ioUek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKCwRSQrPIpYPeT5pgiX/XjSqfnkZTmsnetx4SRpTJ+4HKgA4uWB8S+UdI3aWg4qA
	 BoQdERIhNSchepWqsCf1+l5ECVS/ogJEERAk2G75aAWYT6euorouPZf8uLrH0r5tvV
	 VWgzcGHWP++DVvzB1h1KK/MAgCZVqeKXv9b3tqa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/196] drm/amd/pm: Disable MCLK switching with non-DC at 120 Hz+ (v2)
Date: Mon, 13 Oct 2025 16:44:41 +0200
Message-ID: <20251013144318.606218521@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



