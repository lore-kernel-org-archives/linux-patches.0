Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093AB481DD;
	Sat, 30 May 2026 17:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161070; cv=none; b=M2cQUEORMjYFVC51FIy8/CqKy+GcPfim+7MJE5EoSGPSVwPnLl6CKyQwL4uGWHRsz2jiNxcEmmpx9SIO0jxp8a6+oWQj8l2ybNRXSIgDvX63pJAbJc5343Sz9MqYHg5pKI4gzk7ddtmR+QVotMd/uL/4/qPFLD6txeHg2ctncNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161070; c=relaxed/simple;
	bh=Cfkw71OWm858J9vRyUQ4IHt12MzCWQKuGgvoZiGDT4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C/CpEIMV+b7AusSze19pZi68SdY8rbRo6Evz2hCPuJDCzJQ8/IcQMhiq1aSAg+nTkZqPY+nKXv5dFMzqlDFwPlTNJGIoYneUtRCRicdB7G7iCBplqUNjlHXlLtGEDLy/6MCob13mdfIo/h87xVgxHQnJdaXUCGA6A3kSXdp3n7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ub+aD1gu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ub+aD1gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503FD1F00893;
	Sat, 30 May 2026 17:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161069;
	bh=+nWyy9T6nsmuC/xtVXvanDyAfOEiQddTqHknjAUFqRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ub+aD1guJ8q5/dkad7MaXgoZLEg5lslr1xny8L4bQyPZOShibCLCNrQzAKLB1WCfy
	 GoT3KilAYiLx1gxXErAUPS4Grb4bH0vpwL778A/atHvzGJHszKJtptCo5KMbqxS8OZ
	 kMoJ9qV4d7uGOffLVICBBFCQBKe0AxIfrs9IkBBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 517/969] drm/amd/pm/ci: Use highest MCLK on CI when MCLK DPM is disabled
Date: Sat, 30 May 2026 18:00:41 +0200
Message-ID: <20260530160314.620662877@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9b8974e89145d..20419da731993 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1323,6 +1323,14 @@ static int ci_populate_all_memory_levels(struct pp_hwmgr *hwmgr)
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



