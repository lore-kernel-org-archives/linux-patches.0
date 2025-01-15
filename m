Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEC61E98E6;
	Wed, 15 Jan 2025 10:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938440; cv=none; b=WE0aeSDYWbv41j1Iz3OQwyJmbnJQZbbUsBoBTg2Vbw/DucopODB8wqmz1cFzo5O05yForlugKEZx5xIKahuOc9OMDSqu66IdcNob7juE+ZXNDubZIK8pq7xv936Eg3d76u1DWIQWaHtTCVB7uaFcn+QrE1/j4lnXn1PiEDOLPGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938440; c=relaxed/simple;
	bh=iEOAA1o86qjmAOzmUVtevvKxvKE1w7u5KZmdZE8nddY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qgZpoFuqhdRWqZ8EkZMOLz74YEwY4TqcssXkrXsP1E24tpjvdNYbYlZIjJbQomqBjX9pc2ZzdrtagtEAYFHSQ4YQEWT5tus1Eo+FogZazHTQJkcG3mVsKLadE0OrWcckft6Vl4b2TFj4rSPcSDNX2aRkV3aZpaUBtMFEUDhmkEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNpC3Vq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNpC3Vq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FBFC4CEDF;
	Wed, 15 Jan 2025 10:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938440;
	bh=iEOAA1o86qjmAOzmUVtevvKxvKE1w7u5KZmdZE8nddY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNpC3Vq6ObQ3Fyaw64MyJ57l8CzMsb1XahBclS0Dvlr5Z9aW6WjOVEmUwGbO4MqrV
	 TozzLyHtKnS7R/zSr8hxwa9adrSFhw+mBlTL/EiDwA+KR4pHvqhCD9kF1azTqIcL/d
	 0vn9ucOwrxCkU15IABMrZ9Rl8UTHqVqbvcCj3Fqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/189] drm/xe/oa/uapi: Define and parse OA sync properties
Date: Wed, 15 Jan 2025 11:37:59 +0100
Message-ID: <20250115103613.709036132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit c8507a25cebd179db935dd266a33c51bef1b1e80 ]

Now that we have laid the groundwork, introduce OA sync properties in the
uapi and parse the input xe_sync array as is done elsewhere in the
driver. Also add DRM_XE_OA_CAPS_SYNCS bit in OA capabilities for userspace.

v2: Fix and document DRM_XE_SYNC_TYPE_USER_FENCE for OA (Matt B)
    Add DRM_XE_OA_CAPS_SYNCS bit to OA capabilities (Jose)

Acked-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241022200352.1192560-3-ashutosh.dixit@intel.com
Stable-dep-of: f0ed39830e60 ("xe/oa: Fix query mode of operation for OAR/OAC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c       | 83 +++++++++++++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_oa_types.h |  6 +++
 drivers/gpu/drm/xe/xe_query.c    |  2 +-
 include/uapi/drm/xe_drm.h        | 17 +++++++
 4 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 4962c9eb9a81..94c558d949e1 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -36,6 +36,7 @@
 #include "xe_pm.h"
 #include "xe_sched_job.h"
 #include "xe_sriov.h"
+#include "xe_sync.h"
 
 #define DEFAULT_POLL_FREQUENCY_HZ 200
 #define DEFAULT_POLL_PERIOD_NS (NSEC_PER_SEC / DEFAULT_POLL_FREQUENCY_HZ)
@@ -70,6 +71,7 @@ struct flex {
 };
 
 struct xe_oa_open_param {
+	struct xe_file *xef;
 	u32 oa_unit_id;
 	bool sample;
 	u32 metric_set;
@@ -81,6 +83,9 @@ struct xe_oa_open_param {
 	struct xe_exec_queue *exec_q;
 	struct xe_hw_engine *hwe;
 	bool no_preempt;
+	struct drm_xe_sync __user *syncs_user;
+	int num_syncs;
+	struct xe_sync_entry *syncs;
 };
 
 struct xe_oa_config_bo {
@@ -1393,6 +1398,9 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 	stream->period_exponent = param->period_exponent;
 	stream->no_preempt = param->no_preempt;
 
+	stream->num_syncs = param->num_syncs;
+	stream->syncs = param->syncs;
+
 	/*
 	 * For Xe2+, when overrun mode is enabled, there are no partial reports at the end
 	 * of buffer, making the OA buffer effectively a non-power-of-2 size circular
@@ -1743,6 +1751,20 @@ static int xe_oa_set_no_preempt(struct xe_oa *oa, u64 value,
 	return 0;
 }
 
+static int xe_oa_set_prop_num_syncs(struct xe_oa *oa, u64 value,
+				    struct xe_oa_open_param *param)
+{
+	param->num_syncs = value;
+	return 0;
+}
+
+static int xe_oa_set_prop_syncs_user(struct xe_oa *oa, u64 value,
+				     struct xe_oa_open_param *param)
+{
+	param->syncs_user = u64_to_user_ptr(value);
+	return 0;
+}
+
 typedef int (*xe_oa_set_property_fn)(struct xe_oa *oa, u64 value,
 				     struct xe_oa_open_param *param);
 static const xe_oa_set_property_fn xe_oa_set_property_funcs[] = {
@@ -1755,6 +1777,8 @@ static const xe_oa_set_property_fn xe_oa_set_property_funcs[] = {
 	[DRM_XE_OA_PROPERTY_EXEC_QUEUE_ID] = xe_oa_set_prop_exec_queue_id,
 	[DRM_XE_OA_PROPERTY_OA_ENGINE_INSTANCE] = xe_oa_set_prop_engine_instance,
 	[DRM_XE_OA_PROPERTY_NO_PREEMPT] = xe_oa_set_no_preempt,
+	[DRM_XE_OA_PROPERTY_NUM_SYNCS] = xe_oa_set_prop_num_syncs,
+	[DRM_XE_OA_PROPERTY_SYNCS] = xe_oa_set_prop_syncs_user,
 };
 
 static int xe_oa_user_ext_set_property(struct xe_oa *oa, u64 extension,
@@ -1814,6 +1838,49 @@ static int xe_oa_user_extensions(struct xe_oa *oa, u64 extension, int ext_number
 	return 0;
 }
 
+static int xe_oa_parse_syncs(struct xe_oa *oa, struct xe_oa_open_param *param)
+{
+	int ret, num_syncs, num_ufence = 0;
+
+	if (param->num_syncs && !param->syncs_user) {
+		drm_dbg(&oa->xe->drm, "num_syncs specified without sync array\n");
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (param->num_syncs) {
+		param->syncs = kcalloc(param->num_syncs, sizeof(*param->syncs), GFP_KERNEL);
+		if (!param->syncs) {
+			ret = -ENOMEM;
+			goto exit;
+		}
+	}
+
+	for (num_syncs = 0; num_syncs < param->num_syncs; num_syncs++) {
+		ret = xe_sync_entry_parse(oa->xe, param->xef, &param->syncs[num_syncs],
+					  &param->syncs_user[num_syncs], 0);
+		if (ret)
+			goto err_syncs;
+
+		if (xe_sync_is_ufence(&param->syncs[num_syncs]))
+			num_ufence++;
+	}
+
+	if (XE_IOCTL_DBG(oa->xe, num_ufence > 1)) {
+		ret = -EINVAL;
+		goto err_syncs;
+	}
+
+	return 0;
+
+err_syncs:
+	while (num_syncs--)
+		xe_sync_entry_cleanup(&param->syncs[num_syncs]);
+	kfree(param->syncs);
+exit:
+	return ret;
+}
+
 /**
  * xe_oa_stream_open_ioctl - Opens an OA stream
  * @dev: @drm_device
@@ -1839,6 +1906,7 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
 		return -ENODEV;
 	}
 
+	param.xef = xef;
 	ret = xe_oa_user_extensions(oa, data, 0, &param);
 	if (ret)
 		return ret;
@@ -1907,11 +1975,24 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
 		drm_dbg(&oa->xe->drm, "Using periodic sampling freq %lld Hz\n", oa_freq_hz);
 	}
 
+	ret = xe_oa_parse_syncs(oa, &param);
+	if (ret)
+		goto err_exec_q;
+
 	mutex_lock(&param.hwe->gt->oa.gt_lock);
 	ret = xe_oa_stream_open_ioctl_locked(oa, &param);
 	mutex_unlock(&param.hwe->gt->oa.gt_lock);
+	if (ret < 0)
+		goto err_sync_cleanup;
+
+	return ret;
+
+err_sync_cleanup:
+	while (param.num_syncs--)
+		xe_sync_entry_cleanup(&param.syncs[param.num_syncs]);
+	kfree(param.syncs);
 err_exec_q:
-	if (ret < 0 && param.exec_q)
+	if (param.exec_q)
 		xe_exec_queue_put(param.exec_q);
 	return ret;
 }
diff --git a/drivers/gpu/drm/xe/xe_oa_types.h b/drivers/gpu/drm/xe/xe_oa_types.h
index 8862eca73fbe..99f4b2d4bdcf 100644
--- a/drivers/gpu/drm/xe/xe_oa_types.h
+++ b/drivers/gpu/drm/xe/xe_oa_types.h
@@ -238,5 +238,11 @@ struct xe_oa_stream {
 
 	/** @no_preempt: Whether preemption and timeslicing is disabled for stream exec_q */
 	u32 no_preempt;
+
+	/** @num_syncs: size of @syncs array */
+	u32 num_syncs;
+
+	/** @syncs: syncs to wait on and to signal */
+	struct xe_sync_entry *syncs;
 };
 #endif
diff --git a/drivers/gpu/drm/xe/xe_query.c b/drivers/gpu/drm/xe/xe_query.c
index 1c96375bd7df..6fec5d1a1eb4 100644
--- a/drivers/gpu/drm/xe/xe_query.c
+++ b/drivers/gpu/drm/xe/xe_query.c
@@ -679,7 +679,7 @@ static int query_oa_units(struct xe_device *xe,
 			du->oa_unit_id = u->oa_unit_id;
 			du->oa_unit_type = u->type;
 			du->oa_timestamp_freq = xe_oa_timestamp_frequency(gt);
-			du->capabilities = DRM_XE_OA_CAPS_BASE;
+			du->capabilities = DRM_XE_OA_CAPS_BASE | DRM_XE_OA_CAPS_SYNCS;
 
 			j = 0;
 			for_each_hw_engine(hwe, gt, hwe_id) {
diff --git a/include/uapi/drm/xe_drm.h b/include/uapi/drm/xe_drm.h
index c4182e95a619..4a8a4a63e99c 100644
--- a/include/uapi/drm/xe_drm.h
+++ b/include/uapi/drm/xe_drm.h
@@ -1485,6 +1485,7 @@ struct drm_xe_oa_unit {
 	/** @capabilities: OA capabilities bit-mask */
 	__u64 capabilities;
 #define DRM_XE_OA_CAPS_BASE		(1 << 0)
+#define DRM_XE_OA_CAPS_SYNCS		(1 << 1)
 
 	/** @oa_timestamp_freq: OA timestamp freq */
 	__u64 oa_timestamp_freq;
@@ -1634,6 +1635,22 @@ enum drm_xe_oa_property_id {
 	 * to be disabled for the stream exec queue.
 	 */
 	DRM_XE_OA_PROPERTY_NO_PREEMPT,
+
+	/**
+	 * @DRM_XE_OA_PROPERTY_NUM_SYNCS: Number of syncs in the sync array
+	 * specified in @DRM_XE_OA_PROPERTY_SYNCS
+	 */
+	DRM_XE_OA_PROPERTY_NUM_SYNCS,
+
+	/**
+	 * @DRM_XE_OA_PROPERTY_SYNCS: Pointer to struct @drm_xe_sync array
+	 * with array size specified via @DRM_XE_OA_PROPERTY_NUM_SYNCS. OA
+	 * configuration will wait till input fences signal. Output fences
+	 * will signal after the new OA configuration takes effect. For
+	 * @DRM_XE_SYNC_TYPE_USER_FENCE, @addr is a user pointer, similar
+	 * to the VM bind case.
+	 */
+	DRM_XE_OA_PROPERTY_SYNCS,
 };
 
 /**
-- 
2.39.5



