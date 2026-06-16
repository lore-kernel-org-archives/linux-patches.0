Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305C6328610;
	Tue, 16 Jun 2026 17:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629524; cv=none; b=P0QYWt7xYs+YuUOtulrIPftHNQ0Mu4SsIhfku6d59aMNUcprCoebrgt/rJ6JdqyO8e3IFljsb6seNT0lPfnehEKwpbJDtBQgX8BHzomySuGpGPD+GhM/dvocrn3gcYVMZN7e7o9SMk6f3MvCwoPk2tYTeNFDaizrAz4RhBesoL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629524; c=relaxed/simple;
	bh=FZ1cdTnko42ZFNVcy3guMKpWFr9O3McxRLfABxGDEDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNWfELjDbZHAfdGyzyQ5MbZ7q3PpXcBzigA8ZEqZiZh5BSICqJEzl0/IKzHneGnnfLt12P17m7NZMuQlFYMM4Bi7Aefl1EgCnh8hPfTNPQ3k0Q3czu3LOmTd+dmVsgKDJBXzZOj2hI2dzsRC4uEFSt9txNbdRJdDPFk5Y4n47Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sedu4tDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sedu4tDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9451F000E9;
	Tue, 16 Jun 2026 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629523;
	bh=2TTIcKt2mHv8ISo1sUjEttPQMWuBRcMtdxkvNrvD6ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sedu4tDyyoc+WSTElF9kGFQJIrSqosJwh3pkbRRgigJaOi6kEMU1EY949F11o+A5w
	 4G5dUMB9/UB4jNU5E5qMPxvOAAecbq/yDdF/aJlo/k6oRCD6/nN1kci6cL8r5lTXJi
	 DSIzLANfjqMwlx0CAcbf56XyWvIJssPOnesmMjek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/452] drm/virtio: Fix driver removal with disabled KMS
Date: Tue, 16 Jun 2026 20:28:36 +0530
Message-ID: <20260616145132.758878137@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c5716fd0aed380..9b399a12d43c20 100644
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



