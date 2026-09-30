Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400AB3C1986;
	Wed, 30 Sep 2026 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795457; cv=none; b=G/W+xbe3AQV8jkn57MwRDcDKF7MRBXhuMGZpu8SihB+VSGbacRgKitaRN2gVnJza6ME/vpk3FNgFrnDard7PyxSLaIVlTM5E4ZoQ900TyJDl2sHOcHXWRYmRQWqjHqZKAV+bS48woGVIMfugLjjBI2PyicQw6dyqt8Hhw+LsfPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795457; c=relaxed/simple;
	bh=hQ9SHov7syRVDjF/CTnrtKN16dSi5RLaGy5ypbMpLbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVzlTUT7lZ1dXKZKqQqsjt2Ax6rOZAgbaF6FF6cMmQnMRChsUjc2OxGtlz/MN8nqnJIPznQULazIAaGMbGgrjWqcDb07zDqfSNGo06Fcni/9BV+/jbR64zUvXb7+PxW0EYHmcDx13VcHpVcG+YycSR3ViV4Fj7VxKAaYgE2s2+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccdCawIY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccdCawIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8171F000FF;
	Wed, 30 Sep 2026 19:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795456;
	bh=TunCsbr7D6b1h86AsKthHTtWrFi2srTlWYx6SGRKyBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccdCawIYbwmAv6ZnFDf/29dto6g8a9cXvsOxAoeQrGWIxgUOxxHUmtnRCfd0VQ6sR
	 79MMgJKSQpTPYPqlCwC3gnoZI5s3iFa2rcpKR3z5A4qTHRZCkMwVAs5K+Sgy4DCkB+
	 Z5KG3M7c1gWmqYLrJvMSTWACeYY+M6iNF5nA0x00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0523/1193] virtio_console: do not free control-out buffers on remove
Date: Wed, 30 Sep 2026 17:20:07 +0200
Message-ID: <20260930152445.808278962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit 894f98e73983f37354214a89a3a7fd35bf9e3072 ]

__send_control_msg() publishes &portdev->cpkt as the control-out
virtqueue cookie. remove_vqs() walks every virtqueue and passes leftover
cookies to free_buf(), which treats them as struct port_buffer and
reads sgpages.

If a control message is still on c_ovq when the device is unbound,
free_buf() reads past the ports_device object.

KASAN reported slab-out-of-bounds in free_buf():

	free_buf
	remove_vqs
	virtcons_remove
	unbind_store

The object was the ports_device allocated in virtcons_probe().

Drain c_ovq without freeing. The packet lives in portdev and is released
with it.

Fixes: a7a69ec0d8e4 ("virtio_console: free buffers after reset")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260819021230.292696-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index f09b02f85cf6b..04d3ed5fb76b4 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1930,13 +1930,28 @@ static const struct file_operations portdev_fops = {
 static void remove_vqs(struct ports_device *portdev)
 {
 	struct virtqueue *vq;
+	bool multiport = use_multiport(portdev);
 
 	virtio_device_for_each_vq(portdev->vdev, vq) {
 		struct port_buffer *buf;
+		unsigned int len;
 
-		flush_bufs(vq, true);
-		while ((buf = virtqueue_detach_unused_buf(vq)))
-			free_buf(buf, true);
+		/*
+		 * c_ovq cookies are &portdev->cpkt, not port_buffer.
+		 * Detach them but do not free_buf().
+		 */
+		if (multiport && vq == portdev->c_ovq) {
+			spin_lock(&portdev->c_ovq_lock);
+			while (virtqueue_get_buf(vq, &len))
+				;
+			while (virtqueue_detach_unused_buf(vq))
+				;
+			spin_unlock(&portdev->c_ovq_lock);
+		} else {
+			flush_bufs(vq, true);
+			while ((buf = virtqueue_detach_unused_buf(vq)))
+				free_buf(buf, true);
+		}
 		cond_resched();
 	}
 	portdev->vdev->config->del_vqs(portdev->vdev);
-- 
2.53.0



