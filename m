Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C441863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C68C433D2;
	Wed, 28 Dec 2022 15:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241020;
	bh=IQj4jAtdLDkSaRLYS/ofgyUfK/kIyBl2/qwFt4uRLCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOMqjUpK5YjCOB+Y3qn/Af+7GC3drOHV2P5Fur4urrHWoK3178PX8Pzu7GWZzpFWO
	 J66mSVtoFxeHQO1G7IgThPy3oAdaOWWIBmrt71Uj0GEQx6czv+KzkGj1J9TLDcPlUM
	 1KFn1i7JdM5IidRfQyN1CS1Qd1m/k+BdVSPpnPdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0216/1073] drm/amdgpu/powerplay/psm: Fix memory leak in power state init
Date: Wed, 28 Dec 2022 15:30:04 +0100
Message-Id: <20221228144333.882963399@linuxfoundation.org>
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit 8f8033d5663b18e6efb33feb61f2287a04605ab5 ]

Commit 902bc65de0b3 ("drm/amdgpu/powerplay/psm: return an error in power
state init") made the power state init function return early in case of
failure to get an entry from the powerplay table, but it missed to clean up
the allocated memory for the current power state before returning.

Fixes: 902bc65de0b3 ("drm/amdgpu/powerplay/psm: return an error in power state init")
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c
index 67d7da0b6fed..1d829402cd2e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c
@@ -75,8 +75,10 @@ int psm_init_power_state_table(struct pp_hwmgr *hwmgr)
 	for (i = 0; i < table_entries; i++) {
 		result = hwmgr->hwmgr_func->get_pp_table_entry(hwmgr, i, state);
 		if (result) {
+			kfree(hwmgr->current_ps);
 			kfree(hwmgr->request_ps);
 			kfree(hwmgr->ps);
+			hwmgr->current_ps = NULL;
 			hwmgr->request_ps = NULL;
 			hwmgr->ps = NULL;
 			return -EINVAL;
-- 
2.35.1



