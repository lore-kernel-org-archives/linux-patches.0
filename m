Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB34197A76;
	Thu,  5 Sep 2024 09:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529490; cv=none; b=NaM6KYpHAdSqmHa2av9GbCypIzV0vT6weXXKPtBwGYrGUzm4WPsKN/+/zdP9imjBQEaCNjIReVadBsYe6ae0mP1pwyMeJxMuwRxu/k9Huz33oA4DxjwMAi8P5xbm9MMzFmeaHdy4gtu5lApqyrjDedfDB/y8768h1VXPxLXrA2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529490; c=relaxed/simple;
	bh=Av7zxh+CypO3xko7XgTmhUGywuLjOh3ycA9GBgwiYR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toP3ZrA+bQwYpcGIUXHGO9sKuZwX5GnZarY5nlWdYkG/hGwsHIA2mE3EX51IlTQ4x82BAzuLS+uBT0sYAAQRTvxsUqGfb7dbB59OtNRpeTGZCvcy8BPHWXGYUZIxGhxUVhaw8ZcaAAX5gt9FwG3wrhVcoRC3kiiVaxl+PQLdxjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgsaKfy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgsaKfy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F71C4CEC4;
	Thu,  5 Sep 2024 09:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529489;
	bh=Av7zxh+CypO3xko7XgTmhUGywuLjOh3ycA9GBgwiYR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgsaKfy/wkmwGQcmYG1XrMP6158XxtNUcKMTgxGbjGwXMY2xU4yg/zv2/ki1m+XsS
	 1fUmDVyvZdalKiCV2COBQeISG9LzXWSumAB5cyowaONt705PNVSqOpTbZl7dgRhiMH
	 2PPhxrzrUwXbQsXrCjZlAmhNxSQY8zleOZ7VcXY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 049/184] drm/amd/pm: fix warning using uninitialized value of max_vid_step
Date: Thu,  5 Sep 2024 11:39:22 +0200
Message-ID: <20240905093734.159624580@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 17e3bea65cdc453695b2fe4ff26d25d17f5339e9 ]

Check the return of pp_atomfwctrl_get_Voltage_table_v4
as it may fail to initialize max_vid_step
V2: change the check condition (Tim Huang)

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index f4acdb226741..574ead01430f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -2571,8 +2571,11 @@ static int vega10_init_smc_table(struct pp_hwmgr *hwmgr)
 		}
 	}
 
-	pp_atomfwctrl_get_voltage_table_v4(hwmgr, VOLTAGE_TYPE_VDDC,
+	result = pp_atomfwctrl_get_voltage_table_v4(hwmgr, VOLTAGE_TYPE_VDDC,
 			VOLTAGE_OBJ_SVID2,  &voltage_table);
+	PP_ASSERT_WITH_CODE(!result,
+			"Failed to get voltage table!",
+			return result);
 	pp_table->MaxVidStep = voltage_table.max_vid_step;
 
 	pp_table->GfxDpmVoltageMode =
-- 
2.43.0



