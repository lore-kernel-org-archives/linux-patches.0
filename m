Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F41C1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3274C433F0;
	Wed, 28 Dec 2022 16:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246118;
	bh=RfH9LmeSmRyUFA/u+LvjDwVJ2qp3eFFU8aKEIPlYbZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIxFUfH2y9HOHxCR1Hguvlaurl4CrVho7XjXuU6GWAY0UKSDO9zQfj1YsP4F0hN5t
	 FGtSbfKLwlucdn1glE2YgAhcswMaiVZLYxFSIwFUK8+srCpt0yBtvYA0BhYMBu5jNF
	 PrfPSwRlAj53L+e8NjbUOU7rV843gaeYptuSVTjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1015/1073] drm/amd/pm: avoid large variable on kernel stack
Date: Wed, 28 Dec 2022 15:43:23 +0100
Message-Id: <20221228144355.744437544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d118b18fb1da02b41df2da78cb2794b3638d89cd ]

The activity_monitor_external[] array is too big to fit on the
kernel stack, resulting in this warning with clang:

drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_7_ppt.c:1438:12: error: stack frame size (1040) exceeds limit (1024) in 'smu_v13_0_7_get_power_profile_mode' [-Werror,-Wframe-larger-than]

Use dynamic allocation instead. It should also be possible to
have single element here instead of the array, but this seems
easier.

v2: fix up argument to sizeof() (Alex)

Fixes: 334682ae8151 ("drm/amd/pm: enable workload type change on smu_v13_0_7")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index d74debc584f8..39deb06a86ba 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1436,7 +1436,7 @@ static int smu_v13_0_7_get_power_limit(struct smu_context *smu,
 
 static int smu_v13_0_7_get_power_profile_mode(struct smu_context *smu, char *buf)
 {
-	DpmActivityMonitorCoeffIntExternal_t activity_monitor_external[PP_SMC_POWER_PROFILE_COUNT];
+	DpmActivityMonitorCoeffIntExternal_t *activity_monitor_external;
 	uint32_t i, j, size = 0;
 	int16_t workload_type = 0;
 	int result = 0;
@@ -1444,6 +1444,12 @@ static int smu_v13_0_7_get_power_profile_mode(struct smu_context *smu, char *buf
 	if (!buf)
 		return -EINVAL;
 
+	activity_monitor_external = kcalloc(PP_SMC_POWER_PROFILE_COUNT,
+					    sizeof(*activity_monitor_external),
+					    GFP_KERNEL);
+	if (!activity_monitor_external)
+		return -ENOMEM;
+
 	size += sysfs_emit_at(buf, size, "                              ");
 	for (i = 0; i <= PP_SMC_POWER_PROFILE_WINDOW3D; i++)
 		size += sysfs_emit_at(buf, size, "%-14s%s", amdgpu_pp_profile_name[i],
@@ -1456,15 +1462,17 @@ static int smu_v13_0_7_get_power_profile_mode(struct smu_context *smu, char *buf
 		workload_type = smu_cmn_to_asic_specific_index(smu,
 							       CMN2ASIC_MAPPING_WORKLOAD,
 							       i);
-		if (workload_type < 0)
-			return -EINVAL;
+		if (workload_type < 0) {
+			result = -EINVAL;
+			goto out;
+		}
 
 		result = smu_cmn_update_table(smu,
 					  SMU_TABLE_ACTIVITY_MONITOR_COEFF, workload_type,
 					  (void *)(&activity_monitor_external[i]), false);
 		if (result) {
 			dev_err(smu->adev->dev, "[%s] Failed to get activity monitor!", __func__);
-			return result;
+			goto out;
 		}
 	}
 
@@ -1492,7 +1500,10 @@ do {													\
 	PRINT_DPM_MONITOR(Fclk_BoosterFreq);
 #undef PRINT_DPM_MONITOR
 
-	return size;
+	result = size;
+out:
+	kfree(activity_monitor_external);
+	return result;
 }
 
 static int smu_v13_0_7_set_power_profile_mode(struct smu_context *smu, long *input, uint32_t size)
-- 
2.35.1



