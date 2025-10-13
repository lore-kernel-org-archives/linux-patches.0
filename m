Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D91B34BA40;
	Mon, 13 Oct 2025 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367661; cv=none; b=dUbz5bTma/jkojSnghON+fJ5XzEQY1dltSzIo9MEnUODmGWzyd0lRwGHYIX7gPZ+jaIdjGRXPFQfkv8ozMx2PyTaSJLr2WAh0A6YvQor+PfXemrVhdQyusmoXBRmM8+HKyjUu/UMBWfuVC80z7NmWJhrqw+lqqn4XF8WOhO5nQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367661; c=relaxed/simple;
	bh=hlhFP6MtNaPxb2rz1OzGYzopiK09Ehz2ZtphqMrVjNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fS8WZ5OeFiHvJzVBsHRyny5ASET3kGyAL6WktBDjY3UwNeAk9sJncQh9FKUkAPQmZql/tx2n0DgNXs58k++s/mKUk99IbZCkOLYeiJMFOSYVcuneJ5Okh8eNJeEhcTOIexkwOAblOghBG7ubaAbXJt6Zat0bfTGqEAYiGQPqQek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cP+XRhy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cP+XRhy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CACC4CEE7;
	Mon, 13 Oct 2025 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367661;
	bh=hlhFP6MtNaPxb2rz1OzGYzopiK09Ehz2ZtphqMrVjNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cP+XRhy0UUojStEuBf9iDCLPLrLSC6aHJTQg81QoQXPI+4MkEU8W7NQkvpWNPI/WR
	 BZs3cbmCKZzwF3Q8QG/cvDqdPN83U35CNBmR26qR30A/Omyea4JR4HHuEF8KUdW8Gf
	 qoT1fVRW+8A6gESsEFljO1O+eItdD/91iYBpHkgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/196] drm/amd/pm: Treat zero vblank time as too short in si_dpm (v3)
Date: Mon, 13 Oct 2025 16:44:40 +0200
Message-ID: <20251013144318.537028313@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3ce9396900f7f..075d183bb1bb9 100644
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



