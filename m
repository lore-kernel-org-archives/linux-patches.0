Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985DA221719;
	Tue, 29 Apr 2025 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945556; cv=none; b=GNKHUsYx6uwBK060nekoiVIRhGtSCvkKBwE7+6/odrhO/lRN7xYUvYDTaHuDmZAOoBXldkHkbP7ruWQPgPhpRcqPCDt6110drRUu3AE7gYM0L3XIpFq9bidcKT46q1KKbJecl9sCpWVDXS3RE+I0sbc75tA3kcUAcVw2wTv7JNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945556; c=relaxed/simple;
	bh=ZjrR95rHeXmKI/gxU2x/cxZDoz8LtkwnMZBGZr1PYOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdujWMwqGX1cQg69CCEGYYthzQLQ7PE0P/alze4ThPs9D0iykKTxC/ZcfeGKbs3loAsY02ydGd0mEj6XHHzMAEIjsujNK0Vq2UO+XdqU/oz8AW1S7DU6EiBOlsqil+Udzku5ZVEB9Z2vJ4BAUjT67OZGHXzMJXMA8C+6vm/XYgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0uNHBzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0uNHBzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF13C4CEE9;
	Tue, 29 Apr 2025 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945556;
	bh=ZjrR95rHeXmKI/gxU2x/cxZDoz8LtkwnMZBGZr1PYOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0uNHBzAtRV+QKcMlPRBFbvUT34C8cCj9xHfF4D6NL4JVxrUac7QxmV4/erG/a2gs
	 682GJuj/LzehfoifGX+C1+nRAClVK4GJktj+0E7WmCwXYuTvZv6S4xchB6JY6MSLZC
	 3GUkr2t/plc+VPfhHZd3MG+LMDMXdGj1IVUrZoeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Larry Bassel <larry.bassel@oracle.com>
Subject: [PATCH 5.4 123/179] virtio-net: Add validation for used length
Date: Tue, 29 Apr 2025 18:41:04 +0200
Message-ID: <20250429161054.373592427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xie Yongji <xieyongji@bytedance.com>

commit ad993a95c508417acdeb15244109e009e50d8758 upstream.

This adds validation for used length (might come
from an untrusted device) to avoid data corruption
or loss.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210531135852.113-1-xieyongji@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Larry: backport to 5.4.y. Minor conflict resolved due to missing commit 9ce6146ec7b50
  virtio_net: Add XDP frame size in two code paths ]
Signed-off-by: Larry Bassel <larry.bassel@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -717,6 +717,12 @@ static struct sk_buff *receive_small(str
 	len -= vi->hdr_len;
 	stats->bytes += len;
 
+	if (unlikely(len > GOOD_PACKET_LEN)) {
+		pr_debug("%s: rx error: len %u exceeds max size %d\n",
+			 dev->name, len, GOOD_PACKET_LEN);
+		dev->stats.rx_length_errors++;
+		goto err_len;
+	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -819,6 +825,7 @@ err:
 err_xdp:
 	rcu_read_unlock();
 	stats->xdp_drops++;
+err_len:
 	stats->drops++;
 	put_page(page);
 xdp_xmit:
@@ -871,6 +878,13 @@ static struct sk_buff *receive_mergeable
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
 
+	truesize = mergeable_ctx_to_truesize(ctx);
+	if (unlikely(len > truesize)) {
+		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+			 dev->name, len, (unsigned long)ctx);
+		dev->stats.rx_length_errors++;
+		goto err_skb;
+	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -990,14 +1004,6 @@ static struct sk_buff *receive_mergeable
 	}
 	rcu_read_unlock();
 
-	truesize = mergeable_ctx_to_truesize(ctx);
-	if (unlikely(len > truesize)) {
-		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
-			 dev->name, len, (unsigned long)ctx);
-		dev->stats.rx_length_errors++;
-		goto err_skb;
-	}
-
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
 			       metasize);
 	curr_skb = head_skb;


