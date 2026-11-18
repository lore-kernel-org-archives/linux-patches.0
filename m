Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029173;
	b=Jo+f4cEUkbxuJDDodlvX3q1Los3Q4gsC8dx5XEnRXwL2+B21uBSiNqYjE+WPuW/8linV
	 7qauqHoULmy1nOEevCLYw/rOVsBERijgjvKY9CHuP7a02WSN8AFzNyYNMFYEUfqS3uCV7
	 2m1hWP6V/YAfGOro4z/GiO7EQ91qgiOUxbm0c7StuRCKG34XCieLwSMAMBkB+uu6wwlxE
	 oQf/no4iKEIYpZSTdHAj8Zpynx49zyTPlFEHvTJojCc+MQe7MvnxSFOdDOuHj9Z3kXrtJ
	 MsbWsnNCij3KGKkou0oX+HwLK4ApLUy3l3/t0FNjohW/uoVLId9HTw9Gi+dmwXFVO2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zI0JIgtZ+RAxQFcu8hugYT8vtAPm34+rbDOXqjx2D4I=;
	b=pUQptVA5muIWuJkyDQ95NF2kKm5ycmIDj9vHJgw/hd4afGDuVanNPitzxfUuuW1NZdws
	 iawtfZ1gKWrY2ACngRe/Gpb859RS9NxQbDQ/GjZvlxVIJm93eZlgM5hox2UYzKWngG1ZH
	 UCcpioZCjs2z6To8ng8OuqsNzSpLB0Dpd7Z9j9yI90CwF0JFWS7qZs/zsT8e7NnMk9Z4Q
	 3cdRg8nyfBqh0DCsoeSaSLutfGIQqO0pfWyvD1HadVC7nRF0Vt2M1FmcASIN3Hx+T6IjJ
	 W1s+FC+ktpAGLNQVtdK8rDxS7IFdpM/cLU/JiVOQlkBeBWvaEMyPh2E91PnntgvkzNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvOGuRTl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C700E606A32C;
	Wed, 18 Nov 2026 19:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvOGuRTl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8A51F000C4;
	Wed, 18 Nov 2026 19:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029173;
	bh=zI0JIgtZ+RAxQFcu8hugYT8vtAPm34+rbDOXqjx2D4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvOGuRTl0CycpYSWC5ossSu3TROCI8Uqa7OGpSsSHkqU3mi/OKz8xf5+Ut5WP1qm8
	 difoVLwzEvICsyP2cXTgRW0jGb32yi7iFxkxGIgPMzWeyG+12pI5KooO1QTrVYlcAZ
	 ZpIl5vZ346rHlTUBcP1sHNqRmKePi93ZTC+FBaU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0254/1756] virtio_ccw: fix synchronize_cbs() after interrupt fallback
Date: Wed, 18 Nov 2026 15:39:41 +0100
Message-ID: <20261118150018.485591683@linuxfoundation.org>
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

[ Upstream commit 6e484b870b71eb6acb3fa7a10b8e71098e242033 ]

virtio_ccw_synchronize_cbs() assumes the device uses adapter interrupts
when vcdev->airq_info is not NULL. If registering adapter indicators
fails, virtio_ccw_find_vqs() falls back to classic interrupts but can
leave airq_info set.

With VIRTIO_HARDEN_NOTIFICATION enabled,
virtio_ccw_int_handler() invokes callbacks under vcdev->irq_lock.
synchronize_cbs() instead takes the indicator area lock, so it does
not synchronize with those callbacks.

Use vcdev->is_thinint, which the fallback clears, to select the lock.
Keep the airq_info check because is_thinint can be set before the
first find_vqs() call, when airq_info is still NULL.

Fixes: 3a232277c1ac ("virtio-ccw: implement synchronize_cbs()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260908053817.26065-2-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 4904b831c0a75..98b62bc18228b 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1061,7 +1061,7 @@ static void virtio_ccw_synchronize_cbs(struct virtio_device *vdev)
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct airq_info *info = vcdev->airq_info;
 
-	if (info) {
+	if (vcdev->is_thinint && info) {
 		/*
 		 * This device uses adapter interrupts: synchronize with
 		 * vring_interrupt() called by virtio_airq_handler()
-- 
2.53.0



