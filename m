Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB6946EC84;
	Tue, 21 Jul 2026 17:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656565; cv=none; b=nhpChOrT+slOvnGV8Rn7NCl8r02oL4gSGmMxcFQLM+emvGgbP9vK7ELu1aBJmwBY6wHhwKT/JdRsnxZQ+aSN15c01DzAkox9KCL7F7ZBPtUoZTa3HCk5IxyS04irZUHVROORYAqZREfOXK7E0IdRYLhSvWe+qosbA2fXID1qRV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656565; c=relaxed/simple;
	bh=zrGdwm3wQrkbZXPTdRE0Ij1YzesobEA90/yYGcUs8s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEfcbh/QH9ik+Pj/zCm8w43+HOmN1ZqiW0GFadcMHcXhC78u6qksbcVJwNUMoPPg1cZ6ZoQIQC0Rq6wwl9RiKvMmWNUeMlpMHkbPcRlbhjwR5OMw1bKHvJFfWR1SEyzPtKk43WrOT0XtMu3KURjIltys8hQEq9xF16obwrE3+Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCyz9phM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCyz9phM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B681F000E9;
	Tue, 21 Jul 2026 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656563;
	bh=ZabjluDp055JdDJR96E7f7t3437vkxIfR5ZE1os1AYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCyz9phM9Zt8DzpwO3TWGOnorYQXKgikhHyQQekY2npgGcbjRpaufIfh42LjIWnjq
	 sHpO9gqEiaEGmLP1ScbAhtYM0MtrTU9sh7jVjnjrVwy8Op9Dx7LOdzLehUVyPcm5Q6
	 VjWtabsg5SAqhhWWM8of6h+pFNjw6x4IS9JzEdXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Peter Hilber <peter.hilber@oss.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0436/1611] virtio: rtc: tear down old virtqueues before restore
Date: Tue, 21 Jul 2026 17:09:12 +0200
Message-ID: <20260721152525.091743595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit 548d2208455f14e6121404c6e30e997bfe0cd264 ]

virtio_device_restore() resets the device and restores the negotiated
features before calling ->restore(). viortc_freeze() intentionally
leaves the existing virtqueues in place so the alarm queue can still
wake the system, but viortc_restore() immediately calls
viortc_init_vqs() without first deleting those old queues.

If virtqueue reinitialization fails on virtio-pci, the transport error
path can run vp_del_vqs() against a newly allocated vp_dev->vqs array
while vdev->vqs still contains the old virtqueues. vp_del_vqs() then
looks up queue state through the new array and can dereference a NULL
info pointer in vp_del_vq(), crashing the guest kernel during restore.

This can also happen during a non-faulty reinitialization, when one of
the vp_find_vqs_msix() attempts is unsuccessful before a later attempt
would succeed.

Delete the stale virtqueues before rebuilding them. If restore fails
before virtio_device_ready(), reuse the remove path to stop the device.
Once the device is ready, return errors directly instead of deleting the
virtqueues again.

Fixes: 0623c7592768 ("virtio_rtc: Add module and driver core")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Reviewed-by: Peter Hilber <peter.hilber@oss.qualcomm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260507120801.3677552-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_rtc_driver.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio_rtc_driver.c b/drivers/virtio/virtio_rtc_driver.c
index a57d5e06e19d2d..4419735b0f0dcf 100644
--- a/drivers/virtio/virtio_rtc_driver.c
+++ b/drivers/virtio/virtio_rtc_driver.c
@@ -1257,6 +1257,15 @@ static int viortc_init_vqs(struct viortc_dev *viortc)
 	return 0;
 }
 
+static void __viortc_remove(struct viortc_dev *viortc)
+{
+	struct virtio_device *vdev = viortc->vdev;
+
+	viortc_clocks_deinit(viortc);
+	virtio_reset_device(vdev);
+	vdev->config->del_vqs(vdev);
+}
+
 /**
  * viortc_probe() - probe a virtio_rtc virtio device
  * @vdev: virtio device
@@ -1282,7 +1291,7 @@ static int viortc_probe(struct virtio_device *vdev)
 
 	ret = viortc_init_vqs(viortc);
 	if (ret)
-		return ret;
+		goto err_reset_vdev;
 
 	virtio_device_ready(vdev);
 
@@ -1329,10 +1338,7 @@ static void viortc_remove(struct virtio_device *vdev)
 {
 	struct viortc_dev *viortc = vdev->priv;
 
-	viortc_clocks_deinit(viortc);
-
-	virtio_reset_device(vdev);
-	vdev->config->del_vqs(vdev);
+	__viortc_remove(viortc);
 }
 
 static int viortc_freeze(struct virtio_device *dev)
@@ -1353,9 +1359,11 @@ static int viortc_restore(struct virtio_device *dev)
 	bool notify = false;
 	int ret;
 
+	dev->config->del_vqs(dev);
+
 	ret = viortc_init_vqs(viortc);
 	if (ret)
-		return ret;
+		goto err_remove;
 
 	alarm_viortc_vq = &viortc->vqs[VIORTC_ALARMQ];
 	alarm_vq = alarm_viortc_vq->vq;
@@ -1364,7 +1372,7 @@ static int viortc_restore(struct virtio_device *dev)
 		ret = viortc_populate_vq(viortc, alarm_viortc_vq,
 					 VIORTC_ALARMQ_BUF_CAP, false);
 		if (ret)
-			return ret;
+			goto err_remove;
 
 		notify = virtqueue_kick_prepare(alarm_vq);
 	}
@@ -1372,8 +1380,12 @@ static int viortc_restore(struct virtio_device *dev)
 	virtio_device_ready(dev);
 
 	if (notify && !virtqueue_notify(alarm_vq))
-		ret = -EIO;
+		return -EIO;
+
+	return 0;
 
+err_remove:
+	__viortc_remove(viortc);
 	return ret;
 }
 
-- 
2.53.0



