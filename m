Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B179189905;
	Mon, 24 Feb 2025 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408973; cv=none; b=CuhCYaJUvBQ5t6atvEPhha8U6iyuq0JtUy0VL3Ggng+rK/gENfFi3VoDlXAOKgV1IZwgmExepndvBQ0cdagFUIDaaWcJauDyjjnAsN09srOInlQPFw05mgAsFHQOwtMeC4tu4JQwBvazmkM3bW+tQHF44HPKnBx34YF8415SPzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408973; c=relaxed/simple;
	bh=2Sowp2hk4u/sfZZuLo+c8wm6iACDYx1ZagjysI01OOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mgxcsyt/KnVyzFFnBjVkxE3p9gXgZ6WQ7JgtbOWlAi1igdxOo/L1cNuDNfzZPXI5ZmCjiSwu4k5J2AtXLYv0UBNt9ADVNsOPqhvS95UxLUHq9GCzLVJC0Ck61RogkEZh70p/A8anewqw55YGx+PdZI1IKQq9cpo3co8DtAZ+erg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwAa9aBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwAa9aBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8419AC4CEE6;
	Mon, 24 Feb 2025 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408972;
	bh=2Sowp2hk4u/sfZZuLo+c8wm6iACDYx1ZagjysI01OOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwAa9aBAz94YmnmHD2cfUjf+elyc4HEDSNVGb41nLsoSRuovXHJo4sYr+2Ni7MTT+
	 tmCkdKaH+RpB0bWK7tX/i0Fsf8tXT8VSg8kcdQIRzqH0rv8J2V8+Q67WR60/ZyNcEv
	 N/2CHWMYmYgeU0Z7oODxq/jm4Hx/+6Q8H3Zzl36M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Gao <ying01.gao@samsung.com>,
	Junnan Wu <junnan01.wu@samsung.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 027/138] vsock/virtio: fix variables initialization during resuming
Date: Mon, 24 Feb 2025 15:34:17 +0100
Message-ID: <20250224142605.538137507@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junnan Wu <junnan01.wu@samsung.com>

[ Upstream commit 55eff109e76a14e5ed10c8c3c3978d20a35e2a4d ]

When executing suspend to ram twice in a row,
the `rx_buf_nr` and `rx_buf_max_nr` increase to three times vq->num_free.
Then after virtqueue_get_buf and `rx_buf_nr` decreased
in function virtio_transport_rx_work,
the condition to fill rx buffer
(rx_buf_nr < rx_buf_max_nr / 2) will never be met.

It is because that `rx_buf_nr` and `rx_buf_max_nr`
are initialized only in virtio_vsock_probe(),
but they should be reset whenever virtqueues are recreated,
like after a suspend/resume.

Move the `rx_buf_nr` and `rx_buf_max_nr` initialization in
virtio_vsock_vqs_init(), so we are sure that they are properly
initialized, every time we initialize the virtqueues, either when we
load the driver or after a suspend/resume.

To prevent erroneous atomic load operations on the `queued_replies`
in the virtio_transport_send_pkt_work() function
which may disrupt the scheduling of vsock->rx_work
when transmitting reply-required socket packets,
this atomic variable must undergo synchronized initialization
alongside the preceding two variables after a suspend/resume.

Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
Link: https://lore.kernel.org/virtualization/20250207052033.2222629-1-junnan01.wu@samsung.com/
Co-developed-by: Ying Gao <ying01.gao@samsung.com>
Signed-off-by: Ying Gao <ying01.gao@samsung.com>
Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20250214012200.1883896-1-junnan01.wu@samsung.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index b58c3818f284f..f0e48e6911fc4 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -670,6 +670,13 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	};
 	int ret;
 
+	mutex_lock(&vsock->rx_lock);
+	vsock->rx_buf_nr = 0;
+	vsock->rx_buf_max_nr = 0;
+	mutex_unlock(&vsock->rx_lock);
+
+	atomic_set(&vsock->queued_replies, 0);
+
 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
 	if (ret < 0)
 		return ret;
@@ -779,9 +786,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	vsock->vdev = vdev;
 
-	vsock->rx_buf_nr = 0;
-	vsock->rx_buf_max_nr = 0;
-	atomic_set(&vsock->queued_replies, 0);
 
 	mutex_init(&vsock->tx_lock);
 	mutex_init(&vsock->rx_lock);
-- 
2.39.5



