Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB42C18CC1A;
	Tue, 10 Sep 2024 10:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963297; cv=none; b=g9Zf0vk9ir/ovEyqLtLyV3tIi3pFAYPPjzHZ3nxZpOdTvMCifb+JQHu4Ht9e7iWhEtjRZpOx0i0OSDmhk5ZtqDH9lPMBdJqbstxUzbL0i9pz/76ueMDUsre7qOJpWTb5jGWPixAKJjsShXnTVD122u73Y7OBXSyjplRXjsoRfhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963297; c=relaxed/simple;
	bh=boVvB7SDmYOWUN6lhEs8akoZ5ILoeSWgs76w22tZtHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YenEZD4KzAR+gAtFz72rA2nf50mqH60/DWSjq2Kfu4Sz0AJZhsR9KSiVmEjn58PgNJNTRIC0l/Vy7p9A0ScC158iPsy/G/CzdwXIHZ1Wyn6O+chdu/BjrydbGaLDRQWCBSd6jkZqJ6FFF43MWI7tOhyP/6fpCvZw1m/wIjhvAcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ac6XRltK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ac6XRltK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F00C4CEC3;
	Tue, 10 Sep 2024 10:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963297;
	bh=boVvB7SDmYOWUN6lhEs8akoZ5ILoeSWgs76w22tZtHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ac6XRltKHM2ejszONyP5zN/cxcpF6/CZb0D6DxmrwRB4fEt9XIWRjTLjMADiWtE3e
	 f4Q+MrgI0kT6rEmqSOuqG0M/uNukJPAfGNLnrZ4EUJ/fgzFd+L/Cf8ZwG6ciWajGBd
	 Dv9zAWTRxGMgS4PQJf39DHebH9KQqSUpfJNcwVQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/214] drm/amdgpu/pm: Check the return value of smum_send_msg_to_smc
Date: Tue, 10 Sep 2024 11:30:32 +0200
Message-ID: <20240910092559.139528664@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 579f0c21baec9e7506b6bb3f60f0a9b6d07693b4 ]

Check the return value of smum_send_msg_to_smc, otherwise
we might use an uninitialized variable "now"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
index cf74621f94a7..8b46214fc6fe 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
@@ -1026,7 +1026,9 @@ static int smu10_print_clock_levels(struct pp_hwmgr *hwmgr,
 
 	switch (type) {
 	case PP_SCLK:
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetGfxclkFrequency, &now);
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetGfxclkFrequency, &now);
+		if (ret)
+			return ret;
 
 	/* driver only know min/max gfx_clk, Add level 1 for all other gfx clks */
 		if (now == data->gfx_max_freq_limit/100)
@@ -1047,7 +1049,9 @@ static int smu10_print_clock_levels(struct pp_hwmgr *hwmgr,
 					i == 2 ? "*" : "");
 		break;
 	case PP_MCLK:
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetFclkFrequency, &now);
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetFclkFrequency, &now);
+		if (ret)
+			return ret;
 
 		for (i = 0; i < mclk_table->count; i++)
 			size += sprintf(buf + size, "%d: %uMhz %s\n",
-- 
2.43.0



