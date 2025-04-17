Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26A2257427;
	Thu, 17 Apr 2025 18:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912849; cv=none; b=Hepi7zEKyJINeHGvHCdBYKBHufIk9dq2O2y7Y2jOkFs4VA31sezmtWvP2zUUeYFoK9ZwvYa1Yz3IZw6xMtBauFJHUiVmc7q/epShz9bL8v5u/iZmZ8vSEA6rrfLB/0oxKNolCtdwb77kDbeHG77NFPqrIG55bnDnOlUmIwg6Slw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912849; c=relaxed/simple;
	bh=cko/aa+cb/kywKM2ErjQRNHNe0kVoxKYu0WLiOxRBQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n93nM+z4hzkgprn6FNnlzXmrnbbRtiywY4rtGnMb8+1MpOBYzDpprbq78VCuZaYmUla2DdtSaWDFd2RBVRPikZTOAj1iZqVj2HvrTwPFa47p0FlBbHUIZiJdWGr3cckDTiCDcv4KKi1KqskAlx7Gw/7yrAfJ60P/tYaL76w9T9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KImoY84y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KImoY84y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5798EC4CEE4;
	Thu, 17 Apr 2025 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912848;
	bh=cko/aa+cb/kywKM2ErjQRNHNe0kVoxKYu0WLiOxRBQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KImoY84ydCI0l1MVV1i1fPnPxXH6E3zus3BaB1S6qwbjDInRF4jIsKEPxINDl9GzJ
	 +IGu3HFeSFmEVBlEDbosNztcr82sMRj5OWuVaauPkjc1ABKHAGaEWCk88czduX16av
	 6IYGWFl8kqM/xUW5L0jIgOnuIqZ3PGjlaqdJ0Z8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 145/449] drm/virtio: Set missing bo->attached flag
Date: Thu, 17 Apr 2025 19:47:13 +0200
Message-ID: <20250417175123.807600125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit ffda6454267d0b870f3a09945a7ce88137b914a6 ]

VirtIO-GPU driver now supports detachment of shmem BOs from host, but
doing it only for imported dma-bufs. Mark all shmem BOs as attached, not
just dma-bufs. This is a minor correction since detachment of a non-dmabuf
BOs not supported today.

Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241129155357.2265357-1-dmitry.osipenko@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_prime.c | 1 -
 drivers/gpu/drm/virtio/virtgpu_vq.c    | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index d28d1c45a703b..58c9e22e9745c 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -250,7 +250,6 @@ static int virtgpu_dma_buf_init_obj(struct drm_device *dev,
 	virtio_gpu_cmd_resource_create_blob(vgdev, bo, &params,
 					    ents, nents);
 	bo->guest_blob = true;
-	bo->attached = true;
 
 	dma_buf_unpin(attach);
 	dma_resv_unlock(resv);
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index ad91624df42dd..062639250a4e9 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -1300,6 +1300,9 @@ virtio_gpu_cmd_resource_create_blob(struct virtio_gpu_device *vgdev,
 
 	virtio_gpu_queue_ctrl_buffer(vgdev, vbuf);
 	bo->created = true;
+
+	if (nents)
+		bo->attached = true;
 }
 
 void virtio_gpu_cmd_set_scanout_blob(struct virtio_gpu_device *vgdev,
-- 
2.39.5



