Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37841322745;
	Mon, 27 Oct 2025 19:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591974; cv=none; b=KhT9M9uwKAUvX0iybGXJkAIPChY5C4g3EkH+64t4YFJgNBcIdTPvnbMkms0Iax/luYuGtK2hZIrd8+4XTMaNFf6LE+0hBkP54c3Ph4XbeEBxunH6hjVDMNQ00+BvR7Sfn6SaTJRmuaccLXDMewgdj6qlXt+PsdAFB6yAk0eYE+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591974; c=relaxed/simple;
	bh=vs8PLaRPkjh9ZYRSNzHULwc5Fcsza8Q38/ScxXokgic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tc64nQObKobX9XkfM7778jegdTVXK8cL2auP9F08zbEX7Hav/fjkmHsHsh0Fot3/6v9KafiEHyG0hyPnX1efybL8x8nfOetknswl3vTwWNKaFVb4Ai3/eojhIgaUdbb6m5YMjpmEKJ77EFMGTGqLB2rbCZzD9uMfcQUaMBmiSJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3GBTU2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3GBTU2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61A6C4CEF1;
	Mon, 27 Oct 2025 19:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591974;
	bh=vs8PLaRPkjh9ZYRSNzHULwc5Fcsza8Q38/ScxXokgic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3GBTU2SrJf2CqnDbZpXQpS1SnN2fGSAD2pGGY4AOhnmJNKeizOFIkg+MIcnOsVDt
	 5sFnmn4bfq+jREZijrxZeliob8IUYsxCUtuVu8k8ffqRvScDelwiEUYZVjLXFOEzIx
	 d5zyP4iwmcshv4aKoOIstGnKLOeJ9gU8v3KWgrE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/123] drm/amd/powerplay: Fix CIK shutdown temperature
Date: Mon, 27 Oct 2025 19:35:13 +0100
Message-ID: <20251027183447.284901370@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2d1f37aefdbd1..e25032ad16be7 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -5387,8 +5387,7 @@ static int smu7_get_thermal_temperature_range(struct pp_hwmgr *hwmgr,
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



