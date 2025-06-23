Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD84519D084;
	Mon, 23 Jun 2025 21:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714843; cv=none; b=sbvcCk/RoasLcy/OK8p72rCjx0+5b39cR/Kr0fP7b1tn6g7NSAi/AqP/njLdo+4V6SqwLyDDjI3fKTiZd96BulVlgIdh+q9ezJU/uHA0JMuS+sjLuoBLuP7CplBHgKASIjHzgsaVMtX0fNd71Jrsj7HgmvJYVpFj3kK6/I5m8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714843; c=relaxed/simple;
	bh=EZvafpJMdUuS14E5eAWkksKhGVrMy7k3UKRKM0gt2tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMJSGAou11xqP+9wGFery5CkXGXVWAQuGosD0uTPtlQjrYvi3+31wuC9Qe6xMY9gaeFx5nkRtugXmu/TRVkJ9npBaqJrp2xW7xwAY0hUDw53YsNHOcz74tHDWTMN0hn1SfNB4TrdXBNdxAK9b2VTT/SaakkyL6G+hSUZ3kC9O+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5AlU6bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5AlU6bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CAFC4CEEA;
	Mon, 23 Jun 2025 21:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714843;
	bh=EZvafpJMdUuS14E5eAWkksKhGVrMy7k3UKRKM0gt2tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5AlU6bRlN4NV0qHi9sg12z9B5oHCZwBR+mdybtdUNGRfPaXKcsEc7im82rHCddE7
	 G7OM9ez/Jtcl/ZYFB+63Wv7tDgeHtJZojSntx/1s+WYW5oWge1/UaMTH1N7JvNy149
	 aj91jJzSZkHgX9CDTh8D3nCTMPsNmx5lc1yF+NpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 160/414] accel/ivpu: Fix warning in ivpu_gem_bo_free()
Date: Mon, 23 Jun 2025 15:04:57 +0200
Message-ID: <20250623130646.036888794@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 91274fd4ed9ba110b02c53d71d2778b7d13b49ac upstream.

Don't WARN if imported buffers are in use in ivpu_gem_bo_free() as they
can be indeed used in the original context/driver.

Fixes: 647371a6609d ("accel/ivpu: Add GEM buffer object management")
Cc: stable@vger.kernel.org # v6.3
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250528171220.513225-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -242,7 +242,8 @@ static void ivpu_gem_bo_free(struct drm_
 	list_del(&bo->bo_list_node);
 	mutex_unlock(&vdev->bo_list_lock);
 
-	drm_WARN_ON(&vdev->drm, !dma_resv_test_signaled(obj->resv, DMA_RESV_USAGE_READ));
+	drm_WARN_ON(&vdev->drm, !drm_gem_is_imported(&bo->base.base) &&
+		    !dma_resv_test_signaled(obj->resv, DMA_RESV_USAGE_READ));
 	drm_WARN_ON(&vdev->drm, ivpu_bo_size(bo) == 0);
 	drm_WARN_ON(&vdev->drm, bo->base.vaddr);
 


