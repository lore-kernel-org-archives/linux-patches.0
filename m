Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C651C5F30;
	Wed, 19 Feb 2025 08:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954424; cv=none; b=ivqrIaFt5LQxThsOdVCMwZB5zq+ISNtor1a65EK8zc+/KHAXLWwK46LYQj+dEIXpyeOhVjoXXSysTk5I2+ldAVC3jbme8OdC1Z0ek5180lTFcSO/uIhXH0OMuZ8wkFg7Ji881N/OfTAdIopnU+zLa3IepyVcHch3bD6eEWRodhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954424; c=relaxed/simple;
	bh=0OCglGThr2XVBLRQzzWhn+3PWxYwVWpDnmItulH9L/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRMBkB+1IJEF9Bzf1mFeNJcE/4o9+XJnp9MF8ScRhBAK+LI48a2bqcfhja4ZweWg/MhWudw0/BEdjViDIvnLSNcWsMqmWihjPp5DrECRiC9wAo7UGUwjIbJ1yjNMRkDnJpVtItC4Hq2oV55IsZTRHW0M2MM0ur0T/bzB5+627gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2N5PRSlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2N5PRSlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52C7C4CED1;
	Wed, 19 Feb 2025 08:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954424;
	bh=0OCglGThr2XVBLRQzzWhn+3PWxYwVWpDnmItulH9L/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2N5PRSlIzoz5xd6C5LYhjfibwXbYpluZJ9SAwJgyf2m6UhWCAAABX2XFEtmdQlhk5
	 Gb9xjsiv19CaI02yPa002kDMCOZKJVgw1l5nD0VMZHt58Ig+kg3m+wlv0Q77PPn6Qx
	 SuGryWUYOFOiAjGCysbY8tajsOeRmC1kJA0yEucI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 200/274] drm/xe/oa/uapi: Expose an unblock after N reports OA property
Date: Wed, 19 Feb 2025 09:27:34 +0100
Message-ID: <20250219082617.408124604@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 5637797add2af632a5d037044ab1b0b35643902e ]

Expose an "unblock after N reports" OA property, to allow userspace threads
to be woken up less frequently.

Co-developed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241212224903.1853862-1-ashutosh.dixit@intel.com
Stable-dep-of: 990d35edc5d3 ("drm/xe/oa: Set stream->pollin in xe_oa_buffer_check_unlocked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c       | 30 ++++++++++++++++++++++++++----
 drivers/gpu/drm/xe/xe_oa_types.h |  3 +++
 drivers/gpu/drm/xe/xe_query.c    |  3 ++-
 include/uapi/drm/xe_drm.h        |  7 +++++++
 4 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index dd9d2d374b2d4..d56b0a0ede0da 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -91,6 +91,7 @@ struct xe_oa_open_param {
 	int num_syncs;
 	struct xe_sync_entry *syncs;
 	size_t oa_buffer_size;
+	int wait_num_reports;
 };
 
 struct xe_oa_config_bo {
@@ -235,11 +236,10 @@ static void oa_timestamp_clear(struct xe_oa_stream *stream, u32 *report)
 static bool xe_oa_buffer_check_unlocked(struct xe_oa_stream *stream)
 {
 	u32 gtt_offset = xe_bo_ggtt_addr(stream->oa_buffer.bo);
+	u32 tail, hw_tail, partial_report_size, available;
 	int report_size = stream->oa_buffer.format->size;
-	u32 tail, hw_tail;
 	unsigned long flags;
 	bool pollin;
-	u32 partial_report_size;
 
 	spin_lock_irqsave(&stream->oa_buffer.ptr_lock, flags);
 
@@ -283,8 +283,8 @@ static bool xe_oa_buffer_check_unlocked(struct xe_oa_stream *stream)
 
 	stream->oa_buffer.tail = tail;
 
-	pollin = xe_oa_circ_diff(stream, stream->oa_buffer.tail,
-				 stream->oa_buffer.head) >= report_size;
+	available = xe_oa_circ_diff(stream, stream->oa_buffer.tail, stream->oa_buffer.head);
+	pollin = available >= stream->wait_num_reports * report_size;
 
 	spin_unlock_irqrestore(&stream->oa_buffer.ptr_lock, flags);
 
@@ -1247,6 +1247,17 @@ static int xe_oa_set_prop_oa_buffer_size(struct xe_oa *oa, u64 value,
 	return 0;
 }
 
+static int xe_oa_set_prop_wait_num_reports(struct xe_oa *oa, u64 value,
+					   struct xe_oa_open_param *param)
+{
+	if (!value) {
+		drm_dbg(&oa->xe->drm, "wait_num_reports %llu\n", value);
+		return -EINVAL;
+	}
+	param->wait_num_reports = value;
+	return 0;
+}
+
 static int xe_oa_set_prop_ret_inval(struct xe_oa *oa, u64 value,
 				    struct xe_oa_open_param *param)
 {
@@ -1268,6 +1279,7 @@ static const xe_oa_set_property_fn xe_oa_set_property_funcs_open[] = {
 	[DRM_XE_OA_PROPERTY_NUM_SYNCS] = xe_oa_set_prop_num_syncs,
 	[DRM_XE_OA_PROPERTY_SYNCS] = xe_oa_set_prop_syncs_user,
 	[DRM_XE_OA_PROPERTY_OA_BUFFER_SIZE] = xe_oa_set_prop_oa_buffer_size,
+	[DRM_XE_OA_PROPERTY_WAIT_NUM_REPORTS] = xe_oa_set_prop_wait_num_reports,
 };
 
 static const xe_oa_set_property_fn xe_oa_set_property_funcs_config[] = {
@@ -1283,6 +1295,7 @@ static const xe_oa_set_property_fn xe_oa_set_property_funcs_config[] = {
 	[DRM_XE_OA_PROPERTY_NUM_SYNCS] = xe_oa_set_prop_num_syncs,
 	[DRM_XE_OA_PROPERTY_SYNCS] = xe_oa_set_prop_syncs_user,
 	[DRM_XE_OA_PROPERTY_OA_BUFFER_SIZE] = xe_oa_set_prop_ret_inval,
+	[DRM_XE_OA_PROPERTY_WAIT_NUM_REPORTS] = xe_oa_set_prop_ret_inval,
 };
 
 static int xe_oa_user_ext_set_property(struct xe_oa *oa, enum xe_oa_user_extn_from from,
@@ -1759,6 +1772,7 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 	stream->periodic = param->period_exponent > 0;
 	stream->period_exponent = param->period_exponent;
 	stream->no_preempt = param->no_preempt;
+	stream->wait_num_reports = param->wait_num_reports;
 
 	stream->xef = xe_file_get(param->xef);
 	stream->num_syncs = param->num_syncs;
@@ -2118,6 +2132,14 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
 	if (!param.oa_buffer_size)
 		param.oa_buffer_size = DEFAULT_XE_OA_BUFFER_SIZE;
 
+	if (!param.wait_num_reports)
+		param.wait_num_reports = 1;
+	if (param.wait_num_reports > param.oa_buffer_size / f->size) {
+		drm_dbg(&oa->xe->drm, "wait_num_reports %d\n", param.wait_num_reports);
+		ret = -EINVAL;
+		goto err_exec_q;
+	}
+
 	ret = xe_oa_parse_syncs(oa, &param);
 	if (ret)
 		goto err_exec_q;
diff --git a/drivers/gpu/drm/xe/xe_oa_types.h b/drivers/gpu/drm/xe/xe_oa_types.h
index df77939156288..2dcd3b9562e97 100644
--- a/drivers/gpu/drm/xe/xe_oa_types.h
+++ b/drivers/gpu/drm/xe/xe_oa_types.h
@@ -218,6 +218,9 @@ struct xe_oa_stream {
 	/** @pollin: Whether there is data available to read */
 	bool pollin;
 
+	/** @wait_num_reports: Number of reports to wait for before signalling pollin */
+	int wait_num_reports;
+
 	/** @periodic: Whether periodic sampling is currently enabled */
 	bool periodic;
 
diff --git a/drivers/gpu/drm/xe/xe_query.c b/drivers/gpu/drm/xe/xe_query.c
index 1cda6cbd9b795..1bdffe6315d54 100644
--- a/drivers/gpu/drm/xe/xe_query.c
+++ b/drivers/gpu/drm/xe/xe_query.c
@@ -671,7 +671,8 @@ static int query_oa_units(struct xe_device *xe,
 			du->oa_unit_type = u->type;
 			du->oa_timestamp_freq = xe_oa_timestamp_frequency(gt);
 			du->capabilities = DRM_XE_OA_CAPS_BASE | DRM_XE_OA_CAPS_SYNCS |
-					   DRM_XE_OA_CAPS_OA_BUFFER_SIZE;
+					   DRM_XE_OA_CAPS_OA_BUFFER_SIZE |
+					   DRM_XE_OA_CAPS_WAIT_NUM_REPORTS;
 
 			j = 0;
 			for_each_hw_engine(hwe, gt, hwe_id) {
diff --git a/include/uapi/drm/xe_drm.h b/include/uapi/drm/xe_drm.h
index 0383b52cbd869..f62689ca861a4 100644
--- a/include/uapi/drm/xe_drm.h
+++ b/include/uapi/drm/xe_drm.h
@@ -1487,6 +1487,7 @@ struct drm_xe_oa_unit {
 #define DRM_XE_OA_CAPS_BASE		(1 << 0)
 #define DRM_XE_OA_CAPS_SYNCS		(1 << 1)
 #define DRM_XE_OA_CAPS_OA_BUFFER_SIZE	(1 << 2)
+#define DRM_XE_OA_CAPS_WAIT_NUM_REPORTS	(1 << 3)
 
 	/** @oa_timestamp_freq: OA timestamp freq */
 	__u64 oa_timestamp_freq;
@@ -1660,6 +1661,12 @@ enum drm_xe_oa_property_id {
 	 * buffer is allocated by default.
 	 */
 	DRM_XE_OA_PROPERTY_OA_BUFFER_SIZE,
+
+	/**
+	 * @DRM_XE_OA_PROPERTY_WAIT_NUM_REPORTS: Number of reports to wait
+	 * for before unblocking poll or read
+	 */
+	DRM_XE_OA_PROPERTY_WAIT_NUM_REPORTS,
 };
 
 /**
-- 
2.39.5



