Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9985433EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2134FC433EF;
	Mon, 16 Jan 2023 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884503;
	bh=8qRTdXvIvxl0/gerX2qxYxM0dkK3Mf/RxEFqs2Rw+T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FS+117yzegP93yp4CxlFZqiEk0MDh31VKGyGlx7MgCAhQR6JQlKjmP/fryzLZVXzA
	 FkqY9tlRcFqMOhZ2nP7KMuVpyPrU0rhTYvGLOd7FL6k4M490/KCAKU38Du0nuWrnCW
	 k4wEbFQFgNg174C2LOiaHiOE9muhEb+A5TKwusbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 030/183] drm/i915: Reserve enough fence slot for i915_vma_unbind_async
Date: Mon, 16 Jan 2023 16:49:13 +0100
Message-Id: <20230116154804.633702520@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nirmoy Das <nirmoy.das@intel.com>

commit 476fdcdaaae7b06c780cdfc234c704107f16c529 upstream.

A nested dma_resv_reserve_fences(1) will not reserve slot from the
2nd call onwards and folowing dma_resv_add_fence() might hit the
"BUG_ON(fobj->num_fences >= fobj->max_fences)" check.

I915 hit above nested dma_resv case in ttm_bo_handle_move_mem() with
async unbind:

dma_resv_reserve_fences() from --> ttm_bo_handle_move_mem()
        dma_resv_reserve_fences() from --> i915_vma_unbind_async()
        dma_resv_add_fence() from --> i915_vma_unbind_async()
dma_resv_add_fence() from -->ttm_bo_move_accel_cleanup()

Resolve this by adding an extra fence in i915_vma_unbind_async().

Suggested-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: 2f6b90da9192 ("drm/i915: Use vma resources for async unbinding")
Cc: <stable@vger.kernel.org> # v5.18+
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221223092011.11657-1-nirmoy.das@intel.com
(cherry picked from commit 4f0755c2faf7388616109717facc5bbde6850e60)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -2114,7 +2114,7 @@ int i915_vma_unbind_async(struct i915_vm
 	if (!obj->mm.rsgt)
 		return -EBUSY;
 
-	err = dma_resv_reserve_fences(obj->base.resv, 1);
+	err = dma_resv_reserve_fences(obj->base.resv, 2);
 	if (err)
 		return -EBUSY;
 


