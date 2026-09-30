Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7EA3EA976;
	Wed, 30 Sep 2026 18:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791512; cv=none; b=jPiTvxExZOJi9XZF0CbQDxFVE6rkA+5ZzBUVS0PoaGIRHw4JJVwrNDtJD7AMjKNiVEkHbS9/S/AyUacoZUEaThuFUd1TnjkpoOcd5mnTiNBQ80hMQUx41Yv8SsNFzOaTaiXdWXjer3SDV2U3ZvizrOqIJ1aKjZwRpwnayrBTUqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791512; c=relaxed/simple;
	bh=N5tGh7s/xK1sk6oZpgsRGjUa4nio8S2wJUEuYvYLKq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/CMc//I5T6d3BNcSgDFkpdu3rLPGVYbyqMGjGj6+7YBr+5+ZeHpvwJjd1ia3dqn6OyDEMh8J7Hj9+OfuHJ3+LNVKyMEcYuZCaXwMLk82mNEc4onJ7SY2M/CXRn2YiAhAr/YWCTYZFC2YbJyvE/iZGfFjop184Rb+iDojOZfBYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7BSt+l/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7BSt+l/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85EB1F000FF;
	Wed, 30 Sep 2026 18:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791511;
	bh=BSH8GZ+NOxbvPGZXyoymuqIgJaWSLlCVbQHBmbqSThM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7BSt+l/WH8HYVQ3tOijg1FEEUelS7trRHiPVEHqdm1IHvpi5zNCNOyCCDAySF3Ro
	 RqHXff43TgSkQdkCl/oDRZoXjoHxQY5lVx1ZTkJy16aNPJk0PpIDf/iagHkWlYQj7f
	 03CNWkJvzoFg09InSXHiP5PxGojEZE6ZoIB8akSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 329/752] virtio_console: do not free control-out buffers on remove
Date: Wed, 30 Sep 2026 17:23:19 +0200
Message-ID: <20260930152405.415547332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index df48e5e906f85..dadd31a5dbf99 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1933,13 +1933,28 @@ static const struct file_operations portdev_fops = {
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



