Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0590E350A3C;
	Tue, 21 Oct 2025 20:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076923; cv=none; b=BPRGdF673hiJFzB/7IUPCygTy+0tLmGOC7Rt/4K4khEsam7Gctez9Jkk1SAf4mjyodnNCgIKNFKMwJ7oxa0VKZPhOQL+FGJIhjNe0OtM4I4LPEh3lI8qhEETghy9qSlCgzBugTjy2BJGwLJA8SL2N4sy4EQJKKPNCipSkktXoWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076923; c=relaxed/simple;
	bh=oleEsP0whFBjkEBXvYV25q5ud+4sJ7RoMCIG5jwIUU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYLVcub5SIVRWz+vZ0lY7f7/WGTwkebgErb1hz/e7d1v6MaSJHPIxALmxgI8DPQg6dNP7fZJmcfc2ubjvU4WgjF56UhYEq0nDI1ghCdiDfS4AXCWwshendzU9BM6KvduU/X36y83niBi09GhIlItitHZoFmkcLVFF88ZrVDNL08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsPFJCcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsPFJCcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D304C4CEF1;
	Tue, 21 Oct 2025 20:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076922;
	bh=oleEsP0whFBjkEBXvYV25q5ud+4sJ7RoMCIG5jwIUU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsPFJCcFYQRM85RKUI5ZK1X+6CIzSmOp23cnSISZJkMDtT2q8jedeBD6Ar8ovXzQs
	 eC65+uArZfd0AFalzikpYIKl7NR3vMxfxuFMJl5k/5dluUj801kXSMjrQ7DIBzb/1L
	 KCx1c+RXv53OtqMzzvxrY4n88fO0DIXuB6GG6HqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/136] drm/amd/powerplay: Fix CIK shutdown temperature
Date: Tue, 21 Oct 2025 21:51:07 +0200
Message-ID: <20251021195037.868501488@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

[ Upstream commit 6917112af2ba36c5f19075eb9f2933ffd07e55bf ]

Remove extra multiplication.

CIK GPUs such as Hawaii appear to use PP_TABLE_V0 in which case
the shutdown temperature is hardcoded in smu7_init_dpm_defaults
and is already multiplied by 1000. The value was mistakenly
multiplied another time by smu7_get_thermal_temperature_range.

Fixes: 4ba082572a42 ("drm/amd/powerplay: export the thermal ranges of VI asics (V2)")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1676
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index 632a25957477e..3018e294673a5 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -5444,8 +5444,7 @@ static int smu7_get_thermal_temperature_range(struct pp_hwmgr *hwmgr,
 		thermal_data->max = table_info->cac_dtp_table->usSoftwareShutdownTemp *
 			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 	else if (hwmgr->pp_table_version == PP_TABLE_V0)
-		thermal_data->max = data->thermal_temp_setting.temperature_shutdown *
-			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
+		thermal_data->max = data->thermal_temp_setting.temperature_shutdown;
 
 	thermal_data->sw_ctf_threshold = thermal_data->max;
 
-- 
2.51.0



