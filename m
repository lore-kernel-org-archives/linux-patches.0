Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023176;
	b=WPrX14a7DqFMbsjB7TjgisxcLksk+4v78q5qOEybMzPOboEtU9shNJ6GGevGBpdfKaMH
	 ZFoHEtMforPOfH9+iVmzW7gom0biYN1OCFJ31wpWXs4ly2fKlqZgHg1qFS0Kyjo8BJ06n
	 EXlAypmO3ryAIwhp1vi2/5LtINUj0/TQXLHNXjXqlYPEDb5+mXuqZqNG1s1DYtPcVi9ng
	 Smqhjs0uMdMqKpQx6U0+HSTy0hBC/4KdKqr1mwN1oToLxh2+/mbIQhj5bXlWcLes5kO78
	 j6KlG+D33Xk08C9MVrvdJx9i7sFd4jwfOw+vdkxS9EmerdVk6T1NeYDypwCpQqoD1IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XMmpDjqfDghIKacOZPqkbxFPVUhOx+jCbJyvokZ1EZg=;
	b=DzM6WLuCiKq7eiIjRbZTlPi+KG/g/Y7L8VUytYrOG4YYVaHfjqxCzmevI9JNs0wgQzur
	 eEUtQbEV+xDeL7w4M3fHb4dnR6Dbd27qzRHYvh7F0KaZIVqX3uJ7aHwrHIP2UgpAlji+U
	 rMq2a6UIKMTNEyavq+hSI66tvcetlvyDZ8Fg4qRnnbHgtIt/nGLMEsoN+R6L+4oV4LRBq
	 Wot1B0WGLi8/r/O9wRIllUrgPOds9Wq8ObWTsbmCJ4yJtI4dPMN7lINdhy32VhARoahfV
	 tNusisaJwdeoV4WJdxMbzqhpJXGR1FxlTujoCTDyD3ez0k0E3UJ2wl7Qx2Tm9RzyYzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whLEpIY+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB89606A325;
	Wed, 18 Nov 2026 17:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whLEpIY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAB51F000C4;
	Wed, 18 Nov 2026 17:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023175;
	bh=XMmpDjqfDghIKacOZPqkbxFPVUhOx+jCbJyvokZ1EZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whLEpIY+SUcFbSrkLkiaaGnfMq7bsgcy/PfHD6muEP6l8ZrlPViEIaY2E4npYb8/z
	 8mHzmf70hnOpeoA9ZeedSBoh/wX7UWrZCKf5EtbLeUBS3XDcjpsVAkEMIUjEgPbbr6
	 9LIj6neirIooJexNDQFTP3chXMvjCKfQojGRNLuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0275/2151] virtio_ccw: always take irq_lock in the classic interrupt handler
Date: Wed, 18 Nov 2026 15:33:30 +0100
Message-ID: <20261118150131.879427041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 48a355cf5b382570975e60857450ff3d42f268e9 ]

virtio_ccw_int_handler() takes vcdev->irq_lock around its
vring_interrupt() calls only when VIRTIO_HARDEN_NOTIFICATION is enabled.

The virtio shutdown path calls synchronize_cbs() even when notification
hardening is disabled. virtio_reset_device() now does so after the
transport reset too.

For classic interrupts, synchronize_cbs() takes vcdev->irq_lock for
writing, but the interrupt handler does not take the matching read
lock in that configuration. synchronize_cbs() can return while a
callback is still running.

Take the read lock unconditionally so the write side can synchronize
with the callbacks.

Fixes: 8bd2fa086a04 ("virtio: break and reset virtio devices on device_shutdown()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260908053817.26065-3-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 98b62bc18228b..340191410d2c8 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1203,13 +1203,11 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
 			vcdev->err = -EIO;
 	}
 	virtio_ccw_check_activity(vcdev, activity);
-#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	/*
 	 * Paired with virtio_ccw_synchronize_cbs() and interrupts are
 	 * disabled here.
 	 */
 	read_lock(&vcdev->irq_lock);
-#endif
 	for_each_set_bit(i, indicators(vcdev),
 			 sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
 		/* The bit clear must happen before the vring kick. */
@@ -1218,9 +1216,7 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
 		vq = virtio_ccw_vq_by_ind(vcdev, i);
 		vring_interrupt(0, vq);
 	}
-#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	read_unlock(&vcdev->irq_lock);
-#endif
 	if (test_bit(0, indicators2(vcdev))) {
 		virtio_config_changed(&vcdev->vdev);
 		clear_bit(0, indicators2(vcdev));
-- 
2.53.0



