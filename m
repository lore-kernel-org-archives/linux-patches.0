Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3932232AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301203; cv=none; b=HeOy54qhTgqcQ3N0HaoFL01oL6QqVUV8GovLAtvE7r0kK0uMNhPO+Ycaa0erKPJwlhS1Hk01mHH/HB4jrs113RskrSGkIdxPuo3hpKoMyk9O9TVberV8KihX9hfK/ZUoLqWw6GV8Rb6wpXNolOnCKMfmq51roNpcYOkDOi0njtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301203; c=relaxed/simple;
	bh=8js+6JV8+KnG5BF6f/Cf0va/Fe/CnW60BXryTEzuY28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpQE73lJS045WkWI50JDEFhpmIdU7CDFsjmRUa4d3ckPye431qHye3FFuRXAaw1QO0lYxwmbENg1lCMu5ZP2zcJhUEEBCjB3b9egqCoWUO77RlKTnN24+qVV/89Cnlce/DY6ONLyhZQcL6U8qSlxyK0fhh3nEBdjTUvPhVjjHSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJ2Ql0ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJ2Ql0ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D49BC19423;
	Sat, 28 Feb 2026 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301203;
	bh=8js+6JV8+KnG5BF6f/Cf0va/Fe/CnW60BXryTEzuY28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJ2Ql0ws5QO916rHi88iQ5FO2W/dzP1SvXnmiNyVWOnGCihdixoxx35sPONKey5EQ
	 CQFagfUiIHiSxvabdFBmg6tVkcKv7IUAQDPSgEUTstpxiaYXOLtuGlkipSn22l+uta
	 qgIVhFgPXO0kVRoElwafE6W2kRhi9E6LL/nD6HTdYM2HkTJY5TU1X1LpTQ96d1h7gf
	 KFUe1pEHJg11WnDmcaeQOGT5VCYmRku6RZsd9vMQxlS69M4cPwFFUo8zNCzkbFpVMT
	 YXfIIKLBVJ0K38ZAiboOyIvaIlED+igOncLuOUeT7oz5n2W4SmxFDS2uCFR7uQpPC8
	 zH4vc1uDlKXzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tom Chung <chiahsuan.chung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 376/752] drm/amd/display: Fix system resume lag issue
Date: Sat, 28 Feb 2026 12:41:27 -0500
Message-ID: <20260228174750.1542406-376-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit 64c94cd9be2e188ed07efeafa6a109bce638c967 ]

[Why]
System will try to apply idle power optimizations setting during
system resume. But system power state is still in D3 state, and
it will cause the idle power optimizations command not actually
to be sent to DMUB and cause some platforms to go into IPS.

[How]
Set power state to D0 first before calling the
dc_dmub_srv_apply_idle_power_optimizations(dm->dc, false)

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b527d5764b76b..c8415a2840567 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3407,7 +3407,17 @@ static int dm_resume(struct amdgpu_ip_block *ip_block)
 	struct dc_commit_streams_params commit_params = {};
 
 	if (dm->dc->caps.ips_support) {
+		if (!amdgpu_in_reset(adev))
+			mutex_lock(&dm->dc_lock);
+
+		/* Need to set POWER_STATE_D0 first or it will not execute
+		 * idle_power_optimizations command to DMUB.
+		 */
+		dc_dmub_srv_set_power_state(dm->dc->ctx->dmub_srv, DC_ACPI_CM_POWER_STATE_D0);
 		dc_dmub_srv_apply_idle_power_optimizations(dm->dc, false);
+
+		if (!amdgpu_in_reset(adev))
+			mutex_unlock(&dm->dc_lock);
 	}
 
 	if (amdgpu_in_reset(adev)) {
-- 
2.51.0

