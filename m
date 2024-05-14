Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414A8200BF;
	Tue, 14 May 2024 11:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685618; cv=none; b=SFIxYGPrvAl0/BXGGeA3jLFAHDldSCy371HYNdITOO8zWZl7AhINc8S8QMyjKaiw/UEcLy/dxNtsszPPzfDBOUMl0CI1pS+Rt7VhWnPwDiUpTjygA202evUxhLGqj3MJu9X4a/0RieIBOHtOwrbWiIFXEnpwyFefB+ujj0NumEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685618; c=relaxed/simple;
	bh=2aalL5PO078epPbrWjOcIAyLVsHJ7+ZTeyh01WPbAXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqndjrOs85Z20LDXFI0NNo3qL93di+DkM38WtpMwLlBYm9cebo3XKALRq6Wkr3oNMf+MsG6ya/Gbi7FHAO5LPqDxrcwX0gSqGFON6lMYUaHrg23aIZi9AEqIICJLtNGoKiRYLgVuCZepNWqnek3Cz4EeTM7yyhufKwBvozFp5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/KPkE5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/KPkE5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CF2C2BD10;
	Tue, 14 May 2024 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685618;
	bh=2aalL5PO078epPbrWjOcIAyLVsHJ7+ZTeyh01WPbAXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/KPkE5nVddQOaCQkT1D7qT/+kBvM1WpL4XrPd90ZWMz7qQN7oSNHrq9bkSrE7Uyh
	 3ee4Q11q/EPqlFtSC8Zg+2MikDqhZ514xvHOwx1qKTHjx/Sw5oHb7zSN5wOvHlppQH
	 1fze5b/rpO6yuoSfdwlzVMvTk6UwiUybM21rCJnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/301] dm/amd/pm: Fix problems with reboot/shutdown for some SMU 13.0.4/13.0.11 users
Date: Tue, 14 May 2024 12:18:06 +0200
Message-ID: <20240514101040.377447886@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit cd94d1b182d2986378550c9087571991bfee01d4 ]

Limit the workaround introduced by commit 31729e8c21ec ("drm/amd/pm: fixes
a random hang in S4 for SMU v13.0.4/11") to only run in the s4 path.

Cc: Tim Huang <Tim.Huang@amd.com>
Fixes: 31729e8c21ec ("drm/amd/pm: fixes a random hang in S4 for SMU v13.0.4/11")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3351
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
index 1d1917e1b63f4..cd674ef5adb19 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
@@ -226,7 +226,7 @@ static int smu_v13_0_4_system_features_control(struct smu_context *smu, bool en)
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
-	if (!en && !adev->in_s0ix) {
+	if (!en && adev->in_s4) {
 		/* Adds a GFX reset as workaround just before sending the
 		 * MP1_UNLOAD message to prevent GC/RLC/PMFW from entering
 		 * an invalid state.
-- 
2.43.0



