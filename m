Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD3F2D0602;
	Thu, 30 Jul 2026 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424125; cv=none; b=lO+uTI7K8KBTObi2feV+wngp9yM6TcKoatHiv6jGXKKNWTgr3PVn3TYKVRiSk1wEvQ9uH5pXWETdRScg0hWAuVbV2I1YeBZhgyTmxZQTePIeFTD2gc41yFPWeYC/tpn+xx0mfwtVCd2JHWpdTCdrHYhUUzKXfzo5Rm7YpSBX+co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424125; c=relaxed/simple;
	bh=Kx47jyW/5dTvP4Hu64MVRYJM3dTV6gGDneohK6ZC1jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jGWneBTqDTVX7C1aiLGzvTlbTCyAR7wfHM2VpQQkvM4Qasi8avG/JF1K7w16b9GDCcIYHgWfIqzAZlLQYSOI5eqDAYObNJEap27OH27qQvhrlWVraYExRpqlKp8lwhIogVgHhVlYVjg5l4+RXjn/3weKnHRpzjN/PyKMUuhVXwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vP6/rNNO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vP6/rNNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218AF1F000E9;
	Thu, 30 Jul 2026 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424124;
	bh=1qZg5745HEgC2oniXUyxe5yMwldaEks95ymYC62iYRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vP6/rNNONN9xL57stx9XGaJW7tSpnOWETCMeXhL9YUYE26hHd3YTgWkLJaDFg/VTQ
	 hsPTRBEE52wdyX9V9Gdikh83W93dd53LXL1/sLatwoH1aA6j/HnejnSP/TgLcgtxYV
	 WRS5PXYLNg7Lyy7VdDI2G2XmkKLKvgo0GklUL1AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/675] drm/tests: shmem: Set DMA mask to 64-bit in drm_gem_shmem
Date: Thu, 30 Jul 2026 16:10:14 +0200
Message-ID: <20260730141451.160784350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: José Expósito <jose.exposito@redhat.com>

[ Upstream commit b04a248cfa6cfa1e7dc9ce91cb1eb88b1a70dd69 ]

drm_gem_shmem_test_purge [1] and drm_gem_shmem_test_get_pages_sgt [2]
intermittently fail on ppc64le and s390x CI systems with a DMA address
overflow:

  DMA addr 0x0000000100307000+4096 overflow (mask ffffffff, bus limit 0)
  WARNING: kernel/dma/direct.h:114 dma_direct_map_sg+0x778/0x920

  drm_gem_shmem_test_purge: ASSERTION FAILED at
    drivers/gpu/drm/tests/drm_gem_shmem_test.c:330
    Expected sgt is not error, but is: -5

The call chain leading to the failure is:

  drm_gem_shmem_test_purge() / drm_gem_shmem_test_get_pages_sgt()
    drm_gem_shmem_get_pages_sgt()
      drm_gem_shmem_get_pages_sgt_locked() [drm_gem_shmem_helper.c]
        dma_map_sgtable()                  [mapping.c]
          __dma_map_sg_attrs()
            dma_direct_map_sg()            [direct.c]
              dma_direct_map_phys()        [kernel/dma/direct.h]
                dma_capable()              Checks addr against DMA mask
                  -> FAILS: addr > 0xFFFFFFFF

The root cause is that KUnit devices are initialized with a 32-bit DMA
mask (DMA_BIT_MASK(32)) in lib/kunit/device.c. On ppc64le and s390x
systems with physical memory above 4GB, page allocations can land at
addresses that exceed this mask. When drm_gem_shmem_get_pages_sgt()
attempts to DMA-map these pages via dma_map_sgtable(), the DMA layer
rejects the mapping because the physical address overflows the 32-bit
mask.

The failure is intermittent because pages may or may not be allocated
above 4GB on any given run depend on memory pressure.

Fix by setting a 64-bit DMA mask on the device before calling
drm_gem_shmem_get_pages_sgt() for all tests, following the same pattern
already used in drm_gem_shmem_test_obj_create_private().

[1] https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/2643976103/test_s390x/15128551935/artifacts/jobwatch/logs/recipes/21561049/tasks/220716793/results/1014626315/logs/dmesg.log
[2] https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/2643976103/test_ppc64le/15128551933/artifacts/jobwatch/logs/recipes/21561041/tasks/220716705/results/1014628163/logs/dmesg.log

Fixes: 93032ae634d4 ("drm/test: add a test suite for GEM objects backed by shmem")
Closes: https://datawarehouse.cki-project.org/issue/5345
Closes: https://datawarehouse.cki-project.org/issue/3184
Assisted-by: Claude:claude-4.6-opus
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: José Expósito <jose.exposito@redhat.com>
Link: https://patch.msgid.link/20260703150808.3832-1-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_gem_shmem_test.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_gem_shmem_test.c b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
index 4b459f21acfd95..b1fa287892fb81 100644
--- a/drivers/gpu/drm/tests/drm_gem_shmem_test.c
+++ b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
@@ -95,13 +95,9 @@ static void drm_gem_shmem_test_obj_create_private(struct kunit *test)
 	sg_init_one(sgt->sgl, buf, TEST_SIZE);
 
 	/*
-	 * Set the DMA mask to 64-bits and map the sgtables
-	 * otherwise drm_gem_shmem_free will cause a warning
-	 * on debug kernels.
+	 * Map the sgtables otherwise drm_gem_shmem_free will cause a warning on
+	 * debug kernels.
 	 */
-	ret = dma_set_mask(drm_dev->dev, DMA_BIT_MASK(64));
-	KUNIT_ASSERT_EQ(test, ret, 0);
-
 	ret = dma_map_sgtable(drm_dev->dev, sgt, DMA_BIDIRECTIONAL, 0);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -352,11 +348,19 @@ static int drm_gem_shmem_test_init(struct kunit *test)
 {
 	struct device *dev;
 	struct drm_device *drm_dev;
+	int ret;
 
 	/* Allocate a parent device */
 	dev = drm_kunit_helper_alloc_device(test);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
 
+	/*
+	 * Set the DMA mask to 64-bits to avoid intermittent failures calling
+	 * drm_gem_shmem_get_pages_sgt().
+	 */
+	ret = dma_set_mask(dev, DMA_BIT_MASK(64));
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	/*
 	 * The DRM core will automatically initialize the GEM core and create
 	 * a DRM Memory Manager object which provides an address space pool
-- 
2.53.0



