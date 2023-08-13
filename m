Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377DD9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEECDC433C7;
	Sun, 13 Aug 2023 21:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961972;
	bh=3QppXAd9JBc/wefvgr+cBsDuCfIjuy0/cdV/H1l0A4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBznFvgeRz+uMVXZa3bhb7P4GuJjHuCE4Xu0d6TKZPGDLD6VoOYBrGY851FpODNKo
	 FTjhbHh93R3eaVlBGmXCK1H2ljODO9qDT8vHATi9sM5C50a/YSrs7IRBC5cvMW5nwN
	 7zffBfWhytWxDS5AQ15v0e43Yf5l6LE4zUepfFrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.4 058/206] accel/ivpu: Add set_pages_array_wc/uc for internal buffers
Date: Sun, 13 Aug 2023 23:17:08 +0200
Message-ID: <20230813211726.676663559@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karol Wachowski <karol.wachowski@linux.intel.com>

commit 1963546390ed8b649f529993a755eba0fdeb7aaa upstream.

Buffers mapped with pgprot_writecombined() are not correctly
flushed. This triggers issues on VPU access using random
memory content such as MMU translation faults, invalid context
descriptors being fetched and can lead to VPU FW crashes.

Fixes: 647371a6609d ("accel/ivpu: Add GEM buffer object management")
Cc: stable@vger.kernel.org # 6.3+
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230802063735.3005291-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_gem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index 52b339aefadc..9967fcfa27ec 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -173,6 +173,9 @@ static void internal_free_pages_locked(struct ivpu_bo *bo)
 {
 	unsigned int i, npages = bo->base.size >> PAGE_SHIFT;
 
+	if (ivpu_bo_cache_mode(bo) != DRM_IVPU_BO_CACHED)
+		set_pages_array_wb(bo->pages, bo->base.size >> PAGE_SHIFT);
+
 	for (i = 0; i < npages; i++)
 		put_page(bo->pages[i]);
 
@@ -587,6 +590,11 @@ ivpu_bo_alloc_internal(struct ivpu_device *vdev, u64 vpu_addr, u64 size, u32 fla
 	if (ivpu_bo_cache_mode(bo) != DRM_IVPU_BO_CACHED)
 		drm_clflush_pages(bo->pages, bo->base.size >> PAGE_SHIFT);
 
+	if (bo->flags & DRM_IVPU_BO_WC)
+		set_pages_array_wc(bo->pages, bo->base.size >> PAGE_SHIFT);
+	else if (bo->flags & DRM_IVPU_BO_UNCACHED)
+		set_pages_array_uc(bo->pages, bo->base.size >> PAGE_SHIFT);
+
 	prot = ivpu_bo_pgprot(bo, PAGE_KERNEL);
 	bo->kvaddr = vmap(bo->pages, bo->base.size >> PAGE_SHIFT, VM_MAP, prot);
 	if (!bo->kvaddr) {
-- 
2.41.0



