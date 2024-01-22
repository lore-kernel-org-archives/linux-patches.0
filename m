Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C6E4F204;
	Tue, 23 Jan 2024 00:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970331; cv=none; b=jkd8tVaAStFjTqLH9OYE1LuY10WDvAdY2x94nnYeqzLIEiat9xb+shhBAZosTkPYorXNa54okJQbPWc+062kYnpRDpYpIBZG+6CHKl7YbHEuO3ZiKNV4nnkOUJtk+foAZMIKmTymjAT0O6RCw7I4rm02dNrd6TuGs0F5EWzQcrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970331; c=relaxed/simple;
	bh=lEVHxmMnhjU5QpmujW5on1hVKV60t9bjCiS5WqfFVF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfIe3ixllknHC7TY49xO022qleCmoRZ8r1N4lLLSU3bfg2/winvgVNJVm5o2StbZ7ED1pu+QtfLUhMKowca2jE+G5uz+XZbDBcOyOazlijBSLNIJzQGBbmZtVUsEmHdqzxnfm61wObKw3vawuptBjUtRHp6+3e5ZCVcIehvDGhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qv5WNjHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qv5WNjHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F47DC433F1;
	Tue, 23 Jan 2024 00:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970331;
	bh=lEVHxmMnhjU5QpmujW5on1hVKV60t9bjCiS5WqfFVF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qv5WNjHZcZkm4WHczJkvSS1sBYaDKYHWaZMwJCYvqmwaXozradCkMVzRgvUWIGvHU
	 Q3WklcBrgNegjJ6dBBAMZtZP9ks95nIPjIJ5Dx57qFk3bOA0TwQXTO5kMmaRtqDQoc
	 GVeOq+Y5b33g5b44V7N6r2uocdEMjuHn2R9chtxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 611/641] drm/amdgpu: fall back to INPUT power for AVG power via INFO IOCTL
Date: Mon, 22 Jan 2024 15:58:35 -0800
Message-ID: <20240122235837.347890171@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit d02069850fc102b07ae923535d5e212f2c8a34e9 ]

For backwards compatibility with userspace.

Fixes: 47f1724db4fe ("drm/amd: Introduce `AMDGPU_PP_SENSOR_GPU_INPUT_POWER`")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2897
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 583cf03950cd..598867919c4f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -1105,7 +1105,12 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 			if (amdgpu_dpm_read_sensor(adev,
 						   AMDGPU_PP_SENSOR_GPU_AVG_POWER,
 						   (void *)&ui32, &ui32_size)) {
-				return -EINVAL;
+				/* fall back to input power for backwards compat */
+				if (amdgpu_dpm_read_sensor(adev,
+							   AMDGPU_PP_SENSOR_GPU_INPUT_POWER,
+							   (void *)&ui32, &ui32_size)) {
+					return -EINVAL;
+				}
 			}
 			ui32 >>= 8;
 			break;
-- 
2.43.0



