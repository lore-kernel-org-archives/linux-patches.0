Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6131863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E907CC433D2;
	Wed, 28 Dec 2022 15:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242528;
	bh=TysLWZxsnVb8erUgU7pXb3w5UkFrysFkGEmLXlYnk4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5RzcUcPL6peyJFt+TX7LfnEs86S0rZVn2xWkIILxXvwyL5cc0am0YzwjhzjX7E+w
	 9lAGWE9IGEZEMX/BCYSP7x+CiPLFzYnRnk61UC+WsJJJ0FCP5NupRAShpJACEpdWYL
	 XN7jK+cgzQfHhBsJPVTkvIIImPcIjIXQ5TEhNQdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0420/1073] drm/amd/pm/smu11: BACO is supported when its in BACO state
Date: Wed, 28 Dec 2022 15:33:28 +0100
Message-Id: <20221228144339.429651070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 6dca7efe6e522bf213c7dab691fa580d82f48f74 ]

Return true early if ASIC is in BACO state already, no need
to talk to SMU. It can fix the issue that driver was not
calling BACO exit at all in runtime pm resume, and a timing
issue leading to a PCI AER error happened eventually.

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index 70b560737687..ad5f6a15a1d7 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1588,6 +1588,10 @@ bool smu_v11_0_baco_is_support(struct smu_context *smu)
 	if (amdgpu_sriov_vf(smu->adev) || !smu_baco->platform_support)
 		return false;
 
+	/* return true if ASIC is in BACO state already */
+	if (smu_v11_0_baco_get_state(smu) == SMU_BACO_STATE_ENTER)
+		return true;
+
 	/* Arcturus does not support this bit mask */
 	if (smu_cmn_feature_is_supported(smu, SMU_FEATURE_BACO_BIT) &&
 	   !smu_cmn_feature_is_enabled(smu, SMU_FEATURE_BACO_BIT))
-- 
2.35.1



