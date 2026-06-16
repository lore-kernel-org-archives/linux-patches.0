Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF6E34889F;
	Tue, 16 Jun 2026 15:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623492; cv=none; b=YFqzcglz7IPpHdKweWVzwRtzPGjYzPO/7zb0c026PLRga6Gej/n29ItFrsg3Ql8wpz1N+y0KP1RlG9VB8BWdR4ITC5WiqXa0ONqgkrx4xzaKZGZuR12q5Vh/9GxSjDjrwLxZLEIEHtswSQKp/OAFRNSDGV51L8IbGeXlkiurqFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623492; c=relaxed/simple;
	bh=6edJeDfeURJe5cmnUFUdhlNGjObPPmY7iXSDLqrHh8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oX30n/dNto0qPZjaUYVpfhsqZMh2ABj+C8rEf1d3TEQ7Hc0vFxZGs+zrCe3QMpKyNMf9IgHK9IQbRHgYWsT5hQk5w6QMkfA6jDPCFCqmTEsFCCwX9HbIxZvKlt34KVM5EGCrol08ITujc9CWOgT97+mbDtnhsngHZLU9mzO4dKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNaY90mU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNaY90mU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C6F1F000E9;
	Tue, 16 Jun 2026 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623491;
	bh=1LCk7xqjI2ZXi4cGQ24gUXvQRFagLZPO/w6cpd+45RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNaY90mUn/x1XKYtoQhG++G/O3vz/36VDe7nHJ/FoUzFAycTptL24r33MnrvDjhXz
	 uea+1Mx9iflXuxygv4iQSAnQTgz6SV5q1IWbPjSJDauyST/tloYlhZEnoh/bR27oPl
	 SuMyOEuoLgDa1FDukSgFEYcelCt7dnSBIMZqProo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 159/378] drm/virtio: Fix driver removal with disabled KMS
Date: Tue, 16 Jun 2026 20:26:30 +0530
Message-ID: <20260616145118.615578362@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a5ce96fb8a1d24..9af740bda83593 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -124,7 +124,10 @@ static void virtio_gpu_remove(struct virtio_device *vdev)
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



