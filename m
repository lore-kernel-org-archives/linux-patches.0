Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D2B288C22;
	Wed, 28 Jan 2026 15:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615368; cv=none; b=tTxDXo+0DdgNsTkL63PFnN4bfBLu6CispfRR+UvDd+XAqJEzm057DBM4fyIy5wbQkvcYctlzVMyOX9sUJZk1RU9xpap7O/8l7i07DWTyaepWXKf2HnqlkW3JpUFKjpn6nVDEXceIVn7+FeZ3zcQGGJOm06YNBAodo5VILEIF/Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615368; c=relaxed/simple;
	bh=HhpcPdl9Ey0qY70Ppn0aqqD4uVGHclelhEjb2QmaHZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqHGgnaGlD3k8PF5Zd5aI0zxpmMD7b+bYTlfDOnUJR3L4o+OXcWhnK33b3+tq2W0KD32kPxHDXSihexlfKoK1o2Q30hXe2ZpvNIWQmWn+is2oNTT6yoA4MI6L4+uAWaHSkBmVqKKjVUMnfM3AqF1fzd+l8R8jVNo1CAXXKO7zIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cvEf4Xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cvEf4Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86673C4CEF1;
	Wed, 28 Jan 2026 15:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615367;
	bh=HhpcPdl9Ey0qY70Ppn0aqqD4uVGHclelhEjb2QmaHZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cvEf4XzvrpMaDMgYt03Bd7v0xwyrCXDGh98jbx8A7Fw6RAsVcvfqnF8h1RGpjbcT
	 tkkw5o1UFSc8/fuzYgiYbJ2mvnQ6NijtWi/jjwX09Tokg8KR7lcvMrqdhC8Y1btw9u
	 6vMaD4cuBIDR3mN2CflR1uqSfQD9mg0dctNKcCbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.12 159/169] accel/ivpu: Fix race condition when unbinding BOs
Date: Wed, 28 Jan 2026 16:24:02 +0100
Message-ID: <20260128145339.738143653@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>

[ Upstream commit 00812636df370bedf4e44a0c81b86ea96bca8628 ]

Fix 'Memory manager not clean during takedown' warning that occurs
when ivpu_gem_bo_free() removes the BO from the BOs list before it
gets unmapped. Then file_priv_unbind() triggers a warning in
drm_mm_takedown() during context teardown.

Protect the unmapping sequence with bo_list_lock to ensure the BO is
always fully unmapped when removed from the list. This ensures the BO
is either fully unmapped at context teardown time or present on the
list and unmapped by file_priv_unbind().

Fixes: 48aea7f2a2ef ("accel/ivpu: Fix locking in ivpu_bo_remove_all_bos_from_context()")
Signed-off-by: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20251029071451.184243-1-karol.wachowski@linux.intel.com
[ The context change is due to the commit e0c0891cd63b
("accel/ivpu: Rework bind/unbind of imported buffers")
and the proper adoption is done. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -240,7 +240,6 @@ static void ivpu_gem_bo_free(struct drm_
 
 	mutex_lock(&vdev->bo_list_lock);
 	list_del(&bo->bo_list_node);
-	mutex_unlock(&vdev->bo_list_lock);
 
 	drm_WARN_ON(&vdev->drm, !drm_gem_is_imported(&bo->base.base) &&
 		    !dma_resv_test_signaled(obj->resv, DMA_RESV_USAGE_READ));
@@ -248,6 +247,8 @@ static void ivpu_gem_bo_free(struct drm_
 	drm_WARN_ON(&vdev->drm, bo->base.vaddr);
 
 	ivpu_bo_unbind_locked(bo);
+	mutex_unlock(&vdev->bo_list_lock);
+
 	drm_WARN_ON(&vdev->drm, bo->mmu_mapped);
 	drm_WARN_ON(&vdev->drm, bo->ctx);
 


