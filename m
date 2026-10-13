Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848234F85BC;
	Tue, 13 Oct 2026 12:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893137; cv=none; b=BmtWuoo5XfhU6CAVA4J1Chss/LGDB4bt6TfbuDndYgG8uHUWmFmv9uQnDG2AAb5QrT0R+BgskgF7wntbk+Flpm7v/t7ni9HX06Bauv0sitvC59QBMKcuetfKLQ44ZrRbqowQrIeuqhDRZif9rLrf1j1dOBDzrcEcLRYtIEKVxEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893137; c=relaxed/simple;
	bh=L7Hj7IFkpS7VWFUOW3XT39sP5E5PIOMFVZvz467t0rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GbdA8fHltqu2fy5aQWPw37nqf8QB9T77SBuxqEopQ8e3UzFvCUpVFegPpMYhC/5DI+CmaPZZpcKDecZ1wBYAC11lv2L0VLGXOLdDWTS0kOZ2W+TaZ4IZ2hN+n7TJofGHJtq+aIpdNV/6MWalYUMWdxdm3msDUY0SWfxRB00s+DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Br4664NK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Br4664NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC631F00898;
	Tue, 13 Oct 2026 12:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893136;
	bh=XhfmAqC2dq1FQEcA1+hxTzcRk1afQbSsT2VhhBS5GIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Br4664NKro2c5dW1tSa2nb0Y90JdHnMyEF12NWKWRsPhH613WdYtTTM1Xvq1PUU+j
	 +c7H8fo+dPC1v3YiF/Y2otKSy7M2bCCroD6VsJRmifXT+BkJNkrUck2H8mf66pO2Cf
	 mZ5woWMpZrPYmR/IfS2OM+DVPVaqBj2OUmkP0ong=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 126/621] drm/amdgpu/userq: return the memdup_user() error for the user MQD
Date: Tue, 13 Oct 2026 13:32:01 +0200
Message-ID: <20261013112923.847557227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit 76ceb6ed610cbf14341a9ba78c5c0b2199b9030a upstream.

mes_userq_mqd_create() returns -ENOMEM when copying the user MQD fails,
even though memdup_user() returns -EFAULT for a bad pointer or -EINTR
when interrupted by a signal. Return PTR_ERR() instead.

While at it drop the error messages. Neither case is a driver error and
userspace shouldn't be able to spam the log with invalid IOCTL
parameters.

v2: drop the error messages (Christian)

Fixes: 2c695d7c0720 ("drm/amdgpu: enable compute/gfx usermode queue")
Fixes: 543b61453774 ("drm/amdgpu: enable SDMA usermode queues")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 49a443fcb829be9fc780f10850652ddea2fe81f0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
@@ -290,8 +290,7 @@ static int mes_userq_mqd_create(struct a
 
 		compute_mqd = memdup_user(u64_to_user_ptr(mqd_user->mqd), mqd_user->mqd_size);
 		if (IS_ERR(compute_mqd)) {
-			DRM_ERROR("Failed to read user MQD\n");
-			r = -ENOMEM;
+			r = PTR_ERR(compute_mqd);
 			goto free_mqd;
 		}
 
@@ -326,8 +325,7 @@ static int mes_userq_mqd_create(struct a
 
 		mqd_gfx_v11 = memdup_user(u64_to_user_ptr(mqd_user->mqd), mqd_user->mqd_size);
 		if (IS_ERR(mqd_gfx_v11)) {
-			DRM_ERROR("Failed to read user MQD\n");
-			r = -ENOMEM;
+			r = PTR_ERR(mqd_gfx_v11);
 			goto free_mqd;
 		}
 
@@ -357,8 +355,7 @@ static int mes_userq_mqd_create(struct a
 
 		mqd_sdma_v11 = memdup_user(u64_to_user_ptr(mqd_user->mqd), mqd_user->mqd_size);
 		if (IS_ERR(mqd_sdma_v11)) {
-			DRM_ERROR("Failed to read sdma user MQD\n");
-			r = -ENOMEM;
+			r = PTR_ERR(mqd_sdma_v11);
 			goto free_mqd;
 		}
 		r = amdgpu_userq_input_va_validate(queue, mqd_sdma_v11->csa_va,


