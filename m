Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A552EFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7FFC433EF;
	Mon, 15 May 2023 16:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169243;
	bh=m3A2LEQw96u0xuoOZL80r0yaJP9Nb+odg++rSFtaHj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZY+F1Rn/4ftMx396NruIi1MtPLapGM8Bu1E/8RFlz5A3RWSHR8VCrB9ZTNregt8z
	 oYCzZkOPGKQ5euYPnshERZ6syJSJojZlQK0h55OdOGX22G3p/ieSVRD04vyrMNawLu
	 BjSK3Zhk3PiYK3Sj6OYSbIxRt1T1KY/1n43jMuuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/191] drm/amdgpu: Add command to override the context priority.
Date: Mon, 15 May 2023 18:26:35 +0200
Message-Id: <20230515161713.154702139@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

[ Upstream commit b5bb37eddb63b16b7ab959598d108b1c444be77d ]

Given a master fd we can then override the priority of the context
in another fd.

Using these overrides was recommended by Christian instead of trying
to submit from a master fd, and I am adding a way to override a
single context instead of the entire process so we can only upgrade
a single Vulkan queue and not effectively the entire process.

Reused the flags field as it was checked to be 0 anyways, so nothing
used it. This is source-incompatible (due to the name change), but
ABI compatible.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 2397e3d8d2e1 ("drm/amdgpu: add a missing lock for AMDGPU_SCHED")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c | 41 ++++++++++++++++++++++-
 include/uapi/drm/amdgpu_drm.h             |  3 +-
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
index 0b70410488b66..0767a93e4d913 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
@@ -76,6 +76,39 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
 	return 0;
 }
 
+static int amdgpu_sched_context_priority_override(struct amdgpu_device *adev,
+						  int fd,
+						  unsigned ctx_id,
+						  enum drm_sched_priority priority)
+{
+	struct file *filp = fget(fd);
+	struct amdgpu_fpriv *fpriv;
+	struct amdgpu_ctx *ctx;
+	int r;
+
+	if (!filp)
+		return -EINVAL;
+
+	r = amdgpu_file_to_fpriv(filp, &fpriv);
+	if (r) {
+		fput(filp);
+		return r;
+	}
+
+	ctx = amdgpu_ctx_get(fpriv, ctx_id);
+
+	if (!ctx) {
+		fput(filp);
+		return -EINVAL;
+	}
+
+	amdgpu_ctx_priority_override(ctx, priority);
+	amdgpu_ctx_put(ctx);
+	fput(filp);
+
+	return 0;
+}
+
 int amdgpu_sched_ioctl(struct drm_device *dev, void *data,
 		       struct drm_file *filp)
 {
@@ -85,7 +118,7 @@ int amdgpu_sched_ioctl(struct drm_device *dev, void *data,
 	int r;
 
 	priority = amdgpu_to_sched_priority(args->in.priority);
-	if (args->in.flags || priority == DRM_SCHED_PRIORITY_INVALID)
+	if (priority == DRM_SCHED_PRIORITY_INVALID)
 		return -EINVAL;
 
 	switch (args->in.op) {
@@ -94,6 +127,12 @@ int amdgpu_sched_ioctl(struct drm_device *dev, void *data,
 							   args->in.fd,
 							   priority);
 		break;
+	case AMDGPU_SCHED_OP_CONTEXT_PRIORITY_OVERRIDE:
+		r = amdgpu_sched_context_priority_override(adev,
+							   args->in.fd,
+							   args->in.ctx_id,
+							   priority);
+		break;
 	default:
 		DRM_ERROR("Invalid sched op specified: %d\n", args->in.op);
 		r = -EINVAL;
diff --git a/include/uapi/drm/amdgpu_drm.h b/include/uapi/drm/amdgpu_drm.h
index 1ceec56de0157..b72aeb766fc7a 100644
--- a/include/uapi/drm/amdgpu_drm.h
+++ b/include/uapi/drm/amdgpu_drm.h
@@ -272,13 +272,14 @@ union drm_amdgpu_vm {
 
 /* sched ioctl */
 #define AMDGPU_SCHED_OP_PROCESS_PRIORITY_OVERRIDE	1
+#define AMDGPU_SCHED_OP_CONTEXT_PRIORITY_OVERRIDE	2
 
 struct drm_amdgpu_sched_in {
 	/* AMDGPU_SCHED_OP_* */
 	__u32	op;
 	__u32	fd;
 	__s32	priority;
-	__u32	flags;
+	__u32   ctx_id;
 };
 
 union drm_amdgpu_sched {
-- 
2.39.2



