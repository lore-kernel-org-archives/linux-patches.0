Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0634E30FC09;
	Mon, 13 Oct 2025 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369726; cv=none; b=sp6IMiL0V7kotahMmjHphwVxpfx4qu/B8+YEz4D+p/iyEpdMMTw71iO8JVwLZue8XHngvspNfHd9hH+h/5dkgm2QfM7AzlSJeJJyXY0/i/4Hb06BsaMxYc5lL5lfoU6Ic+56WgokyETpef/yN6eTWYu5MOQNvXk9fEaDbKt1f0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369726; c=relaxed/simple;
	bh=hUJPqrhWB3M2DTSNvEs+gyAstiGyzTxSie2GeUzqEds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KEAjPM1899b7Oab7TnhK2YLHqiXg2gWAHGtfNUm5TRkDU9EGimWAOJUAJpCk2b5qZe14TYvE1+20GbNcwKiNWwhpDuW/3Uokr8xNLvAoj0UWE8gKCgO52Zy1MpSzE4Y02N7jlxVelPZP0eA2jvdH63toQ8vGXaypErcQX7sRv/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLkAZ6m5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLkAZ6m5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3B8C4CEFE;
	Mon, 13 Oct 2025 15:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369725;
	bh=hUJPqrhWB3M2DTSNvEs+gyAstiGyzTxSie2GeUzqEds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLkAZ6m5mVcStZ90R40u60ovIEdVpEjwu6Cu5F4SN1UFwYebjBGsv3XYVAj/Vash0
	 qbTDvdC8/FgW6fRtqw9vuQmAzvO9CMhY5TulPKa0xzWreVXpW83ctnmCBhJ4Luf2Un
	 VSdZUkhIfW+H5DEm3LIptGuAYLirRnc9Rf9JL0zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 303/563] drm/amd/pm: Disable ULV even if unsupported (v3)
Date: Mon, 13 Oct 2025 16:42:44 +0200
Message-ID: <20251013144422.243809265@linuxfoundation.org>
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
index 52e732be59e36..e71070a23b915 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -5637,14 +5637,10 @@ static int si_populate_smc_t(struct amdgpu_device *adev,
 
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



