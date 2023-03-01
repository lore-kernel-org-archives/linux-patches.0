Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25665847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D82EC433EF;
	Wed,  1 Mar 2023 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694217;
	bh=UMIMOpi4R56rS3TJV7+eADWVt30WJvkhSk5kKGwWR3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naK5v/+BjdZaERvnB9J3usZPJAetdVR1f7i+m8h/nJa21xEbJoUIr0fnxSv+XMANA
	 yG4jyVpC8LZEAH2aFWBScjgSn+1ZGrgcosbi5qELDGR6PGtOm+6mqtTQFNHIaEZno5
	 1IGlVlv6ptPK8vpc/DIpf9Z0j20DmKzIlJ11xS9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Velikov <emil.l.velikov@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 16/19] drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling
Date: Wed,  1 Mar 2023 19:08:45 +0100
Message-Id: <20230301180652.989746215@linuxfoundation.org>
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

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 64b88afbd92fbf434759d1896a7cf705e1c00e79 upstream.

Previous commit fixed checking of the ERR_PTR value returned by
drm_gem_shmem_get_sg_table(), but it missed to zero out the shmem->pages,
which will crash virtio_gpu_cleanup_object(). Add the missing zeroing of
the shmem->pages.

Fixes: c24968734abf ("drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init")
Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-2-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/gpu/drm/virtio/virtgpu_object.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -159,6 +159,7 @@ static int virtio_gpu_object_shmem_init(
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base.base);
+		shmem->pages = NULL;
 		return PTR_ERR(shmem->pages);
 	}
 


