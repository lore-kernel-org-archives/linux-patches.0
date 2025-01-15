Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A791E991F;
	Wed, 15 Jan 2025 10:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938443; cv=none; b=nd/6yfyioqx9pr5/tEJc28XmA49n337rAMRN2wQKRMMAA4hPA5guz0xOoUnEWvnsXeGIB+83MAdVNb8lVAww99xdLP5wG1JEX8vui2g8Yc33pHhHUTZexZAWA0NicLizoGkH67C1smCNM9habRxFqhJhzCf9vOflk1Bbc83Fbgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938443; c=relaxed/simple;
	bh=2CJKO2cjdecZnpakG7e4gOSCs/oOTX0v+SigMrlhvY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBJw4T29Tq4GXYq371KsaJZCeA80/FhtHeNTrKjMLp+NQimZoDjjRJbSOJ0snKdLjPa34/Mcn8hhi0x5wdRvJM7ZYznJctDFK+bBYbp+86iQoNOUlSV85RRx5Ncw0lrpGioBmaw8d2xcYKP0yUhZWk0WpPmTUuzwQcZ2w4lCOOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdGsJTu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdGsJTu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAF6C4CEDF;
	Wed, 15 Jan 2025 10:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938443;
	bh=2CJKO2cjdecZnpakG7e4gOSCs/oOTX0v+SigMrlhvY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdGsJTu/OGgpWmLnexUukc+HMdfIaGesDxuUUN5/PDXdnEBNGgwROX6RCxVt2kU5/
	 K/DqMrnbuoMh0+biVVnRTO3/j9TD580pYSd6kePxp3EEfGMYRF95l0jD8eGvKANGpE
	 EJ4+PjnZKfOdPKoKGvnrwjFcU9RvFLQNQUHLXbYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/189] drm/xe/oa: Add input fence dependencies
Date: Wed, 15 Jan 2025 11:38:00 +0100
Message-ID: <20250115103613.749396091@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 2fb4350a283af03a5ee34ba765783a941f942b82 ]

Add input fence dependencies which will make OA configuration wait till
these dependencies are met (till input fences signal).

v2: Change add_deps arg to xe_oa_submit_bb from bool to enum (Matt Brost)

Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241022200352.1192560-4-ashutosh.dixit@intel.com
Stable-dep-of: f0ed39830e60 ("xe/oa: Fix query mode of operation for OAR/OAC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 94c558d949e1..fd14d62bfb54 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -42,6 +42,11 @@
 #define DEFAULT_POLL_PERIOD_NS (NSEC_PER_SEC / DEFAULT_POLL_FREQUENCY_HZ)
 #define XE_OA_UNIT_INVALID U32_MAX
 
+enum xe_oa_submit_deps {
+	XE_OA_SUBMIT_NO_DEPS,
+	XE_OA_SUBMIT_ADD_DEPS,
+};
+
 struct xe_oa_reg {
 	struct xe_reg addr;
 	u32 value;
@@ -572,7 +577,8 @@ static __poll_t xe_oa_poll(struct file *file, poll_table *wait)
 	return ret;
 }
 
-static struct dma_fence *xe_oa_submit_bb(struct xe_oa_stream *stream, struct xe_bb *bb)
+static struct dma_fence *xe_oa_submit_bb(struct xe_oa_stream *stream, enum xe_oa_submit_deps deps,
+					 struct xe_bb *bb)
 {
 	struct xe_sched_job *job;
 	struct dma_fence *fence;
@@ -585,11 +591,22 @@ static struct dma_fence *xe_oa_submit_bb(struct xe_oa_stream *stream, struct xe_
 		goto exit;
 	}
 
+	if (deps == XE_OA_SUBMIT_ADD_DEPS) {
+		for (int i = 0; i < stream->num_syncs && !err; i++)
+			err = xe_sync_entry_add_deps(&stream->syncs[i], job);
+		if (err) {
+			drm_dbg(&stream->oa->xe->drm, "xe_sync_entry_add_deps err %d\n", err);
+			goto err_put_job;
+		}
+	}
+
 	xe_sched_job_arm(job);
 	fence = dma_fence_get(&job->drm.s_fence->finished);
 	xe_sched_job_push(job);
 
 	return fence;
+err_put_job:
+	xe_sched_job_put(job);
 exit:
 	return ERR_PTR(err);
 }
@@ -667,7 +684,7 @@ static int xe_oa_modify_ctx_image(struct xe_oa_stream *stream, struct xe_lrc *lr
 
 	xe_oa_store_flex(stream, lrc, bb, flex, count);
 
-	fence = xe_oa_submit_bb(stream, bb);
+	fence = xe_oa_submit_bb(stream, XE_OA_SUBMIT_NO_DEPS, bb);
 	if (IS_ERR(fence)) {
 		err = PTR_ERR(fence);
 		goto free_bb;
@@ -696,7 +713,7 @@ static int xe_oa_load_with_lri(struct xe_oa_stream *stream, struct xe_oa_reg *re
 
 	write_cs_mi_lri(bb, reg_lri, 1);
 
-	fence = xe_oa_submit_bb(stream, bb);
+	fence = xe_oa_submit_bb(stream, XE_OA_SUBMIT_NO_DEPS, bb);
 	if (IS_ERR(fence)) {
 		err = PTR_ERR(fence);
 		goto free_bb;
@@ -944,7 +961,7 @@ static int xe_oa_emit_oa_config(struct xe_oa_stream *stream, struct xe_oa_config
 		goto exit;
 	}
 
-	fence = xe_oa_submit_bb(stream, oa_bo->bb);
+	fence = xe_oa_submit_bb(stream, XE_OA_SUBMIT_ADD_DEPS, oa_bo->bb);
 	if (IS_ERR(fence)) {
 		err = PTR_ERR(fence);
 		goto exit;
-- 
2.39.5



