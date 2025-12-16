Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE3E31B10F;
	Tue, 16 Dec 2025 11:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885411; cv=none; b=ajkVnBWfwH4BQHpyxL66l9zkiRKUhN3KUoBlLaT427rPzkVBFtGIJ1r9umHkilOeOHZopf0J4PWo0rHb/gounIunB7f0t/mZV06XKewMKoa9Da0LDgRfVYoRm5XxMmhdX097URGe5Ke+XL/aRWgpG7OUdIgB3BB+10dShyhCQGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885411; c=relaxed/simple;
	bh=TWYOT0ycoJcV/cVyfxVf1IRK+zlXJKb6FWo+BlME4rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgMqkanHx05TfsFcuUSoUJsk+nMS/IXjgBSZ4Gz6AfYeWEBFpugxWligYn8+LVQE3eqCc40ExKXo9afniTkVYmYQJC/PvQfOCvTGaZEzhvqy7Uy/lbrcEh2Dp/QQNBTTfJc8TUGUtISpRt2tIz9n4PkQK9J8rCSzmwrKek7llI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBzyhi2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBzyhi2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6C2C4CEF1;
	Tue, 16 Dec 2025 11:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885411;
	bh=TWYOT0ycoJcV/cVyfxVf1IRK+zlXJKb6FWo+BlME4rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBzyhi2djSkpn0K+2jC+CGMKaht1m5bY56NPW2O6GjQWHemizzmGl8aSfz6zo1TeK
	 s6+xscZPK7peqXXcTXQtlZDxvis153FWL+6oWT9yEkdoFfgNL60nhSIwhGqk8oozWR
	 w5gSWyTqXsJh1HwNjERUNC4+fSJMiGR8MlObKxGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 130/507] accel/ivpu: Fix race condition when unbinding BOs
Date: Tue, 16 Dec 2025 12:09:31 +0100
Message-ID: <20251216111350.240219218@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index a38e41f9c7123..fda0a18e6d639 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -314,7 +314,6 @@ static void ivpu_gem_bo_free(struct drm_gem_object *obj)
 
 	mutex_lock(&vdev->bo_list_lock);
 	list_del(&bo->bo_list_node);
-	mutex_unlock(&vdev->bo_list_lock);
 
 	drm_WARN_ON(&vdev->drm, !drm_gem_is_imported(&bo->base.base) &&
 		    !dma_resv_test_signaled(obj->resv, DMA_RESV_USAGE_READ));
@@ -325,6 +324,8 @@ static void ivpu_gem_bo_free(struct drm_gem_object *obj)
 	ivpu_bo_unbind_locked(bo);
 	ivpu_bo_unlock(bo);
 
+	mutex_unlock(&vdev->bo_list_lock);
+
 	drm_WARN_ON(&vdev->drm, bo->mmu_mapped);
 	drm_WARN_ON(&vdev->drm, bo->ctx);
 
-- 
2.51.0



