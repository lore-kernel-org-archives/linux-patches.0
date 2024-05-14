Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2374D47A57;
	Tue, 14 May 2024 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686556; cv=none; b=cdmZQ+ah7Zu0L4PyBRND26mOMHOxQQ5BSurnK7gk9hluoTBFwgrwVil4VfXd6ZQkuEvHbCXFynpxd03ZJlNKMz+hUOmN7aL6sHIIHU25FgaD/ArB+SPxxPatKLUUBUJuaQlPpVmb3SLIRGB1/GZxXhk0yyMaPju202GK7/P387A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686556; c=relaxed/simple;
	bh=xEuGX6Al4W1VpG1Z5SKJ+VJ2SOjM3SKNilw4CaYcI6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQ7f9HMyyGNmT7NldSWQjp3FBi5lKhQtdaBfMKqGOZuZM5EaeWArt1uMNmYRYvfry20K8Bs0CBEVTcNGhBfRxuRmxluv0UXC990JZr9xww510l9x9quFcTFzqz0vI8zwHv6c2D5q6OU9hBoiER89L9ct2Utuk8enfIR8ARLDL5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijgu3E/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijgu3E/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BBDC2BD10;
	Tue, 14 May 2024 11:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686555;
	bh=xEuGX6Al4W1VpG1Z5SKJ+VJ2SOjM3SKNilw4CaYcI6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijgu3E/PiAez8W+EwEawWp8Rdnye9SDvSJpXXR6QpANyETXnVbby8efqDP367DgIF
	 5BLu9jglbAJMLLeSucywYQhmSBYesRwXJJ4Siw9tYZqgXDcpx9a21i1tQdfgGfaBeS
	 yoOw15fFPv44+nE4AOHuQZ+9+X+5CM+E+SkCZZxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/236] dm/amd/pm: Fix problems with reboot/shutdown for some SMU 13.0.4/13.0.11 users
Date: Tue, 14 May 2024 12:18:59 +0200
Message-ID: <20240514101027.081418731@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 21b374d121819..5de31961319a2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
@@ -222,7 +222,7 @@ static int smu_v13_0_4_system_features_control(struct smu_context *smu, bool en)
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
-	if (!en && !adev->in_s0ix) {
+	if (!en && adev->in_s4) {
 		/* Adds a GFX reset as workaround just before sending the
 		 * MP1_UNLOAD message to prevent GC/RLC/PMFW from entering
 		 * an invalid state.
-- 
2.43.0



