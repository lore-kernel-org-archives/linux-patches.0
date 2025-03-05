Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8797250BFC;
	Wed,  5 Mar 2025 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198138; cv=none; b=RQUDlqd5HsvIBHsTxblou+FSOd4KgFW9NnPbwVoypiTLzK8fXvajF/qz7F317W87sW8A4I7H1q78KfR1c5fyRsm8u6ROGmtFLCGpducBHkyaMrqHc0izKhBFHKxAszT84TpbO7RjTI2GbeLuSmMqA1sEGvc9CSBZBea3f1ATFWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198138; c=relaxed/simple;
	bh=HUUNtD/eJfpj+O5GvFhT5VIC/liyt4iqId5Tx08Dka4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okHuGASbuAHVrbXjCPOh6IqNDVMmGUQOXo1xPf6LUFfZW0iWeOeI9rSAkDfkv08HrxMuoZ3LCTjvaNOr9db0sciR6JP2qlFMSqWvwRBlRumG2TdpNCNKnneeK14TfXK4Muku9Iv3pXrTtwb0M6/FaUpbxzq3aoyd0ONxgt4xUww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHTIFlwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHTIFlwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5594AC4CED1;
	Wed,  5 Mar 2025 18:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198138;
	bh=HUUNtD/eJfpj+O5GvFhT5VIC/liyt4iqId5Tx08Dka4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHTIFlwIN9YT53TemLXrLA+gJpxfLURFrQI2XAEtai6vF3z5UmVmTeFP65AZlSMt4
	 LJEpTk6P/X4LzXughULmpLw08LudgwgxIPsnYcMi4btqHP0HDKI/VG3+TqB1I1PTvt
	 gkQpKHNrk+E1JHoJlY7M+DNxcQb3zDlWE5EP+9/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/150] drm/xe/oa: Add syncs support to OA config ioctl
Date: Wed,  5 Mar 2025 18:47:55 +0100
Message-ID: <20250305174505.672720301@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 9920c8b88c5cf2e44f4ff508dd3c0c96e4364db0 ]

In addition to stream open, add xe_sync support to the OA config ioctl,
where it is even more useful. This allows e.g. Mesa to replay a workload
repeatedly on the GPU, each time with a different OA configuration, while
precisely controlling (at batch buffer granularity) the workload segment
for which a particular OA configuration is active, without introducing
stalls in the userspace pipeline.

v2: Emit OA config even when config id is same as previous, to ensure
    consistent sync behavior (Jose)

Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241022200352.1192560-7-ashutosh.dixit@intel.com
Stable-dep-of: 5bd566703e16 ("drm/xe/oa: Allow oa_exponent value of 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c       | 41 ++++++++++++++++++--------------
 drivers/gpu/drm/xe/xe_oa_types.h |  3 +++
 2 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index dd541b62942f8..78f662fd197c4 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -844,6 +844,7 @@ static void xe_oa_stream_destroy(struct xe_oa_stream *stream)
 		xe_gt_WARN_ON(gt, xe_guc_pc_unset_gucrc_mode(&gt->uc.guc.pc));
 
 	xe_oa_free_configs(stream);
+	xe_file_put(stream->xef);
 }
 
 static int xe_oa_alloc_oa_buffer(struct xe_oa_stream *stream)
@@ -1413,36 +1414,38 @@ static int xe_oa_disable_locked(struct xe_oa_stream *stream)
 
 static long xe_oa_config_locked(struct xe_oa_stream *stream, u64 arg)
 {
-	struct drm_xe_ext_set_property ext;
+	struct xe_oa_open_param param = {};
 	long ret = stream->oa_config->id;
 	struct xe_oa_config *config;
 	int err;
 
-	err = __copy_from_user(&ext, u64_to_user_ptr(arg), sizeof(ext));
-	if (XE_IOCTL_DBG(stream->oa->xe, err))
-		return -EFAULT;
-
-	if (XE_IOCTL_DBG(stream->oa->xe, ext.pad) ||
-	    XE_IOCTL_DBG(stream->oa->xe, ext.base.name != DRM_XE_OA_EXTENSION_SET_PROPERTY) ||
-	    XE_IOCTL_DBG(stream->oa->xe, ext.base.next_extension) ||
-	    XE_IOCTL_DBG(stream->oa->xe, ext.property != DRM_XE_OA_PROPERTY_OA_METRIC_SET))
-		return -EINVAL;
+	err = xe_oa_user_extensions(stream->oa, arg, 0, &param);
+	if (err)
+		return err;
 
-	config = xe_oa_get_oa_config(stream->oa, ext.value);
+	config = xe_oa_get_oa_config(stream->oa, param.metric_set);
 	if (!config)
 		return -ENODEV;
 
-	if (config != stream->oa_config) {
-		err = xe_oa_emit_oa_config(stream, config);
-		if (!err)
-			config = xchg(&stream->oa_config, config);
-		else
-			ret = err;
+	param.xef = stream->xef;
+	err = xe_oa_parse_syncs(stream->oa, &param);
+	if (err)
+		goto err_config_put;
+
+	stream->num_syncs = param.num_syncs;
+	stream->syncs = param.syncs;
+
+	err = xe_oa_emit_oa_config(stream, config);
+	if (!err) {
+		config = xchg(&stream->oa_config, config);
+		drm_dbg(&stream->oa->xe->drm, "changed to oa config uuid=%s\n",
+			stream->oa_config->uuid);
 	}
 
+err_config_put:
 	xe_oa_config_put(config);
 
-	return ret;
+	return err ?: ret;
 }
 
 static long xe_oa_status_locked(struct xe_oa_stream *stream, unsigned long arg)
@@ -1685,6 +1688,7 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 	stream->period_exponent = param->period_exponent;
 	stream->no_preempt = param->no_preempt;
 
+	stream->xef = xe_file_get(param->xef);
 	stream->num_syncs = param->num_syncs;
 	stream->syncs = param->syncs;
 
@@ -1784,6 +1788,7 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 err_free_configs:
 	xe_oa_free_configs(stream);
 exit:
+	xe_file_put(stream->xef);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_oa_types.h b/drivers/gpu/drm/xe/xe_oa_types.h
index c8e0df13faf83..fea9d981e414f 100644
--- a/drivers/gpu/drm/xe/xe_oa_types.h
+++ b/drivers/gpu/drm/xe/xe_oa_types.h
@@ -239,6 +239,9 @@ struct xe_oa_stream {
 	/** @no_preempt: Whether preemption and timeslicing is disabled for stream exec_q */
 	u32 no_preempt;
 
+	/** @xef: xe_file with which the stream was opened */
+	struct xe_file *xef;
+
 	/** @last_fence: fence to use in stream destroy when needed */
 	struct dma_fence *last_fence;
 
-- 
2.39.5



