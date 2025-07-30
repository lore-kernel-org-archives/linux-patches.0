Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A13626C383;
	Wed, 30 Jul 2025 09:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869030; cv=none; b=DH0yf53JMUPJcckt1jCTiZraYLDEPFqeakuHIS2Fd+en5aZnr77R3p05leoK7RPGnn80JbWkC2zuft0kqbaYIr2ydCxjEL1uZS32I9v+s1pHMEqRcCmeDeQwZHiSXK5LUIEJXDDvslgXPwWmIkpqeVsA/V545IuDra8Q5PuUIUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869030; c=relaxed/simple;
	bh=W6leb5pHL/uwdO7uNnZNY+4gEvQvJB2kzX+dj3VDLFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JU802+gipFRYO0WlPAR9IvhFh1SE6xdGDuaejdl3jN4AuNIjzYs+1+a31LtIFnNF0QSCw3sRRfj+U/OyMnxyLhBzyndlJNRoRxbXFHJW6lVEJ9hbKS2XJgg55epQ82pHphLJKr5lyq2Bg+Cje7WGoE3+aoQRjtNFXSnSQsbTE7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGb+SrHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGb+SrHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1763AC4CEF5;
	Wed, 30 Jul 2025 09:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869030;
	bh=W6leb5pHL/uwdO7uNnZNY+4gEvQvJB2kzX+dj3VDLFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGb+SrHG2w2Mv7+gu3Cf+VAt8nGhhr1bElXm/dhGLAJ40yxNcxoQS84ANbAEDqr8o
	 iswdDgmRbTB3WChvMbmpYhTBnXnTZN20mRhbRe9woiAI9cqjie2cEUHAw4eUbR8vRu
	 NqYAQfMbknQyw/bZby8408sEdl04oaIH3pgbjCVo=
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
Subject: [PATCH 6.15 02/92] virtio_net: Enforce minimum TX ring size for reliability
Date: Wed, 30 Jul 2025 11:35:10 +0200
Message-ID: <20250730093230.728942127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c69c241948019..0c9bedb679169 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3525,6 +3525,12 @@ static int virtnet_tx_resize(struct virtnet_info *vi, struct send_queue *sq,
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



