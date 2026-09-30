Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF9B36921B;
	Wed, 30 Sep 2026 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785253; cv=none; b=O/6/tBV/7ktAN5yJe8+x7G/W206FRIR/xSkmxetsiD+u04iJGg6Q6BUYAJUfc9dVRQYKG1s+72cn1na+LFMT+VBdBGqwCShxBlGIbqiY3ZAKV2gu1mragX94POuPO98b9HqU/d/x9n34DJLnbevRdO2RlAe2fOHX2DJp4z6L0Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785253; c=relaxed/simple;
	bh=WXy8S1la2LeA+YGIPGClq/s8HQ5I7pM6jQeOz92pISE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf647EseWQVev0ZZCyYHsUI0oWp+ZSDMHSn3v8v/uWrcVTDrPERlefVejDFv2mRP6uVmF9U1Mqn8SRz4kOV+9Jfn2eORM33NmZxZY5iz1oRiGUqI2+GnjSHKoNH6gpeMa88FG/1QVgqXxrUru5vvaX2wVBQDZN+WV21pV2JAz3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sz9qfFnV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sz9qfFnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256171F000FF;
	Wed, 30 Sep 2026 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785248;
	bh=ZwIVGIDNfl7tDPv/Au37G9ZOMvpMJDnswXiCTmlIdDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sz9qfFnVM/mlZ9uqxFEJGvqGShZAR6Y+Colob3x4XZDWIGxCn1jliPiCjtC2XTB7d
	 l4JQN/VLI0jOgFdN1XUhGGERUTAXx/EM3R6p8CoX70RcVcX5JZdAD2zf0Cb8ihB07c
	 3bX+aspZ1o+QDhwkUokQHXFRAP0UWArJ4qorOELM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 440/982] virtio_console: do not free control-out buffers on remove
Date: Wed, 30 Sep 2026 17:19:36 +0200
Message-ID: <20260930152426.244068194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd3c83ccecc46..4e790f6fe0c3f 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1934,13 +1934,28 @@ static const struct file_operations portdev_fops = {
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



