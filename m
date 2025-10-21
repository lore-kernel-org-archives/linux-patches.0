Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B4E2773F1;
	Tue, 21 Oct 2025 20:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077456; cv=none; b=ueowuL0T9ww/JByA3XdSjtYRP5k1C/73RJ+7IhIpbw8rZG9CxrRyIqWlQ7/EknaIQW6KrC74atPHfLmymNe04NJ9e+0kHcbjOSuTjCjz5enQwP76fE93Wx2Jf6oZdbKs4d0yLuhg7jh9Z+GXPg4Du5SipeJ80M/cnX7zkJV6UuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077456; c=relaxed/simple;
	bh=zUCB2teSguGcry1D0MpUNo8ViGBuqPrHpVtdVfrvZx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jn6o4xGlie2tYoNaJrf49dqjqdlaGzsJ/uZCHWUvHQdTnoS4AHqXonveQE3PUiDY87fjlTBqG7Xtd57EVRerXZiUS2T2nrZOKX8y9Q5EcJShqPuzffMZGfSd145n2zP6rxbQpWD06JIdnjx8k0FL6Ed459gCBrCRUAldXNknfaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cj23OmIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cj23OmIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E737C4CEF1;
	Tue, 21 Oct 2025 20:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077456;
	bh=zUCB2teSguGcry1D0MpUNo8ViGBuqPrHpVtdVfrvZx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cj23OmIhIxA850CkSRe0wWyfg1xeUTZQIZ/6MFWSQXxS97hSRwAPt/JgeC/2P/duM
	 B9nTHtsURe580V4m/G9yaBYoCjm3I76noSlCFLRlag23IEJnGvSgJ8yFBY+WluQBVZ
	 o/n+c3Z31jLOK2H5sACDix1/h35wTz8xcDsuyEIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 111/159] drm/amd/powerplay: Fix CIK shutdown temperature
Date: Tue, 21 Oct 2025 21:51:28 +0200
Message-ID: <20251021195045.840048660@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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
index 8da882c518565..9b28c07282699 100644
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



