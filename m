Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF621664C6;
	Mon, 24 Feb 2025 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408418; cv=none; b=bohNrJI297E5zBlowxyeUNhDIjlVBhi6+IAb2GfU5wzSbdCzxNtVXT4t1PBw0+FUt8+yQoS2z79dQrSr6dFe9w3cjqBxEPeWxx6OgsjaN2XcPfzU6tQBmjt4NvOPbO26fL+m+sLpfv9CiPOEPVMv0KaEz1EE62dLVvRkMoWmKbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408418; c=relaxed/simple;
	bh=DinY9s/BBkhjBWWuS94CJ99BNm59EKnMtqChjsvk9RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgP2YtnBouAHBioxXk/oK1C8EEbLqfpETlMoFMz/ZKzEylDWEtZvrqcI6raihxyIC7FCqgxG/BW1Z+Ykrmesz7LXlr39WBEU9oa3Yls9sVgHhlL83/4xny15mSEWlD7h74dCulv9Qhpi+riXc5Mc3RtIpHhNRc83Ts2HRBJuT/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6mruHBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6mruHBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DA3C4CED6;
	Mon, 24 Feb 2025 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408418;
	bh=DinY9s/BBkhjBWWuS94CJ99BNm59EKnMtqChjsvk9RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6mruHBXI89z/PFt5aqK4j9M2ah8oBNGNft1j+mEkgHT8AsiEChXPYfcDMrsq5ADJ
	 gJYMUVvACExnkuk4V3kgMTzR0QzXzXOR9ElwN7LdowQ1hfpwcCzzjBGY4TbK5+d1Uq
	 6ku/MdSoFPb0la1nAiISE9Coz69XtVZcsQEP5lw8=
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
Subject: [PATCH 6.12 051/154] vsock/virtio: fix variables initialization during resuming
Date: Mon, 24 Feb 2025 15:34:10 +0100
Message-ID: <20250224142609.091197753@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



