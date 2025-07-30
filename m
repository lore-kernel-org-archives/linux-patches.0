Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B9726C396;
	Wed, 30 Jul 2025 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868260; cv=none; b=qJa2/h9AY9PWxggW5C75PsQQqGwvRDeq3dwRqTCc9z4KIgYAZPGuvldjKIugtwDuYAG83IT9GN7b5iEALj7SHxefSW2eczow7R+guYgNnWujustD5uRz/k5dcSFxwnnxGB2cWz9lG/3jecIxe3Onqx/LBYnvqePWVydEa9mKR4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868260; c=relaxed/simple;
	bh=pbwz/30dYhQBslUUCAHs6ilLwTRci2xjmZYJahWdZgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZizFEcQfQ1KY5lX4ouY5ghFg8VOvQK5s0AtMhJua6E/V+8e560DR7qZhCte4vKnoVkStJOat23d23LP4IUpInEl8r4cd8paq6Jyo47F6DwqmYigbRtrEFiJF+WPBTKnvrbQEVxC7sHuqyHsepfNN11VyMbsc+BscVlmJiD9mDc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uK8zDft4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uK8zDft4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6E2C4CEF8;
	Wed, 30 Jul 2025 09:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868260;
	bh=pbwz/30dYhQBslUUCAHs6ilLwTRci2xjmZYJahWdZgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uK8zDft4syS4hmE9Tn+HmMx4mPgVUPtzCqhEI393ht9asbflz4Pn9VmPf1M39Tvae
	 YmMqI6hSjI4quURt7nqWzd08lhKlX2WsJeiPynQtMyvC55gIb1bY3hRAJkE25S/LDo
	 Q5UH8QKGHHBQd4ieSQAz/6QKjf0Fg0+2Ejuk4zo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xuanzhuo@linux.alibaba.com,
	Laurent Vivier <lvivier@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/76] virtio_ring: Fix error reporting in virtqueue_resize
Date: Wed, 30 Jul 2025 11:34:55 +0200
Message-ID: <20250730093226.951409619@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit 45ebc7e6c125ce93d2ddf82cd5bea20121bb0258 ]

The virtqueue_resize() function was not correctly propagating error codes
from its internal resize helper functions, specifically
virtqueue_resize_packet() and virtqueue_resize_split(). If these helpers
returned an error, but the subsequent call to virtqueue_enable_after_reset()
succeeded, the original error from the resize operation would be masked.
Consequently, virtqueue_resize() could incorrectly report success to its
caller despite an underlying resize failure.

This change restores the original code behavior:

       if (vdev->config->enable_vq_after_reset(_vq))
               return -EBUSY;

       return err;

Fix: commit ad48d53b5b3f ("virtio_ring: separate the logic of reset/enable from virtqueue_resize")
Cc: xuanzhuo@linux.alibaba.com
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20250521092236.661410-2-lvivier@redhat.com
Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c5f04234d9511..db4582687b958 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2739,7 +2739,7 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
 		     void (*recycle)(struct virtqueue *vq, void *buf))
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	int err;
+	int err, err_reset;
 
 	if (num > vq->vq.num_max)
 		return -E2BIG;
@@ -2759,7 +2759,11 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
 	else
 		err = virtqueue_resize_split(_vq, num);
 
-	return virtqueue_enable_after_reset(_vq);
+	err_reset = virtqueue_enable_after_reset(_vq);
+	if (err_reset)
+		return err_reset;
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(virtqueue_resize);
 
-- 
2.39.5



