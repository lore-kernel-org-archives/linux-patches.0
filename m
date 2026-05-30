Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8022823392B;
	Sat, 30 May 2026 18:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164084; cv=none; b=E1jXwFMth/uZHMYh2BgIk0v9+IlZx47pAbU8wBr6sl8DuNXAGjGTyQIHI2zaaOuUA49wXRu92VIoGI6kPWq0p/6UsrjOdaBZ0xVPgbUUy3fF/x1SftZaCzM9/djr5ua5eekFoMSuXe6MkzwJgEXDIQF4LMh6mi2hA9kUY8ZI8lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164084; c=relaxed/simple;
	bh=yN1GoSbjTwK4bmps1YfXGfbYLyF8AQElRuKCO2PQH+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFHUoI5uAOTxZl/z+pE/cStzk49BcXP2U14JKe+iswXgY9/cReMRF3mLZzmzu7/yOBqqiBpEmhO/HyaRJt7CEKX0O3lENRkW2nEsbXreeCJ75iev33AtOGPgPF/wJrUpRjUS4LXNYFsEZs63bbq6euAuikGK9KbMCUUhs72NVlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8d6ht9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8d6ht9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FA11F00893;
	Sat, 30 May 2026 18:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164083;
	bh=RiXZuuks3LDZXDYTFcROuF6XKe+Xeg5ONBLPXDu8ZU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8d6ht9YXSaXPPQukmr65aAeHhkszWh/NELY15u0xm+yUxjk0dM0EV7anDS2bfvUq
	 +d/z9p93OGCsUpi90iR9I+ga6SG6+i+zVJK2Ovx4NfremLYZHo9SPSHJjenrXNlAK4
	 pVlceZrlJ6FOwkb03DgwYJori5b775SR1gSshac0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/776] drm/amd/pm/ci: Use highest MCLK on CI when MCLK DPM is disabled
Date: Sat, 30 May 2026 18:02:43 +0200
Message-ID: <20260530160251.999081338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

[ Upstream commit 894f0d34d66cb47fe718fe2ae5c18729d22c5218 ]

When MCLK DPM is disabled for any reason, populate the MCLK
table with the highest MCLK DPM level, so that the ASIC can
use the highest possible memory clock to get good performance
even when MCLK DPM is disabled.

Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
index 7cce5d200527e..a6d2c6256c347 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1321,6 +1321,14 @@ static int ci_populate_all_memory_levels(struct pp_hwmgr *hwmgr)
 			return result;
 	}
 
+	if (data->mclk_dpm_key_disabled && dpm_table->mclk_table.count) {
+		/* Populate the table with the highest MCLK level when MCLK DPM is disabled */
+		for (i = 0; i < dpm_table->mclk_table.count - 1; i++) {
+			levels[i] = levels[dpm_table->mclk_table.count - 1];
+			levels[i].DisplayWatermark = PPSMC_DISPLAY_WATERMARK_HIGH;
+		}
+	}
+
 	smu_data->smc_state_table.MemoryLevel[0].EnabledForActivity = 1;
 
 	dev_id = adev->pdev->device;
-- 
2.53.0



