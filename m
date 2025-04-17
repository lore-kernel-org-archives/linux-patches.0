Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6A11B3934;
	Thu, 17 Apr 2025 18:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915696; cv=none; b=RHCma3oet3y8ykzmy2tR89BG0HDA5rqvUuDx4+OLMSnBB2TGpnIURuyytw+jcao/dlYmnfgaqY6bEDGqFMhqjB0uHPyduFZce5UiBKa8iOOuKKBab+PA6/0iaRxY2PiT8TmHY86OQG+YJeAbbqA6I/U0Q2DxOOElDs67yvBGpeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915696; c=relaxed/simple;
	bh=v8qn1jFbKij4WBzRnQKo4ZRnlF0BbStZwaCAy2b1N48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRa7WqAoJ3PTbVrcIBh6Lk5v9CxP6uTrtlM+vBddgpdN/WOi7Q541+9fLMJfGwN/znHd7DRiQx3/EnqlTvDu1UPg2fm4WA66rlrBoqp6Uba7B91gNsG4Dmr0LFXPhLpaVlNGJsCFRI345Ddqx5AeNA2hbcq1HOIU7NKCRUjAoFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz3wI9WX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz3wI9WX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E9FC4CEE4;
	Thu, 17 Apr 2025 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915696;
	bh=v8qn1jFbKij4WBzRnQKo4ZRnlF0BbStZwaCAy2b1N48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tz3wI9WXQOncv3AlL9mmYoDUSMWBOnv1NJDgcJbC5STQrd1azYyvwtp1aZ0FKixG6
	 gylWC5S89ISrmsDlEOsS8XoC/nQmGp46EK0z6hHlVWMAwMqFKXkRKduXheOK9GqxXd
	 xwQO6FK3foejfOQCxop4APeB25ez4Uw2zWgVHWHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 210/393] accel/ivpu: Fix PM related deadlocks in MS IOCTLs
Date: Thu, 17 Apr 2025 19:50:19 +0200
Message-ID: <20250417175116.025992601@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit d893da85e06edf54737bb80648bb58ba8fd56d9f upstream.

Prevent runtime resume/suspend while MS IOCTLs are in progress.
Failed suspend will call ivpu_ms_cleanup() that would try to acquire
file_priv->ms_lock, which is already held by the IOCTLs.

Fixes: cdfad4db7756 ("accel/ivpu: Add NPU profiling support")
Cc: stable@vger.kernel.org # v6.11+
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250325114306.3740022-3-maciej.falkowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_debugfs.c |    4 ++--
 drivers/accel/ivpu/ivpu_ms.c      |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/accel/ivpu/ivpu_debugfs.c
+++ b/drivers/accel/ivpu/ivpu_debugfs.c
@@ -331,7 +331,7 @@ ivpu_force_recovery_fn(struct file *file
 		return -EINVAL;
 
 	ret = ivpu_rpm_get(vdev);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	ivpu_pm_trigger_recovery(vdev, "debugfs");
@@ -408,7 +408,7 @@ static int dct_active_set(void *data, u6
 		return -EINVAL;
 
 	ret = ivpu_rpm_get(vdev);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	if (active_percent)
--- a/drivers/accel/ivpu/ivpu_ms.c
+++ b/drivers/accel/ivpu/ivpu_ms.c
@@ -44,6 +44,10 @@ int ivpu_ms_start_ioctl(struct drm_devic
 	    args->sampling_period_ns < MS_MIN_SAMPLE_PERIOD_NS)
 		return -EINVAL;
 
+	ret = ivpu_rpm_get(vdev);
+	if (ret < 0)
+		return ret;
+
 	mutex_lock(&file_priv->ms_lock);
 
 	if (get_instance_by_mask(file_priv, args->metric_group_mask)) {
@@ -96,6 +100,8 @@ err_free_ms:
 	kfree(ms);
 unlock:
 	mutex_unlock(&file_priv->ms_lock);
+
+	ivpu_rpm_put(vdev);
 	return ret;
 }
 
@@ -160,6 +166,10 @@ int ivpu_ms_get_data_ioctl(struct drm_de
 	if (!args->metric_group_mask)
 		return -EINVAL;
 
+	ret = ivpu_rpm_get(vdev);
+	if (ret < 0)
+		return ret;
+
 	mutex_lock(&file_priv->ms_lock);
 
 	ms = get_instance_by_mask(file_priv, args->metric_group_mask);
@@ -187,6 +197,7 @@ int ivpu_ms_get_data_ioctl(struct drm_de
 unlock:
 	mutex_unlock(&file_priv->ms_lock);
 
+	ivpu_rpm_put(vdev);
 	return ret;
 }
 
@@ -204,11 +215,17 @@ int ivpu_ms_stop_ioctl(struct drm_device
 {
 	struct ivpu_file_priv *file_priv = file->driver_priv;
 	struct drm_ivpu_metric_streamer_stop *args = data;
+	struct ivpu_device *vdev = file_priv->vdev;
 	struct ivpu_ms_instance *ms;
+	int ret;
 
 	if (!args->metric_group_mask)
 		return -EINVAL;
 
+	ret = ivpu_rpm_get(vdev);
+	if (ret < 0)
+		return ret;
+
 	mutex_lock(&file_priv->ms_lock);
 
 	ms = get_instance_by_mask(file_priv, args->metric_group_mask);
@@ -217,6 +234,7 @@ int ivpu_ms_stop_ioctl(struct drm_device
 
 	mutex_unlock(&file_priv->ms_lock);
 
+	ivpu_rpm_put(vdev);
 	return ms ? 0 : -EINVAL;
 }
 


