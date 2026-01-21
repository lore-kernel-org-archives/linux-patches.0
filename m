Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361083AE6F3;
	Wed, 21 Jan 2026 18:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020420; cv=none; b=IzsAmIqoMOaddhIcBbjWXgbeNzgpUNl58sQ0x3Fq1JneketM5PwYv/xjprW2VGx5yjUoumsAfoeK+xgY8i+4m5NNllh5jbNLwWVtIBe7Ib5p31KTrtbyLWIQV7DS2E6bKqRq0vGyR1T/xQaI/SFaNdLQwXT/XvmODj40052z7As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020420; c=relaxed/simple;
	bh=gTZlTQCJPskVKsV3mVBEQUdnqLoOC2Ne/+W3x+ugQeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JyCOu414U51n8kPjbWtQznBFfYathhnmKN3R23yZ83LdLuJ6POcitd3hzzAkckwjKQt/kXS6u2MDB6CIvKpcY9U/QqaHi8VUdfWXRm3ZN+9KseFhv5Hsz5isd2uCLXC8xAFpjqK+5VqVXEXoqxBJ3uTA5uHKmvd38o7CYcNVaaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1Lj8hIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1Lj8hIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76843C4CEF1;
	Wed, 21 Jan 2026 18:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020419;
	bh=gTZlTQCJPskVKsV3mVBEQUdnqLoOC2Ne/+W3x+ugQeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1Lj8hIlfWyiNz1HQPb4CcW5qILkkdLwwHI9zj/P2CV/kTwFpq+dpk26jrE7qu98q
	 /eDbtX3yVyJKYt9jFHvfQVyLsJA/2kGvR7HRqUrce0XzkdAf75Pg9kW+10b1HOJhhM
	 gHxDFmaq2m8oSqXmKD8vcIHH53AK3zf7LACWjZl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 153/198] drm/amdgpu: make sure userqs are enabled in userq IOCTLs
Date: Wed, 21 Jan 2026 19:16:21 +0100
Message-ID: <20260121181424.061059433@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b6dff005fcf32dd072f6f2d08ca461394a21bd4f upstream.

These IOCTLs shouldn't be called when userqs are not
enabled.  Make sure they are enabled before executing
the IOCTLs.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d967509651601cddce7ff2a9f09479f3636f684d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c       |   16 ++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h       |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c |    6 ++++++
 3 files changed, 23 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -681,12 +681,28 @@ static int amdgpu_userq_input_args_valid
 	return 0;
 }
 
+bool amdgpu_userq_enabled(struct drm_device *dev)
+{
+	struct amdgpu_device *adev = drm_to_adev(dev);
+	int i;
+
+	for (i = 0; i < AMDGPU_HW_IP_NUM; i++) {
+		if (adev->userq_funcs[i])
+			return true;
+	}
+
+	return false;
+}
+
 int amdgpu_userq_ioctl(struct drm_device *dev, void *data,
 		       struct drm_file *filp)
 {
 	union drm_amdgpu_userq *args = data;
 	int r;
 
+	if (!amdgpu_userq_enabled(dev))
+		return -ENOTSUPP;
+
 	if (amdgpu_userq_input_args_validate(dev, args, filp) < 0)
 		return -EINVAL;
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h
@@ -135,6 +135,7 @@ uint64_t amdgpu_userq_get_doorbell_index
 					     struct drm_file *filp);
 
 u32 amdgpu_userq_get_supported_ip_mask(struct amdgpu_device *adev);
+bool amdgpu_userq_enabled(struct drm_device *dev);
 
 int amdgpu_userq_suspend(struct amdgpu_device *adev);
 int amdgpu_userq_resume(struct amdgpu_device *adev);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -472,6 +472,9 @@ int amdgpu_userq_signal_ioctl(struct drm
 	struct drm_exec exec;
 	u64 wptr;
 
+	if (!amdgpu_userq_enabled(dev))
+		return -ENOTSUPP;
+
 	num_syncobj_handles = args->num_syncobj_handles;
 	syncobj_handles = memdup_user(u64_to_user_ptr(args->syncobj_handles),
 				      size_mul(sizeof(u32), num_syncobj_handles));
@@ -654,6 +657,9 @@ int amdgpu_userq_wait_ioctl(struct drm_d
 	int r, i, rentry, wentry, cnt;
 	struct drm_exec exec;
 
+	if (!amdgpu_userq_enabled(dev))
+		return -ENOTSUPP;
+
 	num_read_bo_handles = wait_info->num_bo_read_handles;
 	bo_handles_read = memdup_user(u64_to_user_ptr(wait_info->bo_read_handles),
 				      size_mul(sizeof(u32), num_read_bo_handles));


