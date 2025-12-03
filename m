Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA527352F96;
	Wed,  3 Dec 2025 16:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780253; cv=none; b=Agp1ZaFIlkJWPt/IbbMO9nUlWlTfehXfq68OSBErI9hUJ6GCR/E9uw/ljo6tPcAZ/obB3bc1J0RE3vekRkK1WvLFPS6skKzehd1xmFVmAJ/l89TNIgj8KE7xyZWXw4dazuDoaisJR/P7duaLtTSTDgIJtT7GYxFNCzSBaerJvTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780253; c=relaxed/simple;
	bh=zJDnNDrx45kehE+yw6oahSAj15O3o/Z/EFc5EOSZ59M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meHxTPufELqrL57p4f76XAdRlQ31BK/Hh9hvXFh3IIZbMieQx+IsEry6BMmnKgRDMf0rQcCM2rzTa0DPhHOVnxFhKFhZ7GfL3BY8H6PpuNrDJk+EceIQBq+TjvxRXXLwAyKycRWTVivGDKlWQOc4HwNqbWeZRmRhz1AbX7Cmtg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uzrQJNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uzrQJNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4C7C4CEF5;
	Wed,  3 Dec 2025 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780253;
	bh=zJDnNDrx45kehE+yw6oahSAj15O3o/Z/EFc5EOSZ59M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uzrQJNMosUe/l0jR//Hd63XvJOsJ8R3TpflH+axEQLrtPOQNl1D48llYljY7H0eQ
	 hqBgn2E8b7yJRZwxNWcws5EF+L5NZCCP4INee4IZb1FpRwHVAyH8sDcp5RDZtMpf5c
	 LQm2O3nom2NH3Uoq2IXbAij8Z1vAflpJpQBPcqdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 502/568] drm/amdgpu: fix cyan_skillfish2 gpu info fw handling
Date: Wed,  3 Dec 2025 16:28:24 +0100
Message-ID: <20251203152459.100127802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f18f165876043..38b81ae236cb3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2021,6 +2021,8 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
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



