Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D7A340A72;
	Tue, 11 Nov 2025 01:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823172; cv=none; b=TYJIoVAUrzOFd2kP21ZHovAXcKX0QaYqiLxzHPPCgJyYgnYSbxESoD8dlXO1qHeSyeua+tZgY19dirA4WYkdXebhOh0ryzX15NW/Lq/p7O2tAexcWnCswFWE8CVRFchOqNbHP97FX6Jpzbw0jBSM+NMCwkFtl14fMmXCUg49YDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823172; c=relaxed/simple;
	bh=AMDhvRAObt77zGv59MT2s7iE0F82Va5okmGL4AzjbUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFiSzjJj/GofYJrfOjvesG41GYbtAFrFXo1vucplp2suDWa3G/FEyHZdiKrA1URHh75PEDaxJKAl05LB9n1COQ/vWeo8S2/UsvqwSIWdX1d58SyiahqOG1zF0BT5EnZLAKJbgy4jstWeWziOwevwAZiZh7kuvaOA5NrHG8MzHrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnOkbJmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnOkbJmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6933C19421;
	Tue, 11 Nov 2025 01:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823172;
	bh=AMDhvRAObt77zGv59MT2s7iE0F82Va5okmGL4AzjbUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnOkbJmL/RzYbjc+XUsNZWLxBql3w2hk8yLJitOVVY/nyniGVeNwrRNpkk/buPZ7+
	 kWV75b9aYuu9Lecg2+pHdtwYS6KR4BT6L8kEjnCD/2Q1WugKDwQ9JbGs/VN23JJ6ZB
	 PlLOsykI0IRVhJclNohPuh6xvvU/i08gqFSsvqvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 244/849] drm/amdgpu: Fix build error when CONFIG_SUSPEND is disabled
Date: Tue, 11 Nov 2025 09:36:54 +0900
Message-ID: <20251111004542.332894249@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit 8e3967a71e6fca9c871f98b9289b59c82b88b729 ]

The variable `pm_suspend_target_state` is conditionally defined only when
`CONFIG_SUSPEND` is enabled (see `include/linux/suspend.h`). Directly
referencing it without guarding by `#ifdef CONFIG_SUSPEND` causes build
failures when suspend functionality is disabled (e.g., `CONFIG_SUSPEND=n`).

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 65f4a76490eac..c1792e9ab126d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2597,6 +2597,7 @@ static int amdgpu_pmops_suspend(struct device *dev)
 	else if (amdgpu_acpi_is_s3_active(adev))
 		adev->in_s3 = true;
 	if (!adev->in_s0ix && !adev->in_s3) {
+#if IS_ENABLED(CONFIG_SUSPEND)
 		/* don't allow going deep first time followed by s2idle the next time */
 		if (adev->last_suspend_state != PM_SUSPEND_ON &&
 		    adev->last_suspend_state != pm_suspend_target_state) {
@@ -2604,11 +2605,14 @@ static int amdgpu_pmops_suspend(struct device *dev)
 				     pm_suspend_target_state);
 			return -EINVAL;
 		}
+#endif
 		return 0;
 	}
 
+#if IS_ENABLED(CONFIG_SUSPEND)
 	/* cache the state last used for suspend */
 	adev->last_suspend_state = pm_suspend_target_state;
+#endif
 
 	return amdgpu_device_suspend(drm_dev, true);
 }
-- 
2.51.0



