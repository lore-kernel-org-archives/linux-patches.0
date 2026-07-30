Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C01143E4AC;
	Thu, 30 Jul 2026 15:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424941; cv=none; b=ikgFgBmjf6CfZN12qFpqinsw557/onZdEK3yNMKGrJYQxrWR46O585xaLEV97TyaW7qWsGFT8H+wJJ1FNMr/noM8CL29WZhXii1J4LIHZtuS+TDMvjGI3RnjzS6O8XyrbO6s8wir7ULA25FRvIWCAkrZcYJGKy4VZq41JiKaOJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424941; c=relaxed/simple;
	bh=7JEVALRW1UrRNHh9Y58aOlIqoyulx0BeJq3wjDhQzD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOOb/Szade8GA/sI+H3bz52cWX2jVc8Vw7HcGjAFlVEVAavqRRynll7JQpoBtM6sKpyRqZV7vVq6G8P2Id3RZYBiQ+rWcp4a92Rzh7gH7OkdBu0+c5Pe6Esh0s/fYA9QE5o+fFaOpullhrZZifCzpfROfOddKxJsL6cN/BRVZIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0A7htUgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0A7htUgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EC01F000E9;
	Thu, 30 Jul 2026 15:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424940;
	bh=4doexS2BpN5XzMYxFN8btFp0FymMy4EKGbzIEJN+Fsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0A7htUgASkXgIGrVFhsjfcd9xZV3J+qL0G4MFQBpbU6w34jlIKT+ZHHvZ+jaJIzuw
	 jOKQT/Uv1NpIYBMWOz/kAOrxsxDb7OmHwEHRzQHiaBKJ08RA2yfK/ADVbPLavk5+c3
	 WECTYwbI4TI8mggIxIcjvO8eabFsHAUDeIquKrR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 570/675] drm/amd/pm: fix amdgpu_pm_info power display units
Date: Thu, 30 Jul 2026 16:15:00 +0200
Message-ID: <20260730141457.246933197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 238baca26a6279e688d1a156bd031390b82eb578 upstream.

amdgpu_pm_info displayed power sensor readings with the wrong fractional unit.
It treated the low byte of the raw sensor value as the decimal part of watts,
while that field represents milliwatts in the decoded value. As a result,
debugfs could report misleading SoC power when the remainder was not already
a two-digit centiwatt value.

Example with query = 0x00000354:

  raw field        value
  ---------------------
  query >> 8       3 W
  query & 0xff     84 mW
  decoded power    3084 mW

  output           value
  ---------------------
  before           3.84 W
  after            3.08 W

Fixes: f0b8f65b4825 ("drm/amd/amdgpu: fix the GPU power print error in pm info")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 01992b121fb652c753d37e0c1427a2d1a557d2b1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -40,6 +40,8 @@
 
 #define DEVICE_ATTR_IS(_name)		(attr_id == device_attr_id__##_name)
 
+#define power_2_mwatt(power)	(((power) >> 8) * 1000 + ((power) & 0xff))
+
 struct od_attribute {
 	struct kobj_attribute	attribute;
 	struct list_head	entry;
@@ -3261,7 +3263,6 @@ static int amdgpu_hwmon_get_power(struct
 				  enum amd_pp_sensors sensor)
 {
 	struct amdgpu_device *adev = dev_get_drvdata(dev);
-	unsigned int uw;
 	u32 query = 0;
 	int r;
 
@@ -3270,9 +3271,7 @@ static int amdgpu_hwmon_get_power(struct
 		return r;
 
 	/* convert to microwatts */
-	uw = (query >> 8) * 1000000 + (query & 0xff) * 1000;
-
-	return uw;
+	return power_2_mwatt(query) * 1000;
 }
 
 static ssize_t amdgpu_hwmon_show_power_avg(struct device *dev,
@@ -4804,7 +4803,7 @@ static int amdgpu_debugfs_pm_info_pp(str
 {
 	uint32_t mp1_ver = amdgpu_ip_version(adev, MP1_HWIP, 0);
 	uint32_t gc_ver = amdgpu_ip_version(adev, GC_HWIP, 0);
-	uint32_t value;
+	uint32_t value, mwatt, centiwatt;
 	uint64_t value64 = 0;
 	uint32_t query = 0;
 	int size;
@@ -4829,17 +4828,21 @@ static int amdgpu_debugfs_pm_info_pp(str
 		seq_printf(m, "\t%u mV (VDDNB)\n", value);
 	size = sizeof(uint32_t);
 	if (!amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GPU_AVG_POWER, (void *)&query, &size)) {
+		mwatt = power_2_mwatt(query);
+		centiwatt = DIV_ROUND_CLOSEST(mwatt, 10);
 		if (adev->flags & AMD_IS_APU)
-			seq_printf(m, "\t%u.%02u W (average SoC including CPU)\n", query >> 8, query & 0xff);
+			seq_printf(m, "\t%u.%02u W (average SoC including CPU)\n", centiwatt / 100, centiwatt % 100);
 		else
-			seq_printf(m, "\t%u.%02u W (average SoC)\n", query >> 8, query & 0xff);
+			seq_printf(m, "\t%u.%02u W (average SoC)\n", centiwatt / 100, centiwatt % 100);
 	}
 	size = sizeof(uint32_t);
 	if (!amdgpu_dpm_read_sensor(adev, AMDGPU_PP_SENSOR_GPU_INPUT_POWER, (void *)&query, &size)) {
+		mwatt = power_2_mwatt(query);
+		centiwatt = DIV_ROUND_CLOSEST(mwatt, 10);
 		if (adev->flags & AMD_IS_APU)
-			seq_printf(m, "\t%u.%02u W (current SoC including CPU)\n", query >> 8, query & 0xff);
+			seq_printf(m, "\t%u.%02u W (current SoC including CPU)\n", centiwatt / 100, centiwatt % 100);
 		else
-			seq_printf(m, "\t%u.%02u W (current SoC)\n", query >> 8, query & 0xff);
+			seq_printf(m, "\t%u.%02u W (current SoC)\n", centiwatt / 100, centiwatt % 100);
 	}
 	size = sizeof(value);
 	seq_printf(m, "\n");


