Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3F9AD35
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 17:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2615C433CA;
	Thu, 15 Jun 2023 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686848785;
	bh=OMYNXDmf2G+KE4O+YFGoP1cRngLJ6R4++Xd36xT5ZOk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AGzxwnYFlrpfQHikLxx9cHO4xrRxWnsOY8UJcw0MOc7m4MG1hSamNgOyHff8Dbkad
	 H30n72Y7sxEcu10lnQEi54gwNSgvRvFVM1Q3n0V+MWk5MAj52ICCtTwpw169vCkeJc
	 PJEYl5wOKWmohP7ePjkJvr17Ba7WgIbVRAx3OrWt9Byup8GTZ39hU5dGgKmhk+iE9F
	 gCkVtoll9LUFzUjBboeAmmibQJQkkaWHt2Gjkry7iIxBJ/XVT1+2TNUPYFooB9C6IZ
	 SA/QjyTlti4LnEYUe04Ox4T7J+bc80uMcQ8Uds0J5HtMfBIpn5GMUGUkC375glqA+f
	 ivWlNu9MFmmZg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 15 Jun 2023 10:06:08 -0700
Subject: [PATCH 1/2] drm/amdgpu: Remove CONFIG_DEBUG_FS guard around body
 of amdgpu_rap_debugfs_init()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230615-amdgpu-wunused-const-variable-wo-debugfs-v1-1-06efd224aebb@kernel.org>
References: <20230615-amdgpu-wunused-const-variable-wo-debugfs-v1-0-06efd224aebb@kernel.org>
In-Reply-To: <20230615-amdgpu-wunused-const-variable-wo-debugfs-v1-0-06efd224aebb@kernel.org>
To: alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1622; i=nathan@kernel.org;
 h=from:subject:message-id; bh=OMYNXDmf2G+KE4O+YFGoP1cRngLJ6R4++Xd36xT5ZOk=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCndrgLTpr27MJXd8MJGbYNzQbOPNOwV7TnUPTvd8n3k5
 q/CM3ce6ihlYRDjYJAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQATOazEyPCl3bDjz8WbZz6q
 zL2/QUH92dSnC2ffV347qbhi0z6N5+5mjAwn7+6unvXTuvxS6q8buyN11te4G9hbi7Ssf2QpEXe
 FoZ8BAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit a25a9dae2067 ("drm/amd/amdgpu: enable W=1 for amdgpu"),
there is an instance of -Wunused-const-variable when CONFIG_DEBUG_FS is
disabled:

  drivers/gpu/drm/amd/amdgpu/amdgpu_rap.c:110:37: error: unused variable 'amdgpu_rap_debugfs_ops' [-Werror,-Wunused-const-variable]
    110 | static const struct file_operations amdgpu_rap_debugfs_ops = {
        |                                     ^
  1 error generated.

There is no reason for the body of this function to be guarded when
CONFIG_DEBUG_FS is disabled, as debugfs_create_file() is a stub that
just returns an error pointer in that situation. Remove the preprocessor
guards so that the variable never appears unused, while not changing
anything at run time.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_rap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_rap.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_rap.c
index 12010c988c8b..123bcf5c2bb1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_rap.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_rap.c
@@ -116,7 +116,6 @@ static const struct file_operations amdgpu_rap_debugfs_ops = {
 
 void amdgpu_rap_debugfs_init(struct amdgpu_device *adev)
 {
-#if defined(CONFIG_DEBUG_FS)
 	struct drm_minor *minor = adev_to_drm(adev)->primary;
 
 	if (!adev->psp.rap_context.context.initialized)
@@ -124,5 +123,4 @@ void amdgpu_rap_debugfs_init(struct amdgpu_device *adev)
 
 	debugfs_create_file("rap_test", S_IWUSR, minor->debugfs_root,
 				adev, &amdgpu_rap_debugfs_ops);
-#endif
 }

-- 
2.41.0

