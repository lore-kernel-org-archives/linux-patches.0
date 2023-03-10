Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53876882C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD086C4339E;
	Fri, 10 Mar 2023 15:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461445;
	bh=AvUKvCQs9KpHmnXHhCG0uNA02Idm89s59O/h1EIuD5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaNatbdNy3V42Y2qjq8lMejG+fh/s2a04buvcYL27bpmx9QrEF26b/tWcszHhMFpW
	 m1rkJCCnNVea1wKqTyq2er5DYSD0lN8gLP+z0YXomMUqXP01UuINGfF2VcjoBQQNi1
	 MBs0GXuYuPS6RnZCU1emcQzrMGtXETTvNQ7R5xfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kraxel@redhat.com, linux-kernel@vger.kernel.org, emil.l.velikov@gmail.com, airlied@linux.ie, error27@gmail.com, darren.kenny@oracle.com, vegard.nossum@oracle.com, Harshit Mogalapalli" <harshit.m.mogalapalli@oracle.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 130/136] drm/virtio: Fix error code in virtio_gpu_object_shmem_init()
Date: Fri, 10 Mar 2023 14:44:12 +0100
Message-Id: <20230310133711.161611575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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
@@ -169,8 +169,9 @@ static int virtio_gpu_object_shmem_init(
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base);
+		ret = PTR_ERR(shmem->pages);
 		shmem->pages = NULL;
-		return PTR_ERR(shmem->pages);
+		return ret;
 	}
 
 	if (use_dma_api) {


