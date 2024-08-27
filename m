Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C2B1C6F4D;
	Tue, 27 Aug 2024 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769976; cv=none; b=I82k9U0WpHLYEW0NZF0STOgqimOvo5lgqCZ4hTBYWNNYj8uMAxnhwtmR6TYaaD58qPJ99UYLW+MzeV0g2n6CuUm2QFq2/0eTTBiCajZvAGooe5GbfXScrGx0IGPYYBGi+vBFXP5lz1wKUILQrROEOUdtqlcX1txX2D3bPsHt67E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769976; c=relaxed/simple;
	bh=U9+esCb/u9IY1x3BSHWadh3GfB4y8SFSWdcQWHyn2zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i06TrvKTdqKcxQcsL8+1tv0jR9ivQP/FOuP+AT2szoezh/Ju8AEhaYdINUllJBuk5vfuJNdYABkJUbk/jtYVvyB8sIw+Q+pfTq5p2bAdL5O1+G7y+239rMjG3BBNqCr0EoJ16O9M1qKhIFVf+EFyUMqe4WQS25fR4M9x6NY8CK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IusOTxk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IusOTxk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D5CC61063;
	Tue, 27 Aug 2024 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769976;
	bh=U9+esCb/u9IY1x3BSHWadh3GfB4y8SFSWdcQWHyn2zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IusOTxk7z6Yvv2BxPzZ9H5J05Kw6xD/kbiXxylVlLJfzw0n1+sl2edpKvs7S/4oW5
	 QUhkiUyveXi2tI7LqjxHYOQTlB8DT6O1bepHS4ZUC7/TYFfl9ecIS4WAjCwbIVnMUV
	 C3wrVHTcWrR5x3BGxNUuTZqW/pZxLt/kL8KXkoAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/341] drm/amd/pm: fix error flow in sensor fetching
Date: Tue, 27 Aug 2024 16:35:14 +0200
Message-ID: <20240827143846.568254634@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit a5600853167aeba5cade81f184a382a0d1b14641 ]

Sensor fetching functions should return an signed int to
handle errors properly.

Reviewed-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reported-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 7372eae0b0ef8..babb73147adfb 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1471,9 +1471,9 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 	return -EINVAL;
 }
 
-static unsigned int amdgpu_hwmon_get_sensor_generic(struct amdgpu_device *adev,
-						    enum amd_pp_sensors sensor,
-						    void *query)
+static int amdgpu_hwmon_get_sensor_generic(struct amdgpu_device *adev,
+					   enum amd_pp_sensors sensor,
+					   void *query)
 {
 	int r, size = sizeof(uint32_t);
 
@@ -2787,8 +2787,8 @@ static ssize_t amdgpu_hwmon_show_vddnb_label(struct device *dev,
 	return sysfs_emit(buf, "vddnb\n");
 }
 
-static unsigned int amdgpu_hwmon_get_power(struct device *dev,
-					   enum amd_pp_sensors sensor)
+static int amdgpu_hwmon_get_power(struct device *dev,
+				  enum amd_pp_sensors sensor)
 {
 	struct amdgpu_device *adev = dev_get_drvdata(dev);
 	unsigned int uw;
@@ -2809,7 +2809,7 @@ static ssize_t amdgpu_hwmon_show_power_avg(struct device *dev,
 					   struct device_attribute *attr,
 					   char *buf)
 {
-	unsigned int val;
+	int val;
 
 	val = amdgpu_hwmon_get_power(dev, AMDGPU_PP_SENSOR_GPU_AVG_POWER);
 	if (val < 0)
@@ -2822,7 +2822,7 @@ static ssize_t amdgpu_hwmon_show_power_input(struct device *dev,
 					     struct device_attribute *attr,
 					     char *buf)
 {
-	unsigned int val;
+	int val;
 
 	val = amdgpu_hwmon_get_power(dev, AMDGPU_PP_SENSOR_GPU_INPUT_POWER);
 	if (val < 0)
-- 
2.43.0



