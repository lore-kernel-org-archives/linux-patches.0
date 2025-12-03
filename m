Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3483D338918;
	Wed,  3 Dec 2025 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780561; cv=none; b=rvt5dsBs8TIiqq+ibdlxFWTsijENjXZ2QkfwFC8SYTwmxBziQrCnTHaWFnUhahxn3VhT+UuNQnT3JnffETVuWS8vJI2rfp2+S3hQQhT/X6ebS/G1mEtPFF7PNPGcW8iAiUDmnKywNTJyLsFXY8OcaMYPz/6nRmLKrIiHIxZX0Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780561; c=relaxed/simple;
	bh=1IJ4wYYKkqpaWU4SgpCm3Msvax5CTug+VAwS2nn+4bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vE+fvb+/t3FhLVOAZL5osi9AME3YrNBXe1l+Uzbqz+94KGFKHD/OeR2BW5AYdz9fLDD6E01WYUeJiF0xIgEMAEPKLIJiC5EWCpIkPsNP9bbtxyI4JDSjimjJVp8VO2muu4VRkyTRzRgSPajnXJ8DOz5HScNEY/UQictfbvgcobY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xq5bhKq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xq5bhKq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7E2C4CEF5;
	Wed,  3 Dec 2025 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780561;
	bh=1IJ4wYYKkqpaWU4SgpCm3Msvax5CTug+VAwS2nn+4bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xq5bhKq4mpGLkZ0WfCqJ/LGhur0o5da1Vt7sbNgidlEvnbVFFbSkAYZhdd1sVB5qk
	 HO40TJE2Mawg7pQ1TgkV/W9A8QUG2C/rmfb+hfdA5ps4AtjGhDI4Ce6vfZQX/T+zY+
	 fxUHwRK649qwBDsSdfBNF7Uzn+KH/gNyBAeIxVw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/132] drm/amdgpu: fix cyan_skillfish2 gpu info fw handling
Date: Wed,  3 Dec 2025 16:28:21 +0100
Message-ID: <20251203152344.121738841@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 7fa666ab07ba9e08f52f357cb8e1aad753e83ac6 ]

If the board supports IP discovery, we don't need to
parse the gpu info firmware.

Backport to 6.18.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4721
Fixes: fa819e3a7c1e ("drm/amdgpu: add support for cyan skillfish gpu_info")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5427e32fa3a0ba9a016db83877851ed277b065fb)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index b93afd52a0094..9e1716a3f70ba 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2414,6 +2414,8 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
 		chip_name = "navi12";
 		break;
 	case CHIP_CYAN_SKILLFISH:
+		if (adev->mman.discovery_bin)
+			return 0;
 		chip_name = "cyan_skillfish";
 		break;
 	}
-- 
2.51.0



