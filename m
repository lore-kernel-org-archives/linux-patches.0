Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7E536124;
	Wed, 30 Jul 2025 09:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868602; cv=none; b=Fw8b3XL8dMNAZ/WqGRNp/yxB6Nu5aeIhbzSxxjBlTfIcfIgfAEF++zXMUwHGqWiuTe7D2bkEUAafz7Y1Ad+EaLG4phxYo2fOtbeAmpSgMlh6hxZK9meNrzUvX78dxk5J3LFO2Vezg7UKYTEjGEvfCI8uoIdnF3fBe3tijSY3wgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868602; c=relaxed/simple;
	bh=25/gdz1SYGDxX40lufW0y5G4wWzMwMC0G+G0YAKLctg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tk5foFRtsM/Nmoe+9hYV1h5yjTsLMwZmmdbnLRTTrhk8p9hdlvbd35PKFjihY+eZdG1mv1dLghR7j659BdCElAvMuy5zZtAZG0cIHMjOmX30bKQzbNT+hDF45gOsvfNd6Y4y0tj+7j1SlcVeIfu5uqCG3MX2iBTMia+kWB8cTzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzOqcI5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzOqcI5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE35C4CEE7;
	Wed, 30 Jul 2025 09:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868602;
	bh=25/gdz1SYGDxX40lufW0y5G4wWzMwMC0G+G0YAKLctg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzOqcI5c35MdPeZyTupcVb95zlAECp0xOSfU6SY4Q+ICDFdhk5ZK11j1w/Zw7AsZr
	 Ans5LZ2e2hrjM1pIeHhNQZtwvJMe+KJTOWJVq9PqICGr+q8yDz6Sr56+pDU/MekfGw
	 Wk4CRoHjnD5kkd2eBljuF5qmbWEQF2YeerMY4pmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Yang <leiyang@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/117] virtio_net: Enforce minimum TX ring size for reliability
Date: Wed, 30 Jul 2025 11:34:32 +0200
Message-ID: <20250730093233.728633180@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit 24b2f5df86aaebbe7bac40304eaf5a146c02367c ]

The `tx_may_stop()` logic stops TX queues if free descriptors
(`sq->vq->num_free`) fall below the threshold of (`MAX_SKB_FRAGS` + 2).
If the total ring size (`ring_num`) is not strictly greater than this
value, queues can become persistently stopped or stop after minimal
use, severely degrading performance.

A single sk_buff transmission typically requires descriptors for:
- The virtio_net_hdr (1 descriptor)
- The sk_buff's linear data (head) (1 descriptor)
- Paged fragments (up to MAX_SKB_FRAGS descriptors)

This patch enforces that the TX ring size ('ring_num') must be strictly
greater than (MAX_SKB_FRAGS + 2). This ensures that the ring is
always large enough to hold at least one maximally-fragmented packet
plus at least one additional slot.

Reported-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20250521092236.661410-4-lvivier@redhat.com
Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0408c21bb1220..fb3908798458b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3275,6 +3275,12 @@ static int virtnet_tx_resize(struct virtnet_info *vi, struct send_queue *sq,
 {
 	int qindex, err;
 
+	if (ring_num <= MAX_SKB_FRAGS + 2) {
+		netdev_err(vi->dev, "tx size (%d) cannot be smaller than %d\n",
+			   ring_num, MAX_SKB_FRAGS + 2);
+		return -EINVAL;
+	}
+
 	qindex = sq - vi->sq;
 
 	virtnet_tx_pause(vi, sq);
-- 
2.39.5



