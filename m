Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08A61C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D80C433D2;
	Wed, 28 Dec 2022 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245645;
	bh=6nYTkxlby+DRi1O8DjM51QkGP8OAhwhGRwgpfg5K5Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1Io8rWrrqBkyZ4s2EwLolzK+QTHU3f/tHdQoEaG+FU0sTMXmsFoHwt5R2ATyZhIp
	 xFzim8+sVCx49QY6p5y9ePNDykuDP25DOPy7odgVULwjGjQ6lUaoD5xIoGIUUumqUJ
	 LVVwfgCygIETD3BB3zspxLex/ws0Dx8gMaGT9OXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Kees Cook <keescook@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0931/1073] drm/amdgpu: Fix type of second parameter in trans_msg() callback
Date: Wed, 28 Dec 2022 15:41:59 +0100
Message-Id: <20221228144353.316925278@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit f0d0f1087333714ee683cc134a95afe331d7ddd9 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c:412:15: error: incompatible function pointer types initializing 'void (*)(struct amdgpu_device *, u32, u32, u32, u32)' (aka 'void (*)(struct amdgpu_device *, unsigned int, unsigned int, unsigned int, unsigned int)') with an expression of type 'void (struct amdgpu_device *, enum idh_request, u32, u32, u32)' (aka 'void (struct amdgpu_device *, enum idh_request, unsigned int, unsigned int, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
          .trans_msg = xgpu_ai_mailbox_trans_msg,
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

  drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c:435:15: error: incompatible function pointer types initializing 'void (*)(struct amdgpu_device *, u32, u32, u32, u32)' (aka 'void (*)(struct amdgpu_device *, unsigned int, unsigned int, unsigned int, unsigned int)') with an expression of type 'void (struct amdgpu_device *, enum idh_request, u32, u32, u32)' (aka 'void (struct amdgpu_device *, enum idh_request, unsigned int, unsigned int, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
          .trans_msg = xgpu_nv_mailbox_trans_msg,
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

The type of the second parameter in the prototype should be 'enum
idh_request' instead of 'u32'. Update it to clear up the warnings.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 617d072275eb..77210fd64a2b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -75,6 +75,8 @@ struct amdgpu_vf_error_buffer {
 	uint64_t data[AMDGPU_VF_ERROR_ENTRY_SIZE];
 };
 
+enum idh_request;
+
 /**
  * struct amdgpu_virt_ops - amdgpu device virt operations
  */
@@ -84,7 +86,8 @@ struct amdgpu_virt_ops {
 	int (*req_init_data)(struct amdgpu_device *adev);
 	int (*reset_gpu)(struct amdgpu_device *adev);
 	int (*wait_reset)(struct amdgpu_device *adev);
-	void (*trans_msg)(struct amdgpu_device *adev, u32 req, u32 data1, u32 data2, u32 data3);
+	void (*trans_msg)(struct amdgpu_device *adev, enum idh_request req,
+			  u32 data1, u32 data2, u32 data3);
 };
 
 /*
-- 
2.35.1



