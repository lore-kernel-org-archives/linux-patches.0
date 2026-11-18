Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029176;
	b=hAwx5vxCrts+bFi5AYBwQiJ2zMa7czRFSvC3CPA6x9lMTer08S/YRJivCTdDncBulNig
	 Ua8C9M7pzV/OgFz9fnARxrXsram/huWGca5bo2zIaG9cC+ECkiA09DUORpSzskckA1AkW
	 WOH36CI0+2Thcd8Xv5z5h1cifozxbiLs7+WGG+zWrpXtg6l0cXFKgR0JhsieRp86Sar9g
	 yjvCAOnkmoy/M8qR12+o5RuFHlZ6uZwblNhVg2c2uBuORTJh1cp9IGSIxcogx0cPti9/r
	 gECXWOiY72+lDbhpZ0HXVQrmT41Eh1gd8eIhGx2WJgNICEqUHrFYQFYpkUqLev9mrSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c7Dr6dAf90lZdLc212GF/tcY2bLLejN8FnX5gu8m0zw=;
	b=mBDuun8De99rlIr+NKKryVISgZfrowziGKpb1GazVHF27dB8zQySiRJy9tbIDrrZDEHC
	 T1w0aYHX3EF8tLRIbudYCloNhxaY1PS4353iam/i7JJTAUAtoqCh5UaqKdpvYh1tWt9Cg
	 g7L4Szy/KNTErIDu+s82o8oUmPgB7x4vmZaVHOp/uQeF7uG72iEObBQTPYAwIQ/XM0zHO
	 KiUSzsjrgkdoyDvIlMIutvO7/7IfB+hXJfqbLfgal4/1j7RtamC0A3Oc+HylogS29MJ3G
	 1qXNF5Cc0TEwqWNk9bDaRPoMb9On4lRXNHuI4B4SwFyg5bI1SwrXY5rRYQWRaaCs3qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bhYC5FZN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9269D606A31C;
	Wed, 18 Nov 2026 19:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bhYC5FZN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64081F000C4;
	Wed, 18 Nov 2026 19:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029176;
	bh=c7Dr6dAf90lZdLc212GF/tcY2bLLejN8FnX5gu8m0zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhYC5FZNF3EQMB4m8nFnbYVnWiOV0mfX2xxiWX++dA8/ClkBnc9rId+EUMIkQvA/E
	 IMHzX4jKps21am71B1QipJvhQxQyk9nMl1Ql+DFZVlj8nU9mAT0ain3g6HyzSeDtu6
	 j1vusxP2+JL0jFiccqvRxvNOQRYkzfRuPE5+xv1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0255/1756] virtio_ccw: always take irq_lock in the classic interrupt handler
Date: Wed, 18 Nov 2026 15:39:42 +0100
Message-ID: <20261118150018.522771756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



