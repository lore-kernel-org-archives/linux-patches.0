Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC58FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB84C433D2;
	Mon, 15 May 2023 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169531;
	bh=Gwo4vQWt2xIeID0AOSvgoQAvl1jdqNntedPLM2qVDX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIqPAQfqfaP4rZxF9kSAy0Dper6N9Vg7ymZwJNQoLExQsQOccAO3ezf1M8g9PUrnE
	 Jp6mMmPz0xgMYc370J3MANwqnTSZvtKvMAjIUSm9SRY0++qWl/rH6+xYsUH161VvDQ
	 djR0yLbbhLcTUelIq5qyDpBQ8naQVRUe2SCz43bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 058/246] drm/i915/guc: Actually return an error if GuC version range check fails
Date: Mon, 15 May 2023 18:24:30 +0200
Message-Id: <20230515161724.317031752@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 1816f4a17f54a01afa2f06d6571c39890b97d282 ]

Dan Carpenter pointed out that 'err' was not being set in the case
where the GuC firmware version range check fails. Fix that.

Note that while this is a bug fix for a previous patch (see Fixes tag
below). It is an exceedingly low risk bug. The range check is
asserting that the GuC firmware version is within spec. So it should
not be possible to ever have a firmware file that fails this check. If
larger version numbers are required in the future, that would be a
backwards breaking spec change and thus require a major version bump,
in which case an old i915 driver would not load that new version anyway.

Fixes: 9bbba0667f37 ("drm/i915/guc: Use GuC submission API version number")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230421224742.2357198-1-John.C.Harrison@Intel.com
(cherry picked from commit 80ab31799002166ac7c660bacfbff4f85bc29107)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
index 264c952f777bb..22786d9116fd0 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
@@ -622,9 +622,10 @@ static bool is_ver_8bit(struct intel_uc_fw_ver *ver)
 	return ver->major < 0xFF && ver->minor < 0xFF && ver->patch < 0xFF;
 }
 
-static bool guc_check_version_range(struct intel_uc_fw *uc_fw)
+static int guc_check_version_range(struct intel_uc_fw *uc_fw)
 {
 	struct intel_guc *guc = container_of(uc_fw, struct intel_guc, fw);
+	struct intel_gt *gt = __uc_fw_to_gt(uc_fw);
 
 	/*
 	 * GuC version number components are defined as being 8-bits.
@@ -633,24 +634,24 @@ static bool guc_check_version_range(struct intel_uc_fw *uc_fw)
 	 */
 
 	if (!is_ver_8bit(&uc_fw->file_selected.ver)) {
-		gt_warn(__uc_fw_to_gt(uc_fw), "%s firmware: invalid file version: 0x%02X:%02X:%02X\n",
+		gt_warn(gt, "%s firmware: invalid file version: 0x%02X:%02X:%02X\n",
 			intel_uc_fw_type_repr(uc_fw->type),
 			uc_fw->file_selected.ver.major,
 			uc_fw->file_selected.ver.minor,
 			uc_fw->file_selected.ver.patch);
-		return false;
+		return -EINVAL;
 	}
 
 	if (!is_ver_8bit(&guc->submission_version)) {
-		gt_warn(__uc_fw_to_gt(uc_fw), "%s firmware: invalid submit version: 0x%02X:%02X:%02X\n",
+		gt_warn(gt, "%s firmware: invalid submit version: 0x%02X:%02X:%02X\n",
 			intel_uc_fw_type_repr(uc_fw->type),
 			guc->submission_version.major,
 			guc->submission_version.minor,
 			guc->submission_version.patch);
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	return i915_inject_probe_error(gt->i915, -EINVAL);
 }
 
 static int check_fw_header(struct intel_gt *gt,
@@ -759,8 +760,11 @@ int intel_uc_fw_fetch(struct intel_uc_fw *uc_fw)
 	if (err)
 		goto fail;
 
-	if (uc_fw->type == INTEL_UC_FW_TYPE_GUC && !guc_check_version_range(uc_fw))
-		goto fail;
+	if (uc_fw->type == INTEL_UC_FW_TYPE_GUC) {
+		err = guc_check_version_range(uc_fw);
+		if (err)
+			goto fail;
+	}
 
 	if (uc_fw->file_wanted.ver.major && uc_fw->file_selected.ver.major) {
 		/* Check the file's major version was as it claimed */
-- 
2.39.2



