Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CAF481CE;
	Mon,  1 Apr 2024 16:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988706; cv=none; b=RADCbg3ZO9TKXzX8tPFx/U8ZS4IhcFfNEb8zRGLD8+sCWXZJLlzJ3gEfErwacAgmYV8mzIzzdg30Stp9Xj0MST1NPQZ8xqz7b+/majKkgwxVt5nGXXTE727XRlvYlarHVdxEU3ujl2UgNnOGhMvVkyH5jJsOF3qy1CPbBjZ1Bf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988706; c=relaxed/simple;
	bh=gjnNLe7NtbSxvwCM4AEqLcYs0p4hAX3+4V5G2SsRqnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYz6UcIOHZ/vXPsVuiouwmQMcOKUB2QzKIV3tmanU3rOGSaKTGpXnbxGqsMH/GSP/izLAfmD9ynKBgt80bhX48FG1uSD8iRODYAlQq5VELLU+6RYC6YX6HPIA2eIhlLkpWdtbCvZl5uZRmNfi0BHzN97kpMu5YDwyEiNn/aqGYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5jZj6fV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5jZj6fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1472FC43390;
	Mon,  1 Apr 2024 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988706;
	bh=gjnNLe7NtbSxvwCM4AEqLcYs0p4hAX3+4V5G2SsRqnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5jZj6fVq4acrt5yO78U4lYc0pSwfByTKz/0JRSEe+JL504V3LvY75MZN793+kpB4
	 0VxDV5yyKB6Yror7zT/VClFlSf4qtYgZZtrCq4jmoumgRYxWcnmhKTKfeX5EWodDy9
	 luYe0aIggA34ao4SZQKX7RBDSnICdQrPj241saAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 257/432] drm/amdgpu/pm: Fix the error of pwm1_enable setting
Date: Mon,  1 Apr 2024 17:44:04 +0200
Message-ID: <20240401152600.805986717@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

commit 0dafaf659cc463f2db0af92003313a8bc46781cd upstream.

Fix the pwm_mode value error which used for
pwm1_enable setting

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2518,6 +2518,7 @@ static ssize_t amdgpu_hwmon_set_pwm1_ena
 {
 	struct amdgpu_device *adev = dev_get_drvdata(dev);
 	int err, ret;
+	u32 pwm_mode;
 	int value;
 
 	if (amdgpu_in_reset(adev))
@@ -2529,13 +2530,22 @@ static ssize_t amdgpu_hwmon_set_pwm1_ena
 	if (err)
 		return err;
 
+	if (value == 0)
+		pwm_mode = AMD_FAN_CTRL_NONE;
+	else if (value == 1)
+		pwm_mode = AMD_FAN_CTRL_MANUAL;
+	else if (value == 2)
+		pwm_mode = AMD_FAN_CTRL_AUTO;
+	else
+		return -EINVAL;
+
 	ret = pm_runtime_get_sync(adev_to_drm(adev)->dev);
 	if (ret < 0) {
 		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
 		return ret;
 	}
 
-	ret = amdgpu_dpm_set_fan_control_mode(adev, value);
+	ret = amdgpu_dpm_set_fan_control_mode(adev, pwm_mode);
 
 	pm_runtime_mark_last_busy(adev_to_drm(adev)->dev);
 	pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);


