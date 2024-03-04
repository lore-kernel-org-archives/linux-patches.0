Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7417BAF0;
	Mon,  4 Mar 2024 21:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588748; cv=none; b=RJ3XYZ4IGm3kKYY2YFaPGyFrbKwYC65E5cimFiA9LL3w9Lf9+hBd+NdPz0D/Kc9p3Qnf0fXVQvPf5rCmfniy3l7ptwTz1r9oLvy34ADyBSVxyVMkhudd8oTlqIbM2WHnna52/cMZDwrxSFPa8RCbeZ5mPChdS6oCa0upZ7esGJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588748; c=relaxed/simple;
	bh=GleRpfPPD4Cemg3vcx1Y2HW1tDOCrAJ4tVTee67KAgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8rgrGOAfWR3v95mMQnnXAABGyVBLOI0xc7U0G4C1dRHSvylq7HvZmipn9j6w7BmSO7R+TZEPY1iQPhGHrbFo2C5DAqpsU4pzfKha7mMu1iFzE1ojAN6dbq1wDF+5rHJZwobyJkf1jSXB7yIpUCCmU1NQeF91w1UmRPRAV3QiZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeWmoOMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeWmoOMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10905C433A6;
	Mon,  4 Mar 2024 21:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588748;
	bh=GleRpfPPD4Cemg3vcx1Y2HW1tDOCrAJ4tVTee67KAgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeWmoOMPUoQFaE4KQsktvUvqSE6kaviCsKQRUG08Wj3sM5Ka38VZW9tbXa5lmxHI6
	 Be0JdFEIbTzfweQUDLNvw+3YgmdAiJLsqKJduL2PocXoKdu9Ps1VUbQ+tCkWAbMRBA
	 oEYVqIWP3ZlPlPvKqTS199YQteY05qQEFRkKx80Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 082/215] Revert "drm/amd/pm: resolve reboot exception for si oland"
Date: Mon,  4 Mar 2024 21:22:25 +0000
Message-ID: <20240304211559.590263803@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 955558030954b9637b41c97b730f9b38c92ac488 upstream.

This reverts commit e490d60a2f76bff636c68ce4fe34c1b6c34bbd86.

This causes hangs on SI when DC is enabled and errors on driver
reboot and power off cycles.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3216
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2755
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -6925,6 +6925,23 @@ static int si_dpm_enable(struct amdgpu_d
 	return 0;
 }
 
+static int si_set_temperature_range(struct amdgpu_device *adev)
+{
+	int ret;
+
+	ret = si_thermal_enable_alert(adev, false);
+	if (ret)
+		return ret;
+	ret = si_thermal_set_temperature_range(adev, R600_TEMP_RANGE_MIN, R600_TEMP_RANGE_MAX);
+	if (ret)
+		return ret;
+	ret = si_thermal_enable_alert(adev, true);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
 static void si_dpm_disable(struct amdgpu_device *adev)
 {
 	struct rv7xx_power_info *pi = rv770_get_pi(adev);
@@ -7608,6 +7625,18 @@ static int si_dpm_process_interrupt(stru
 
 static int si_dpm_late_init(void *handle)
 {
+	int ret;
+	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+
+	if (!adev->pm.dpm_enabled)
+		return 0;
+
+	ret = si_set_temperature_range(adev);
+	if (ret)
+		return ret;
+#if 0 //TODO ?
+	si_dpm_powergate_uvd(adev, true);
+#endif
 	return 0;
 }
 


