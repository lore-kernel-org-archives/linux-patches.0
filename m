Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0856A30C375;
	Mon, 13 Oct 2025 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369686; cv=none; b=lLvDYD57e03fJqPF/KQzxp3PNCTf70LNUlyvYTKVfGqDxYvV4qWRvC5VMduNz8oLUH/VpPneELxIrlqsJWDLMkr2vO5QqNidPZ748+eBnQ+OAaXyAsF0nidGl864wIBQA5WiVUemmSKFtSWKdB9BqW7LGqu1hs+w7WfT+/ELOlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369686; c=relaxed/simple;
	bh=b6vUOrzE+Zd/p9mi7jeMweqqv3bOdhbiWdrPt2yKS8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kb8MeZkq0aKL4F6ptOa8Lb2L/IRMsw+H98xn6bYEYJxaAErt7iH/Ydh54mkvxNRHk1EyMVFWuU7lfVPLiN/vFd0EyERubLAskI+PzyrqYBha12i75wa9vNOsjGfWKiR/xZLWjnznigdtVqQAF+LkM+qJV0NObHYLNuk7fLlTO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Im1AdVtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Im1AdVtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88629C116D0;
	Mon, 13 Oct 2025 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369685;
	bh=b6vUOrzE+Zd/p9mi7jeMweqqv3bOdhbiWdrPt2yKS8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Im1AdVtQpB4YvnEY9Jq1/Ru6VqOMSxTFKt5aeRM6JxKnuvWl7duMprTIO3yR/Lflb
	 FBjwXWkHAebtbIfn7ZssgpFb4KdazPW06OTwv8xh818gYICLfHIDC4GUReduzYaYLf
	 pT0aHi8KvDNsHYy4OyaoQuiJTjD/da74WTdK3KLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 306/563] drm/amd/pm: Treat zero vblank time as too short in si_dpm (v3)
Date: Mon, 13 Oct 2025 16:42:47 +0200
Message-ID: <20251013144422.350152698@linuxfoundation.org>
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
index fb008c5980d67..c11c4cc111df5 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3085,7 +3085,13 @@ static bool si_dpm_vblank_too_short(void *handle)
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



