Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB5279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAAEC433D6;
	Wed, 30 Nov 2022 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834519;
	bh=a5TLPnqN6vulHzwPbssFPVP3FkGa4iHQNl6mysWjL8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PG0fQW4v8Ros+rgRBGcrw1UaQHhcCzpqw3oIEeQULCrS1WRHRDdJxPv4r4gTQdBfM
	 t3Rpou8F7Gny1bRG+/uWajjk7pMP8otdaCd7Z9TKrSuO4uh3FmPdK8CHfw2NAHZiDF
	 8qJIqlHhEOn6gQ9CUfFqxw0XQ/vxOZZ1RGK04Rq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 283/289] drm/amdgpu/psp: dont free PSP buffers on suspend
Date: Wed, 30 Nov 2022 19:24:28 +0100
Message-Id: <20221130180550.518420264@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit 4f2bea62cf3874c5a58e987b0b472f9fb57117a2 upstream.

We can reuse the same buffers on resume.

v2: squash in S4 fix from Shikai

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2213
Reviewed-by: Christian König <christian.koenig@amd.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -171,6 +171,7 @@ void psp_ta_free_shared_buf(struct ta_me
 {
 	amdgpu_bo_free_kernel(&mem_ctx->shared_bo, &mem_ctx->shared_mc_addr,
 			      &mem_ctx->shared_buf);
+	mem_ctx->shared_bo = NULL;
 }
 
 static void psp_free_shared_bufs(struct psp_context *psp)
@@ -181,6 +182,7 @@ static void psp_free_shared_bufs(struct
 	/* free TMR memory buffer */
 	pptr = amdgpu_sriov_vf(psp->adev) ? &tmr_buf : NULL;
 	amdgpu_bo_free_kernel(&psp->tmr_bo, &psp->tmr_mc_addr, pptr);
+	psp->tmr_bo = NULL;
 
 	/* free xgmi shared memory */
 	psp_ta_free_shared_buf(&psp->xgmi_context.context.mem_context);
@@ -728,7 +730,7 @@ static int psp_load_toc(struct psp_conte
 /* Set up Trusted Memory Region */
 static int psp_tmr_init(struct psp_context *psp)
 {
-	int ret;
+	int ret = 0;
 	int tmr_size;
 	void *tmr_buf;
 	void **pptr;
@@ -755,10 +757,12 @@ static int psp_tmr_init(struct psp_conte
 		}
 	}
 
-	pptr = amdgpu_sriov_vf(psp->adev) ? &tmr_buf : NULL;
-	ret = amdgpu_bo_create_kernel(psp->adev, tmr_size, PSP_TMR_ALIGNMENT,
-				      AMDGPU_GEM_DOMAIN_VRAM,
-				      &psp->tmr_bo, &psp->tmr_mc_addr, pptr);
+	if (!psp->tmr_bo) {
+		pptr = amdgpu_sriov_vf(psp->adev) ? &tmr_buf : NULL;
+		ret = amdgpu_bo_create_kernel(psp->adev, tmr_size, PSP_TMR_ALIGNMENT,
+					      AMDGPU_GEM_DOMAIN_VRAM,
+					      &psp->tmr_bo, &psp->tmr_mc_addr, pptr);
+	}
 
 	return ret;
 }
@@ -2720,8 +2724,6 @@ static int psp_suspend(void *handle)
 	}
 
 out:
-	psp_free_shared_bufs(psp);
-
 	return ret;
 }
 


