Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F4D847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0809FC433EF;
	Wed,  1 Mar 2023 18:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694214;
	bh=jyRcVKi9r95ZAWV/kT7GN8wDBwuD50Q0uroq0yZ4AZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvJDku4QiqbMuBLowrZA/byV3bC2jA0phvKIyJE3Ye+R2zUqD2f/YD14pw85GVktx
	 htxeQnN6vg/s4nes1UCgZAimZ0RHxrB0jMZk/u0sBH1NhlCPxB845+6EUIrFc9dYWQ
	 g6X7D8VYFEOg9JPiYhljpZLpOwAnd7ma3y1s9az8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 15/19] drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init
Date: Wed,  1 Mar 2023 19:08:44 +0100
Message-Id: <20230301180652.949607547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
References: <20230301180652.316428563@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

commit c24968734abfed81c8f93dc5f44a7b7a9aecadfa upstream.

Since drm_prime_pages_to_sg() function return error pointers.
The drm_gem_shmem_get_sg_table() function returns error pointers too.
Using IS_ERR() to check the return value to fix this.

Fixes: 2f2aa13724d5 ("drm/virtio: move virtio_gpu_mem_entry initialization to new function")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220602104223.54527-1-linmq006@gmail.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/gpu/drm/virtio/virtgpu_object.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -157,9 +157,9 @@ static int virtio_gpu_object_shmem_init(
 	 * since virtio_gpu doesn't support dma-buf import from other devices.
 	 */
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
-	if (!shmem->pages) {
+	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base.base);
-		return -EINVAL;
+		return PTR_ERR(shmem->pages);
 	}
 
 	if (use_dma_api) {


