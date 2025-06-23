Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF67347DD;
	Mon, 23 Jun 2025 13:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685833; cv=none; b=oYVry2b0b9PrbNZbMQ6wRaVQA/NzLUShHK62RqawZJxIDprjvV6Fuq/EYgc9/2EC26qNLzdGIZ1Y9mjRJkO9tXYwynrfwvkztfQ1b/foARe0erBIfmxHo51jeWzVy2xgIvN4ZtwVDxG9r9CCb0MiFOxiMsiCHW3uZTOD4a631y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685833; c=relaxed/simple;
	bh=ADHBdSyH02HH3tZfxuLxtQxb3nqwYxKAk5WDXq25L+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f18O7z3C5+2EXERSU8ERK388hqvyhHZbK3JDigmQZIxJ72tY7cGh4iACZE1w1yS93DyZlHRcx8s7bCZf7R5egWvQAYB18PTa/V1TypxC8lroIJagzbksNVN1VOcWQXOYrtE2nJdgKotC5Rr9sbxx1Bs8Idy4ds99z40l9f+PaMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhjQ91oS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhjQ91oS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E836C4CEEA;
	Mon, 23 Jun 2025 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685833;
	bh=ADHBdSyH02HH3tZfxuLxtQxb3nqwYxKAk5WDXq25L+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhjQ91oS9zKxRbzzvll1xBEZrhzXhikX+sphUIPg1PHO2HgIvA8dmRA3ZnKmSgZuJ
	 0AXFph4FIi9QCamo1IN2HUgTIBjoTbEvokvxcDWJAl61iqBCBWGGGbvEZlnuMBsHRy
	 ayF7eH24bE0uwRtngQl2qWdc5rjCk23tMMuEJXEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 287/592] drm/amdgpu: Disallow partition query during reset
Date: Mon, 23 Jun 2025 15:04:05 +0200
Message-ID: <20250623130707.186255278@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 75f138db48c5c493f0ac198c2579d52fc6a4c4a0 ]

Reject queries to get current partition modes during reset. Also, don't
accept sysfs interface requests to switch compute partition mode while
in reset.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 10 ++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index cf2df7790077d..1dc06e4ab4970 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -1351,6 +1351,10 @@ static ssize_t amdgpu_gfx_get_current_compute_partition(struct device *dev,
 	struct amdgpu_device *adev = drm_to_adev(ddev);
 	int mode;
 
+	/* Only minimal precaution taken to reject requests while in reset.*/
+	if (amdgpu_in_reset(adev))
+		return -EPERM;
+
 	mode = amdgpu_xcp_query_partition_mode(adev->xcp_mgr,
 					       AMDGPU_XCP_FL_NONE);
 
@@ -1394,8 +1398,14 @@ static ssize_t amdgpu_gfx_set_compute_partition(struct device *dev,
 		return -EINVAL;
 	}
 
+	/* Don't allow a switch while under reset */
+	if (!down_read_trylock(&adev->reset_domain->sem))
+		return -EPERM;
+
 	ret = amdgpu_xcp_switch_partition_mode(adev->xcp_mgr, mode);
 
+	up_read(&adev->reset_domain->sem);
+
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index ecb74ccf1d908..6b0fbbb91e579 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -1230,6 +1230,10 @@ static ssize_t current_memory_partition_show(
 	struct amdgpu_device *adev = drm_to_adev(ddev);
 	enum amdgpu_memory_partition mode;
 
+	/* Only minimal precaution taken to reject requests while in reset */
+	if (amdgpu_in_reset(adev))
+		return -EPERM;
+
 	mode = adev->gmc.gmc_funcs->query_mem_partition_mode(adev);
 	if ((mode >= ARRAY_SIZE(nps_desc)) ||
 	    (BIT(mode) & AMDGPU_ALL_NPS_MASK) != BIT(mode))
-- 
2.39.5



