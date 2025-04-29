Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01F922A81D;
	Tue, 29 Apr 2025 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946509; cv=none; b=k5epSzflI13uL9xXqXdWEW+VC95tflcxuqyUZgAyHapbblhZdhDvVaZC0YusXR1VWGNRIEdt5KUYW6k4o29U8zVfE3A4xIecoVYpJc2IS62abEkgQypJEAK1opfFXM+ZD9+kHPbxTbc/II50yVCfsIWzGaM9hibEbedg3TbXhsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946509; c=relaxed/simple;
	bh=fA7K3i3yR4SbPlleWumCys2LcIJ8hNfrkmo8BNZ7wGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRQ9njwQrabIgDP/hh657yaSu9VTxXo7dLAqt7s1v40qSvA6jqLU7n1eEXw0CfzIlxL+nSqZWbNvBhU7Yt9ApXuu+Sqi1S02bKE6jh6emVxdp/JuwsByLTyOirTLjyWYtV9GChivD/XX4qAbnRekKed0AYwBNWpP09uORkuBa8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNCMCyJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNCMCyJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A353C4CEE3;
	Tue, 29 Apr 2025 17:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946509;
	bh=fA7K3i3yR4SbPlleWumCys2LcIJ8hNfrkmo8BNZ7wGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNCMCyJwkpmZO7JyGb076a7xV/43jJ1CvmNzDivqPmBmOb22VY7FR2JKwN+hh3oER
	 ru/UidY1Es1kH26/ScZjM/zS1b3YL8k64HbjXwRrXClpm0K8Lw24/K+u2b8RUBs+Zx
	 xiEUiLvuF4TwMxlZjLaUU3chrQfYVKVt1likg3TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 291/311] drm/amd: Forbid suspending into non-default suspend states
Date: Tue, 29 Apr 2025 18:42:08 +0200
Message-ID: <20250429161132.921886211@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 1657793def101dac7c9d3b2250391f6a3dd934ba ]

On systems that default to 'deep' some userspace software likes
to try to suspend in 'deep' first.  If there is a failure for any
reason (such as -ENOMEM) the failure is ignored and then it will
try to use 's2idle' as a fallback. This fails, but more importantly
it leads to graphical problems.

Forbid this behavior and only allow suspending in the last state
supported by the system.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4093
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250408180957.4027643-1-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2aabd44aa8a3c08da3d43264c168370f6da5e81d)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h     |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index ab04d56b4fe36..98f0c12df12bc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1118,6 +1118,7 @@ struct amdgpu_device {
 	bool				in_s3;
 	bool				in_s4;
 	bool				in_s0ix;
+	suspend_state_t			last_suspend_state;
 
 	enum pp_mp1_state               mp1_state;
 	struct amdgpu_doorbell_index doorbell_index;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 24c255e05079e..f2d77bc04e4a9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2515,8 +2515,20 @@ static int amdgpu_pmops_suspend(struct device *dev)
 		adev->in_s0ix = true;
 	else if (amdgpu_acpi_is_s3_active(adev))
 		adev->in_s3 = true;
-	if (!adev->in_s0ix && !adev->in_s3)
+	if (!adev->in_s0ix && !adev->in_s3) {
+		/* don't allow going deep first time followed by s2idle the next time */
+		if (adev->last_suspend_state != PM_SUSPEND_ON &&
+		    adev->last_suspend_state != pm_suspend_target_state) {
+			drm_err_once(drm_dev, "Unsupported suspend state %d\n",
+				     pm_suspend_target_state);
+			return -EINVAL;
+		}
 		return 0;
+	}
+
+	/* cache the state last used for suspend */
+	adev->last_suspend_state = pm_suspend_target_state;
+
 	return amdgpu_device_suspend(drm_dev, true);
 }
 
-- 
2.39.5



