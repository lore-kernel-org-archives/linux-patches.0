Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E73482ED;
	Mon,  1 Apr 2024 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990101; cv=none; b=oIOETaQNIqLfSZ+50GFi3997m1d6zzTYQijCCS+hKyN5SRO2aX2JrTME/dZdwMo2+Re9RMSMHYeD+P++Nz8BTZj29yHAWCa3TXfBtQ5M6zrGA3HMtLfTgMi5xnAcz8Y3VUgKPgFGZm3DGD/+bVLOGB/hZVTMgoXvJxNB+xsU4QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990101; c=relaxed/simple;
	bh=OPRX4fb2htaYMzAB0gtOgnhRL6ceqrSDqV9DsPDlXfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3jQDT9GdQyS5KXrpRbUUz2szzht91xTge5Wxti3TKP8ZEYvCcYlmtdp5LC1u5v39c5pIau84hP+Z1+6sVV6cBMvRRYyfG7Op1cUxvzdbuHfFX5DzxoVRp7olq31jWsmJMUWIr3F2PpzIVkX0Y/GP0IILgaM6XWhyx4asWohBFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONNKHioQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONNKHioQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F034C433F1;
	Mon,  1 Apr 2024 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990100;
	bh=OPRX4fb2htaYMzAB0gtOgnhRL6ceqrSDqV9DsPDlXfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONNKHioQ2bqXIH909FBZll+20iip4sjemevxe3HPn4dT0CK3vc28zNA05Wk6EzW8/
	 R2HZIf90SuKCLA5QyoB6LuI9KCNGsc8Ott+zMcm5ek46BkKKHlWku48f9soFC+oZam
	 wNbU7E7CStkUEo8d6JGex1jy8BbCLC5SCxfed5wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 217/396] drm/amdgpu/pm: Fix the error of pwm1_enable setting
Date: Mon,  1 Apr 2024 17:44:26 +0200
Message-ID: <20240401152554.392329368@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2395,6 +2395,7 @@ static ssize_t amdgpu_hwmon_set_pwm1_ena
 {
 	struct amdgpu_device *adev = dev_get_drvdata(dev);
 	int err, ret;
+	u32 pwm_mode;
 	int value;
 
 	if (amdgpu_in_reset(adev))
@@ -2406,13 +2407,22 @@ static ssize_t amdgpu_hwmon_set_pwm1_ena
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


