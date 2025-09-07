Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605381A9FAA;
	Sun,  7 Sep 2025 20:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276389; cv=none; b=VQVAb/AxEWEhZhk7sqjWAmdgkRjAq/1C/trHjc6O8oAFc6szcGBRhK8puaeWQ1pvMnxbUWr9KESQP+9jFOeZruKetKhzqgLpsCwPYGzq+nvaylt38BO4fPMH06oWagCee2WPaplq2IgtWCJTn9eoIWz4HbTYgmj2QdoOihaO17U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276389; c=relaxed/simple;
	bh=9CIYPPP6LkUHaOuqIHkyiVd+lhoYQGsP8otSxE0rJsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTWraVK6O09fZna2+aNzgr0CwzJUC6haieW3GhxAr7iXtRQE/4PI/9EyBxt/iPpLUY25EVWVzh7Q2cHhmQRnKD2IiTABXYIfgY3/G7TR1ut7wHhEtt/g7RLOHq/dSYv2ZTDkzzPVFmLAZuL4rwiV995r9dv8JkifmsCGBCQbIOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUo/Uh6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUo/Uh6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C161C4CEF0;
	Sun,  7 Sep 2025 20:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276387;
	bh=9CIYPPP6LkUHaOuqIHkyiVd+lhoYQGsP8otSxE0rJsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUo/Uh6L1TKQYaq/nuHPc/2DiiFV07NcY/1pA/wd4hwYhsyoK+1pwZELgwkrD6gx1
	 UnxmVlESCv6++erVL1PJSk3Rdukc4+zqCKi5gF+N28F6EzZvmYVtCuVb4iIQ8FtJua
	 7CL6NzQU1jGHPELXgeSpC8akveCW1YWG0waaAdxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Candice Li <candice.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/104] drm/amdgpu: remove the check of init status in psp_ras_initialize
Date: Sun,  7 Sep 2025 21:58:46 +0200
Message-ID: <20250907195609.979663743@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit 3e931368091f7d5d7902cee9d410eb6db2eea419 ]

The initialized status indicates RAS TA is loaded, but in some cases
(such as RAS fatal error) RAS TA could be destroyed although it's not
unloaded. Hence we load RAS TA unconditionally here.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Candice Li <candice.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 467e00b30dfe ("drm/amd/amdgpu: Fix missing error return on kzalloc failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index d101333fe3a57..ff3678a1c0296 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1571,11 +1571,6 @@ static int psp_ras_initialize(struct psp_context *psp)
 	if (amdgpu_sriov_vf(adev))
 		return 0;
 
-	if (psp->ras_context.context.initialized) {
-		dev_warn(adev->dev, "RAS WARN: TA has already been loaded\n");
-		return 0;
-	}
-
 	if (!adev->psp.ras_context.context.bin_desc.size_bytes ||
 	    !adev->psp.ras_context.context.bin_desc.start_addr) {
 		dev_info(adev->dev, "RAS: optional ras ta ucode is not available\n");
@@ -1647,6 +1642,9 @@ static int psp_ras_initialize(struct psp_context *psp)
 	else {
 		if (ras_cmd->ras_status)
 			dev_warn(psp->adev->dev, "RAS Init Status: 0x%X\n", ras_cmd->ras_status);
+
+		/* fail to load RAS TA */
+		psp->ras_context.context.initialized = false;
 	}
 
 	return ret;
-- 
2.51.0



