Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015701;
	b=vfZVQtj0ifJpaX9f20Zg/LdQ0gdHyP3DLD04l7wglb/hqf5jSPVLq8aYAB3iw0CKqHc3
	 PoMSyidmAznEnmX197JQi2OCqZAql993nsFG5Mg9FtFH/8kZWAUdBoKhdinEa57UA0EQh
	 PMt5JkyliNwH4qkbb6N2KT3uei8XHiv8VRjZaXanHXm87uB3zQRluPE+t7fULiMgbkh18
	 NQ5O4EWiRmPSRosAdvFaKVqu9+wKNOcOaZ8XgTxAaVXbcr2GuhhjLfK5t04dmbwTZ44Mc
	 xn7OsEagbunhFHxaTtZhYXVMw2Fu/7wQ3Z7D0rq1miElDAlGy+jv3m/T58UegTOngSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=02qQxCiWDNtj0N4prXXFXOGjcUUqYIlfv3MtnGwmVG0=;
	b=34hf2r3XATC5j2p7jHIbSzRYNQ+pi19qI99Rmnd1KqINP1tAAgeNzvGSOpUi0M4/GNz+
	 8fyhae0cv6PV/PZSshKnspLngUO99HiATY1Ey6KptOkS/zXPtrxNdzAM+/wHqQ0MrjVsD
	 Jim/lqSerzSaPcoCPneFyFWt7Ccb8QvlQgyVLUPf04fFPinT4V7I98ejhAbXT1jBX3Lpb
	 z16tHcmuJVDGnN42RsF5KV2lnRSXW4pJCMv4D61Rep+2I7Le1IaPCfCrmsG+Pdl4/dQR1
	 eHqSX80OVaFEZek/F0SxzT/0GC04WGxxb1JiJbeaDT5GC4KcyY7aYUrkiGcHnYzoLyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pkt1z0VW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DC4606A33A;
	Wed, 18 Nov 2026 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pkt1z0VW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A6E1F000C8;
	Wed, 18 Nov 2026 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015701;
	bh=02qQxCiWDNtj0N4prXXFXOGjcUUqYIlfv3MtnGwmVG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pkt1z0VW43zwmvjXqsdZsqwjASOnR/aAjzUv8rgghxVc4w1QUZDxgGGEbP7yOI/Z1
	 zUCYWSo1dbK/KNJvsSiuJa0/AwsBLAXYkROiXa/SRfLAuKd5A2NrTyadGq5/5cxl4P
	 l9avZFLgg0NWFj8g8ORMt3y6/vmpjYcKNGNUIomM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0267/2651] virtio_ccw: always take irq_lock in the classic interrupt handler
Date: Wed, 18 Nov 2026 15:25:07 +0100
Message-ID: <20261118150257.515366528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b90299205698b..552d779980129 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1204,13 +1204,11 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
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
@@ -1219,9 +1217,7 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
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



