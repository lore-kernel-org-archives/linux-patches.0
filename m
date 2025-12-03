Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E033563CE;
	Wed,  3 Dec 2025 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780975; cv=none; b=rkJRTg6mRuQKiS86igpSyXob0InwZz7N7ssO0FZCX9ZfMDaWGIYCHYcBzSmW0D5sJ0tezsjR1BD5tBGt6nCLdaFhB141DUrz5U7E1M0jv2prxw09jBqsO9u5tYWT339lK/Cym6S/4uIHrmkLd7xWdO7c9em1oU7a1D73Q8GGbdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780975; c=relaxed/simple;
	bh=mjSBR6FYLlOnCdyodMAJEwqeMm60ebXlXnebgXA1k/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdXiR4obZYXWvmfHozFlHsku7nrskol4mpWH1wZyrHqLqLe3YYUymElPe3hrlOPf6P58T8tQqBKqezysPPPVCdWrltIQvJ0q07OMD5efWmn2EfbZfUigigJsqZAU7fCo/cIOKbMjF6oEh5g4W9XyTL69pJl3i6IB8bik3Q9/nes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQEv7AKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQEv7AKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6342C4CEF5;
	Wed,  3 Dec 2025 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780975;
	bh=mjSBR6FYLlOnCdyodMAJEwqeMm60ebXlXnebgXA1k/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQEv7AKH5m6605YkEO3ApAg4Y67n4V57RoIz5IdZQEiJMKq5t4J8vrbZDGuukKc+H
	 94PtZRDWr1Rl6O7Sy+6mbbi6kAUfBXW3rha6dDLz23qhI8Uco72wJHl39w1KRSPg+5
	 Xc9aMiF//F1pouvZNOQSr7V/cvl64+OVzPajAGhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 13/93] drm/amdgpu: fix cyan_skillfish2 gpu info fw handling
Date: Wed,  3 Dec 2025 16:29:06 +0100
Message-ID: <20251203152337.000662371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b2a1dc193cb8f..c1b9333d7b78a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1941,6 +1941,8 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
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



