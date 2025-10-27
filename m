Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B17332EB1;
	Mon, 27 Oct 2025 18:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591582; cv=none; b=WFJK5IxnIgyJ4RsccnpEEauH/ytGhX/WFzRR+AdFmndDdUSpyVivXG0irSopq9J6bGIcg4iggjrYhLA8Vt7un9pfNRLzpwxE5T7vQLIpxypXjMGdB7qD1D2PmMRN8RHn+KEr2thL8QIFZ6nchqdUutXzT1UhLPCrIywksCPWqaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591582; c=relaxed/simple;
	bh=tUYJWDXToLCQhHqBrXrbXZ9ZLcAbyxvDP8Xr0R6lqBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZKbhR3dQUdZ3r3UGXy2ExsLJsQgIk/mETarJUD5K9k0RCfmDJvEf1GXWT30NC5D9VYbh3KhkojCoTP2TYzs8X1X4wgLSypOdvdz6X/C/ALqIl3FrrueyDf5WihdP7ZmMi8bfJ7KZ6CQXWMsZy3umajkb271MmzKaoJHEy8fK4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHy7gnbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHy7gnbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B420C4CEF1;
	Mon, 27 Oct 2025 18:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591582;
	bh=tUYJWDXToLCQhHqBrXrbXZ9ZLcAbyxvDP8Xr0R6lqBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHy7gnbuB/wn01DSahCD1Lz7XewvZhTc3Bk4JDdS3LjASu/cPWEYVvBLZIzB5uaVE
	 PD/FcS6Ko92iaqcaTmq0DeGUhPqy959C70LRgwlVufrtYHt+lxgLSdCFvfscuoV4Vx
	 2449pirZgD/cnLvFCTaQF1/bbPotXqmsIFkZdP94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/332] drm/amd/powerplay: Fix CIK shutdown temperature
Date: Mon, 27 Oct 2025 19:35:05 +0100
Message-ID: <20251027183531.496724447@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3673a9e7ba449..e2816c88cfe52 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -4982,8 +4982,7 @@ static int smu7_get_thermal_temperature_range(struct pp_hwmgr *hwmgr,
 		thermal_data->max = table_info->cac_dtp_table->usSoftwareShutdownTemp *
 			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 	else if (hwmgr->pp_table_version == PP_TABLE_V0)
-		thermal_data->max = data->thermal_temp_setting.temperature_shutdown *
-			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
+		thermal_data->max = data->thermal_temp_setting.temperature_shutdown;
 
 	return 0;
 }
-- 
2.51.0



