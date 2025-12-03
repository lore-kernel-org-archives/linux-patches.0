Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B41331A80E;
	Wed,  3 Dec 2025 15:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776908; cv=none; b=O+X+XRofJ7p/nYxjzGWLa5JyGDKCGViGRcbBxeNsQCnoTT2njEWJLCMotenyZa/jw5XT0QHPwxlXzS9/Ng9yzElAE9OVovuftIFoJozHwvPvHpF4dll3ewdwVZPrvflPMPpBFIErcNmieARdJsIsWD8/NpwHnnr0Ukyh+yZrv4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776908; c=relaxed/simple;
	bh=/J96AMWbTmRtG2PzIY31cn6mMh8DP8YeSxmkQI/UB/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETJtILuE2WGP9sJYNo08Y0uZVrzOZCsaNY9DIib+fa6TOWJhts5ZusjfnFQKDTgtCwhOjt1DdtX/FbVdC7+EPfjdWuKXxZOvPVXxkOmHgvliq5G96NbXgfHFsp/VQ3l+9I6Flid6RjYHbbgn0l1ndfBVwhysnRFgUZosjelWvmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qW2kVvFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qW2kVvFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943DFC4CEF5;
	Wed,  3 Dec 2025 15:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776908;
	bh=/J96AMWbTmRtG2PzIY31cn6mMh8DP8YeSxmkQI/UB/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qW2kVvFrlUDNGQnL4YeaTZViRAM6fG5l/KIgHHcCz9iSNKQFLnO9cVavwbO0duKdU
	 uqdWxSZaCiNDQAo9OycTnmpAiKz1OxjZM6WlLKZzUGphz1QhT/Idg6y1ZzSSRQDZUs
	 sIICYeOLcwbgAxbSREz/HN6MfQVg2CR84yVvS91k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 023/146] drm/amdgpu: fix cyan_skillfish2 gpu info fw handling
Date: Wed,  3 Dec 2025 16:26:41 +0100
Message-ID: <20251203152347.316273733@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index aaee97cd9a109..a713d5e6e4012 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2604,6 +2604,8 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
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



