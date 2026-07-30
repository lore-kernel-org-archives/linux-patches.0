Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD73769FD;
	Thu, 30 Jul 2026 15:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426480; cv=none; b=Jt8Q8AzX02VGAX0MsSqRG6E4LOhGgOI74FYnbK0dNTGyu+3NHgIOtYWKokxhNl+X3ltoKHQZvwEhAymdwjjiQp3dkcgFfPgjdcrpGOj4EIFkkaNWe01us16NIjEA5/Y8E9zTGeW0m6ay7uwE5PuHusjtHs9otaMCEQmhfOakydU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426480; c=relaxed/simple;
	bh=vF7ALT4cxnANrcgQB1behqjgQKWAE8cUIkUuCPkhWxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVJolWtXJfrnx+qhatoBZF6HA1T4M1rBzjAD58iV+F13wSuBCc55EoL236jbROHHceyiLhAN8pK+oFyYBbXZ7qbLp02GY3zoSKU36Y8YmRXNSKtWe1Dgiy3nIfsMIMjeTlV/DkMrZJei4ugDmlr0HTvBKS3oQb6iO/Sn4na/jIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMgEkGAt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMgEkGAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60311F00A3A;
	Thu, 30 Jul 2026 15:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426479;
	bh=zbQQ8PWqmVxXxEUr/wTncZJvNbgAP7d1M6++sUr6fOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMgEkGAtgMKZDt5DR17br0hd9/e9DuiPglSNVCWUER7NplOvJtVOe9DU1DhycHWHA
	 g2zU13+EBH+1ZSliTa2bHj4f9yW8M1VACh4ykjfpOmRybox8WxMlpdNl4XMs9JYtGR
	 tEGlKEe/RH+x7W+eZis7reQRBIGk28bL3Kgy/P2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 435/602] drm/amd/pm: fix amdgpu_pm_info power display units
Date: Thu, 30 Jul 2026 16:13:47 +0200
Message-ID: <20260730141445.107341940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3200,7 +3202,6 @@ static int amdgpu_hwmon_get_power(struct
 				  enum amd_pp_sensors sensor)
 {
 	struct amdgpu_device *adev = dev_get_drvdata(dev);
-	unsigned int uw;
 	u32 query = 0;
 	int r;
 
@@ -3209,9 +3210,7 @@ static int amdgpu_hwmon_get_power(struct
 		return r;
 
 	/* convert to microwatts */
-	uw = (query >> 8) * 1000000 + (query & 0xff) * 1000;
-
-	return uw;
+	return power_2_mwatt(query) * 1000;
 }
 
 static ssize_t amdgpu_hwmon_show_power_avg(struct device *dev,
@@ -4607,7 +4606,7 @@ static int amdgpu_debugfs_pm_info_pp(str
 {
 	uint32_t mp1_ver = amdgpu_ip_version(adev, MP1_HWIP, 0);
 	uint32_t gc_ver = amdgpu_ip_version(adev, GC_HWIP, 0);
-	uint32_t value;
+	uint32_t value, mwatt, centiwatt;
 	uint64_t value64 = 0;
 	uint32_t query = 0;
 	int size;
@@ -4632,17 +4631,21 @@ static int amdgpu_debugfs_pm_info_pp(str
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


