Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CAC156225;
	Thu,  5 Sep 2024 09:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530062; cv=none; b=fubrDPsSSoXsuDVgClC74zzHXgNY80jykYapv1PLBrt0SZ17mMcoSISq9rEE5C8LbVFkV656YEwuoskYKd9xUVxm3QMqtgGC4D+tNC40dqYcyVTDJBSZ7gxsxXiz1s94B4DQkApgVYa3dLen7kmshMNKUZIpZqMDkCd4P2BTJdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530062; c=relaxed/simple;
	bh=XR60+lv7BWNf9dkgGoIZIdCu5ZND67LQfOoQX2ONQYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVscsW9pbzdNxsRkOlrY57ca5xMGy4mPufSbkNadeAIIbm9aLofpAdjmGb7DjsCU72k0ZJ3Ek7GzRGqXoI2GR61ekBJ+0R5JZtJ2JSBlX4eNGi+a3ZWVWXBNOkCow4QG/aJnUfxw28oWr1YYPZMTPcfjXz5a0yhlYKxlpoC9RMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pM0gIlzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pM0gIlzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1268CC4CEC3;
	Thu,  5 Sep 2024 09:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530061;
	bh=XR60+lv7BWNf9dkgGoIZIdCu5ZND67LQfOoQX2ONQYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pM0gIlzAV5BiXRaWNqvuW6E/uM5seo/Jrk1Hj4jWy5LeDxiewOoHvfXNw4gHmkcM9
	 UOe75BQizdAWOigURGAAGTJy3aFPzxNNzWqkIN3RvwX3e6eVWyVrAz0i1Tvya1nChd
	 cfiZhjCFu/fRrBoLQIPf9oDDyYTGwokChfMZUAj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/132] drm/amdgpu/pm: Check the return value of smum_send_msg_to_smc
Date: Thu,  5 Sep 2024 11:40:30 +0200
Message-ID: <20240905093723.933213235@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 02ba68d7c654..0b181bc8931c 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
@@ -1036,7 +1036,9 @@ static int smu10_print_clock_levels(struct pp_hwmgr *hwmgr,
 
 	switch (type) {
 	case PP_SCLK:
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetGfxclkFrequency, &now);
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetGfxclkFrequency, &now);
+		if (ret)
+			return ret;
 
 	/* driver only know min/max gfx_clk, Add level 1 for all other gfx clks */
 		if (now == data->gfx_max_freq_limit/100)
@@ -1057,7 +1059,9 @@ static int smu10_print_clock_levels(struct pp_hwmgr *hwmgr,
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



