Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D584A882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A73C433D2;
	Fri, 10 Mar 2023 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460991;
	bh=HAZOJrd73kJG/1xoaTlxrGOsIWv9avtuFE/GUTtdpBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjPu5zxE5Bn80etWYakM2bT5trBsz+C66sVhhFieokIk6AWkAhP9MASEqiEIqynkz
	 fAK7LFMCjUScVk34a1GZBj8/++HsKA/HVOmNlU/Z52Mt97zA1ZA/UJc5hbeRLH0EuX
	 3Blz8LvK4DsF/ZDnvE5tYnveYWyQ0YJRBdcQMSno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 5.10 520/529] drm/virtio: Fix error code in virtio_gpu_object_shmem_init()
Date: Fri, 10 Mar 2023 14:41:03 +0100
Message-Id: <20230310133828.922435725@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

In virtio_gpu_object_shmem_init() we are passing NULL to PTR_ERR, which
is returning 0/success.

Fix this by storing error value in 'ret' variable before assigning
shmem->pages to NULL.

Found using static analysis with Smatch.

Fixes: 64b88afbd92f ("drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -159,8 +159,9 @@ static int virtio_gpu_object_shmem_init(
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base.base);
+		ret = PTR_ERR(shmem->pages);
 		shmem->pages = NULL;
-		return PTR_ERR(shmem->pages);
+		return ret;
 	}
 
 	if (use_dma_api) {


