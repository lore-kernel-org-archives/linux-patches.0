Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBF930C619;
	Mon, 13 Oct 2025 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368309; cv=none; b=rJokIkqeTb/RDjeXziRYfu7ZgpROLMhoOTPisPEyn63gE3Eels/cJ6u4K34dYQlIxaqLkw6PEpBAnZbUa+pPTf4NWcWTpcbCcrHtAGtNaRwn3UQGFRQe3+6WXT1oYEmeKF+LoJtiJ1AcwP3DX6zDJ5CXh7cA1gQPLFgCFzpJEG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368309; c=relaxed/simple;
	bh=5sHWTdvPeke7pUB/ZX4qCXhvaERqr3d/Bp4Zdv33Q2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RyQQ7sWHbwFCxPQDWZNOBKazr+IgBWXxcL9rd882+E3bkp+PFG8a1cUHH2mSRodU2M8eJlE7G7+VFGew+jLNYVUXmotXLx1uWrkZMUZLrShMR23e2tr0hLZFk50F5SYHt8jh/UlBxM3btdT962gQth72DS99fKXuTgTyE2ixq04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7MaZ1PJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7MaZ1PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0954C4CEE7;
	Mon, 13 Oct 2025 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368309;
	bh=5sHWTdvPeke7pUB/ZX4qCXhvaERqr3d/Bp4Zdv33Q2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7MaZ1PJLu5OsYQo6BSg1xDyBdqZNBw9YISuW3YQrFNpUZKX2mwTbk2h6NcMkTlC3
	 tYetX1g3ao/XaUcKcE7Q223ipfWT1EZmGO7corEi+tOOUUo1ViEeqp6I8dGY/x01mT
	 D5NbK+GNROZwMVbhvkkKr/E/M1qFmQeQ2TUiFpQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/262] drm/amd/pm: Disable ULV even if unsupported (v3)
Date: Mon, 13 Oct 2025 16:44:19 +0200
Message-ID: <20251013144330.338717849@linuxfoundation.org>
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

[ Upstream commit 3a0c3a4035f995e1f993dfaf4d63dc19e9b4bc1c ]

Always send PPSMC_MSG_DisableULV to the SMC, even if ULV mode
is unsupported, to make sure it is properly turned off.

v3:
Simplify si_disable_ulv further.
Always check the return value of amdgpu_si_send_msg_to_smc.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index a5ad1b60597e6..6a97ddcd695b5 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -5613,14 +5613,10 @@ static int si_populate_smc_t(struct amdgpu_device *adev,
 
 static int si_disable_ulv(struct amdgpu_device *adev)
 {
-	struct si_power_info *si_pi = si_get_pi(adev);
-	struct si_ulv_param *ulv = &si_pi->ulv;
+	PPSMC_Result r;
 
-	if (ulv->supported)
-		return (amdgpu_si_send_msg_to_smc(adev, PPSMC_MSG_DisableULV) == PPSMC_Result_OK) ?
-			0 : -EINVAL;
-
-	return 0;
+	r = amdgpu_si_send_msg_to_smc(adev, PPSMC_MSG_DisableULV);
+	return (r == PPSMC_Result_OK) ? 0 : -EINVAL;
 }
 
 static bool si_is_state_ulv_compatible(struct amdgpu_device *adev,
-- 
2.51.0



