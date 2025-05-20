Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A66C2475CD;
	Tue, 20 May 2025 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750052; cv=none; b=UtrUm/I9bnZ+XkFaCN1U4V0Wums5o6xC0kZhiF9wUKbWhhGxyLWBFZNOwQ7LVNA9jOHf/dMTqK2pIt9LBzdb1V4AzrfgTo2MrNyPBRfH4l5LNLTLt9eXw0fLfEmDsoHDPuUj870x8mYzkdBkDsbheGARAe95cQNqZgZxzq3HkgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750052; c=relaxed/simple;
	bh=eA8Tb4YeldoQTdVlcEFs7OavpbK8RZHj63BV0IYkAKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoDV4xZ1DZn414afAcOjh33TTX+UVC8fq5XObHBsOoVQEvltdSjsNX5QLsd+H5FTJuNa+U2IYZiigue33oyj+TMuR0tOCZTtHFlfGy8gthK1kfBjYaoAHbRODQLxHCGUDtCaraL4af22hSmRKEA3KtN3NPygpWdYZZxEiwr+H40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtWglO7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtWglO7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E977DC4CEEB;
	Tue, 20 May 2025 14:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750052;
	bh=eA8Tb4YeldoQTdVlcEFs7OavpbK8RZHj63BV0IYkAKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtWglO7VFXf0ipsqQHYXefKopokmLMolbFqfxPJeiN7YxNTA6+fwrGKTfpiOPOaIa
	 8hpBdI8cedrFpG8d+TktQ3tzC3IYrALLwEjDOrcHjH8vGKhPh/VTETeoUM3uNeIt5+
	 X1DgH3u2ypd5PTD6xpSigO+WKmxJYYE87qw7yi6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/143] virtio_net: ensure netdev_tx_reset_queue is called on bind xsk for tx
Date: Tue, 20 May 2025 15:49:41 +0200
Message-ID: <20250520125811.078323051@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Koichiro Den <koichiro.den@canonical.com>

[ Upstream commit 76a771ec4c9adfd75fe53c8505cf656a075d7101 ]

virtnet_sq_bind_xsk_pool() flushes tx skbs and then resets tx queue, so
DQL counters need to be reset when flushing has actually occurred, Add
virtnet_sq_free_unused_buf_done() as a callback for virtqueue_resize()
to handle this.

Fixes: 21a4e3ce6dc7 ("virtio_net: xsk: bind/unbind xsk for tx")
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb444972693a0..6d36cb204f9bc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -5576,7 +5576,8 @@ static int virtnet_sq_bind_xsk_pool(struct virtnet_info *vi,
 
 	virtnet_tx_pause(vi, sq);
 
-	err = virtqueue_reset(sq->vq, virtnet_sq_free_unused_buf, NULL);
+	err = virtqueue_reset(sq->vq, virtnet_sq_free_unused_buf,
+			      virtnet_sq_free_unused_buf_done);
 	if (err) {
 		netdev_err(vi->dev, "reset tx fail: tx queue index: %d err: %d\n", qindex, err);
 		pool = NULL;
-- 
2.39.5



