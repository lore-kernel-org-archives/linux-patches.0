Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D5A1DFF4;
	Mon,  1 Apr 2024 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991165; cv=none; b=m5odJLi0IdMgs0hefUJ28n6VIOn5j5+redOleHimIQnfp7lW3ZM7Lb7Nn9Ph4DRPiXnrKkfblFihWr98oY0rhKcCLJfs5D+lGm6thLf6tE53UPZG/0b+xnl8mfDb7cFHn5xCSbRWljL9x9f/FltbStF8tihl4ewW3JXBsO4MBnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991165; c=relaxed/simple;
	bh=AwtQZmQ6bjBxSyQcAyBclotD6SD3Jg3+sfKXv0XpdNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjvvSI0ZRgNWBvgJ2x4ISlGrEDlstnfFnjOC1ARiXXVzUksD7fpbnYaBUJe4qz7e1OCCjHYbnEfeIJ2zosZhKr9dYoF9Wx04ZlOjOlpBsDV/CFgYAhMJH8Rlauhc5IdGlemxnMRtZyDWZsg3fjV5tfUwC8Il27Kcfciy+CthoPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFrlkBW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFrlkBW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987FFC433C7;
	Mon,  1 Apr 2024 17:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991165;
	bh=AwtQZmQ6bjBxSyQcAyBclotD6SD3Jg3+sfKXv0XpdNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFrlkBW38GtPXdFGDFU+FY4V216Xe+51N8pMxJLlFaVZ6S8Z5Z4sg181YiHUMi0cp
	 UoSQwsKbEDUU0wSjdH75c2gbfIsRkijZBJToAK1ep7sBQaLbOmTXn6Sl91P++uuCGt
	 O3WXLNZbLdGt/s8ESqEnJ0abQxg5fWzZKrg6k+7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 154/272] drm/amdgpu/pm: Fix the error of pwm1_enable setting
Date: Mon,  1 Apr 2024 17:45:44 +0200
Message-ID: <20240401152535.515770763@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -2344,6 +2344,7 @@ static ssize_t amdgpu_hwmon_set_pwm1_ena
 {
 	struct amdgpu_device *adev = dev_get_drvdata(dev);
 	int err, ret;
+	u32 pwm_mode;
 	int value;
 
 	if (amdgpu_in_reset(adev))
@@ -2355,13 +2356,22 @@ static ssize_t amdgpu_hwmon_set_pwm1_ena
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


