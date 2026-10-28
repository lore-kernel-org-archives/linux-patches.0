Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217289;
	b=wyPf+PdWVEuNRDdLMD56M/6AqAZSPvdoJO8sUF2326xYULF/GL04OO/GdQ2iXmlxxz8W
	 yXzwmAOZwVmnJvjnTkhHbio/szenbwShbrSZsetXtlcisreBmBXvehGStiAKV54ZSS5sZ
	 eItqA1M8ZFz1Ps97ttEvALxWHgEfc2ZCE39CtEVNmeqrMUW2XBUQptuX9fAXPThPm3LI+
	 aPKWTRWtvvKUJ81WK+wzYNanEClYi3qq+V6MtdQt7ydpo5SxkIEv4tLGo1+pGYc3EpurT
	 YM/yOPoPJLRCvgbuM5Fy5clvoKxmR/jJj1uRFf9rfhgzifaG48WShwDVX1Tj/PZRSLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C1GdQ3Kh04g/OFT1rfxSo3BeBkqYRIDFM9oJBvMO2lk=;
	b=cer61UfXsS77XAv0+VgIKv4sctinlcrraygTg70vPewmAwmvAHFyyEoP2lfbgIObLZXL
	 dUqb0yuPgzhTPL6E/EZDvYrq3HjVL8SSB3IaDDVyx8kMce3HW9uZbngO3fys8s4E1P1PD
	 jPvQG8eZEwqCf4+p1H4xkVg46pd72MkEPRAHS8NwGSCxBdCRu3uuh2TV9kJv570DeDCds
	 CYtSdqKwCTynIBhadl1A0DGrcfwoKhnztxIgLh9l7ZZS+LgN4lVelXK7BBzMO81wQvrSa
	 oMLfLSpmUHWhoUZHONJxPj+SUvbJeFMgqkpQI7M3MQcn0ygid/7lLFhhJM6MaAL8A6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wull4P7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99FA606A31C;
	Wed, 28 Oct 2026 19:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wull4P7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059271F031E0;
	Wed, 28 Oct 2026 19:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217288;
	bh=C1GdQ3Kh04g/OFT1rfxSo3BeBkqYRIDFM9oJBvMO2lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wull4P7li/scqnCIu28NNADrAXwnoPIKR4yzw8giI5liinabBO+811lkXKAMycdWq
	 GXa+2jNnFq6C5/QNly+ClxxF+wtUwQ3vm5Q+bdwyJ9t2qAobS3HYhiGhmHkO2yclky
	 fLe/irYW3xfZ8NU2Mu5Q3W+H6Uf2ZHDfWqfhPM0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1852/1887] virtio_ccw: always take irq_lock in the classic interrupt handler
Date: Wed, 28 Oct 2026 18:05:48 +0100
Message-ID: <20261028170541.594870939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a10dbe632ef9b..630db9f4d9f5e 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1141,13 +1141,11 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
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
@@ -1156,9 +1154,7 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
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



