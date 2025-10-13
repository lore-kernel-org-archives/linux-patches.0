Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A7030CD80;
	Mon, 13 Oct 2025 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368318; cv=none; b=n8Op+It/E0d7Glftk5Tuy2lwDrZyM4RyngYitHcQRf0FDGJB4lnZk8WCLETOyDsj13ql8sEp5P97K8TBgH5zIcrWGVq47OjTPO0OTHvRONyIOfQqiSuD8NgcM5aDG3BH8cfmOS60y7dLQTuNBbPysBZe6CK1bwgmaGGAI3gCNr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368318; c=relaxed/simple;
	bh=6oSO/sy2EdHRTMuSqU69ai3TvlQTs9Ce+Z7UFzMXIDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GS0ldWpsi+6+RsuHMA6b+r/+WsSiJ0ycPq2sDyAhE3RdJSFGo9O2kW/uNb3bdi18JH7X/bvJvU7mRRBaPqvVJEnnagxRWSs7gnMXKUg56DsVHvXcOGMG97z6AsI9vGiigm6A8Ho5u0Qyqul8sYvzHO8paf1/g7UptDyAbfELwG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCwVUV7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCwVUV7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EACC4CEE7;
	Mon, 13 Oct 2025 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368317;
	bh=6oSO/sy2EdHRTMuSqU69ai3TvlQTs9Ce+Z7UFzMXIDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCwVUV7OnlUOgpRnKgVEl2Uj+iOPVj2gIYEoxxIek9N+Q+ecLLGBytXpJyzYZpZoj
	 EFu/7M1iRFBpL7xMXS63GydVfUaz1hioJwcyJHF+Ns1leM4P5qcUGca665wtCDH0wx
	 Vqzskkz+hanbWYfm4OZdegEyl9dHmNa7Yrj8oqgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/262] drm/amd/pm: Treat zero vblank time as too short in si_dpm (v3)
Date: Mon, 13 Oct 2025 16:44:22 +0200
Message-ID: <20251013144330.446999296@linuxfoundation.org>
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

[ Upstream commit 9003a0746864f39a0ef72bd45f8e1ad85d930d67 ]

Some parts of the code base expect that MCLK switching is turned
off when the vblank time is set to zero.

According to pp_pm_compute_clocks the non-DC code has issues
with MCLK switching with refresh rates over 120 Hz.

v3:
Add code comment to explain this better.
Add an if statement instead of changing the switch_limit.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index a8fe6aa6845eb..76fc08cda7480 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3066,7 +3066,13 @@ static bool si_dpm_vblank_too_short(void *handle)
 	/* we never hit the non-gddr5 limit so disable it */
 	u32 switch_limit = adev->gmc.vram_type == AMDGPU_VRAM_TYPE_GDDR5 ? 450 : 0;
 
-	if (vblank_time < switch_limit)
+	/* Consider zero vblank time too short and disable MCLK switching.
+	 * Note that the vblank time is set to maximum when no displays are attached,
+	 * so we'll still enable MCLK switching in that case.
+	 */
+	if (vblank_time == 0)
+		return true;
+	else if (vblank_time < switch_limit)
 		return true;
 	else
 		return false;
-- 
2.51.0



