Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF323BFE40;
	Tue, 16 Jun 2026 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627085; cv=none; b=Yz/eA5vzjNPX3dNdrtqZU+kPm06SochE91qyetprKUiMIizXc4Zn/YtkCT2Rne+j9LTOdsm/XSeYSbkKTjRTiooxshoCOdvQ85W/pFAfgqaFSXj/EnUwcPlqdJnYpvoA6QiqrAY2El03F6AzejN/n91VvpLmY9gD+e9Q45dn73Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627085; c=relaxed/simple;
	bh=n/7yb4kxT4PU06RjwsiEzsTZndNP/dP38s0BlTc+f2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7FwZTynLq4qrzNsSMFV5go3wOrFL0its58NxdUUGOE8BpdbWHVF2pW01ZaVPV3DUuFvVgXsw29C+1nKH2euOUrp/z23IJFQqgq8CI6PL41pTg+Fin8YQAHErljd/H9C+cRDPohYxc0puz7K0DAmsSJpTWqqE4fT1jf52FMtFMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBgXcK6M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBgXcK6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1549D1F000E9;
	Tue, 16 Jun 2026 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627084;
	bh=IvSBqEygOxCbjwT2KkFbrpbU+qmOq7YvUDma1Z+37bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBgXcK6MQ04gOsihUzUpjlkiznWF6rttBup3D2MblanntNUnojrs75+3dSXJrW3k+
	 g5EkGH/jnLJHYVwiBZ/3lRWUhQrAXs0RcRnI7qIUz2eP3kfHEKXJfxr1UERuVGFCIH
	 aO0ffQ4J18GhMdKwQrJAt3ZKzMV8pbPYBnYduvI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/261] drm/virtio: Fix driver removal with disabled KMS
Date: Tue, 16 Jun 2026 20:29:15 +0530
Message-ID: <20260616145050.480694602@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit f329e8325e054bd6d84d10904f8dd51137281b92 ]

DRM atomic and modesetting aren't initialized if virtio-gpu driver built
with disabled KMS, leading to access of uninitialized data on driver
removal/unbinding and crashing kernel. Fix it by skipping shutting down
atomic core with unavailable KMS.

Fixes: 72122c69d717 ("drm/virtio: Add option to disable KMS support")
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Tested-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Reviewed-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Link: https://patch.msgid.link/20260604122743.13383-1-dmitry.osipenko@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.c b/drivers/gpu/drm/virtio/virtgpu_drv.c
index e5a2665e50eac4..44d99e89bb9b65 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -118,7 +118,10 @@ static void virtio_gpu_remove(struct virtio_device *vdev)
 	struct drm_device *dev = vdev->priv;
 
 	drm_dev_unplug(dev);
-	drm_atomic_helper_shutdown(dev);
+
+	if (drm_core_check_feature(dev, DRIVER_ATOMIC))
+		drm_atomic_helper_shutdown(dev);
+
 	virtio_gpu_deinit(dev);
 	drm_dev_put(dev);
 }
-- 
2.53.0



