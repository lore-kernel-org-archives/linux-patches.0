Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E38D33CA;
	Wed, 24 May 2023 16:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2205C433D2;
	Wed, 24 May 2023 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684946655;
	bh=eAH+SzDKLDb9MJ17r21lT92I2icSy5j2//LJV3igUS8=;
	h=From:Date:Subject:To:Cc:From;
	b=HLaeCR9kYippXTpwMhmoIBXFcib3XxmEbPPGCDY8oRtTFQzg8fjwigeFbHleQCdV3
	 1KzeCN9qiJWZpk6pjO6hBdGE9WOtZ4r9gbM1Xs8kk//4mgNlz4CjDPOa+ptF+ncw1B
	 aZdump2fjeM82X6pIj2kcBMVTaUe7oejw/Alzu5HCsZyCPXqVTtBtJK6HUh+iIN6F9
	 Ok58qP3JFqFR5oy0fkxlvZKF/mfE/EWQiaVlx3hrntnp04pOKWV65ziUqdUvdNJJwu
	 fXvpevVO6oUvYB1gLjqQpDRA6gTNAH6M4u5VE2b+odu1WLtaCdMTWf6Z0YvY0F+y1y
	 yi1Be8BREU1eA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 24 May 2023 09:44:02 -0700
Subject: [PATCH] drm/amdgpu: Fix return types of certain NBIOv7.9 callbacks
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230524-nbio_v7_9-wincompatible-function-pointer-types-strict-v1-1-da17e01907cf@kernel.org>
X-B4-Tracking: v=1; b=H4sIANE+bmQC/x2O2wrCMBAFf6Xk2YXerNZfESnJurULdhOysSql/
 27q43CY4axGKTKpuRSribSwspcM1aEwOFl5EPA9s6nLuimPdQvi2A/LaejhzYJ+DjaxexKML8G
 UZQieJVGE9A2koCkyJsBz33ZNh1S1ncltZ5XARSs47fXZalb2IUQa+fM/dL1t2w86X0cLoAAAA
 A==
To: alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com
Cc: ndesaulniers@google.com, trix@redhat.com, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3148; i=nathan@kernel.org;
 h=from:subject:message-id; bh=eAH+SzDKLDb9MJ17r21lT92I2icSy5j2//LJV3igUS8=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCl5dvde6L0L3bXh7DHZwkUr0zOim0tZ76cv2bXi+P6SF
 ++XLDsj11HKwiDGwSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAmEivOyLC44KOjmkhDusTf
 BwXK+xg+t1haKKpyhB7vmZdwJ+yRuDzDf7+kN0sXVNz+w6ie7yt9SK3HpEZBblVao6LfMccj558
 U8gEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with clang's -Wincompatible-function-pointer-types-strict,
which ensures that function pointer signatures match exactly to avoid
tripping clang's Control Flow Integrity (kCFI) checks at run time and
will eventually be turned on for the kernel, the following instances
appear in the NBIOv7.9 code:

  drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c:465:32: error: incompatible function pointer types initializing 'int (*)(struct amdgpu_device *)' with an expression of type 'enum amdgpu_gfx_partition (struct amdgpu_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .get_compute_partition_mode = nbio_v7_9_get_compute_partition_mode,
                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c:467:31: error: incompatible function pointer types initializing 'u32 (*)(struct amdgpu_device *, u32 *)' (aka 'unsigned int (*)(struct amdgpu_device *, unsigned int *)') with an expression of type 'enum amdgpu_memory_partition (struct amdgpu_device *, u32 *)' (aka 'enum amdgpu_memory_partition (struct amdgpu_device *, unsigned int *)') [-Werror,-Wincompatible-function-pointer-types-strict]
          .get_memory_partition_mode = nbio_v7_9_get_memory_partition_mode,
                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  2 errors generated.

Change the return types of these callbacks to match the prototypes to
clear up the warning and avoid tripping kCFI at run time. Both functions
return a value from ffs(), which is an integer that can fit into either
int or unsigned int.

Fixes: 11f64eb1472f ("drm/amdgpu: add sysfs node for compute partition mode")
Fixes: 41a717ea8afc ("drm/amdgpu: detect current GPU memory partition mode")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
index e082f6343d20..d19325476752 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
@@ -382,7 +382,7 @@ static void nbio_v7_9_enable_doorbell_interrupt(struct amdgpu_device *adev,
 			      DOORBELL_INTERRUPT_DISABLE, enable ? 0 : 1);
 }
 
-static enum amdgpu_gfx_partition nbio_v7_9_get_compute_partition_mode(struct amdgpu_device *adev)
+static int nbio_v7_9_get_compute_partition_mode(struct amdgpu_device *adev)
 {
 	u32 tmp, px;
 
@@ -408,8 +408,8 @@ static void nbio_v7_9_set_compute_partition_mode(struct amdgpu_device *adev,
 	WREG32_SOC15(NBIO, 0, regBIF_BX_PF0_PARTITION_COMPUTE_STATUS, tmp);
 }
 
-static enum amdgpu_memory_partition
-nbio_v7_9_get_memory_partition_mode(struct amdgpu_device *adev, u32 *supp_modes)
+static u32 nbio_v7_9_get_memory_partition_mode(struct amdgpu_device *adev,
+					       u32 *supp_modes)
 {
 	u32 tmp;
 

---
base-commit: fd8f7bb391fa9c1979232cb5ab5bedb08abc855d
change-id: 20230524-nbio_v7_9-wincompatible-function-pointer-types-strict-c894636ce146

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

