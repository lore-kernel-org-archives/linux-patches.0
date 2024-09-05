Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3C9156225;
	Thu,  5 Sep 2024 09:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530180; cv=none; b=fae9xh6SwYsUQV2xFKYKHvx3J7mHTnRmGQyRUNeRYlYVDYP2kS7Z4HJ+9SHoiFwotAAPuzOunlvKE9zRbU+DqOiiTT1SZHjHIbRROQgrclclvddVUYKSuH1uZMrS32LDqVPrsT97kQ/TKgAuNbi7xD9ET0gEy9hI1vrixzMH0vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530180; c=relaxed/simple;
	bh=38s0XOuEPWA7FivWGZjajY0EXDa7RYv43JAK+3C33To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNx4q6+iF6L9IQMo92umHJW3yQe2s+QmNsUWig4tyctx2WZSxwm4gLK0Q+15pNYHL50EYvZjgPDNDu/Itblms/ti/hxjBtpxrzC+GX7h3JLIxgKPabDYLmoqyfqWAHApm2epxRUXjjPhPhnEFZYG3xA1SyqRMMOTUMUyyzMpesk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diSGXiya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diSGXiya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55356C4CEC3;
	Thu,  5 Sep 2024 09:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530179;
	bh=38s0XOuEPWA7FivWGZjajY0EXDa7RYv43JAK+3C33To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diSGXiyaz7HurAQhFb0f5BsktfdF9ggTdnVOPssYzoW6uJkBsMNdL1FxgZvTgEYtP
	 LvOxYye4Vr/uqpvBWFprqz+78Bx87jZE5LOg2dFzyrRPIHHKFwTE4rOuAKvxvMmUIJ
	 UnuXMO8oWRGhLdS9xW5B3XrqAiUGSbw40MF43Dyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/132] drm/amdgpu: Fix the warning division or modulo by zero
Date: Thu,  5 Sep 2024 11:41:06 +0200
Message-ID: <20240905093725.324065002@linuxfoundation.org>
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

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 1a00f2ac82d6bc6689388c7edcd2a4bd82664f3c ]

Checks the partition mode and returns an error for an invalid mode.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index 0284c9198a04..6c6f9d9b5d89 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -500,6 +500,12 @@ static int aqua_vanjaram_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr,
 
 	if (mode == AMDGPU_AUTO_COMPUTE_PARTITION_MODE) {
 		mode = __aqua_vanjaram_get_auto_mode(xcp_mgr);
+		if (mode == AMDGPU_UNKNOWN_COMPUTE_PARTITION_MODE) {
+			dev_err(adev->dev,
+				"Invalid config, no compatible compute partition mode found, available memory partitions: %d",
+				adev->gmc.num_mem_partitions);
+			return -EINVAL;
+		}
 	} else if (!__aqua_vanjaram_is_valid_mode(xcp_mgr, mode)) {
 		dev_err(adev->dev,
 			"Invalid compute partition mode requested, requested: %s, available memory partitions: %d",
-- 
2.43.0



