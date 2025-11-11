Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F47227FD4A;
	Tue, 11 Nov 2025 01:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825492; cv=none; b=sCoEEb/jp83j6aKBfOeyIYWdNCDmwuZtPcpRI1N5RSubKBdNO8yd3L0Ttu6EEPhaurDztV4pr0PBwj0mjonnRWovc+AgddyqeOCsR5ho4s2S2nNLMgkXFrPLELM/Tdnie6v8Si7hjwj42ErqsNfqyD5h9zQZq98K+ijh/7h0EqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825492; c=relaxed/simple;
	bh=FsxUR9/Oe7dkmN8nRWBeqvfjsEzCTZfDxQEjUNKowRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpTf2sMLu95X6OfMNm3cHPXd/y1l5wJaL85WlZJQZFU56yng8+O5+tVBtJ1rQk4B//LUvzsWsGXVucEX6Z2sWhejSTXbBY9lWRqb6sM+bQBkMS/dFQ7SwKBgDnNqtR4XOni4fKWmDgdFlw2LmxOXrQzo5l/MiBfJmG5J8vAjJJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0JWvYzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0JWvYzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF431C4CEF5;
	Tue, 11 Nov 2025 01:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825492;
	bh=FsxUR9/Oe7dkmN8nRWBeqvfjsEzCTZfDxQEjUNKowRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0JWvYzJB+Ue5mwIvetDaiEvu5BnPVut+p3v1d9R007CrCM9zBx787cyldlAwYE+5
	 BlqkG/29B4nMlf1GtARTw0NRM3U0M5wuhoMX9ySf5nsG8bbdpZqkFWVbaUebOdvMBD
	 VWrpPSa/hN6cnYKDRyg8E5BXybjNsYM8j18d1qsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 825/849] drm/amdgpu/smu: Handle S0ix for vangogh
Date: Tue, 11 Nov 2025 09:46:35 +0900
Message-ID: <20251111004556.374294296@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 7c5609b72bfe57d8c601d9561e0d2551b605c017 upstream.

Fix the flows for S0ix.  There is no need to stop
rlc or reintialize PMFW in S0ix.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4659
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reported-by: Antheas Kapenekakis <lkml@antheas.dev>
Tested-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fd39b5a5830d8f2553e0c09d4d50bdff28b10080)
Cc: <stable@vger.kernel.org> # c81f5cebe849: drm/amdgpu: Drop PMFW RLC notifier from amdgpu_device_suspend()
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c        |    6 ++++++
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c |    3 +++
 2 files changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2012,6 +2012,12 @@ static int smu_disable_dpms(struct smu_c
 	    smu->is_apu && (amdgpu_in_reset(adev) || adev->in_s0ix))
 		return 0;
 
+	/* vangogh s0ix */
+	if ((amdgpu_ip_version(adev, MP1_HWIP, 0) == IP_VERSION(11, 5, 0) ||
+	     amdgpu_ip_version(adev, MP1_HWIP, 0) == IP_VERSION(11, 5, 2)) &&
+	    adev->in_s0ix)
+		return 0;
+
 	/*
 	 * For gpu reset, runpm and hibernation through BACO,
 	 * BACO feature has to be kept enabled.
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -2217,6 +2217,9 @@ static int vangogh_post_smu_init(struct
 	uint32_t total_cu = adev->gfx.config.max_cu_per_sh *
 		adev->gfx.config.max_sh_per_se * adev->gfx.config.max_shader_engines;
 
+	if (adev->in_s0ix)
+		return 0;
+
 	/* allow message will be sent after enable message on Vangogh*/
 	if (smu_cmn_feature_is_enabled(smu, SMU_FEATURE_DPM_GFXCLK_BIT) &&
 			(adev->pg_flags & AMD_PG_SUPPORT_GFX_PG)) {


