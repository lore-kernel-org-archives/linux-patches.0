Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7D67AE6B;
	Mon,  4 Mar 2024 21:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587835; cv=none; b=Q8Ku/rZutLYSITyjqUfzfnvuMwur07m5HucIPKuxgxqqQFIawYYxqh6Z0j4AI022/u/FlzYXwZpUiGBbso+VqZSCxUaXQP35RRpbulpqTzZ7nYn0s4ROoEbx9y29cO5UjS7ZakCGYWyiWVzxjw8PJJsCxzf6ckKn/m6e4y9Cpgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587835; c=relaxed/simple;
	bh=FOfrGYCGclIzhGVDvT9SfbCrhuhC3Xey/M1KoOHeIXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQDOHA47zdt1vNIgj4uDRJ6Rh5XxUoHB5avqeBRIs2B/40WVLm1VC5F3fTtPNPh2gwZ7euimAgBjgD+uXwRrjLz8oESrEj8UWZ4Zvl1Pp0dCPBv3Lbf6Yn5+G+tyxBX+5zUYqrqW13NUn++N1g6jdFuZNG1kop9MZRUdOSR99Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAnE1e02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAnE1e02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3829AC433F1;
	Mon,  4 Mar 2024 21:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587834;
	bh=FOfrGYCGclIzhGVDvT9SfbCrhuhC3Xey/M1KoOHeIXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAnE1e02HKM4SRJcow1bogJI2TRCjVt4qG5b/PjdTO7rzVTMJyKhUOM6fIPoomYy9
	 R5PsyrzPWtiCyuasqJ1H4Dik/+dS216/sgZ8k41aRo2i4wTfiGyN3IBQK72zR9cefy
	 zEprSEbEhiKBl112HXH3OiD3fW41JtKD8kscU30k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 090/162] Revert "drm/amd/pm: resolve reboot exception for si oland"
Date: Mon,  4 Mar 2024 21:22:35 +0000
Message-ID: <20240304211554.716120576@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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
 


