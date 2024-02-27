Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7710213B2B3;
	Tue, 27 Feb 2024 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040647; cv=none; b=XocVcKNvtqaZIfHsvmrpwVFfDS+K5WL+liclmBRsEvDBj2087WzXeINK6GsptSMUEPrlamwIz+aVlr2u1Bj9IpEXztp9avUyW9iIGS4+PdVu6//EXu5K2PTvhuMlIS0ZhOEU8BJDOK43JdhoS7zeIWgjHIqVZSYMWMjFjYbQRWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040647; c=relaxed/simple;
	bh=LQndOUGCHBvBUVIxwUxiZeB0W5I2AJWqx0jW2sTcmiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEUCaAG2gLbRLgNePlLbuIcA+lgyA+0biZws6LNmP6cngUDsfM3Avi0aW8m2USZc6xV04+crrBBK5KNWqCLzLyDo8BxPYhNbE/eeOkjl0CVx+mzu9ZZNoQbYsW+QlOmdSwuFWErZSSwRiYX8JpTZ/Dp1kXjQfVwU6FYJRgQTfDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBSxlGy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBSxlGy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4DCC433F1;
	Tue, 27 Feb 2024 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040647;
	bh=LQndOUGCHBvBUVIxwUxiZeB0W5I2AJWqx0jW2sTcmiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBSxlGy518yHv+lTo3VqQQ8sDdvXU0hjD0rwzz5FIqjJVuVJ5cG5uiGxrg7so1jHg
	 E9hjWqR1TymSsu2FOxPNFoHr4N5mC1ZQZcTlRm8PoqL9UHO4kfutQZhg63WaGdUcab
	 V9mNC9wUvJXHzfvSFPwmTquhqT1NBQlNQLXBJ3dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <Roman.Li@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 031/334] drm/amd/display: Disable ips before dc interrupt setting
Date: Tue, 27 Feb 2024 14:18:09 +0100
Message-ID: <20240227131631.597231736@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 8894b9283afd35b8d22ae07a0c118eb5f7d2e78b ]

[Why]
While in IPS2 an access to dcn registers is not allowed.
If interrupt results in dc call, we should disable IPS.

[How]
Safeguard register access in IPS2 by disabling idle optimization
before calling dc interrupt setting api.

Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
index 51467f132c260..d595030c3359e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
@@ -711,7 +711,7 @@ static inline int dm_irq_state(struct amdgpu_device *adev,
 {
 	bool st;
 	enum dc_irq_source irq_source;
-
+	struct dc *dc = adev->dm.dc;
 	struct amdgpu_crtc *acrtc = adev->mode_info.crtcs[crtc_id];
 
 	if (!acrtc) {
@@ -729,6 +729,9 @@ static inline int dm_irq_state(struct amdgpu_device *adev,
 
 	st = (state == AMDGPU_IRQ_STATE_ENABLE);
 
+	if (dc && dc->caps.ips_support && dc->idle_optimizations_allowed)
+		dc_allow_idle_optimizations(dc, false);
+
 	dc_interrupt_set(adev->dm.dc, irq_source, st);
 	return 0;
 }
-- 
2.43.0



