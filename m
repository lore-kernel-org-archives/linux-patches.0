Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C510138C42F;
	Wed, 30 Sep 2026 19:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795362; cv=none; b=CBhg3UdVNX2vuIzXMCaBjN8Qn5J8b6PtXtTeNVRhHIIHxKvyINc2HCJPNYCJoaZ6htcgYDWneuiXaflSLri6t9T0dlCJ+uIZ/Q4N9l/pd15Xr1fBvaDiNW0frb0rb1OOsQJQvxDPv2uygNoAtyFo0XABRVgBKr/7oBMruT70Jn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795362; c=relaxed/simple;
	bh=oZOkNMn0qwDm+YqjYE6bcTobE1UVeOmH5SrPRPR9zl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPVj6h4GgzbxJPwyzq7jYRt9Ck87Xhox5DivG+PR5C4/x4HXeFRALTiyibxIneI932bmJdXybaEA1B5xL8ivrydTbsqG92615dnMuyFeKLjOPSwlk9ZKXJbyvTdtoOsjm6CRgAQHOSP6Cit+cUOEn8nvrqlewgvmG3khufuCwaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djw/K2Nk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djw/K2Nk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5451F000FF;
	Wed, 30 Sep 2026 19:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795361;
	bh=90zi3hYEMNMs0E/38uNAA3RFMn0FJLXYTeGs7LEu+0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djw/K2NkRZ1CLzDk0hYile0w7YOJQNFIgWZ6bCK5xo1t5b/TtPFTbPXueWTlJbKed
	 S93DuuV1ZPzh+ALrwUWJnJ3wkGV2c6EcZeJtjohrQvX9oDHIy5PjmS78tuixR15094
	 OshV9u58Snv578naVds14fbL1Zd3e37pi5wux8QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0535/1193] virtio_input: reset device if input_register_device() fails
Date: Wed, 30 Sep 2026 17:20:19 +0200
Message-ID: <20260930152446.099049657@linuxfoundation.org>
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

From: Xiong Weimin <xiongweimin@kylinos.cn>

[ Upstream commit 81489b32a21c9360f8750d1fb600155d27452e19 ]

Probe marks the device DRIVER_OK with virtio_device_ready() before
calling input_register_device(). If registration fails, the error path
cleared vi->ready and called del_vqs() while the device was still live,
so the device could keep DMA to queues that were already torn down.

Match remove/freeze: call virtio_reset_device() on that path before
tearing down the virtqueues.

Fixes: 271c865161c5 ("Add virtio-input driver.")
Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260805032931.1606652-1-xiongweimin@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index 3aa46703872dc..54d90006e598f 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -327,6 +327,7 @@ static int virtinput_probe(struct virtio_device *vdev)
 	spin_lock_irqsave(&vi->lock, flags);
 	vi->ready = false;
 	spin_unlock_irqrestore(&vi->lock, flags);
+	virtio_reset_device(vdev);
 err_mt_init_slots:
 	input_free_device(vi->idev);
 err_input_alloc:
-- 
2.53.0



