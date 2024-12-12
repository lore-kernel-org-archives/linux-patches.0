Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1822EAE5;
	Thu, 12 Dec 2024 15:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016693; cv=none; b=rBUMOp8C9GnsEA7qCM1d52htqQDxkef33Y/AYTXl9sQ9fVF3S6vMKdV3Rtqro0T20cdw7bwOkojQG+ic9gPp1Jz3gpyKoiVJ9yUcpZgofXaQ2CcXxWqM1yfq55xN91Y5N5QoXX8M/EAiF6vs8ipHkCm80X0wVFRPu+LNDz14M2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016693; c=relaxed/simple;
	bh=DK3bgaD58HRnjAO/tqIbkzFu1YHhwwbhTayuWcplncs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOT3A7Xq5Be1h2aAYd5V1jRGodPscokA0fPSFMFnwCBeo+laUMEupi6D1kktwE8E0Dd/WJwYGQkdmAj2hTlsxgnhV3HCmA0uH+0koJul5cQFkB/pAD8E5PVlm0Dy9MyOGLssSLjnUCA9L3Gfoo7h5BwBLXhndZxXdfCw80+KHKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4jum9ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4jum9ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6E2C4CECE;
	Thu, 12 Dec 2024 15:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016692;
	bh=DK3bgaD58HRnjAO/tqIbkzFu1YHhwwbhTayuWcplncs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4jum9baEtRwiMnJQ99XPZnGzcucA5zDCdtNaIWM2IW2hCrQqeOVOMTtRAGRF795x
	 1QruyNXR3uwkx2jiAvQniXM0LltHdhyFbTYxMVBIAxDwG5VsN7b6TjkP8YQukY/kjs
	 bjx7dZiINkImvShrozNcD8QSXWDdGWtpSV93fPlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/466] drm/amd/display: disable SG displays on cyan skillfish
Date: Thu, 12 Dec 2024 15:57:21 +0100
Message-ID: <20241212144317.530066541@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 66369db7fdd7d58d78673bf83d2b87ea623efb63 ]

These parts were mainly for compute workloads, but they have
a display that was available for the console.  These chips
should support SG display, but I don't know that the support
was ever validated on Linux so disable it by default. It can
still be enabled by setting sg_display=1 for those that
want to play with it.  These systems also generally had large
carve outs so SG display was less of a factor.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3356
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 24fbde7dd1c42..8c3db8346f300 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1910,7 +1910,11 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		else
 			init_data.flags.gpu_vm_support = (amdgpu_sg_display != 0);
 	} else {
-		init_data.flags.gpu_vm_support = (amdgpu_sg_display != 0) && (adev->flags & AMD_IS_APU);
+		if (amdgpu_ip_version(adev, DCE_HWIP, 0) == IP_VERSION(2, 0, 3))
+			init_data.flags.gpu_vm_support = (amdgpu_sg_display == 1);
+		else
+			init_data.flags.gpu_vm_support =
+				(amdgpu_sg_display != 0) && (adev->flags & AMD_IS_APU);
 	}
 
 	adev->mode_info.gpu_vm_support = init_data.flags.gpu_vm_support;
-- 
2.43.0



