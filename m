Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892EA36E46C;
	Tue, 16 Jun 2026 15:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625443; cv=none; b=gn4FlBrmQ/zzxYiymPpjQKqddizTAD7dYWAmGDodMf9+UGRj+C4/hXyWoYzqhxZmm1IQe1Rz1eBkmWpycUmpp9V56pobmvRRtiiMD2VfykR70eYwimOFODCrKD8hbo2AFGP/Hs2btbyHG5X+3r3jH+YK0f1R1+ppmu1A4L8ubB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625443; c=relaxed/simple;
	bh=rOVo6jBtbzlv3bjHuHo7xUln89A2xBBBw3E8BWkdnqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr8nLxVYPc3W9kSKsV34TKEai41LALC0T7lFtXHYpDdJUHbI3FIA1CQFPxxv8xEsEWY0iNff5vvcr4jK4jP0ig0UuheDIS23b3JcCboKVu5pFCqHnfsgFV7C5kZtscWJxN+Wdy/tcKWZLvWYudMzRkMxfM6hoknPG5dmkVK2Ly8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7XaFAjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7XaFAjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993B11F000E9;
	Tue, 16 Jun 2026 15:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625442;
	bh=ZRZviinv0nxADfsmEqHfeDQ4qiDdQJM8lo2U8M7gs78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7XaFAjjzPe5IBrTadZiyTJpQnc2EMwKwntkVViU1Z7Jo+rWSuwic8nEF/Xe1WZCu
	 d0/N6rK5quyOMKCpgD9KSA9j7Z2X1h5JhPflEKbbP6j/RaW/wcPNXZR8Q/YfPBwHPj
	 DcP0YQuAQltuE1isoFJ726ZSpV29Zcql2+pOIeoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/325] drm/virtio: Fix driver removal with disabled KMS
Date: Tue, 16 Jun 2026 20:28:59 +0530
Message-ID: <20260616145104.856570165@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 71c6ccad4b99b4..d9556e1b67b10b 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -123,7 +123,10 @@ static void virtio_gpu_remove(struct virtio_device *vdev)
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



