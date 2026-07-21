Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149BE35C69A;
	Tue, 21 Jul 2026 21:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669726; cv=none; b=j5DHaRDXBvUcI28QOlaXwTtXgA64uzO1Q/6eqbAG9EVJrSykag/1Omk5nc4ccUUu4/g0j6+5jV0LyaYu8geNOuvE48bPji47lB4LGfGuPfZWmcHWf/v6T8vo4zYPE/dlp4FQHEiQkxRNRy9pTozMO4o6SL19FHIXt5q8oG5qy6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669726; c=relaxed/simple;
	bh=AfBT+tjf5n88gF+QS08QxfcZv+hn165a493+oxe6yTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNELTLg60QtsqVaTXJG5bCE8a6fCMByhguR2wSBF6GGXVyQZCGSj7kQemc5hJl0IW9s6HB1u3TI/KrOqLVpxscHjliYbRqY4Ft7ZJxvduFxQVv7UV0y8Ye+41U/qScQDeeIRW7ovvrT3Tk1PrC1tXt9Yj2aIB56GP7AMnvOAPLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KArwXtyn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KArwXtyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7931F000E9;
	Tue, 21 Jul 2026 21:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669724;
	bh=GcvdgEkcNlcJWyPRToQlaNlKFznh6WQHHqnTD7vqr0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KArwXtynBjki6DO2N1QmQPzsG6pNXDhVCv/MdaZK1ZO0nVhi4EmqiJ8x6aUCynKE+
	 Ayft4QzytLjdaLrY/5k2Vxuu20BzcPx4p7ydnKy6C/J8fBqZMvkcz+5YhPx0sQtwSy
	 iFQ5Z6TJ7XbEV/o2NwRc+WCWyS3jBZZEOVxOIhwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Longjun Tang <tanglongjun@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0664/1067] virtio_net: disable cb when NAPI is busy-polled
Date: Tue, 21 Jul 2026 17:21:05 +0200
Message-ID: <20260721152439.450544771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longjun Tang <tanglongjun@kylinos.cn>

[ Upstream commit 1eb8fc67ca41db71c90866ff76c990d85247daef ]

When busy-poll is active, napi_schedule_prep() returns false in
virtqueue_napi_schedule(), so virtqueue_disable_cb() is skipped.
The device may keep firing irqs until reaches virtqueue_napi_complete().
Under load (received == budget), it will lead to a large number
of spurious interrupts.

Fix it by disabling the callback at the virtnet_poll() entry.
This keeps the callback off while we poll and it is re-enabled by
virtqueue_napi_complete() when going idle.

Fixes: ceef438d613f ("virtio_net: remove custom busy_poll")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Longjun Tang <tanglongjun@kylinos.cn>
Link: https://patch.msgid.link/20260629024230.37325-1-lange_tang@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9bbb26efb82573..23362ef9cb8c35 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1709,6 +1709,9 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	unsigned int received;
 	unsigned int xdp_xmit = 0;
 
+	if (budget)
+		virtqueue_disable_cb(rq->vq);
+
 	virtnet_poll_cleantx(rq, budget);
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
-- 
2.53.0



