Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8833DB62F;
	Thu, 17 Sep 2026 18:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670600; cv=none; b=kAPB37Yh6zpZTDDRhpcbdyUkX5+ChSVq/hJr8aNEt1MVdaaavTwPec4LZ5MedQLkKhmBN70ivQaVtBVVUsLXptVlRoM8mvyPVJXRVRQTcD6JtMFAVsBOEe5/uCdq2fg3PCMkhWzpjD9jNPJlZrh66HpxaWI4hytXnuT42i02aGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670600; c=relaxed/simple;
	bh=cW/ERb4v5m21Y2Z9DXTPZqdUt7RVOrYkT0O1SE32/cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L50fISsNlQUtCljd3FO2kIDGX32w13Eey9gnA6LRtsauWWNd+XCkh1MIMz74XI1WKr0whPuCNcFTPVOrmede2JxWqa6Lz/5eZ7P8zkERItb8l6zIu8AaQnivqpVMaLjqmilp7Qa6ab/LGWf+H9/rTy8l5QgCZfD7pHsK552d0fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TM86tNHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TM86tNHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE501F000FF;
	Thu, 17 Sep 2026 18:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670598;
	bh=rrm1bFGQvFmgERa+XPXuFYj6NKxdkAb9teJrD4EP0vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TM86tNHBP4r5hk8zLawJap/CSfcjyqc1BuNunXPjS1X3DzF7UxqZfWi2hBlmzYX+p
	 Kn1wjfW+ppX6nzHhlFWtfvjehFFJQcltKzXhFUFjimGKKbgo2nCg4PmFajWk7vG+MY
	 iPhTP3uGuoS6TnscFnH601KFREQubbn0agmxciJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0712/1102] virtio_console: do not free control-out buffers on remove
Date: Thu, 17 Sep 2026 16:10:55 +0100
Message-ID: <20260917151558.206539400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 8765e8fcb68a7..75ba23fa2187b 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1896,13 +1896,28 @@ static const struct file_operations portdev_fops = {
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



