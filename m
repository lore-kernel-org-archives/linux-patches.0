Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37528350282;
	Fri, 21 Nov 2025 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733290; cv=none; b=DYzkVOWKWvHiwI7adUC98I29CwTWMSnhUAuJSR/xlaWQMb8Ndng2CSXfRy7iV3uqpry30wcb+/VcBsnze5uvYWhVDwYEnanOsJhz5JnrGfmPekpdnhH0XUHW2V4a5c9mCfjXzEmxmMMcqRfSvUUxVWCiirIhJRUf3tqP05ct+O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733290; c=relaxed/simple;
	bh=jhYUHvVfI3EweO0pNIferuKs2gX1m/rTC0VT3vyDqWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPpwp51PEdcix+erCHqFA/An1AonQ/jXoLF5NvNVWeV+DVAUbsp+bDmNr2Qy/jBqcuasCxkkreXTM2gP5jIgGwOKWCr3lmqFQ3+08GbHRV//r1+tiLCAtX/YooHcAAv6MS2jUPdFVLKoIKCnnAxmb113LSKdFoqcpCPyZtNJ67o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBeo5uDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBeo5uDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B08C4CEF1;
	Fri, 21 Nov 2025 13:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733289;
	bh=jhYUHvVfI3EweO0pNIferuKs2gX1m/rTC0VT3vyDqWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBeo5uDdawArdQPyoENLz3wcxD0RzYCamD+Lmxk5YHdjjtZqqsCrlb7vc0d7Ru2gG
	 Vs71ocZV2gzgkjVy+O1fSfkxYI8k1EP12bMkUtIzxpj4e9ZXbZGZ63Z13YrTY64r9n
	 NYmZ2duN4s/tnh06vg0AkwVSMagjQqtethpi+uj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alyssa Ross <hi@alyssa.is>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 416/529] virtio-net: fix incorrect flags recording in big mode
Date: Fri, 21 Nov 2025 14:11:55 +0100
Message-ID: <20251121130245.820175177@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit 0eff2eaa5322b5b141ff5d5ded26fac4a52b5f7b ]

The purpose of commit 703eec1b2422 ("virtio_net: fixing XDP for fully
checksummed packets handling") is to record the flags in advance, as
their value may be overwritten in the XDP case. However, the flags
recorded under big mode are incorrect, because in big mode, the passed
buf does not point to the rx buffer, but rather to the page of the
submitted buffer. This commit fixes this issue.

For the small mode, the commit c11a49d58ad2 ("virtio_net: Fix mismatched
buf address when unmapping for small packets") fixed it.

Tested-by: Alyssa Ross <hi@alyssa.is>
Fixes: 703eec1b2422 ("virtio_net: fixing XDP for fully checksummed packets handling")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20251111090828.23186-1-xuanzhuo@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fd5663075bd77..caae11ba2f8be 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1821,22 +1821,28 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 		return;
 	}
 
-	/* 1. Save the flags early, as the XDP program might overwrite them.
+	/* About the flags below:
+	 * 1. Save the flags early, as the XDP program might overwrite them.
 	 * These flags ensure packets marked as VIRTIO_NET_HDR_F_DATA_VALID
 	 * stay valid after XDP processing.
 	 * 2. XDP doesn't work with partially checksummed packets (refer to
 	 * virtnet_xdp_set()), so packets marked as
 	 * VIRTIO_NET_HDR_F_NEEDS_CSUM get dropped during XDP processing.
 	 */
-	flags = ((struct virtio_net_common_hdr *)buf)->hdr.flags;
 
-	if (vi->mergeable_rx_bufs)
+	if (vi->mergeable_rx_bufs) {
+		flags = ((struct virtio_net_common_hdr *)buf)->hdr.flags;
 		skb = receive_mergeable(dev, vi, rq, buf, ctx, len, xdp_xmit,
 					stats);
-	else if (vi->big_packets)
+	} else if (vi->big_packets) {
+		void *p = page_address((struct page *)buf);
+
+		flags = ((struct virtio_net_common_hdr *)p)->hdr.flags;
 		skb = receive_big(dev, vi, rq, buf, len, stats);
-	else
+	} else {
+		flags = ((struct virtio_net_common_hdr *)buf)->hdr.flags;
 		skb = receive_small(dev, vi, rq, buf, ctx, len, xdp_xmit, stats);
+	}
 
 	if (unlikely(!skb))
 		return;
-- 
2.51.0



