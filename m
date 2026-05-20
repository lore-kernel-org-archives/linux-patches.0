Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584503EAC82;
	Wed, 20 May 2026 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300439; cv=none; b=AAM+eG7mu8UqRu6kONLmK5i6JxjHsw28bWcaDoGJVM8SLdOZ1ilrH8bAHV8s6FN70S1YcWRpNlqsQMwxTv81q9HD1MmqPtfMClkkMoRe0qWrVmyntYB5tK4YcRtT/sjXWqPE6lSaY2mQIIb6luAQ7yKs/7ReGcO/lj/c8y4a7fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300439; c=relaxed/simple;
	bh=3inSXnkAT4pzwba11Y4moWJvty9HZJbO8J1Cs1LLl44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Go3p5Rcjpvb2CXvhiQuedoyj3OmOyNd3e9wpPZjuM+bQl6ClEdRa2tkgEkPGvrKp0J4SR+fpBGGzgeHcLqbHkIisnaxlbV0bW8gEapYNtSRNOLo1xxJhUwqpS6PxPvg/L1jbaElp7zt/xuV6BvJdONUYcOBrH9ilFjI+IbaDkWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qW94XVDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qW94XVDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2B21F000E9;
	Wed, 20 May 2026 18:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300438;
	bh=lt0sOoz6dB5wAxJSzgKhB8RmrTEteKfWXu6qian1vak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qW94XVDJ7KljLEaPOkLwi9rJp9igrjwnw4ln5EC0WrwlEoVnoZHhOr420ss7zVswd
	 yRzu39o1rbkAHG6QLYGC1baOzjuELsRps4kZCOkFiUjEvGzXaKJFECkrdorYr1++OT
	 fbximdY1+kYWA+Ow9g+e2IyJLLhzQecwBtI/wZs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/666] drm/amd/pm/ci: Use highest MCLK on CI when MCLK DPM is disabled
Date: Wed, 20 May 2026 18:16:27 +0200
Message-ID: <20260520162115.016711979@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 0cb7eaaba3844..71b1dad34926e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1322,6 +1322,14 @@ static int ci_populate_all_memory_levels(struct pp_hwmgr *hwmgr)
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



