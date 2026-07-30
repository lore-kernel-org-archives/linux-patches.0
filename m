Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B393A641D;
	Thu, 30 Jul 2026 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423183; cv=none; b=GlUNvZPblN4BV+ewpkxbGg3Dh5qWvo9g/R6J+3Yp7tJJwOJ288FuZonaxEqjcmeoG9gADNV0TlmWg8jz60qBWYYeoystq12dlXCnBlh/qVN0spzTBZpHmvTox82rCrAF5y9wZlfnlCSrdJCkBl8zwnCLhilTwz8EWSZrw1zzbVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423183; c=relaxed/simple;
	bh=i53HcEzqQBexK3uZ0pnlvdKCfEQGTxki3NdDU/9YL38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gw9i4Bgocsa/9sWQAd7sj5Jz7Ob1LSrQN/lpdjYx4c7ZLD4ys18ZghzgbC1n6v4SRhJHx85jjmuKCW3OelZtx1Weh4PlWUO5QD4BEt99fayYYTWHAOePfEBO66uzs4chmaqwEj/lOqRJWbJtFwQPGjojPXJv1X27zhy+dT0kfj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKecbiIH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKecbiIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD651F000E9;
	Thu, 30 Jul 2026 14:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423182;
	bh=jAHbygJbOpA5vihNNeqv4CSbN724TX6JEyfOyt65GmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKecbiIHBBI5pAqlYaNYgBAz0My68L1uVeVzIQqQ6310Cs2t9+HF3Igo56HOweRMf
	 mRniLY0OJZKqlAyTkpK1+reSV0HZJSCVfASjPJND+DK8V4unsXCao3WYkRIAIC+H1O
	 mg598U94M1Lcr5bStn53U0UTVJRC2L5/TjCPaaes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 693/744] drm/amd/pm: fix amdgpu_pm_info power display units
Date: Thu, 30 Jul 2026 16:16:06 +0200
Message-ID: <20260730141458.999092732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -41,6 +41,8 @@
 
 #define DEVICE_ATTR_IS(_name)		(attr_id == device_attr_id__##_name)
 
+#define power_2_mwatt(power)	(((power) >> 8) * 1000 + ((power) & 0xff))
+
 struct od_attribute {
 	struct kobj_attribute	attribute;
 	struct list_head	entry;
@@ -3333,7 +3335,6 @@ static int amdgpu_hwmon_get_power(struct
 				  enum amd_pp_sensors sensor)
 {
 	struct amdgpu_device *adev = dev_get_drvdata(dev);
-	unsigned int uw;
 	u32 query = 0;
 	int r;
 
@@ -3342,9 +3343,7 @@ static int amdgpu_hwmon_get_power(struct
 		return r;
 
 	/* convert to microwatts */
-	uw = (query >> 8) * 1000000 + (query & 0xff) * 1000;
-
-	return uw;
+	return power_2_mwatt(query) * 1000;
 }
 
 static ssize_t amdgpu_hwmon_show_power_avg(struct device *dev,
@@ -4882,7 +4881,7 @@ static int amdgpu_debugfs_pm_info_pp(str
 {
 	uint32_t mp1_ver = amdgpu_ip_version(adev, MP1_HWIP, 0);
 	uint32_t gc_ver = amdgpu_ip_version(adev, GC_HWIP, 0);
-	uint32_t value;
+	uint32_t value, mwatt, centiwatt;
 	uint64_t value64 = 0;
 	uint32_t query = 0;
 	int size;
@@ -4907,17 +4906,21 @@ static int amdgpu_debugfs_pm_info_pp(str
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


